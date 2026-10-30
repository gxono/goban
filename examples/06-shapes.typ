#import "@preview/gobanist:0.2.0": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Each shape is written once, from A1; shift: (columns, rows) draws it anywhere else.
#let jump = "A1, A3"
#let knight = "A1, B3"
#let bamboo = "A1:2, C1:2"
#let tiger = "A2, B1, C2"

#gobanist-set(profile: "pgfgosmooth")

#goban(size: (15, 9), label: (at: bottom),
  stones(black: jump, shift: (1, 5)),
  stones(black: knight, shift: (4, 5)),
  stones(black: bamboo, shift: (7, 5)),
  stones(black: tiger, shift: (11, 5)),
  stones(white: jump, shift: (1, 1)),
  stones(white: knight, shift: (4, 1)),
  stones(white: bamboo, shift: (7, 1)),
  stones(white: tiger, shift: (11, 1)))

From left to right: the one-space jump, the knight's move, the bamboo joint and the tiger's mouth.
