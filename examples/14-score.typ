#import "@preview/gobanist:0.1.0": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

#gobanist-set(background: (fill: (color: rgb(220, 179, 92))), label: (at: (bottom, left)))

#goban(size: 7,
  stones(black: "D1:7, B5", white: "E1:7"),
  prisoners(white: "B3"),
  territory(auto))
#goban(size: 7, captures: "remove",
  stones(black: "D1:7, A3, B2, B4", white: "E1:7, B3"),
  moves("C3"),
  territory(auto, draw: "fill"))

Black #goban-score("black"), White #goban-score("white", komi: 6.5).
