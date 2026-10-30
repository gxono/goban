#import "@preview/gobanist:0.2.0": *
#set page(width: 10cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo", view: (goban: (scale: 0.45)))

// The views can leave out the arrows and the lines.
#let plan = board(size: 9,
  stones(black: "C3, C5, D7, G3", white: "E3, F5, G6, C7"),
  lines(("B2", "D2"), ("D2", "D6"), ("D6", "B6"), ("B6", "B2"), color: red, width: 1.5pt),
  marks(custom: "C4", content: text(fill: red)[moyo], label: (size: 7pt)),
  arrows(("F5", "D8"), color: blue, width: 1.5pt, bend: 30deg),
  arrows(("G3", "H5")),
  lines(("E3", "G6")))

#goban(plan)

White runs with #goban-view(plan, "E2:H7"); without the arrow and the line, the stones alone:
#goban-view(plan, "E2:H7", arrows: false, lines: false).
