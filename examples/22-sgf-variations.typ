#import "@preview/gobanist:0.2.0": *
#set page(width: 14cm, height: auto, margin: 0.5cm)

#gobanist-set(background: (fill: (color: rgb(220, 179, 92))), label: (at: (bottom, left)))

#let game = sgf-read(path("commented.sgf"))

= #sgf-info(game, "GN")

// The variations of the file get their own diagrams ("Diagram 1a"), after the diagram where they start.
#sgf-diagrams(game, step: 30, variations: (on: true, select: "all"), comments: true,
  layout: (columns: 2, fit: true))
