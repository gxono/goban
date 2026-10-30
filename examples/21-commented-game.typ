#import "@preview/gobanist:0.2.0": *
#set page(width: 13cm, height: auto, margin: 0.5cm)

#gobanist-set(background: (fill: (color: rgb(220, 179, 92))), label: (at: (bottom, left)))

#let game = sgf-read(path("commented.sgf"))

= #sgf-info(game, "GN")
#sgf-info(game, "PB") against #sgf-info(game, "PW"), komi #sgf-info(game, "KM"). #sgf-comment(game, 0)

#sgf-diagrams(game, step: 9, comments: true)
