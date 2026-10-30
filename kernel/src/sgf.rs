//! La lectura de SGF: el texto del archivo pasado a UTF-8, sus partidas como árboles y lo que necesita
//! src/sgf.typ de cada una (una línea con sus jugadas, marcas y comentarios; las propiedades; las variantes).
//! Las coordenadas que devuelve son las de goban: la columna 1 es la de la izquierda y la fila 1, la de abajo.

use serde::{Deserialize, Serialize};
use std::collections::HashMap;

pub type Point = (i32, i32);

/// Las propiedades de un nodo, con sus valores (los nombres viejos, como AddBlack, quedan como AB).
pub type Props = HashMap<String, Vec<String>>;

/// Un árbol SGF: una secuencia de nodos y las variantes que la siguen.
#[derive(Debug, Default)]
pub struct Tree {
    pub nodes: Vec<Props>,
    pub children: Vec<Tree>,
}

// CODIFICACIONES

#[derive(Clone, Copy, PartialEq, Debug)]
enum Charset {
    Utf8,
    Latin,
    Encoding(&'static encoding_rs::Encoding),
}

/// La codificación de un nombre, sin mayúsculas ni signos (Shift_JIS es shiftjis).
fn charset(name: &str) -> Option<Charset> {
    use encoding_rs::*;
    let key: String = name.chars().filter(|c| c.is_ascii_alphanumeric()).collect::<String>().to_ascii_lowercase();
    Some(match key.as_str() {
        "utf8" | "utf16" | "utf16le" | "utf16be" => Charset::Utf8,
        "iso88591" | "iso885915" | "latin1" | "windows1252" | "cp1252" | "ascii" | "usascii" => Charset::Latin,
        "gbk" | "gb2312" | "gb18030" | "cp936" | "windows936" | "euccn" => Charset::Encoding(GB18030),
        "big5" | "big5hkscs" | "cp950" | "windows950" => Charset::Encoding(BIG5),
        "shiftjis" | "sjis" | "xsjis" | "cp932" | "windows31j" | "mskanji" => Charset::Encoding(SHIFT_JIS),
        "eucjp" => Charset::Encoding(EUC_JP),
        "euckr" | "cp949" | "windows949" | "uhc" | "ksc5601" | "ksc56011987" => Charset::Encoding(EUC_KR),
        _ => return None,
    })
}

/// El valor de la primera CA del archivo, como en pgf-go: CA, espacios, [ y lo que sigue hasta ].
fn ca(data: &[u8]) -> Option<String> {
    let mut i = 0;
    while i + 1 < data.len() {
        if &data[i..i + 2] == b"CA" {
            let mut j = i + 2;
            while j < data.len() && data[j].is_ascii_whitespace() {
                j += 1;
            }
            if j < data.len() && data[j] == b'[' {
                if let Some(end) = data[j + 1..].iter().position(|&b| b == b']') {
                    return Some(String::from_utf8_lossy(&data[j + 1..j + 1 + end]).into_owned());
                }
            }
        }
        i += 1;
    }
    None
}

/// El texto del archivo en UTF-8. Uno en UTF-16 con BOM, o que ya es UTF-8 válido, se lee así. Si no, con
/// la codificación forced o, sin ella, la de CA; sin ninguna, Latin-1 (la de SGF por defecto). Una
/// codificación desconocida es un error si hace falta para leerlo.
pub fn decode(data: &[u8], forced: Option<&str>) -> Result<String, String> {
    if let Some(name) = forced {
        if charset(name).is_none() {
            return Err(format!("codificación desconocida: {name}"));
        }
    }
    if data.starts_with(&[0xFF, 0xFE]) || data.starts_with(&[0xFE, 0xFF]) {
        let encoding = if data[0] == 0xFF { encoding_rs::UTF_16LE } else { encoding_rs::UTF_16BE };
        return Ok(encoding.decode_without_bom_handling(&data[2..]).0.into_owned());
    }
    if let Ok(text) = std::str::from_utf8(data) {
        return Ok(text.to_string());
    }
    let wanted = forced.map(str::to_string).or_else(|| ca(data));
    let kind = match &wanted {
        Some(name) => charset(name).ok_or_else(|| format!("el archivo no es UTF-8 y su codificación es desconocida: {name}"))?,
        None => Charset::Latin,
    };
    Ok(match kind {
        Charset::Utf8 | Charset::Latin => data.iter().map(|&b| b as char).collect(),
        Charset::Encoding(e) => e.decode_without_bom_handling(data).0.into_owned(),
    })
}

// EL PARSER

struct Parser<'a> {
    s: &'a [u8],
    text: &'a str,
    i: usize,
}

impl Parser<'_> {
    fn skip(&mut self) {
        while self.i < self.s.len() && self.s[self.i].is_ascii_whitespace() {
            self.i += 1;
        }
    }

    /// Un valor: self.i está en [. La \ escapa el carácter que sigue (\] no cierra el valor); una \ antes de
    /// un salto de línea lo quita.
    fn value(&mut self) -> String {
        let mut out = String::new();
        self.i += 1;
        let mut start = self.i;
        while self.i < self.s.len() {
            match self.s[self.i] {
                b']' => {
                    out.push_str(&self.text[start..self.i]);
                    self.i += 1;
                    return out;
                }
                b'\\' => {
                    out.push_str(&self.text[start..self.i]);
                    self.i += 1;
                    if self.s[self.i..].starts_with(b"\r\n") || self.s[self.i..].starts_with(b"\n\r") {
                        self.i += 2;
                    } else if let Some(c) = self.text[self.i..].chars().next() {
                        if c != '\n' && c != '\r' {
                            out.push(c);
                        }
                        self.i += c.len_utf8();
                    }
                    start = self.i;
                }
                _ => self.i += 1,
            }
        }
        out.push_str(&self.text[start.min(self.s.len())..]);
        out
    }

    fn node(&mut self) -> Props {
        let mut props = Props::new();
        loop {
            self.skip();
            let start = self.i;
            while self.i < self.s.len() && self.s[self.i].is_ascii_alphabetic() {
                self.i += 1;
            }
            if self.i == start {
                return props;
            }
            let ident: String = self.text[start..self.i].chars().filter(|c| !c.is_ascii_lowercase()).collect();
            self.skip();
            let mut values = Vec::new();
            while self.i < self.s.len() && self.s[self.i] == b'[' {
                values.push(self.value());
                self.skip();
            }
            props.entry(ident).or_default().extend(values);
        }
    }

    fn tree(&mut self) -> Tree {
        let mut t = Tree::default();
        self.i += 1;
        loop {
            self.skip();
            match self.s.get(self.i) {
                Some(b';') => {
                    self.i += 1;
                    t.nodes.push(self.node());
                }
                Some(b'(') => t.children.push(self.tree()),
                // Un nodo sin ; (la raíz de algunos archivos viejos: "(SZ[19]...").
                Some(c) if c.is_ascii_alphabetic() => t.nodes.push(self.node()),
                _ => {
                    self.i += 1;
                    return t;
                }
            }
        }
    }
}

/// Las partidas del archivo (una colección tiene varias).
pub fn parse(text: &str) -> Vec<Tree> {
    let mut p = Parser { s: text.as_bytes(), text, i: 0 };
    let mut games = Vec::new();
    while let Some(start) = p.s[p.i.min(p.s.len())..].iter().position(|&b| b == b'(') {
        p.i += start;
        games.push(p.tree());
    }
    games
}

// COORDENADAS

/// a..z son 1..26 y A..Z, 27..52.
fn number(c: u8) -> Option<i32> {
    match c {
        b'a'..=b'z' => Some((c - b'a') as i32 + 1),
        b'A'..=b'Z' => Some((c - b'A') as i32 + 27),
        _ => None,
    }
}

fn point(v: &str, sy: i32) -> Option<Point> {
    let b = v.as_bytes();
    if b.len() != 2 {
        return None;
    }
    Some((number(b[0])?, sy - number(b[1])? + 1))
}

/// Los puntos de un valor: "pd" o un rectángulo "aa:cc", columna por columna y de abajo hacia arriba.
pub fn coords(v: &str, sy: i32) -> Vec<Point> {
    let (a, b) = v.split_once(':').unwrap_or((v, v));
    let (Some(a), Some(b)) = (point(a, sy), point(b, sy)) else { return Vec::new() };
    let mut list = Vec::new();
    for x in a.0.min(b.0)..=a.0.max(b.0) {
        for y in a.1.min(b.1)..=a.1.max(b.1) {
            list.push((x, y));
        }
    }
    list
}

/// La orientación del archivo (origin y transpose de sgf-read): dónde va su punto aa (a la derecha, abajo) y si
/// la primera letra de cada punto es la fila. Entre las dos, las ocho simetrías del tablero.
#[derive(Clone, Copy, Default, PartialEq)]
pub struct Orientation {
    pub right: bool,
    pub bottom: bool,
    pub transpose: bool,
}

fn letter(n: i32) -> char {
    if n <= 26 { (b'a' + (n - 1) as u8) as char } else { (b'A' + (n - 27) as u8) as char }
}

/// Un punto del archivo ("pd"), de un tablero de w×h, en el tablero orientado. Lo que no es un punto del
/// tablero (un pase "tt" en 19×19) queda igual.
fn orient_point(v: &str, w: i32, h: i32, o: Orientation) -> String {
    let b = v.as_bytes();
    let (Some(first), Some(second)) = (b.first().and_then(|&c| number(c)), b.get(1).and_then(|&c| number(c))) else {
        return v.to_string();
    };
    if b.len() != 2 || first > w || second > h {
        return v.to_string();
    }
    let (mut col, mut row) = if o.transpose { (second, first) } else { (first, second) };
    let (bw, bh) = if o.transpose { (h, w) } else { (w, h) };
    if o.right {
        col = bw - col + 1;
    }
    if o.bottom {
        row = bh - row + 1;
    }
    format!("{}{}", letter(col), letter(row))
}

/// La partida orientada: los puntos de las propiedades que los tienen (en LB, el de antes de «:») y, con
/// transpose, el tamaño.
pub fn orient(tree: &mut Tree, (w, h): (i32, i32), o: Orientation) {
    let both = |v: &str| v.split(':').map(|p| orient_point(p, w, h, o)).collect::<Vec<_>>().join(":");
    for node in &mut tree.nodes {
        for (key, values) in node.iter_mut() {
            match key.as_str() {
                "B" | "W" | "AB" | "AW" | "AE" | "TR" | "SQ" | "CR" | "MA" | "SL" | "TB" | "TW" | "VW" | "DD" | "AR"
                | "LN" | sensei::BLANK => values.iter_mut().for_each(|v| *v = both(v)),
                "LB" => values.iter_mut().for_each(|v| {
                    if let Some((p, text)) = v.split_once(':') {
                        *v = format!("{}:{}", orient_point(p, w, h, o), text);
                    }
                }),
                "SZ" if o.transpose && w != h => *values = vec![format!("{h}:{w}")],
                _ => {}
            }
        }
    }
    for child in &mut tree.children {
        orient(child, (w, h), o);
    }
}

/// El tamaño de la partida: SZ de la raíz ("19" o "19:13"), 19 si no está.
pub fn size(root: Option<&Props>) -> (i32, i32) {
    let Some(v) = root.and_then(|r| r.get("SZ")).and_then(|v| v.first()) else { return (19, 19) };
    let parse = |s: &str| s.trim().parse::<i32>().ok();
    match v.split_once(':') {
        Some((x, y)) => (parse(x).unwrap_or(19), parse(y).unwrap_or(19)),
        None => {
            let n = parse(v).unwrap_or(19);
            (n, n)
        }
    }
}

/// La jugada de un nodo: None si no tiene, Some(None) si es un pase ([] y, hasta 19×19, [tt]).
fn node_move(n: &Props, sx: i32, sy: i32) -> Option<Option<Point>> {
    let v = n.get("B").or_else(|| n.get("W"))?;
    let v = v.first().map(String::as_str).unwrap_or("");
    if v == "tt" && sx <= 19 && sy <= 19 {
        return Some(None);
    }
    Some(coords(v, sy).first().copied())
}

fn has_move(n: &Props) -> bool {
    n.contains_key("B") || n.contains_key("W")
}

// LAS LÍNEAS

/// El camino de una variante: en cada bifurcación, la variante que se toma (1 es la principal), o las
/// jugadas de la línea desde la primera (None es un pase). Cuando se termina, se sigue por la primera.
#[derive(Clone, Debug, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum Path {
    Numbers(Vec<usize>),
    Moves(Vec<Option<Point>>),
}

impl Default for Path {
    fn default() -> Path {
        Path::Numbers(Vec::new())
    }
}

/// Los nodos de una línea; por nodo, sus hijos (los que pueden seguir) y sus hermanos (las alternativas, el
/// incluido); la variante que se tomó en cada bifurcación; y si el camino pide algo que no está.
pub struct Line<'a> {
    pub nodes: Vec<&'a Props>,
    pub kids: Vec<Vec<&'a Props>>,
    pub sibs: Vec<Vec<&'a Props>>,
    pub choices: Vec<usize>,
    pub missing: bool,
}

fn firsts(t: &Tree) -> Vec<&Props> {
    t.children.iter().filter_map(|c| c.nodes.first()).collect()
}

pub fn line<'a>(t: &'a Tree, path: &Path, sx: i32, sy: i32) -> Line<'a> {
    let mut line = Line { nodes: vec![], kids: vec![], sibs: vec![], choices: vec![], missing: false };
    let mut i = 0;
    let mut siblings: Option<Vec<&Props>> = None;
    // Si la jugada del nodo es la que pide el camino; None si el nodo no tiene jugada.
    let matches = |n: &Props, want: Option<&Option<Point>>| node_move(n, sx, sy).map(|m| want == Some(&m));
    let mut t = Some(t);
    while let Some(tree) = t {
        for (j, n) in tree.nodes.iter().enumerate() {
            line.nodes.push(n);
            line.sibs.push(match (j, &siblings) {
                (0, Some(s)) => s.clone(),
                _ => vec![n],
            });
            line.kids.push(if j + 1 < tree.nodes.len() { vec![&tree.nodes[j + 1]] } else { firsts(tree) });
            if let Path::Moves(moves) = path {
                if !line.missing && i < moves.len() {
                    match matches(n, moves.get(i)) {
                        Some(false) => line.missing = true,
                        Some(true) => i += 1,
                        None => {}
                    }
                }
            }
        }
        let mut choice = 1;
        if tree.children.len() > 1 {
            match path {
                Path::Moves(moves) => {
                    if !line.missing && i < moves.len() {
                        let starts = |c: &Tree| c.nodes.iter().find_map(|n| matches(n, moves.get(i))).unwrap_or(false);
                        match tree.children.iter().position(starts) {
                            Some(k) => choice = k + 1,
                            None => line.missing = true,
                        }
                    }
                }
                Path::Numbers(numbers) => {
                    choice = numbers.get(i).copied().unwrap_or(1);
                    i += 1;
                    if choice < 1 || choice > tree.children.len() {
                        line.missing = true;
                        choice = 1;
                    }
                }
            }
            line.choices.push(choice);
        }
        siblings = Some(firsts(tree));
        t = tree.children.get(choice - 1);
    }
    let length = match path {
        Path::Numbers(n) => n.len(),
        Path::Moves(m) => m.len(),
    };
    line.missing = line.missing || i < length;
    line
}

// LO QUE SE LEE DE UNA LÍNEA

/// Lo que pasa en la línea, en orden: el jugador que sigue (PL), el número de la jugada siguiente (MN), una
/// jugada (at: None es un pase; end: un pase con el que termina la línea), y las piedras que se quitan (AE) o
/// se agregan (AB, AW) después de la primera jugada.
#[derive(Debug, PartialEq, Serialize)]
#[serde(tag = "kind", rename_all = "lowercase")]
pub enum Event {
    Player { player: &'static str },
    Number { number: i64 },
    Move { player: &'static str, at: Option<Point>, end: bool },
    Remove { at: Point },
    Add { player: &'static str, at: Point },
}

/// Una marca: shape es triangle, square, circle, cross, selected, black-territory, white-territory o label
/// (con text).
#[derive(Debug, PartialEq, Serialize)]
pub struct Mark {
    pub shape: &'static str,
    pub at: Point,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub text: Option<String>,
}

#[derive(Debug, PartialEq, Serialize)]
pub struct Stroke {
    pub kind: &'static str,
    pub from: Point,
    pub to: Point,
}

/// Una anotación: N (con text) o TE, BM, DO, IT, GB, GW, DM, UC (con value 1 o 2).
#[derive(Debug, PartialEq, Serialize)]
pub struct Note {
    pub property: String,
    pub value: i32,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub text: Option<String>,
}

/// Lo de cada jugada k (0: los nodos anteriores a la primera). Un nodo sin jugada se suma a la anterior.
/// comment: los comentarios de sus nodos, seguidos, en una línea. dim: los puntos atenuados (DD), que siguen
/// hasta el próximo DD. children: las jugadas que pueden seguir; siblings: las alternativas a esta jugada (la
/// incluida); None es un pase.
#[derive(Debug, Default, PartialEq, Serialize)]
pub struct Step {
    pub comment: String,
    pub marks: Vec<Mark>,
    pub dim: Vec<Point>,
    pub strokes: Vec<Stroke>,
    pub notes: Vec<Note>,
    pub children: Vec<Option<Point>>,
    pub siblings: Vec<Option<Point>>,
}

/// Una vista (VW): desde qué jugada vale y su rectángulo (x1, y1, x2, y2); None es todo el tablero.
#[derive(Debug, PartialEq, Serialize)]
pub struct View {
    pub start: usize,
    pub rect: Option<(i32, i32, i32, i32)>,
}

/// Una figura (FG): la jugada donde empieza y su nombre.
#[derive(Debug, PartialEq, Serialize)]
pub struct Figure {
    pub start: usize,
    pub title: Option<String>,
}

/// Una línea leída. style: ST; print: PM (0 sin números, 1 como están, 2 reiniciados cada 100); komi: KM.
#[derive(Debug, Serialize)]
pub struct Reading {
    pub size: (i32, i32),
    pub style: i32,
    pub print: i32,
    pub komi: String,
    pub black: Vec<Point>,
    pub white: Vec<Point>,
    pub events: Vec<Event>,
    pub moves: usize,
    pub steps: Vec<Step>,
    pub figures: Vec<Figure>,
    pub views: Vec<View>,
    pub choices: Vec<usize>,
    pub missing: bool,
}

/// Sin el chat de los servidores: en OGS, lo que sigue a una línea "-- chat --"; en KGS, las líneas
/// "nombre [rango]: ..." y, si había alguna, también las "nombre: ..." (los que no tienen rango).
pub fn without_chat(text: &str) -> String {
    let word = |s: &str| !s.is_empty() && s.chars().all(|c| c.is_alphanumeric() || c == '_');
    // "nombre [rango]: ..." o, con ranked: false, "nombre: ...".
    let speaker = |line: &str, ranked: bool| {
        let line = line.trim_start();
        let Some((head, _)) = line.split_once(": ") else { return false };
        if ranked {
            let Some((name, rank)) = head.split_once(" [") else { return false };
            word(name) && rank.ends_with(']') && {
                let r = &rank[..rank.len() - 1];
                !r.is_empty() && r.chars().all(|c| c.is_alphanumeric() || c == '?' || c == '-')
            }
        } else {
            word(head)
        }
    };
    let mut kept = Vec::new();
    let mut ranked = false;
    for line in text.split('\n') {
        if line.trim() == "-- chat --" {
            break;
        }
        if speaker(line, true) {
            ranked = true;
        } else {
            kept.push(line);
        }
    }
    if ranked {
        kept.retain(|line| !speaker(line, false));
    }
    kept.join("\n")
}

fn collapse(text: &str) -> String {
    text.split_whitespace().collect::<Vec<_>>().join(" ")
}

const MARKUP: [(&str, &str); 7] = [
    ("TR", "triangle"), ("SQ", "square"), ("CR", "circle"), ("MA", "cross"), ("SL", "selected"),
    ("TB", "black-territory"), ("TW", "white-territory"),
];

/// Lee la línea path de la partida t. chat: false quita el chat de los comentarios. Un punto fuera del
/// tablero es un error.
pub fn read(t: &Tree, path: &Path, chat: bool) -> Result<Reading, String> {
    let (sx, sy) = size(t.nodes.first());
    let line = line(t, path, sx, sy);
    let root = line.nodes.first().copied();
    let number = |p: &str| root.and_then(|r| r.get(p)).and_then(|v| v.first()).and_then(|v| v.trim().parse::<i32>().ok());
    let komi = root
        .and_then(|r| r.get("KM"))
        .and_then(|v| v.first())
        .filter(|v| v.trim().parse::<f64>().is_ok())
        .map(|v| v.trim().to_string())
        .unwrap_or_else(|| "0".into());
    let mut r = Reading {
        size: (sx, sy),
        style: number("ST").unwrap_or(0),
        print: number("PM").unwrap_or(1),
        komi,
        black: vec![],
        white: vec![],
        events: vec![],
        moves: 0,
        steps: vec![Step::default()],
        figures: vec![],
        views: vec![],
        choices: line.choices.clone(),
        missing: line.missing,
    };
    let inside = |p: Point, v: &str| {
        if p.0 >= 1 && p.1 >= 1 && p.0 <= sx && p.1 <= sy { Ok(p) } else {
            Err(format!("SGF: «{v}» no está en el tablero de {sx}×{sy}"))
        }
    };
    let points = |n: &Props, property: &str| -> Result<Vec<Point>, String> {
        let mut list = Vec::new();
        for v in n.get(property).into_iter().flatten() {
            for p in coords(v, sy) {
                list.push(inside(p, v)?);
            }
        }
        Ok(list)
    };
    let move_of = |n: &Props| node_move(n, sx, sy);
    let moves_of = |list: &[&Props]| list.iter().filter_map(|n| move_of(n)).collect::<Vec<_>>();
    let mut started = false;
    let mut dim: Vec<Point> = Vec::new();
    for (idx, n) in line.nodes.iter().enumerate() {
        let played = r.moves;
        // VW: la vista desde la jugada de este nodo (o la siguiente). VW[] es todo el tablero.
        if n.contains_key("VW") {
            let ps = points(n, "VW")?;
            let rect = ps.iter().fold(None, |acc: Option<(i32, i32, i32, i32)>, &(x, y)| {
                Some(match acc {
                    None => (x, y, x, y),
                    Some((a, b, c, d)) => (a.min(x), b.min(y), c.max(x), d.max(y)),
                })
            });
            match r.views.last_mut() {
                Some(v) if v.start == played + 1 => v.rect = rect,
                _ => r.views.push(View { start: played + 1, rect }),
            }
        }
        if let Some(p) = n.get("PL").and_then(|v| v.first()) {
            match p.trim().to_ascii_uppercase().as_str() {
                "B" => r.events.push(Event::Player { player: "black" }),
                "W" => r.events.push(Event::Player { player: "white" }),
                _ => {}
            }
        }
        // Las piedras iniciales son las de los nodos anteriores a la primera jugada; después, se quitan (AE) y
        // se agregan entre las jugadas.
        for p in points(n, "AE")? {
            if started {
                r.events.push(Event::Remove { at: p });
            } else {
                r.black.retain(|&q| q != p);
                r.white.retain(|&q| q != p);
            }
        }
        for (property, player) in [("AB", "black"), ("AW", "white")] {
            for p in points(n, property)? {
                if started {
                    r.events.push(Event::Add { player, at: p });
                } else {
                    r.black.retain(|&q| q != p);
                    r.white.retain(|&q| q != p);
                    if player == "black" { r.black.push(p) } else { r.white.push(p) }
                }
            }
        }
        for (property, player) in [("B", "black"), ("W", "white")] {
            let Some(values) = n.get(property) else { continue };
            started = true;
            // MN cambia el número de esta jugada (las siguientes siguen desde ahí).
            if let Some(mn) = n.get("MN").and_then(|v| v.first()).and_then(|v| v.trim().parse::<i64>().ok()) {
                r.events.push(Event::Number { number: mn });
            }
            let v = values.first().map(String::as_str).unwrap_or("");
            let at = if v == "tt" && sx <= 19 && sy <= 19 { None } else { coords(v, sy).first().copied() };
            let at = match at {
                Some(p) => Some(inside(p, v)?),
                None => None,
            };
            r.events.push(Event::Move { player, at, end: false });
            r.moves += 1;
            r.steps.push(Step { dim: dim.clone(), siblings: moves_of(&line.sibs[idx]), ..Step::default() });
        }
        let played = r.moves;
        let step = &mut r.steps[played];
        // Las jugadas que pueden seguir: las del último nodo de la jugada.
        step.children = moves_of(&line.kids[idx]);
        // FG: una figura nueva empieza en esta jugada (o en la siguiente, si el nodo no tiene jugada).
        if let Some(fg) = n.get("FG") {
            let v = fg.first().map(String::as_str).unwrap_or("");
            let title = match v.split_once(':') {
                Some((digits, rest)) if digits.chars().all(|c| c.is_ascii_digit()) => rest.to_string(),
                _ if v.chars().all(|c| c.is_ascii_digit()) => String::new(),
                _ => v.to_string(),
            };
            let start = if has_move(n) { played } else { played + 1 };
            let title = (!title.is_empty()).then_some(title);
            match r.figures.last_mut() {
                Some(f) if f.start == start => f.title = title,
                _ => r.figures.push(Figure { start, title }),
            }
        }
        for property in ["N", "TE", "BM", "DO", "IT", "GB", "GW", "DM", "UC"] {
            let Some(v) = n.get(property) else { continue };
            step.notes.push(if property == "N" {
                Note { property: "N".into(), value: 1, text: Some(collapse(&v.join(" "))) }
            } else {
                let value = if v.first().and_then(|v| v.trim().parse::<f64>().ok()) == Some(2.0) { 2 } else { 1 };
                Note { property: property.into(), value, text: None }
            });
        }
        if let Some(c) = n.get("C") {
            let raw = c.join("\n");
            let text = collapse(&if chat { raw } else { without_chat(&raw) });
            if !text.is_empty() {
                if !step.comment.is_empty() {
                    step.comment.push(' ');
                }
                step.comment.push_str(&text);
            }
        }
        for (property, shape) in MARKUP {
            for p in points(n, property)? {
                step.marks.push(Mark { shape, at: p, text: None });
            }
        }
        for v in n.get("LB").into_iter().flatten() {
            if let Some((at, text)) = v.split_once(':') {
                for p in coords(at, sy) {
                    step.marks.push(Mark { shape: "label", at: inside(p, at)?, text: Some(text.to_string()) });
                }
            }
        }
        // DD reemplaza los puntos atenuados (DD[] los quita); sin DD, siguen los del nodo anterior.
        if n.contains_key("DD") {
            dim = points(n, "DD")?;
        }
        step.dim = dim.clone();
        for (property, kind) in [("AR", "arrow"), ("LN", "line")] {
            for v in n.get(property).into_iter().flatten() {
                let Some((a, b)) = v.split_once(':') else { continue };
                if let (Some(p), Some(q)) = (point(a, sy), point(b, sy)) {
                    step.strokes.push(Stroke { kind, from: inside(p, v)?, to: inside(q, v)? });
                }
            }
        }
    }
    // Los pases con los que termina la línea la cierran.
    for e in r.events.iter_mut().rev() {
        match e {
            Event::Move { at: None, end, .. } => *end = true,
            Event::Move { .. } => break,
            _ => {}
        }
    }
    Ok(r)
}

/// Una propiedad de la jugada k de la línea (la de su nodo y la de los nodos sin jugada que lo siguen; k = 0:
/// los nodos anteriores a la primera jugada).
pub fn info(t: &Tree, path: &Path, k: usize, property: &str) -> Vec<String> {
    let (sx, sy) = size(t.nodes.first());
    let mut out = Vec::new();
    let mut played = 0;
    for n in line(t, path, sx, sy).nodes {
        if has_move(n) {
            played += 1;
        }
        if played > k {
            break;
        }
        if played == k {
            out.extend(n.get(property).into_iter().flatten().cloned());
        }
    }
    out
}

// EL ÁRBOL

type Rect = Option<(i32, i32, i32, i32)>;

/// Suma al rectángulo los puntos que se dibujan del nodo (con stones, solo las piedras y las jugadas). Una
/// flecha aa:cc se lee como el rectángulo de sus extremos.
fn node_box(mut rect: Rect, n: &Props, sx: i32, sy: i32, stones: bool) -> Rect {
    let mut extend = |v: &str| {
        if v == "tt" && sx <= 19 && sy <= 19 {
            return;
        }
        for (x, y) in coords(v, sy) {
            if x <= sx && y >= 1 {
                rect = Some(match rect {
                    None => (x, y, x, y),
                    Some((a, b, c, d)) => (a.min(x), b.min(y), c.max(x), d.max(y)),
                });
            }
        }
    };
    let properties: &[&str] = if stones {
        &["AB", "AW", "B", "W"]
    } else {
        &["AB", "AW", "B", "W", "TR", "SQ", "CR", "MA", "SL", "AR", "LN"]
    };
    for p in properties {
        for v in n.get(*p).into_iter().flatten() {
            extend(v);
        }
    }
    if !stones {
        for v in n.get("LB").into_iter().flatten() {
            extend(v.split_once(':').map(|(a, _)| a).unwrap_or(""));
        }
    }
    rect
}

/// Todas las líneas de la partida, como caminos de números, en orden (la única línea de una partida sin
/// bifurcaciones es el camino vacío); y el rectángulo con todo lo que se dibuja del árbol.
#[derive(Debug, Serialize)]
pub struct Shape {
    pub paths: Vec<Vec<usize>>,
    pub rect: Rect,
}

pub fn shape(t: &Tree) -> Shape {
    let (sx, sy) = size(t.nodes.first());
    fn walk(tree: &Tree, prefix: &mut Vec<usize>, out: &mut Shape, sx: i32, sy: i32) {
        for n in &tree.nodes {
            out.rect = node_box(out.rect, n, sx, sy, false);
        }
        match tree.children.len() {
            0 => out.paths.push(prefix.clone()),
            1 => walk(&tree.children[0], prefix, out, sx, sy),
            _ => {
                for (i, c) in tree.children.iter().enumerate() {
                    prefix.push(i + 1);
                    walk(c, prefix, out, sx, sy);
                    prefix.pop();
                }
            }
        }
    }
    let mut out = Shape { paths: vec![], rect: None };
    walk(t, &mut vec![], &mut out, sx, sy);
    out
}

/// El rectángulo con las piedras y las jugadas de las líneas (sin las marcas).
pub fn extent(t: &Tree, paths: &[Path]) -> Rect {
    let (sx, sy) = size(t.nodes.first());
    let mut rect = None;
    for path in paths {
        for n in line(t, path, sx, sy).nodes {
            rect = node_box(rect, n, sx, sy, true);
        }
    }
    rect
}

/// Una variante: cada línea que se aparta de la línea dada, con su camino (sin los 1 del final); depth:
/// cuántas veces se aparta; born: la jugada de la línea que reemplaza la primera vez; start: su primera
/// jugada propia; last: su cantidad de jugadas; commented: si algún nodo propio tiene comentario.
#[derive(Debug, PartialEq, Serialize)]
pub struct Branch {
    pub path: Vec<usize>,
    pub depth: usize,
    pub born: usize,
    pub start: usize,
    pub last: usize,
    pub commented: bool,
}

/// Las variantes que se apartan de la línea path, por la jugada donde nacen (las que nacen en la misma, en
/// el orden del árbol).
pub fn branches(t: &Tree, path: &Path) -> Vec<Branch> {
    let (sx, sy) = size(t.nodes.first());
    let base = line(t, path, sx, sy).choices;
    struct Walk<'a> {
        base: &'a [usize],
        list: Vec<Branch>,
    }
    #[allow(clippy::too_many_arguments)]
    fn walk(w: &mut Walk, tree: &Tree, choices: &mut Vec<usize>, depth: usize, mut moves: usize, born: usize,
        start: usize, mut commented: bool) {
        for n in &tree.nodes {
            if has_move(n) {
                moves += 1;
            }
            if depth > 0 && n.get("C").is_some_and(|c| c.iter().any(|v| !v.trim().is_empty())) {
                commented = true;
            }
        }
        match tree.children.len() {
            0 => {
                if depth > 0 {
                    let mut p = choices.clone();
                    while p.last() == Some(&1) {
                        p.pop();
                    }
                    w.list.push(Branch { path: p, depth, born, start, last: moves, commented });
                }
            }
            1 => walk(w, &tree.children[0], choices, depth, moves, born, start, commented),
            _ => {
                // En la línea, la bifurcación siguiente sigue por base; fuera de ella, por la primera.
                let follow = if depth == 0 { w.base.get(choices.len()).copied().unwrap_or(1) } else { 1 };
                for (i, c) in tree.children.iter().enumerate() {
                    choices.push(i + 1);
                    if i + 1 == follow {
                        walk(w, c, choices, depth, moves, born, start, commented);
                    } else {
                        let born = if depth == 0 { moves + 1 } else { born };
                        walk(w, c, choices, depth + 1, moves, born, moves + 1, false);
                    }
                    choices.pop();
                }
            }
        }
    }
    let mut w = Walk { base: &base, list: vec![] };
    walk(&mut w, t, &mut vec![], 0, 0, 0, 0, false);
    // sort_by_key es estable: las que nacen en la misma jugada quedan en el orden del árbol.
    w.list.sort_by_key(|b| b.born);
    w.list
}

/// El camino como números, sin los 1 del final. Un camino de jugadas se traduce con las variantes que toma;
/// None si no existe.
pub fn numbers(t: &Tree, path: &Path) -> Option<Vec<usize>> {
    let mut p = match path {
        Path::Numbers(n) => n.clone(),
        Path::Moves(_) => {
            let (sx, sy) = size(t.nodes.first());
            let line = line(t, path, sx, sy);
            if line.missing {
                return None;
            }
            line.choices
        }
    };
    while p.last() == Some(&1) {
        p.pop();
    }
    Some(p)
}

// LO QUE PIDE src/sgf.typ

#[derive(Deserialize)]
pub struct Request {
    #[serde(default)]
    pub charset: Option<String>,
    /// Dónde va el punto aa: "top-left" (o nada), "top-right", "bottom-left" o "bottom-right".
    #[serde(default)]
    pub origin: Option<String>,
    #[serde(default)]
    pub transpose: bool,
    /// La sintaxis del archivo: "sgf", "sensei" (los diagramas de Sensei's Library) o nada, que es sensei si no
    /// tiene nodos SGF y tiene líneas $$.
    #[serde(default)]
    pub syntax: Option<String>,
    #[serde(default = "first")]
    pub game: usize,
    pub query: Query,
}

fn first() -> usize {
    1
}

fn yes() -> bool {
    true
}

#[derive(Deserialize)]
#[serde(tag = "kind", rename_all = "lowercase")]
pub enum Query {
    /// El tamaño de cada partida del archivo.
    Games,
    /// Un hash (FNV-1a de 64 bits, en hexadecimal) de los bytes del archivo: identifica un problema en los enlaces.
    Hash,
    Read {
        #[serde(default)]
        path: Path,
        #[serde(default = "yes")]
        chat: bool,
    },
    Info {
        #[serde(default)]
        path: Path,
        #[serde(default)]
        r#move: usize,
        property: String,
    },
    Shape,
    Extent { paths: Vec<Path> },
    Branches {
        #[serde(default)]
        path: Path,
    },
    Numbers { path: Path },
}

pub fn answer(data: &[u8], request: &Request) -> Result<serde_json::Value, String> {
    if let Query::Hash = request.query {
        let hash = data.iter().fold(0xcbf29ce484222325u64, |h, &b| (h ^ b as u64).wrapping_mul(0x100000001b3));
        return Ok(serde_json::json!(format!("{hash:016x}")));
    }
    let text = decode(data, request.charset.as_deref())?;
    let o = Orientation {
        right: matches!(request.origin.as_deref(), Some("top-right" | "bottom-right")),
        bottom: matches!(request.origin.as_deref(), Some("bottom-left" | "bottom-right")),
        transpose: request.transpose,
    };
    let sensei = match request.syntax.as_deref() {
        None => sensei::is_diagram(&text),
        Some("sgf") => false,
        Some("sensei") => true,
        Some(other) => return Err(format!("sintaxis desconocida: {other} (son \"sgf\" y \"sensei\")")),
    };
    let mut games = if sensei { sensei::parse_diagrams(&text)? } else { parse(&text) };
    if o != Orientation::default() {
        for t in &mut games {
            let s = size(t.nodes.first());
            orient(t, s, o);
        }
    }
    if let Query::Games = request.query {
        return Ok(serde_json::json!(games.iter().map(|t| size(t.nodes.first())).collect::<Vec<_>>()));
    }
    let empty = Tree::default();
    let t = match games.get(request.game.wrapping_sub(1)) {
        Some(t) => t,
        None if games.is_empty() && request.game == 1 => &empty,
        None => return Err(format!("el archivo SGF no tiene la partida {} (tiene {})", request.game, games.len())),
    };
    let json = |v: Result<serde_json::Value, serde_json::Error>| v.map_err(|e| e.to_string());
    match &request.query {
        Query::Games | Query::Hash => unreachable!(),
        Query::Read { path, chat } => json(serde_json::to_value(read(t, path, *chat)?)),
        Query::Info { path, r#move, property } => json(serde_json::to_value(info(t, path, *r#move, property))),
        Query::Shape => json(serde_json::to_value(shape(t))),
        Query::Extent { paths } => json(serde_json::to_value(extent(t, paths))),
        Query::Branches { path } => json(serde_json::to_value(branches(t, path))),
        Query::Numbers { path } => json(serde_json::to_value(numbers(t, path))),
    }
}

pub fn answer_json(data: &[u8], request: &[u8]) -> Result<Vec<u8>, String> {
    let request: Request = serde_json::from_slice(request).map_err(|e| format!("pedido SGF del kernel: {e}"))?;
    serde_json::to_vec(&answer(data, &request)?).map_err(|e| e.to_string())
}

mod sensei;

#[cfg(test)]
mod tests;
