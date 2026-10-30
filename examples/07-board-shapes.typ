#import "@preview/gobanist:0.2.0": *
#set page(width: 17cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "simple", label: (at: (bottom, left)))

// blank: points that are not part of the board (a board in the shape of a cross).
// grid.edge: the outer lines of the grid; label.columns: "a", the letters in lower case.
#goban-layout(columns: 2, width: auto, column-sep: 2em, valign: bottom,
  board(size: 13, blank: "A:D 1:4, K:N 1:4, A:D 10:13, K:N 10:13",
    stones(black: "G7, F9, E6", white: "H6, G4, C7")),
  board(size: 9, grid: (edge: (width: 1.2pt)), label: (columns: "a"),
    stones(black: "C3, G7, C6", white: "G3, E7, C7")))

// After Z, the columns have two letters: AA, AB...
#v(1em)
#goban(size: (30, 5), label: (at: bottom, text: (size: 6pt)),
  stones(black: "X2:AB2, Z3", white: "X3, Y3, AA3:AB3, Z4"))
