#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Capturas, marcas capturadas y notas (los ejemplos de «El juego» en el manual de pgf-go).
#goban(size: 5, partial: "A1:C3", moves("B1, A1, A2"))
#goban(size: 5, partial: "A1:C3", captures: "remove", moves("B1, A1, A2"))
#goban(size: 5, partial: "A1:E3", captures: "fade", stones(white: "C1, D1"), stones(black: "B1, C2, D2"), moves("E1"))
#goban(size: 5, partial: "A1:C3", captures: "remove", stones(white: "A1"), stones(black: "B1"), marks(triangle: "A1"), moves("A2"))
#goban(size: 5, partial: "A1:C3", captures: "remove", captured-marks: "remove",
  stones(white: "A1"), stones(black: "B1"), marks(triangle: "A1"), moves("A2"))
#goban(size: 5, partial: "A2:E4", notes: true,
  stones(black: "B3, C2, C4"), stones(white: "D2, D4, E3"), moves(white: "C3"), moves("D3"), moves(white: "C3", from: 3))

#goban(size: 5, partial: "A2:E4", notes: true, captures: "remove",
  stones(black: "B3, C2, C4"), stones(white: "D2, D4, E3"), moves(white: "C3"), moves("D3"), moves(white: "C3", from: 3), moves("D3"))
Notas: #goban-notes(at: "en", separator: "; ").

// resume sigue con las capturas resueltas.
#let ko = board(size: 5, captures: "remove", stones(black: "B3, C2, C4"), stones(white: "D2, D4, E3"),
  moves(white: "C3"), moves("D3"))
#goban(resume: (board: ko, numbers: true), partial: "A2:E4")
#goban(resume: ko, partial: "A2:E4", moves(white: "B2"))

// notes.text: las opciones de text de las notas, en goban-notes y debajo de los diagramas. Las notas de
// diagrams.goban no apagan las de los diagramas (antes, notes: (text: ...) las reemplazaba).
#gobanist-set(notes: (text: (fill: red, style: "italic")))
#goban(size: 5, notes: true, moves("B2, C3, B2"))
Notas: #goban-notes().
#gobanist-set(notes: (text: (fill: black, style: "normal")))
#sgf-diagrams(sgf-read("(;SZ[5];B[bd];W[cc];B[bd])"), goban: (notes: (text: (fill: blue))), layout: (width: auto))
