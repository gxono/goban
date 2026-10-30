#import "@preview/gobanist:0.1.0": *
#set page(width: auto, height: auto, margin: 0.5cm)

#gobanist-set(profile: "wain")

#goban(size: 9, label: (at: (bottom, left)),
  stones(black: "C7", white: "B6, B7, C8, D7"),
  moves(black: "C6, C5, D6, E6, D5, D4, E5, F5, E4, E3"))
