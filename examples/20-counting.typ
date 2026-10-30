#import "@preview/gobanist:0.2.0": *
#set page(width: 8cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo", label: (at: (bottom, left)))

// The end of a game: gobanist plays it with the captures, finds the territory and counts it.
#let game = sgf-read(path("commented.sgf"))

#goban(captures: "remove",
  sgf(game, marks: false, numbers: false),
  prisoners(white: "B3"), // The dead white stone.
  territory(auto))

Black #goban-score("black"), White #goban-score("white", komi: 6.5).
Result in the file: #sgf-info(game, "RE").
