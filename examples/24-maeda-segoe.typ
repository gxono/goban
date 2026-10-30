#import "@preview/gobanist:0.2.0": *
#set page(width: 15cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "yunzi", label: (at: (bottom, left)))

// maeda-segoe.sgf: Maeda Nobuaki against Segoe Kensaku, 1940 (moves only).
#let game = sgf-read(path("maeda-segoe.sgf"))

= #sgf-info(game, "PB") -- #sgf-info(game, "PW")
Black: #sgf-info(game, "PB") #sgf-info(game, "BR").
White: #sgf-info(game, "PW") #sgf-info(game, "WR").
Komi #sgf-info(game, "KM"). Played in 1940.

#sgf-diagrams(game, step: 50, goban: (captures: "remove"), layout: (columns: 2, fit: true))
