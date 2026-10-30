#import "@preview/gobanist:0.1.0": *
#set page(width: auto, height: auto, margin: 0.5cm)

#gobanist-set(background: (fill: (color: rgb(220, 179, 92))), label: (at: (bottom, left)))

// The territory marked point by point, and found by the kernel with territory(auto).
#goban(size: 9,
  stones(black: "A2, B1, B2, C2, D1, D2, G1, G2, F2, F3, F4, G4, G5, G6, E9, E8, E7, F7, G7, H7, J7, G8",
    white: "A7, B7, C7, D7, D8, D9, D6, B5, C5, A3, B3, C3, D3, E1, E2, E3, E4, E5, E6, F5"),
  marks(t-circle: "J1, J2, J3, J4, J5, J6, H1, H2, H3, H4, H5, H6, G3, H8, H9, J8, J9, G9, F9, F8, A1, C1",
    player: "black"),
  marks(t-square: "A9, A8, B9, B8, C9, C8, A6, B6, C6, A5, D5, A4, B4, C4, D4", player: "white"),
  marks(filled-square: "F1, F6", line: (color: gray)))
// The same position, with the coordinates abbreviated.
#goban(size: 9,
  stones(black: "E9|-J7, G8|-F4|-G2--G1, A2-|D1, B1",
    white: "D9|-E6--E1, F5, A:C7, A:D3, B:C5"),
  territory(auto, dame: true))
