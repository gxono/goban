#import "@preview/gobanist:0.1.0": *
#set page(width: 14cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo")

#let joseki = sgf-read(path("joseki.sgf"))

= The 4-4 point: the low approach

// The line is given by its moves, as in a joseki dictionary. The answers are the commented variations that
// leave it at move 3 or later (not the 3-3 invasion, at move 2). partial: auto shows the part of the board
// that all the diagrams use.
#align(center, goban(partial: auto, scale: 0.8, sgf(joseki, to: 2)))

#sgf-diagrams(joseki, variation: "Q16, R14", variations: (on: true, from: 3), partial: auto,
  comments: true, layout: (columns: 3, fit: true))
