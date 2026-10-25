//! El kernel de goban: lo que se calcula jugando la partida. Las capturas, el territorio (de un polígono o
//! buscado solo), la región de cada color y el puntaje. Lo usa src/kernel.typ como plugin de Typst: recibe
//! la partida en JSON (Input) y devuelve lo que pasó (Output). También lee los archivos SGF (sgf.rs) y hace
//! lo que Typst no sabe hacer con las imágenes (images.rs).

use serde::{Deserialize, Serialize};
use std::collections::{HashMap, HashSet};

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, Deserialize, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum Player {
    Black,
    White,
    Neutral,
}

impl Player {
    fn rival(self) -> Option<Player> {
        match self {
            Player::Black => Some(Player::White),
            Player::White => Some(Player::Black),
            Player::Neutral => None,
        }
    }
}

/// La partida: el tamaño, si hay capturas, los prisioneros con que empieza (los de un tablero retomado) y lo
/// que pasa, en orden. Con capturas, una jugada en un punto ocupado es un error; con replace, quita la piedra
/// que había (como un remove de la jugada).
#[derive(Deserialize)]
pub struct Input {
    pub size: (i32, i32),
    #[serde(default)]
    pub captures: bool,
    #[serde(default)]
    pub replace: bool,
    #[serde(default)]
    pub prisoners: Prisoners,
    pub events: Vec<Event>,
}

/// Una piedra puesta (dead: un prisionero), una jugada, una piedra que se quita (AE de un SGF) o un
/// territorio. El territorio es auto (lo busca solo), polygon (los puntos dentro de vertices o en su borde) o
/// points (los de points, cada uno con su dueño; con kill, una piedra del rival en uno de ellos queda muerta,
/// como con TB y TW de un SGF). Sin player, el de auto es el de los dos colores y el de un polígono, neutral.
#[derive(Deserialize)]
#[serde(tag = "kind", rename_all = "lowercase")]
pub enum Event {
    Stone {
        x: i32,
        y: i32,
        player: Player,
        #[serde(default)]
        dead: bool,
    },
    Move {
        x: i32,
        y: i32,
        player: Player,
    },
    Remove {
        x: i32,
        y: i32,
    },
    Territory {
        mode: String,
        #[serde(default)]
        player: Option<Player>,
        #[serde(default)]
        vertices: Vec<(i32, i32)>,
        #[serde(default)]
        points: Vec<(i32, i32, Player)>,
        #[serde(default)]
        dame: bool,
        #[serde(default)]
        region: bool,
        #[serde(default)]
        kill: bool,
    },
}

#[derive(Clone, Copy, Default, Debug, PartialEq, Deserialize, Serialize)]
pub struct Prisoners {
    pub black: u32,
    pub white: u32,
}

/// La región de un color: sus contornos y sus propiedades (las de \pgfgoregion en pgf-go).
#[derive(Debug, PartialEq, Serialize)]
pub struct Region {
    pub contours: Vec<Vec<(i32, i32)>>,
    pub polygons: usize,
    pub outlines: usize,
    pub holes: usize,
    pub vertices: usize,
    pub area: i32,
    pub perimeter: i32,
}

#[derive(Debug, Default, PartialEq, Serialize)]
pub struct Score {
    pub black: u32,
    pub white: u32,
    pub neutral: u32,
}

/// Lo que pasó. captured: por cada jugada que capturó, su número de evento y los de las piedras que sacó.
/// removed: por cada piedra quitada, el evento que la quitó y el que la puso. dead: las piedras que mató un
/// territorio con kill. territory: los puntos que quedan marcados al final, con su dueño y el evento que los
/// marcó.
#[derive(Debug, Serialize)]
pub struct Output {
    pub captured: Vec<(usize, Vec<usize>)>,
    pub removed: Vec<(usize, usize)>,
    pub dead: Vec<usize>,
    pub prisoners: Prisoners,
    pub territory: Vec<(i32, i32, Player, usize)>,
    pub black: Option<Region>,
    pub white: Option<Region>,
    pub score: Score,
}

/// Lo que hay en un punto: la piedra, si es un prisionero y el evento que la puso.
#[derive(Clone, Copy)]
struct Content {
    player: Player,
    dead: bool,
    event: usize,
}

impl Content {
    /// Cuenta para las capturas: una piedra viva negra o blanca.
    fn plays(self) -> bool {
        !self.dead && self.player != Player::Neutral
    }
}

struct Board {
    cols: i32,
    rows: i32,
    points: Vec<Option<Content>>,
}

/// Oeste, este, sur, norte (el orden decide el de las piedras capturadas, como en pgf-go).
const DIRECTIONS: [(i32, i32); 4] = [(-1, 0), (1, 0), (0, -1), (0, 1)];

impl Board {
    fn new(cols: i32, rows: i32) -> Board {
        Board { cols, rows, points: vec![None; (cols * rows) as usize] }
    }

    fn inside(&self, x: i32, y: i32) -> bool {
        x >= 1 && y >= 1 && x <= self.cols && y <= self.rows
    }

    fn index(&self, x: i32, y: i32) -> usize {
        ((y - 1) * self.cols + (x - 1)) as usize
    }

    fn get(&self, x: i32, y: i32) -> Option<Content> {
        self.points[self.index(x, y)]
    }

    fn set(&mut self, x: i32, y: i32, content: Option<Content>) {
        let i = self.index(x, y);
        self.points[i] = content;
    }

    fn neighbours(&self, x: i32, y: i32) -> impl Iterator<Item = (i32, i32)> + '_ {
        DIRECTIONS.iter().map(move |(dx, dy)| (x + dx, y + dy)).filter(|&(x, y)| self.inside(x, y))
    }

    /// Una piedra viva en el punto (ni neutral ni prisionero tapan el territorio, pero la neutral sí).
    fn alive(&self, x: i32, y: i32) -> Option<Player> {
        self.get(x, y).filter(|c| !c.dead).map(|c| c.player)
    }

    /// El grupo de la piedra en (x, y) y si tiene alguna libertad. Solo cuentan las piedras vivas negras y
    /// blancas: un punto con una piedra neutral o un prisionero es una libertad.
    fn group(&self, x: i32, y: i32) -> (Vec<(i32, i32)>, bool) {
        let player = self.get(x, y).map(|c| c.player);
        let mut members = Vec::new();
        let mut seen = HashSet::from([(x, y)]);
        let mut pending = vec![(x, y)];
        let mut free = false;
        while let Some(p) = pending.pop() {
            members.push(p);
            for n in self.neighbours(p.0, p.1) {
                match self.get(n.0, n.1).filter(|c| c.plays()) {
                    None => free = true,
                    Some(c) if Some(c.player) == player && seen.insert(n) => pending.push(n),
                    _ => {}
                }
            }
        }
        (members, free)
    }
}

/// Los puntos del polígono de vértices v (en orden) que están en el tablero: adentro o en el borde, fila por
/// fila desde abajo. La cuenta es con enteros.
pub fn polygon(v: &[(i32, i32)], cols: i32, rows: i32) -> Vec<(i32, i32)> {
    if v.is_empty() {
        return Vec::new();
    }
    let on_segment = |px: i32, py: i32, a: (i32, i32), b: (i32, i32)| {
        (b.0 - a.0) * (py - a.1) - (b.1 - a.1) * (px - a.0) == 0
            && px >= a.0.min(b.0)
            && px <= a.0.max(b.0)
            && py >= a.1.min(b.1)
            && py <= a.1.max(b.1)
    };
    let inside = |px: i32, py: i32| {
        let mut odd = false;
        for i in 0..v.len() {
            let (a, b) = (v[i], v[(i + 1) % v.len()]);
            if on_segment(px, py, a, b) {
                return true;
            }
            if (a.1 > py) != (b.1 > py) {
                // px < la x del cruce, multiplicando por dy (con su signo).
                let dy = b.1 - a.1;
                let lhs = (px - a.0) * dy;
                let rhs = (py - a.1) * (b.0 - a.0);
                if (dy > 0 && lhs < rhs) || (dy < 0 && lhs > rhs) {
                    odd = !odd;
                }
            }
        }
        odd
    };
    let (fx, tx) = (v.iter().map(|p| p.0).min().unwrap(), v.iter().map(|p| p.0).max().unwrap());
    let (fy, ty) = (v.iter().map(|p| p.1).min().unwrap(), v.iter().map(|p| p.1).max().unwrap());
    let mut list = Vec::new();
    for y in fy.max(1)..=ty.min(rows) {
        for x in fx.max(1)..=tx.min(cols) {
            if inside(x, y) {
                list.push((x, y));
            }
        }
    }
    list
}

/// El territorio que se ve en el tablero: cada región de puntos sin piedras vivas es del color que la
/// rodea; si la tocan los dos o ninguno, es neutral. Fila por fila desde abajo.
fn auto_territory(board: &Board) -> Vec<(i32, i32, Player)> {
    let mut owner: HashMap<(i32, i32), Player> = HashMap::new();
    for y in 1..=board.rows {
        for x in 1..=board.cols {
            if board.alive(x, y).is_some() || owner.contains_key(&(x, y)) {
                continue;
            }
            let mut region = Vec::new();
            let mut pending = vec![(x, y)];
            let mut seen = HashSet::from([(x, y)]);
            let (mut black, mut white) = (false, false);
            while let Some(p) = pending.pop() {
                region.push(p);
                for n in board.neighbours(p.0, p.1) {
                    match board.alive(n.0, n.1) {
                        Some(Player::Black) => black = true,
                        Some(Player::White) => white = true,
                        Some(Player::Neutral) => {}
                        None => {
                            if seen.insert(n) {
                                pending.push(n)
                            }
                        }
                    }
                }
            }
            let o = match (black, white) {
                (true, false) => Player::Black,
                (false, true) => Player::White,
                _ => Player::Neutral,
            };
            for p in region {
                owner.insert(p, o);
            }
        }
    }
    let mut list = Vec::new();
    for y in 1..=board.rows {
        for x in 1..=board.cols {
            if let Some(&o) = owner.get(&(x, y)) {
                list.push((x, y, o));
            }
        }
    }
    list
}

/// Las direcciones de los lados: 0 este, 1 norte, 2 oeste, 3 sur.
const STEPS: [(i32, i32); 4] = [(1, 0), (0, 1), (-1, 0), (0, -1)];

/// Los contornos de la región de los puntos: se pinta cada casilla [x, x+1] × [y, y+1] del tablero con
/// alguna esquina en esos puntos. Cada casilla tiene sus lados en sentido antihorario; quedan los que no
/// tienen otra casilla pintada del otro lado. Se recorren prefiriendo girar a la izquierda (así un contacto
/// por una esquina separa las zonas) y solo quedan los vértices donde el borde gira. Cada contorno empieza
/// en su vértice más bajo y, entre esos, en el de más a la izquierda.
pub fn contours(points: &[(i32, i32)], cols: i32, rows: i32) -> Vec<Vec<(i32, i32)>> {
    let own: HashSet<(i32, i32)> = points.iter().copied().collect();
    let mut painted = HashSet::new();
    for cy in 1..rows {
        for cx in 1..cols {
            if [(cx, cy), (cx + 1, cy), (cx, cy + 1), (cx + 1, cy + 1)].iter().any(|p| own.contains(p)) {
                painted.insert((cx, cy));
            }
        }
    }
    let mut out: HashMap<(i32, i32), [bool; 4]> = HashMap::new();
    let mut side = |x: i32, y: i32, d: usize| out.entry((x, y)).or_default()[d] = true;
    for cy in 1..rows {
        for cx in 1..cols {
            if painted.contains(&(cx, cy)) {
                if !painted.contains(&(cx, cy - 1)) {
                    side(cx, cy, 0);
                }
                if !painted.contains(&(cx + 1, cy)) {
                    side(cx + 1, cy, 1);
                }
                if !painted.contains(&(cx, cy + 1)) {
                    side(cx + 1, cy + 1, 2);
                }
                if !painted.contains(&(cx - 1, cy)) {
                    side(cx, cy + 1, 3);
                }
            }
        }
    }
    let mut result = Vec::new();
    for y in 1..=rows {
        for x in 1..=cols {
            while let Some(mut d) = out.get(&(x, y)).and_then(|s| s.iter().position(|&b| b)) {
                out.get_mut(&(x, y)).unwrap()[d] = false;
                let mut v = vec![(x, y)];
                let (mut px, mut py) = (x + STEPS[d].0, y + STEPS[d].1);
                while (px, py) != (x, y) {
                    let here = out.get_mut(&(px, py)).expect("contorno abierto");
                    let nd = [(d + 1) % 4, d, (d + 3) % 4].into_iter().find(|&t| here[t]).expect("contorno abierto");
                    here[nd] = false;
                    if nd != d {
                        v.push((px, py));
                    }
                    d = nd;
                    (px, py) = (px + STEPS[d].0, py + STEPS[d].1);
                }
                result.push(v);
            }
        }
    }
    result
}

/// La región de los puntos, con sus propiedades. Un contorno exterior va hacia el este desde su primer
/// vértice; un hueco, hacia el norte. El área es la de Gauss (los huecos restan).
pub fn region(points: &[(i32, i32)], cols: i32, rows: i32) -> Region {
    let contours = contours(points, cols, rows);
    let (mut outlines, mut holes, mut vertices, mut area, mut perimeter) = (0, 0, 0, 0, 0);
    for c in &contours {
        vertices += c.len();
        if c.len() > 1 && c[0].1 == c[1].1 {
            outlines += 1;
        } else {
            holes += 1;
        }
        let mut last = *c.last().unwrap();
        for &p in c {
            area += last.0 * p.1 - p.0 * last.1;
            perimeter += (p.0 - last.0).abs() + (p.1 - last.1).abs();
            last = p;
        }
    }
    Region { polygons: contours.len(), contours, outlines, holes, vertices, area: area / 2, perimeter }
}

/// Juega la partida.
pub fn simulate(input: &Input) -> Result<Output, String> {
    let (cols, rows) = input.size;
    if cols < 1 || rows < 1 || cols > 52 || rows > 99 {
        return Err(format!("tamaño fuera de rango: {cols}×{rows}"));
    }
    let mut board = Board::new(cols, rows);
    let mut prisoners = input.prisoners;
    let mut captured = Vec::new();
    let mut removed_stones = Vec::new();
    let mut dead_stones = Vec::new();
    // El dueño de cada punto marcado y el evento que lo marcó; si ese evento es una región.
    let mut owner: HashMap<(i32, i32), (Player, usize)> = HashMap::new();
    let mut region_events = HashSet::new();
    let mut region_colors = HashSet::new();
    let check = |x: i32, y: i32| {
        if x >= 1 && y >= 1 && x <= cols && y <= rows { Ok(()) } else { Err(format!("({x}, {y}) no está en el tablero")) }
    };

    for (i, event) in input.events.iter().enumerate() {
        match *event {
            Event::Stone { x, y, player, dead } => {
                check(x, y)?;
                board.set(x, y, Some(Content { player, dead, event: i }));
            }
            Event::Move { x, y, player } => {
                check(x, y)?;
                if player == Player::Neutral {
                    return Err("las jugadas son de negras o de blancas".into());
                }
                if !input.captures {
                    board.set(x, y, Some(Content { player, dead: false, event: i }));
                    continue;
                }
                if let Some(c) = board.get(x, y).filter(|c| c.plays()) {
                    if !input.replace {
                        return Err(format!("jugada en un punto ocupado: ({x}, {y})"));
                    }
                    removed_stones.push((i, c.event));
                }
                board.set(x, y, Some(Content { player, dead: false, event: i }));
                let mut removed = Vec::new();
                let mut remove = |board: &mut Board, members: Vec<(i32, i32)>, removed: &mut Vec<usize>| {
                    for (mx, my) in members {
                        let c = board.get(mx, my).unwrap();
                        match c.player {
                            Player::White => prisoners.black += 1,
                            Player::Black => prisoners.white += 1,
                            Player::Neutral => {}
                        }
                        removed.push(c.event);
                        board.set(mx, my, None);
                    }
                };
                let neighbours: Vec<_> = board.neighbours(x, y).collect();
                for (nx, ny) in neighbours {
                    if board.get(nx, ny).is_some_and(|c| c.plays() && c.player != player) {
                        let (members, free) = board.group(nx, ny);
                        if !free {
                            remove(&mut board, members, &mut removed);
                        }
                    }
                }
                let (members, free) = board.group(x, y);
                if !free {
                    remove(&mut board, members, &mut removed);
                }
                if !removed.is_empty() {
                    captured.push((i, removed));
                }
            }
            Event::Remove { x, y } => {
                check(x, y)?;
                if let Some(c) = board.get(x, y) {
                    removed_stones.push((i, c.event));
                    board.set(x, y, None);
                }
            }
            Event::Territory { ref mode, player, ref vertices, ref points, dame, region, kill } => {
                let marked: Vec<(i32, i32, Player)> = match mode.as_str() {
                    "auto" => auto_territory(&board)
                        .into_iter()
                        .filter(|&(_, _, o)| match player {
                            Some(p) => o == p,
                            None => o != Player::Neutral || dame,
                        })
                        .collect(),
                    "polygon" => polygon(vertices, cols, rows)
                        .into_iter()
                        .map(|(x, y)| (x, y, player.unwrap_or(Player::Neutral)))
                        .collect(),
                    "points" => points.clone(),
                    _ => return Err(format!("territorio desconocido: {mode}")),
                };
                for (x, y, o) in marked {
                    check(x, y)?;
                    if let Some(c) = board.get(x, y).filter(|c| kill && c.plays() && Some(c.player) == o.rival()) {
                        board.set(x, y, Some(Content { dead: true, ..c }));
                        dead_stones.push(c.event);
                    }
                    if board.alive(x, y).is_none() {
                        owner.insert((x, y), (o, i));
                    }
                }
                if region {
                    region_events.insert(i);
                    match player {
                        Some(p) => {
                            region_colors.insert(p);
                        }
                        None => {
                            region_colors.insert(Player::Black);
                            region_colors.insert(Player::White);
                        }
                    }
                }
            }
        }
    }

    // Al final, salen los puntos que tienen una piedra viva.
    let mut territory = Vec::new();
    let mut score = Score::default();
    for y in 1..=rows {
        for x in 1..=cols {
            let Some(&(o, e)) = owner.get(&(x, y)) else { continue };
            if board.alive(x, y).is_some() {
                continue;
            }
            territory.push((x, y, o, e));
            let dead = board.get(x, y).is_some_and(|c| c.dead && Some(c.player) == o.rival());
            let points = 1 + dead as u32;
            match o {
                Player::Black => score.black += points,
                Player::White => score.white += points,
                Player::Neutral => score.neutral += 1,
            }
        }
    }
    score.black += prisoners.black;
    score.white += prisoners.white;
    let region_of = |p: Player| {
        region_colors.contains(&p).then(|| {
            let points: Vec<_> = territory
                .iter()
                .filter(|&&(_, _, o, e)| o == p && region_events.contains(&e))
                .map(|&(x, y, _, _)| (x, y))
                .collect();
            region(&points, cols, rows)
        })
    };
    let (black, white) = (region_of(Player::Black), region_of(Player::White));
    Ok(Output { captured, removed: removed_stones, dead: dead_stones, prisoners, territory, black, white, score })
}

pub fn simulate_json(input: &[u8]) -> Result<Vec<u8>, String> {
    let input: Input = serde_json::from_slice(input).map_err(|e| format!("entrada del kernel: {e}"))?;
    let output = simulate(&input)?;
    serde_json::to_vec(&output).map_err(|e| e.to_string())
}

pub mod sgf;
pub mod images;

#[cfg(target_arch = "wasm32")]
wasm_minimal_protocol::initiate_protocol!();

#[cfg(target_arch = "wasm32")]
#[wasm_minimal_protocol::wasm_func]
pub fn run(input: &[u8]) -> Result<Vec<u8>, String> {
    simulate_json(input)
}

/// Lo que src/sgf.typ pregunta de un archivo SGF (data, tal como se leyó): sgf::Request.
#[cfg(target_arch = "wasm32")]
#[wasm_minimal_protocol::wasm_func]
pub fn sgf(data: &[u8], request: &[u8]) -> Result<Vec<u8>, String> {
    sgf::answer_json(data, request)
}

/// La opacidad o la silueta de una imagen (data, un PNG o un JPEG): images::Request. Devuelve un PNG.
#[cfg(target_arch = "wasm32")]
#[wasm_minimal_protocol::wasm_func]
pub fn image(data: &[u8], request: &[u8]) -> Result<Vec<u8>, String> {
    images::transform_json(data, request)
}

#[cfg(test)]
mod tests;
