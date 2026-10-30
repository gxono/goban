#import "@preview/gobanist:0.2.0": *
#set page(width: 17cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo", partial: auto, label: (at: (bottom, left)))

// joseki.sgf is in the upper right corner. origin says where the point aa of the file goes (initially, top
// left), and transpose swaps columns and rows (the approach comes from the other side): together, the eight
// symmetries of the board. The variation is chosen by its moves on the board.
#let file = path("joseki.sgf")

#goban-layout(columns: 4, fit: true,
  sgf-read(file, origin: top + right),
  sgf-read(file, origin: bottom + right, transpose: true),
  sgf-read(file, transpose: true),
  sgf(sgf-read(file, origin: bottom + left), variation: "Q4, R6, O4"))
