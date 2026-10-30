#import "@preview/gobanist:0.2.0": *
#set page(width: auto, height: auto, margin: 0.5cm)

#gobanist-set(background: (fill: (color: rgb(220, 179, 92))))

#goban(size: 9, partial: "A1:G7",
  stones(black: "C3, D3, E4, C5", white: "D4, D5, E5, F3"),
  marks(dim: "F3"),
  arrows(("C5", "C7")),
  arrows(("E4", "G4"), color: red.darken(20%)),
  lines(("B6", "F6")),
  marks(triangle: "D5"),
  marks(custom: "E3", content: [A]))
