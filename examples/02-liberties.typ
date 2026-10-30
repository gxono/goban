#import "@preview/gobanist:0.2.0": *
#set page(width: auto, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgosmooth")

// The liberties of a stone: four in the middle, three on the side, two in the corner.
#goban-layout(columns: 2, width: auto, column-sep: 0.5em, row-sep: 0.5em,
  board(partial: "A9:E5",
    stones(black: "C7"),
    marks(sequence: "C8, D7, C6, B7")),
  board(partial: "E9:J5",
    stones(black: "G7", white: "F7"),
    marks(sequence: "G8, H7, G6")),
  board(partial: "A1:E5",
    stones(black: "C3", white: "B3, C2"),
    marks(sequence: "C4, D3")),
  board(partial: "E1:J5",
    stones(black: "G3", white: "F3, G2, H3"),
    marks(sequence: "G4")))
