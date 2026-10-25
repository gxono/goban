#import "/lib.typ": *
#set page(width: 16cm, height: auto, margin: 0.5cm)
#set text(lang: "es")

// Los ejemplos de «Partidas en SGF» en el manual de pgf-go.
#let partida = sgf-read(path("/tests/sgf/partida.sgf"))
#let variantes = sgf-read(path("/tests/sgf/variantes.sgf"))

#goban(label: (at: (top, left)), partida)
#goban(label: (at: (top, left)), captures: "remove", partida)
#goban(captures: "remove", sgf(partida, from: 7))
#goban(captures: "remove", sgf(partida, to: 6), moves("F5"))

// Variantes, marcas, MN, restart, last-mark y letters.
#goban(sgf(variantes, variation: (2,)))
#goban(sgf(variantes, variation: (1, 2)))
#goban(sgf(variantes, variation: "C5, C3"))
#goban(sgf(variantes, to: 2))
#goban(sgf(variantes, to: 2, marks: false))
#goban(variantes)
#goban(sgf(variantes, step: 3, restart: true))
#goban(sgf(variantes, step: 3, restart: (on: true, from: 0)))
#goban(sgf(variantes, numbers: false, last-mark: "circle"))
#goban(sgf(variantes, to: 1, marks: false, letters: "children"))

// Pases, AE (con captures: "fade" la piedra quitada no queda), TB y TW.
#goban(notes: true, sgf-read("(;SZ[5];B[cc];W[];B[dd];W[cc];B[])"))
Notas: #goban-notes().
#goban(captures: "fade", sgf-read("(;SZ[5]AB[aa][ba];W[bb];AE[aa];B[cc])"))
#goban(sgf-read("(;SZ[5]AB[cc][cb][bc]AW[aa][dd];B[dc]TB[aa][ab][ba][bb]TW[ee][ed][de])"))
Negras: #goban-score("black"), blancas: #goban-score("white").

#sgf-info(variantes, "PB") contra #sgf-info(variantes, "PW"), komi #sgf-info(variantes, "KM"), resultado
#sgf-info(variantes, "RE").

// La vista (VW): la de las jugadas from a to, la de una jugada y la del tablero, que le gana.
#let vistas = sgf-read(path("/tests/sgf/views.sgf"))
#goban(sgf(vistas, to: 2, view: true))
#goban(sgf(vistas, view: 5))
#goban(partial: "E1:J5", sgf(vistas, view: 5))
