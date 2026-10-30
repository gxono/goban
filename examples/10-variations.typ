#import "@preview/gobanist:0.2.0": *
#set page(width: 14cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo", size: 19, partial: "A1:H8", label: (at: (bottom, left)))

// Each diagram goes on from the board of another one (resume): the stones are already there, and the
// numbers and the turn go on. The third one is a variation of the first.
#let first = board(stones(black: "D4"), moves(white: "C3, D3, C4, D5"))

#goban-layout(columns: 3, fit: true,
  first,
  board(resume: first, moves("B5, B6, C6, C7")),
  board(resume: first, moves("B6, C6, B5")))
