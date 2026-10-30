#import "/lib.typ": *
#set page(width: 16cm, height: auto, margin: 0.5cm)
#set text(lang: "es")

// goban-layout: tableros sueltos y diagramas en una misma disposición. Los ejemplos de «Disposición de los
// diagramas» en el manual de pgf-go.
#let partida = sgf-read(path("/tests/sgf/partida.sgf"))
#let problemas = range(1, 4).map(n => sgf-read(path("/tests/sgf/problemas.sgf"), game: n))

// En la grilla, con fit: cada tablero suelto llena su columna; los diagramas de un sgf-diagrams, con la escala
// del primero. El layout de sgf-diagrams no se usa.
#goban-layout(columns: 4, fit: true,
  board(size: 5, stones(black: "C3")),
  board(size: 5, stones(white: "C3")),
  sgf-diagrams(partida, step: 5, layout: (columns: 1)),
)

// Una partida es un tablero; sgf-problem con sus enunciados solos en su fila.
#goban-layout(columns: 3, fit: true,
  sgf(partida, to: 3),
  board(size: 9, partial: "A9:E5", stones(black: "C7")),
  sgf-problem(..problemas, statement: "alone", comments: false),
)

// Sin grilla: en el párrafo; los comentarios al costado, en su línea.
#goban-layout(
  board(size: 5, scale: 0.5, stones(black: "C3")),
  board(size: 5, scale: 0.5, stones(white: "C3")),
  sgf-diagrams(partida, step: 5, to: 5, comments: (on: true, position: right), goban: (scale: 0.5)),
  board(size: 5, scale: 0.5, stones(black: "B2")),
)

// width: auto: las columnas tienen el ancho del diagrama más ancho, sin espacio entre ellas, y la grilla se centra.
#goban-layout(columns: 2, width: auto, column-sep: 0em, row-sep: 0em,
  board(partial: "A9:E5", scale: 0.5, stones(black: "C7")),
  board(partial: "E9:I5", scale: 0.5, stones(white: "G7")),
  board(partial: "A1:E5", scale: 0.5, stones(black: "C3")),
  board(partial: "E1:I5", scale: 0.5, stones(white: "G3")),
)
// Con menos diagramas que columnas, la grilla tiene el ancho de los que hay; los epígrafes se cortan como sin
// grilla.
#sgf-diagrams(partida, step: 4, to: 8, goban: (scale: 0.6), layout: (columns: 3, width: auto))

// Una grilla más angosta que la línea se centra; halign: left pone cada diagrama a la izquierda de su columna.
#sgf-diagrams(partida, step: 2, to: 6, layout: (columns: 2, width: 60%, column-sep: 3em, row-sep: 2em,
  halign: left))

// Las notas del último tablero quedan para goban-notes.
#goban-layout(columns: 2, board(size: 5, notes: true, moves("C3, D3, C4, D4")),
  board(size: 5, notes: true, captures: "remove", moves(white: "A1, B1, C3, A2, C4, A1")))
Notas: #goban-notes()

// per-page: cada 3 diagramas, la página siguiente; la fila a medias se dibuja antes.
#goban-layout(columns: 2, per-page: 3,
  ..range(1, 6).map(n => board(size: 5, scale: 0.5, stones(black: "C" + str(n)))))
#sgf-diagrams(partida, step: 5, to: 10, goban: (scale: 0.5), layout: (per-page: 1))

// valign: bottom, los tableros de una fila terminan a la misma altura; align-captions, los epígrafes empiezan en
// la misma línea con los tableros arriba. Con comentarios al costado y con una celda que va sola.
#let altos = (board(size: 5, scale: 0.6, stones(black: "C3")), board(size: (5, 3), scale: 0.6, stones(white: "C2")),
  board(size: 9, scale: 0.6, stones(black: "E5")))
#goban-layout(columns: 3, valign: bottom, ..altos)
#let tres = sgf-read("(;SZ[9];B[ee];W[cc];B[gg];W[gc];B[cg])")
#sgf-diagrams(tres, step: (1, 4), goban: (partial: auto), layout: (columns: 2, width: 9cm))
#sgf-diagrams(tres, step: (1, 4), goban: (partial: auto), layout: (columns: 2, width: 9cm, valign: bottom))
#sgf-diagrams(tres, step: (1, 4), goban: (partial: auto), layout: (columns: 2, width: 9cm, align-captions: true))
#sgf-diagrams(tres, step: (1, 4), goban: (partial: auto), comments: (position: right),
  layout: (columns: 2, width: 12cm, valign: bottom))
