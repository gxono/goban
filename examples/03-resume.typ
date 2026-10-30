#import "@preview/gobanist:0.1.0": *
#set page(width: auto, height: auto, margin: 0.5cm)

#gobanist-set(background: (fill: (color: rgb(220, 179, 92))))

// A board is a value: the second one starts with the stones of the first (resume), but not with its marks.
#let atari = board(size: 13,
  stones(black: "A1, J1, K1, G7, N9, D12, D13",
    white: "A2, H1, J2, K2, G6, F7, G8, M9, N10, C12, C13, E12, E13"),
  marks(circle: "B1, L1, N8, H7, D11"))

#goban(atari, label: (at: (top, bottom, left, right)))
#goban(resume: atari, label: (at: (top, right, bottom)),
  stones(white: "B1, L1, N8, H7, D11", mark: "triangle"))
