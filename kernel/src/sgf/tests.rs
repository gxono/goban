// Las pruebas de la lectura de SGF. Las partidas son las de los ejemplos de pgf-go (doc/es/*.sgf).

use super::*;

const PARTIDA: &str = "(;GM[1]FF[4]SZ[9]PB[Negras]PW[Blancas]C[Una partida corta.]
;B[ee];W[ef];B[df];W[ce];B[ff];W[gd];B[eg]C[Negras capturan.];W[dd];B[cf];W[fd])";

const VARIANTES: &str = "(;GM[1]FF[4]SZ[7]PB[Ana]PW[Bruno]RE[B+R]KM[6.5]DT[2026-10-13]
AB[dd]
;B[cc]TR[dd]
(;W[ee]SQ[cc]CR[ee]MA[aa]LB[gg:A][ag:B]
 ;B[ec]
 (;W[ce]MN[10]
  ;B[cf])
 (;W[fe]))
(;W[ce]
 ;B[ec]TR[ec]))";

const PROBLEMA: &str = "(;GM[1]FF[4]SZ[19]PL[B]C[Negras matan.]
AW[ab][bb][cb][db][da]AB[ac][bc][cc][dc][ec][eb][ea]
(;B[ba]TE[1]C[Correcto: el punto vital.]
(;W[aa];B[ca])
(;W[ca];B[aa]C[Blancas tienen un solo ojo.]))
(;B[aa]BM[1]C[Incorrecto: Blancas viven.];W[ba])
(;B[ca]C[Incorrecto.];W[ba]))";

fn game(text: &str) -> Tree {
    parse(text).into_iter().next().unwrap()
}

fn numbers_path(n: &[usize]) -> Path {
    Path::Numbers(n.to_vec())
}

#[test]
fn decodes_charsets() {
    assert_eq!(decode("(;C[año])".as_bytes(), None).unwrap(), "(;C[año])");
    // Sin CA y sin UTF-8 válido, Latin-1 (no windows-1252: 0x80 es U+0080).
    assert_eq!(decode(b"(;C[a\xf1o\x80])", None).unwrap(), "(;C[a\u{f1}o\u{80}])");
    // Con CA.
    assert_eq!(decode(b"(;CA[GBK]C[\xc6\xe5])", None).unwrap(), "(;CA[GBK]C[棋])");
    assert_eq!(decode(b"(;CA[Shift_JIS]C[\x8a\xfb])", None).unwrap(), "(;CA[Shift_JIS]C[棋])");
    assert_eq!(decode(b"(;CA[euc-kr]C[\xb9\xd9\xb5\xcf])", None).unwrap(), "(;CA[euc-kr]C[바둑])");
    // La forzada gana sobre CA; un segundo byte que es ] no cierra el valor.
    assert_eq!(decode(b"(;CA[latin1]C[\xb1\x5d])", Some("big5")).unwrap(), "(;CA[latin1]C[崧])");
    // Un archivo UTF-8 válido se lee como UTF-8 aunque CA diga otra cosa.
    assert_eq!(decode("(;CA[GBK]C[ñ])".as_bytes(), None).unwrap(), "(;CA[GBK]C[ñ])");
    // UTF-16 con BOM.
    let utf16: Vec<u8> = [0xFF, 0xFE].into_iter().chain("(;C[é])".encode_utf16().flat_map(|u| u.to_le_bytes())).collect();
    assert_eq!(decode(&utf16, None).unwrap(), "(;C[é])");
    // Una codificación desconocida es un error cuando hace falta.
    assert!(decode(b"(;CA[KOI8-R]C[\xc1])", None).is_err());
    assert!(decode(b"(;CA[KOI8-R]C[a])", None).is_ok());
    assert!(decode(b"(;C[a])", Some("klingon")).is_err());
}

#[test]
fn parses_trees() {
    let games = parse("(;SZ[9]C[a\\]b\\\\c];B[aa](;W[bb])(;W[cc]AddBlack[dd]))(SZ[5])");
    assert_eq!(games.len(), 2);
    let t = &games[0];
    assert_eq!(t.nodes[0]["C"], vec!["a]b\\c"]);
    assert_eq!(t.children.len(), 2);
    assert_eq!(t.children[1].nodes[0]["AB"], vec!["dd"]);
    // La raíz sin ; de algunos archivos viejos.
    assert_eq!(games[1].nodes[0]["SZ"], vec!["5"]);
    // Una \ antes de un salto de línea lo quita.
    assert_eq!(game("(;C[uno\\\ndos])").nodes[0]["C"], vec!["unodos"]);
    // Varios valores, y la misma propiedad dos veces.
    assert_eq!(game("(;AB[aa][bb]AB[cc])").nodes[0]["AB"], vec!["aa", "bb", "cc"]);
}

#[test]
fn reads_coordinates() {
    assert_eq!(coords("ab", 9), vec![(1, 8)]);
    assert_eq!(coords("aa:bb", 9), vec![(1, 8), (1, 9), (2, 8), (2, 9)]);
    assert_eq!(coords("bb:aa", 9), coords("aa:bb", 9));
    assert_eq!(coords("Aa", 52), vec![(27, 52)]);
    assert_eq!(coords("", 9), vec![]);
    assert_eq!(size(Some(&game("(;SZ[19:13])").nodes[0])), (19, 13));
    assert_eq!(size(None), (19, 19));
}

#[test]
fn reads_a_game() {
    let t = game(PARTIDA);
    let r = read(&t, &Path::default(), true).unwrap();
    assert_eq!(r.size, (9, 9));
    assert_eq!(r.moves, 10);
    assert_eq!(r.events[0], Event::Move { player: "black", at: Some((5, 5)), end: false });
    assert_eq!(r.events[1], Event::Move { player: "white", at: Some((5, 4)), end: false });
    assert_eq!(r.steps[0].comment, "Una partida corta.");
    assert_eq!(r.steps[7].comment, "Negras capturan.");
    assert_eq!(r.steps[1].children, vec![Some((5, 4))]);
    assert_eq!(r.komi, "0");
}

#[test]
fn reads_variations() {
    let t = game(VARIANTES);
    let main = read(&t, &Path::default(), true).unwrap();
    assert_eq!(main.black, vec![(4, 4)]);
    assert_eq!(main.moves, 5);
    assert_eq!(main.komi, "6.5");
    assert_eq!(main.choices, vec![1, 1]);
    assert!(!main.missing);
    // MN[10] en la cuarta jugada.
    assert_eq!(main.events[3], Event::Number { number: 10 });
    // Las marcas de la jugada 2.
    let marks = &main.steps[2].marks;
    assert_eq!(marks.iter().map(|m| m.shape).collect::<Vec<_>>(), vec!["square", "circle", "cross", "label", "label"]);
    assert_eq!(marks[3], Mark { shape: "label", at: (7, 1), text: Some("A".into()) });
    // Las variantes: dos jugadas pueden seguir a la 1, y la 2 tiene una alternativa.
    assert_eq!(main.steps[1].children, vec![Some((5, 3)), Some((3, 3))]);
    assert_eq!(main.steps[2].siblings, vec![Some((5, 3)), Some((3, 3))]);
    assert_eq!(main.steps[4].siblings, vec![Some((3, 3)), Some((6, 3))]);

    let second = read(&t, &numbers_path(&[2]), true).unwrap();
    assert_eq!(second.moves, 3);
    assert_eq!(second.steps[3].marks, vec![Mark { shape: "triangle", at: (5, 5), text: None }]);
    let by_moves = read(&t, &Path::Moves(vec![Some((3, 5)), Some((3, 3))]), true).unwrap();
    assert_eq!(by_moves.choices, vec![2]);
    let deep = read(&t, &numbers_path(&[1, 2]), true).unwrap();
    assert_eq!(deep.moves, 4);
    // Caminos que no existen: se sigue por la primera.
    assert!(read(&t, &numbers_path(&[3]), true).unwrap().missing);
    assert!(read(&t, &numbers_path(&[1, 1, 1]), true).unwrap().missing);
    assert!(read(&t, &Path::Moves(vec![Some((3, 5)), Some((1, 1))]), true).unwrap().missing);
}

#[test]
fn reads_setup_and_events() {
    let t = game("(;SZ[5]AB[aa][bb]AW[bb];B[cc];AE[aa]AW[dd]PL[W];W[];B[tt];W[])");
    let r = read(&t, &Path::default(), true).unwrap();
    // AW[bb] reemplaza la negra puesta antes.
    assert_eq!(r.black, vec![(1, 5)]);
    assert_eq!(r.white, vec![(2, 4)]);
    assert_eq!(r.events, vec![
        Event::Move { player: "black", at: Some((3, 3)), end: false },
        Event::Player { player: "white" },
        Event::Remove { at: (1, 5) },
        Event::Add { player: "white", at: (4, 2) },
        Event::Move { player: "white", at: None, end: true },
        Event::Move { player: "black", at: None, end: true },
        Event::Move { player: "white", at: None, end: true },
    ]);
    // Un punto fuera del tablero es un error.
    assert!(read(&game("(;SZ[5];B[ff])"), &Path::default(), true).is_err());
    assert!(read(&game("(;SZ[5]TR[ag])"), &Path::default(), true).is_err());
}

#[test]
fn reads_annotations_views_and_figures() {
    let t = game("(;SZ[9]VW[aa:cc]DD[aa];B[ee]N[ Uno\n dos ]TE[2]BM[]FG[257:Figura 1];W[dd]VW[]C[x]DD[];B[cc]FG[])");
    let r = read(&t, &Path::default(), true).unwrap();
    assert_eq!(r.views, vec![View { start: 1, rect: Some((1, 7, 3, 9)) }, View { start: 2, rect: None }]);
    assert_eq!(r.figures, vec![Figure { start: 1, title: Some("Figura 1".into()) }, Figure { start: 3, title: None }]);
    assert_eq!(r.steps[1].notes, vec![
        Note { property: "N".into(), value: 1, text: Some("Uno dos".into()) },
        Note { property: "TE".into(), value: 2, text: None },
        Note { property: "BM".into(), value: 1, text: None },
    ]);
    assert_eq!(r.steps[0].dim, vec![(1, 9)]);
    assert_eq!(r.steps[1].dim, vec![(1, 9)]);
    assert_eq!(r.steps[2].dim, vec![]);
}

#[test]
fn strips_chat() {
    assert_eq!(without_chat("Bien.\n-- chat --\nana: hola"), "Bien.");
    assert_eq!(without_chat("Bien.\nana [3k]: hola\nbeto: chau\nfin"), "Bien.\nfin");
    // Sin ninguna línea con rango, "nombre: ..." es parte del comentario.
    assert_eq!(without_chat("Nota: esto queda"), "Nota: esto queda");
    let t = game("(;C[Bien.\nana [3k\\]: hola])");
    assert_eq!(read(&t, &Path::default(), false).unwrap().steps[0].comment, "Bien.");
    assert_eq!(read(&t, &Path::default(), true).unwrap().steps[0].comment, "Bien. ana [3k]: hola");
}

#[test]
fn reads_properties() {
    let t = game(VARIANTES);
    assert_eq!(info(&t, &Path::default(), 0, "PB"), vec!["Ana"]);
    assert_eq!(info(&t, &Path::default(), 0, "AB"), vec!["dd"]);
    assert_eq!(info(&t, &Path::default(), 4, "MN"), vec!["10"]);
    assert_eq!(info(&t, &numbers_path(&[2]), 3, "TR"), vec!["ec"]);
    assert_eq!(info(&t, &Path::default(), 0, "XX"), Vec::<String>::new());
}

#[test]
fn walks_the_tree() {
    let t = game(VARIANTES);
    let s = shape(&t);
    assert_eq!(s.paths, vec![vec![1, 1], vec![1, 2], vec![2]]);
    assert_eq!(s.rect, Some((1, 1, 7, 7)));
    assert_eq!(extent(&t, &[Path::default()]), Some((3, 2, 5, 5)));
    assert_eq!(branches(&t, &Path::default()), vec![
        Branch { path: vec![2], depth: 1, born: 2, start: 2, last: 3, commented: false },
        Branch { path: vec![1, 2], depth: 1, born: 4, start: 4, last: 4, commented: false },
    ]);
    // Desde la segunda variante, la principal es la que se aparta.
    assert_eq!(branches(&t, &numbers_path(&[2]))[0].path, Vec::<usize>::new());
    assert_eq!(numbers(&t, &Path::Moves(vec![Some((3, 5)), Some((3, 3))])), Some(vec![2]));
    assert_eq!(numbers(&t, &numbers_path(&[1, 1])), Some(vec![]));
    assert_eq!(numbers(&t, &Path::Moves(vec![Some((1, 1))])), None);
}

#[test]
fn reads_a_problem() {
    let t = game(PROBLEMA);
    let s = shape(&t);
    assert_eq!(s.paths, vec![vec![1, 1], vec![1, 2], vec![2], vec![3]]);
    let all = branches(&t, &Path::default());
    assert_eq!(all.len(), 3);
    assert!(all.iter().all(|b| b.commented));
    let r = read(&t, &numbers_path(&[1, 2]), true).unwrap();
    assert_eq!(r.events[0], Event::Player { player: "black" });
    assert_eq!(r.steps[1].comment, "Correcto: el punto vital.");
    assert_eq!(r.steps[1].notes, vec![Note { property: "TE".into(), value: 1, text: None }]);
}

#[test]
fn answers_requests() {
    let ask = |data: &str, request: &str| answer_json(data.as_bytes(), request.as_bytes()).map(|v| String::from_utf8(v).unwrap());
    assert_eq!(ask("(;SZ[9])(;SZ[13])", r#"{"query": {"kind": "games"}}"#).unwrap(), "[[9,9],[13,13]]");
    assert_eq!(ask(VARIANTES, r#"{"query": {"kind": "info", "property": "PW"}}"#).unwrap(), r#"["Bruno"]"#);
    assert_eq!(ask(VARIANTES, r#"{"query": {"kind": "numbers", "path": {"moves": [[3, 5], [3, 3]]}}}"#).unwrap(), "[2]");
    assert!(ask("(;SZ[9])", r#"{"game": 2, "query": {"kind": "shape"}}"#).is_err());
}

#[test]
fn hashes_the_bytes() {
    let hash = |data: &[u8]| answer_json(data, br#"{"query": {"kind": "hash"}}"#).unwrap();
    // FNV-1a de 64 bits: el de nada es la base, y un byte cambia el resultado.
    assert_eq!(hash(b""), br#""cbf29ce484222325""#.to_vec());
    assert_eq!(hash(b"a"), br#""af63dc4c8601ec8c""#.to_vec());
    assert_ne!(hash(PARTIDA.as_bytes()), hash(PROBLEMA.as_bytes()));
}

#[test]
fn orients_the_file() {
    let read = |origin: &str, transpose: bool| {
        let request = format!(r#"{{"origin": "{origin}", "transpose": {transpose}, "query": {{"kind": "games"}}}}"#);
        String::from_utf8(answer_json(b"(;SZ[19:13])", request.as_bytes()).unwrap()).unwrap()
    };
    // Con transpose, el tamaño se gira.
    assert_eq!(read("top-left", false), "[[19,13]]");
    assert_eq!(read("top-left", true), "[[13,19]]");
    let o = |right, bottom, transpose| Orientation { right, bottom, transpose };
    // aa va a la esquina de origin; con transpose, la primera letra es la fila.
    assert_eq!(orient_point("aa", 19, 19, o(true, false, false)), "sa");
    assert_eq!(orient_point("aa", 19, 19, o(false, true, false)), "as");
    assert_eq!(orient_point("pd", 19, 19, o(true, true, false)), "dp");
    assert_eq!(orient_point("pd", 19, 19, o(false, false, true)), "dp");
    assert_eq!(orient_point("ab", 19, 13, o(false, false, true)), "ba");
    // Un pase (tt en 19×19) queda igual.
    assert_eq!(orient_point("tt", 19, 19, o(true, true, true)), "tt");
    let mut t = game("(;SZ[9]AB[aa:bb]LB[cc:X]AR[aa:ii];B[ab])");
    orient(&mut t, (9, 9), o(true, false, false));
    assert_eq!(t.nodes[0]["AB"], vec!["ia:hb"]);
    assert_eq!(t.nodes[0]["LB"], vec!["gc:X"]);
    assert_eq!(t.nodes[0]["AR"], vec!["ia:ai"]);
    assert_eq!(t.nodes[1]["B"], vec!["ib"]);
}

#[test]
fn reads_sensei_diagrams() {
    use super::sensei::{is_diagram, parse_diagrams, BLANK};
    let text = "Some text.\n[go]$$Wc Ko\n$$ +-------+\n$$ |. 3 4 .|\n$$ |O 2 1 X|\n$$ |. a _ .|\n$$ +-------+\n[/go]\nMore text.\n\
                $$B9m5\n$$ . . 1 .\n$$ {AR 1:1 C5}\n";
    assert!(is_diagram(text));
    assert!(!is_diagram("(;SZ[9]C[$$ not a diagram])"));
    let games = parse_diagrams(text).unwrap();
    assert_eq!(games.len(), 2);
    // Cuatro bordes: un tablero de 4×3, sin vista; W juega la 1 (PL), la 3 y la 4 siguen (sin MN), GN y FG.
    let root = &games[0].nodes[0];
    assert_eq!(root["SZ"], vec!["4:3"]);
    assert_eq!(root["PL"], vec!["W"]);
    assert_eq!(root["GN"], vec!["Ko"]);
    assert_eq!(root["FG"], vec!["0:Ko"]);
    assert!(!root.contains_key("VW"));
    assert_eq!(root["AW"], vec!["ab"]);
    assert_eq!(root[BLANK], vec!["cc"]);
    let moves: Vec<_> = games[0].nodes[1..].iter().map(|n| n.get("W").or(n.get("B")).unwrap()[0].clone()).collect();
    assert_eq!(moves, vec!["cb", "bb", "ba", "ca"]);
    assert!(games[0].nodes[1].contains_key("W") && !games[0].nodes[3].contains_key("MN"));
    // La letra va en la última jugada.
    assert_eq!(games[0].nodes[4]["LB"], vec!["bc:a"]);
    // Sin bordes, en el medio de 9×9; la 1 con MN 5; la vista es lo dibujado; AR con un punto del diagrama y uno
    // del tablero.
    let g = &games[1];
    assert_eq!(g.nodes[0]["VW"], vec!["ce:fe"]);
    assert_eq!(g.nodes[1]["B"], vec!["ee"]);
    assert_eq!(g.nodes[1]["MN"], vec!["5"]);
    assert_eq!(g.nodes[1]["AR"], vec!["ce:ce"]);
    // Una línea que no se entiende y un diagrama más grande que su tablero son errores.
    assert!(parse_diagrams("$$B\n$$ . . ? .\n").unwrap_err().contains("no se entiende"));
    assert!(parse_diagrams("$$B3\n$$ . . . .\n").unwrap_err().contains("mide 4×1"));
}
