#import "@preview/gobanist:0.2.0": *
#set page(width: auto, height: auto, margin: 0.5cm)

#gobanist-set(background: (fill: (color: rgb(220, 179, 92))), label: (at: (bottom, left)))

// A game read from an SGF file is a value: the board takes its size, and sgf(game, ...) chooses what to draw.
#let game = sgf-read(path("commented.sgf"))

#goban(captures: "remove", sgf(game, to: 15))
#goban(sgf(game, to: 1, letters: "children"))
#goban(sgf(game, variation: (2,)))
