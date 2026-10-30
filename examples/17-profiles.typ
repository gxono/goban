#import "@preview/gobanist:0.1.0": *
#set page(width: 17.4cm, height: auto, margin: 0.5cm)

// The same board with every profile: board(position, profile: p) is that board, with another profile.
#let position = board(
  stones(black: "A6|-B5|-D1|-E2, C4, E9-|F4, D5-|G7--D7, H6, H8, J7",
    white: "E8-|C5, B:E6, A7, B8, D9, J6|-H5, H2:3, F1|-C3, C2, D:E4, G4"),
  prisoners(black: "H1-|J2", white: "A1"),
  marks(t-circle: "A1:4, G8|-J9, J8, H7", player: "black"),
  marks(t-square: "G3|-J1|-H4, C9-|A8, B7", player: "white"),
  marks(t-square: "E1", fill: (color: red)))

#goban-layout(columns: 3,
  ..("default", "pgfgo", "pgfgosmooth", "wain", "shell", "yunzi", "baduktv", "simple", "draft")
    .map(p => board(position, profile: p)))
