// Los diagramas de Sensei's Library (y de los foros como L19): líneas que empiezan con $$. Cada bloque de líneas
// $$ seguidas es una partida, leída como un árbol SGF; lo que hay entre los bloques no se lee. Es el lector de
// pgf-go (parse_diagram, en pgf-go.lua); lo que allí es un aviso aquí es un error.

use super::{Props, Tree};

/// Los puntos _ de un diagrama van en esta propiedad de la raíz (un archivo SGF no puede tenerla): son el blank del
/// tablero.
pub const BLANK: &str = "_blank";

/// Si el texto es de diagramas: no tiene nodos SGF («(;») y tiene alguna línea que empieza con $$.
pub fn is_diagram(text: &str) -> bool {
    let b = text.as_bytes();
    let node = (0..b.len()).any(|i| {
        b[i] == b'(' && b[i + 1..].iter().find(|c| !c.is_ascii_whitespace()) == Some(&b';')
    });
    !node && text.lines().any(|l| l.trim_start_matches([' ', '\t']).starts_with("$$"))
}

/// Las piedras y las marcas de cada símbolo. Los números son jugadas, las minúsculas son letras, . y , son puntos
/// vacíos (los puntos de estrella los pone el tablero) y _ es fuera del tablero.
fn stone(c: char) -> Option<&'static str> {
    match c {
        'X' | 'B' | '#' | 'Y' | 'Z' => Some("AB"),
        'O' | 'W' | '@' | 'Q' | 'P' => Some("AW"),
        _ => None,
    }
}

fn mark(c: char) -> Option<&'static str> {
    match c {
        'B' | 'W' | 'C' => Some("CR"),
        '#' | '@' | 'S' => Some("SQ"),
        'Y' | 'Q' | 'T' => Some("TR"),
        'Z' | 'P' | 'M' => Some("MA"),
        _ => None,
    }
}

const SYMBOLS: &str = "0123456789abcdefghijklmnopqrstuvwxyz.,XOBW#@YQZPCSTM_";

fn letter(n: i32) -> char {
    if n <= 26 { (b'a' + (n - 1) as u8) as char } else { (b'A' + (n - 27) as u8) as char }
}

/// La columna de una coordenada del tablero (las letras del go, sin la I; después de la Z, dos letras).
fn column(letters: &str) -> Option<i32> {
    let code = |c: u8| (c as i32) - (b'A' as i32);
    match letters.as_bytes() {
        [c] if c.is_ascii_uppercase() && *c != b'I' => Some(code(*c) + if *c > b'I' { 0 } else { 1 }),
        [a, b] if a.is_ascii_uppercase() && b.is_ascii_uppercase() => Some(25 + code(*a) * 26 + code(*b) + 1),
        _ => None,
    }
}

/// Un número de la cabecera, al principio de h: el número y lo que sigue.
fn leading_number(h: &str) -> (Option<i32>, &str) {
    let digits = h.len() - h.trim_start_matches(|c: char| c.is_ascii_digit()).len();
    (h[..digits].parse().ok(), &h[digits..])
}

/// Una línea {AR p q} o {LN p q}: la propiedad y los dos puntos.
fn drawn_line(l: &str) -> Option<(String, String, String)> {
    let inner = l.strip_prefix('{')?.strip_suffix('}')?;
    let parts: Vec<&str> = inner.split_whitespace().collect();
    match parts.as_slice() {
        [kind @ ("AR" | "LN"), p, q] => Some((kind.to_string(), p.to_string(), q.to_string())),
        _ => None,
    }
}

/// El diagrama number, de las líneas lines (sin el $$), como partida.
fn diagram(number: usize, lines: &[&str]) -> Result<Tree, String> {
    let fail = |what: String| Err(format!("el diagrama {number} de Sensei's Library: {what}"));
    // La cabecera: B o W (quién juega la 1), c (las coordenadas: no se usa, las pone el tablero), el tamaño, m y el
    // número de la 1, y el título.
    let mut h = lines[0];
    let explicit = h.starts_with(['B', 'W']);
    let first = if h.starts_with('W') { "W" } else { "B" };
    if explicit {
        h = &h[1..];
    }
    h = h.strip_prefix('c').unwrap_or(h);
    let (size, rest) = leading_number(h);
    h = rest;
    let mut start = 1;
    if let Some(after) = h.strip_prefix('m') {
        let (n, rest) = leading_number(after);
        if let Some(n) = n {
            start = n;
            h = rest;
        }
    }
    let title = h.trim();

    let (mut rows, mut drawn) = (Vec::<Vec<char>>::new(), Vec::new());
    let (mut north, mut south, mut west, mut east) = (false, false, false, false);
    for raw in &lines[1..] {
        let l = raw.trim();
        if l.is_empty() || (l.starts_with('[') && l.ends_with(']')) {
            // Los enlaces ([a|página]) no se leen.
        } else if let Some(d) = drawn_line(l) {
            drawn.push(d);
        } else if l.contains('-') && l.chars().all(|c| "-+| \t".contains(c)) {
            if rows.is_empty() { north = true } else { south = true }
        } else {
            let mut r: String = l.chars().filter(|c| !c.is_whitespace()).collect();
            if r.starts_with(['|', '+']) {
                west = true;
                r.remove(0);
            }
            if r.ends_with(['|', '+']) {
                east = true;
                r.pop();
            }
            if r.is_empty() || r.chars().any(|c| !SYMBOLS.contains(c)) {
                return fail(format!("no se entiende la línea «{l}»"));
            }
            rows.push(r.chars().collect());
        }
    }
    let nr = rows.len() as i32;
    let nc = rows.iter().map(|r| r.len()).max().unwrap_or(0) as i32;
    // El tablero: el tamaño de la cabecera; sin tamaño, el que dicen dos bordes opuestos (el otro lado es igual, si
    // entra) o 19.
    let (sx, sy) = match size {
        Some(n) => (n, n),
        None => {
            let w = (west && east).then_some(nc);
            let h = (north && south).then_some(nr);
            (w.or(h.filter(|&h| h >= nc)).unwrap_or(19), h.or(w.filter(|&w| w >= nr)).unwrap_or(19))
        }
    };
    if nc > sx || nr > sy {
        return fail(format!("mide {nc}×{nr} y su tablero, {sx}×{sy}"));
    }
    // Dónde está el diagrama: contra los bordes que tiene; sin bordes, en el medio.
    let x0 = if west { 0 } else if east { sx - nc } else { (sx - nc) / 2 };
    let top = if north { sy } else if south { nr } else { sy - (sy - nr) / 2 };
    let at = |j: i32, i: i32| format!("{}{}", letter(x0 + j), letter(sy - top + i));
    // Un punto de AR o LN: del diagrama (5:6, columna y fila desde arriba a la izquierda) o del tablero (C14).
    let board_point = |text: &str| {
        let (x, y) = match text.split_once(':') {
            Some((j, i)) => (x0 + j.parse::<i32>().ok()?, top - i.parse::<i32>().ok()? + 1),
            None => {
                let digits = text.trim_start_matches(|c: char| c.is_ascii_uppercase());
                (column(&text[..text.len() - digits.len()])?, digits.parse::<i32>().ok()?)
            }
        };
        (x >= 1 && x <= sx && y >= 1 && y <= sy).then(|| format!("{}{}", letter(x), letter(sy - y + 1)))
    };

    let mut root = Props::new();
    root.insert("SZ".into(), vec![if sx == sy { sx.to_string() } else { format!("{sx}:{sy}") }]);
    let mut markup = Props::new();
    let add = |node: &mut Props, property: &str, value: String| node.entry(property.into()).or_default().push(value);
    let mut moves: [Option<String>; 11] = Default::default();
    for (i, r) in rows.iter().enumerate() {
        for (j, &c) in r.iter().enumerate() {
            let p = at(j as i32 + 1, i as i32 + 1);
            if let Some(d) = c.to_digit(10) {
                let n = if d == 0 { 10 } else { d as usize };
                moves[n].get_or_insert(p);
            } else if c.is_ascii_lowercase() {
                add(&mut markup, "LB", format!("{p}:{c}"));
            } else if c == '_' {
                add(&mut root, BLANK, p);
            } else {
                if let Some(property) = stone(c) {
                    add(&mut root, property, p.clone());
                }
                if let Some(property) = mark(c) {
                    add(&mut markup, property, p);
                }
            }
        }
    }
    for (kind, p, q) in &drawn {
        match (board_point(p), board_point(q)) {
            (Some(a), Some(b)) => add(&mut markup, kind, format!("{a}:{b}")),
            _ => return fail(format!("la línea {{{kind} {p} {q}}} sale del tablero")),
        }
    }
    if !title.is_empty() {
        root.insert("GN".into(), vec![title.to_string()]);
        root.insert("FG".into(), vec![format!("0:{title}")]);
    }
    if explicit {
        root.insert("PL".into(), vec![first.to_string()]);
    }
    // La vista es lo dibujado, si no es todo el tablero.
    if nr > 0 && (nc < sx || nr < sy) {
        root.insert("VW".into(), vec![format!("{}:{}", at(1, 1), at(nc, nr))]);
    }
    let mut nodes = vec![root];
    let mut last = 0;
    for (n, p) in moves.iter().enumerate().skip(1) {
        let Some(p) = p else { continue };
        let color = if (n % 2 == 1) == (first == "B") { "B" } else { "W" };
        let mut node = Props::new();
        node.insert(color.into(), vec![p.clone()]);
        if n != last + 1 || (last == 0 && start != 1) {
            node.insert("MN".into(), vec![(n as i32 + start - 1).to_string()]);
        }
        nodes.push(node);
        last = n;
    }
    let node = nodes.last_mut().unwrap();
    for (property, values) in markup {
        node.insert(property, values);
    }
    Ok(Tree { nodes, children: Vec::new() })
}

/// Los diagramas del texto, uno por bloque de líneas $$. Las etiquetas [go] y [/go] de L19 se pueden dejar.
pub fn parse_diagrams(text: &str) -> Result<Vec<Tree>, String> {
    // Las minúsculas ASCII no cambian las posiciones de los bytes.
    let lower = text.to_ascii_lowercase();
    let mut clean = String::with_capacity(text.len());
    let mut i = 0;
    while i < text.len() {
        let tag = ["[go]", "[/go]"].into_iter().find(|t| lower[i..].starts_with(t));
        if let Some(t) = tag {
            clean.push('\n');
            i += t.len();
        } else {
            let c = text[i..].chars().next().unwrap();
            clean.push(c);
            i += c.len_utf8();
        }
    }
    let mut games = Vec::new();
    let mut block: Vec<&str> = Vec::new();
    for line in clean.lines().chain(std::iter::once("")) {
        match line.trim_start().strip_prefix("$$") {
            Some(body) => block.push(body),
            None if !block.is_empty() => {
                games.push(diagram(games.len() + 1, &block)?);
                block.clear();
            }
            None => {}
        }
    }
    Ok(games)
}
