// Las pruebas del kernel. Las de polygon y region son las de pgf-go (tests/kernel-checks.tex).

use super::*;

fn stone(x: i32, y: i32, player: Player) -> Event {
    Event::Stone { x, y, player, dead: false }
}

fn dead(x: i32, y: i32, player: Player) -> Event {
    Event::Stone { x, y, player, dead: true }
}

fn play(x: i32, y: i32, player: Player) -> Event {
    Event::Move { x, y, player }
}

fn auto(player: Option<Player>, dame: bool) -> Event {
    Event::Territory { mode: "auto".into(), player, vertices: vec![], points: vec![], dame, region: false, kill: false }
}

fn run(size: i32, captures: bool, events: Vec<Event>) -> Output {
    let input = Input { size: (size, size), captures, replace: false, prisoners: Prisoners::default(), events };
    simulate(&input).unwrap()
}

use Player::{Black as B, White as W};

#[test]
fn polygon_points() {
    assert_eq!(polygon(&[(1, 1), (1, 3), (3, 3), (3, 1)], 5, 5),
        vec![(1, 1), (2, 1), (3, 1), (1, 2), (2, 2), (3, 2), (1, 3), (2, 3), (3, 3)]);
    assert_eq!(polygon(&[(1, 1), (5, 1), (1, 5)], 5, 5), vec![
        (1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (1, 2), (2, 2), (3, 2), (4, 2), (1, 3), (2, 3), (3, 3), (1, 4),
        (2, 4), (1, 5)]);
    assert_eq!(polygon(&[(1, 1), (3, 1), (3, 2), (2, 2), (2, 3), (1, 3)], 5, 5),
        vec![(1, 1), (2, 1), (3, 1), (1, 2), (2, 2), (3, 2), (1, 3), (2, 3)]);
    assert_eq!(polygon(&[(0, 0), (2, 0), (2, 2), (0, 2)], 5, 5), vec![(1, 1), (2, 1), (1, 2), (2, 2)]);
    assert_eq!(polygon(&[(2, 3)], 5, 5), vec![(2, 3)]);
    assert_eq!(polygon(&[(1, 1), (3, 3)], 5, 5), vec![(1, 1), (2, 2), (3, 3)]);
    assert_eq!(polygon(&[], 5, 5), vec![]);
}

#[test]
fn region_contours() {
    let c = |points: &[(i32, i32)], cols, rows| contours(points, cols, rows);
    assert_eq!(c(&[(4, 4)], 7, 7), vec![vec![(3, 3), (5, 3), (5, 5), (3, 5)]]);
    assert_eq!(c(&[(1, 1)], 7, 7), vec![vec![(1, 1), (2, 1), (2, 2), (1, 2)]]);
    assert_eq!(c(&[(2, 2), (3, 2), (4, 2), (3, 2)], 7, 7), vec![vec![(1, 1), (5, 1), (5, 3), (1, 3)]]);
    let ring = [(2, 2), (3, 2), (4, 2), (5, 2), (6, 2), (2, 3), (6, 3), (2, 4), (6, 4), (2, 5), (6, 5), (2, 6),
        (3, 6), (4, 6), (5, 6), (6, 6)];
    assert_eq!(c(&ring, 7, 7), vec![vec![(1, 1), (7, 1), (7, 7), (1, 7)], vec![(3, 3), (3, 5), (5, 5), (5, 3)]]);
    assert_eq!(c(&[(1, 1), (3, 3)], 7, 7),
        vec![vec![(1, 1), (2, 1), (2, 2), (1, 2)], vec![(2, 2), (4, 2), (4, 4), (2, 4)]]);
    assert_eq!(c(&[], 7, 7), Vec::<Vec<(i32, i32)>>::new());
    let island = [(2, 2), (3, 2), (4, 2), (5, 2), (6, 2), (7, 2), (8, 2), (2, 8), (3, 8), (4, 8), (5, 8), (6, 8),
        (7, 8), (8, 8), (2, 3), (2, 4), (2, 5), (2, 6), (2, 7), (8, 3), (8, 4), (8, 5), (8, 6), (8, 7), (5, 5)];
    assert_eq!(c(&island, 9, 9), vec![
        vec![(1, 1), (9, 1), (9, 9), (1, 9)],
        vec![(3, 3), (3, 7), (7, 7), (7, 3)],
        vec![(4, 4), (6, 4), (6, 6), (4, 6)],
    ]);
    let edge = [(1, 1), (1, 2), (1, 3), (1, 4), (2, 1), (3, 1), (4, 1), (5, 1)];
    assert_eq!(c(&edge, 5, 4), vec![vec![(1, 1), (5, 1), (5, 2), (2, 2), (2, 4), (1, 4)]]);
    let twice = [(1, 1), (2, 1), (3, 1), (4, 1), (1, 2), (4, 2), (1, 3), (1, 4), (2, 4)];
    assert_eq!(c(&twice, 4, 4),
        vec![vec![(1, 1), (4, 1), (4, 3), (3, 3), (3, 2), (2, 2), (2, 3), (3, 3), (3, 4), (1, 4)]]);
}

// El ejemplo de \pgfgoregion en el manual de pgf-go: un territorio negro con un hueco de piedras blancas.
#[test]
fn region_properties() {
    let mut events: Vec<Event> = Vec::new();
    for x in 4..=6 {
        for y in 4..=6 {
            events.push(stone(x, y, W));
        }
    }
    events.push(Event::Territory {
        mode: "polygon".into(), player: Some(B), vertices: vec![(2, 2), (2, 8), (8, 8), (8, 2)],
        points: vec![], dame: false, region: true, kill: false,
    });
    let out = run(9, false, events);
    let r = out.black.unwrap();
    assert_eq!((r.polygons, r.outlines, r.holes, r.vertices, r.area, r.perimeter), (2, 1, 1, 8, 60, 40));
    assert_eq!(r.contours[1], vec![(4, 4), (4, 6), (6, 6), (6, 4)]);
    assert!(out.white.is_none());
}

#[test]
fn captures() {
    // Las jugadas B1, A1, A2 en una esquina: la 3 captura a la 2.
    let out = run(5, true, vec![play(2, 1, B), play(1, 1, W), play(1, 2, B)]);
    assert_eq!(out.captured, vec![(2, vec![1])]);
    assert_eq!(out.prisoners, Prisoners { black: 1, white: 0 });
    // Sin capturas, nada sale del tablero.
    assert!(run(5, false, vec![play(2, 1, B), play(1, 1, W), play(1, 2, B)]).captured.is_empty());
    // Una piedra puesta cuenta; un prisionero y una neutral son libertades.
    let out = run(5, true, vec![stone(1, 1, W), dead(1, 2, B), play(2, 1, B)]);
    assert!(out.captured.is_empty());
    let out = run(5, true, vec![stone(1, 1, W), stone(1, 2, B), play(2, 1, B)]);
    assert_eq!(out.captured, vec![(2, vec![0])]);
    // Suicidio: se retira el grupo propio.
    let out = run(5, true, vec![stone(2, 1, W), stone(1, 2, W), play(1, 1, B)]);
    assert_eq!(out.captured, vec![(2, vec![2])]);
    assert_eq!(out.prisoners, Prisoners { black: 0, white: 1 });
    // Un ko: C3 captura, D3 retoma.
    let ko = vec![
        stone(2, 3, B), stone(3, 2, B), stone(3, 4, B), stone(4, 2, W), stone(4, 4, W), stone(5, 3, W),
        play(3, 3, W), play(4, 3, B),
    ];
    assert_eq!(run(5, true, ko).captured, vec![(7, vec![6])]);
}

#[test]
fn occupied() {
    let mut input = Input { size: (5, 5), captures: true, replace: false, prisoners: Prisoners::default(),
        events: vec![play(2, 2, B), play(2, 2, W)] };
    assert!(simulate(&input).is_err());
    // Con replace, la jugada quita la piedra que había, sin prisioneros, y captura como siempre.
    input.replace = true;
    let out = simulate(&input).unwrap();
    assert_eq!(out.removed, vec![(1, 0)]);
    assert_eq!(out.prisoners, Prisoners::default());
    input.events = vec![stone(1, 2, W), stone(1, 3, B), stone(2, 2, B), play(1, 1, W), play(1, 1, B)];
    let out = simulate(&input).unwrap();
    assert_eq!(out.removed, vec![(4, 3)]);
    assert_eq!(out.captured, vec![(4, vec![0])]);
}

#[test]
fn territory_and_score() {
    // El ejemplo de komi del manual: negras en la columna C, blancas en la D.
    let mut events: Vec<Event> = (1..=5).map(|y| stone(3, y, B)).chain((1..=5).map(|y| stone(4, y, W))).collect();
    events.push(auto(None, false));
    let out = run(5, false, events);
    assert_eq!(out.score, Score { black: 10, white: 5, neutral: 0 });
    // Un prisionero blanco en territorio negro vale dos puntos; un punto marcado dos veces, uno.
    let mut events: Vec<Event> = (1..=5).map(|y| stone(3, y, B)).chain((1..=5).map(|y| stone(4, y, W))).collect();
    events.push(dead(1, 1, W));
    events.push(auto(Some(B), false));
    events.push(auto(Some(B), false));
    let out = run(5, false, events);
    assert_eq!(out.score, Score { black: 11, white: 0, neutral: 0 });
    // Un punto que al final tiene una piedra viva no es territorio.
    let out = run(5, false, vec![stone(3, 3, B), auto(None, false), stone(1, 1, W)]);
    assert_eq!(out.score.black, 23);
    assert!(!out.territory.iter().any(|&(x, y, _, _)| (x, y) == (1, 1)));
    // Dame: una región que tocan los dos colores es neutral.
    let out = run(3, false, vec![stone(1, 1, B), stone(3, 3, W), auto(None, true)]);
    assert_eq!(out.score, Score { black: 0, white: 0, neutral: 7 });
}

#[test]
fn json() {
    let input = br#"{"size": [5, 5], "captures": true, "events": [
        {"kind": "move", "x": 2, "y": 1, "player": "black"},
        {"kind": "move", "x": 1, "y": 1, "player": "white"},
        {"kind": "move", "x": 1, "y": 2, "player": "black"},
        {"kind": "territory", "mode": "auto", "dame": true}]}"#;
    let out: serde_json::Value = serde_json::from_slice(&simulate_json(input).unwrap()).unwrap();
    assert_eq!(out["captured"], serde_json::json!([[2, [1]]]));
    assert_eq!(out["prisoners"]["black"], 1);
}

#[test]
fn removes_and_kills() {
    // AE quita la piedra sin contar prisioneros; después el punto está libre.
    let out = run(5, true, vec![stone(1, 1, B), Event::Remove { x: 1, y: 1 }, play(1, 1, W), Event::Remove { x: 3, y: 3 }]);
    assert_eq!(out.removed, vec![(1, 0)]);
    assert_eq!(out.prisoners, Prisoners::default());
    // TB sobre una piedra blanca la mata: cuenta como prisionero en territorio negro.
    let points = |kill| Event::Territory {
        mode: "points".into(), player: None, vertices: vec![], points: vec![(1, 1, B), (2, 2, B)], dame: false,
        region: false, kill,
    };
    let out = run(5, false, vec![stone(1, 1, W), stone(2, 2, B), points(true)]);
    assert_eq!(out.dead, vec![0]);
    assert_eq!(out.score.black, 2);
    let out = run(5, false, vec![stone(1, 1, W), points(false)]);
    assert_eq!(out.dead, Vec::<usize>::new());
    assert_eq!(out.score.black, 1);
}
