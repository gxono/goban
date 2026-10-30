#import "@preview/gobanist:0.1.0": *
#set page(width: 9cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo", size: 13, label: (at: (bottom, left)))

// Each framework is a polygon given by its corners; gobanist fills its squares and measures it.
#goban(
  stones(black: "K4, K10, J7, L7", white: "D4, D10, C7, F3"),
  territory(black: "J3, M3, M11, J11", draw: "region"),
  territory(white: "B2, F2, F5, E5, E11, B11", draw: "region"),
  marks(triangle: "J10"),
  arrows(("D7", "G7")))

Black's framework: #goban-region("black", "area") squares; White's: #goban-region("white", "area").
The triangle shows where White can reduce it.
