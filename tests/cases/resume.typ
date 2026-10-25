#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// resume: un tablero como valor; sigue la numeración y el turno.
#let base = board(size: 5, stones(black: "C2, D3", white: "C3"), moves(white: "D2"), marks(triangle: "B2"))
#goban(resume: base, partial: "B2:D4", moves("B3"))
#goban(resume: (board: base, numbers: true), partial: "B2:D4", moves("B3"))
#goban(resume: (board: base, numbers: true, marks: true))
#let segundo = board(resume: base, moves("B3"))
#goban(resume: (board: segundo, numbers: true), size: 7)

// forget: resume no trae lo olvidado.
#let olvidos = board(size: 5, stones(black: "C2, D3"), stones(white: "B4", forget: true),
  moves("C3"), moves("B3", forget: "number"), moves("D4", forget: true), marks(triangle: "C2"), marks(circle: "D3", forget: true),
  arrows(("A1", "E1")), arrows(("A5", "E5"), forget: true))
#goban(resume: (board: olvidos, numbers: true, marks: true), moves("E3"))
