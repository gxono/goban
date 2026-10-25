#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// goban-view: el tablero como quedó, con las capturas, en una intersección o un rectángulo, en el texto.
#let tablero1 = board(size: 5, captures: "remove", stones(black: "B3, C2, C4", white: "D2, D4, E3"),
  moves(white: "C3, D3"))
#goban(resume: (board: tablero1, numbers: true))

La negra en D3 #goban-view(tablero1, "D3") captura la blanca de C3 #goban-view(tablero1, "C3").
Así quedó el ko: #goban-view(tablero1, "B2:E4").

// Las marcas, los números y el estilo.
#let tablero2 = board(size: 5, stones(black: "B2, C3"), moves(white: "C2, D3"), marks(triangle: "C3"))
#goban-view(tablero2, "B2:D3")
#goban-view(tablero2, "B2:D3", marks: false, numbers: false)
#goban-view(tablero2, "B2:D3", goban: (grid: false))
#goban-view(tablero2, "B2:D3", goban: (background: false))
#goban-view(tablero2, "B2:D3", goban: (profile: "wain"))

// Flechas, líneas y territorio.
#let flechas = board(size: 5, stones(black: "B2", white: "D4"), arrows(("B2", "D4")), lines(("B4", "D2")),
  marks(triangle: "C3"), territory(black: "A1, A3, C3, C1"))
#goban-view(flechas, "A1:E5")
#goban-view(flechas, "A1:E5", arrows: false, territory: false)
#goban-view(flechas, "A1:E5", lines: false, marks: false)

// Lo olvidado, solo con forgotten.
#let tablero3 = board(size: 5, stones(black: "B2, C3"), stones(white: "D3", forget: true), moves("D2", forget: "number"))
#goban-view(tablero3, "B2:D3")
#goban-view(tablero3, "B2:D3", forgotten: true)

// raise y las opciones de todas las vistas.
Texto #goban-view(tablero2, "C3", raise: 0pt) texto #goban-view(tablero2, "C3") texto
#goban-view(tablero2, "C3", raise: 0.7em).

#goban-set(view: (goban: (background: false, scale: 1)))
Sin fondo y más grande: #goban-view(tablero2, "C3").

// Una partida, y un tablero con resume.
#let partida = sgf-read(path("/tests/sgf/partida.sgf"))
#goban-view(sgf(partida, to: 10), "B3:G7")
#goban-view(board(resume: tablero2, moves("B3")), "B2:D3")

// Una etiqueta de una partida bajo el número de una jugada se ve si la vista esconde el número.
#let etiqueta = sgf-read("(;SZ[5];B[dc];W[cc]LB[cc:A])")
#goban-view(etiqueta, "B2:D4") #goban-view(etiqueta, "B2:D4", numbers: false)
