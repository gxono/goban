#import "@preview/gobanist:0.1.0": *
#set page(width: auto, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgosmooth")

#goban(size: 9, partial: "A2:H9",
  stones(black: "A7, B6, C8, C7"),
  stones(black: "D6, D5, D4", mark: "triangle"),
  stones(white: "C3, C4, C5, C6, D7, E7, E6"),
  stones(white: "E3", mark: (shape: "custom", content: [1])),
  marks(circle: "D3, E4, E5", line: (color: red.darken(20%))))
