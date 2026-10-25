#import "../lib.typ": *

#set page(width: auto, height: auto, margin: 1em)

#goban(size: 19, partial: "K1:T9", label: (at: (top, right)),
  stones(black: "L8, S8, R5, S5, P4, R4, M3, P3, N2, O2",
         white: "L6, S4, S3, Q3, O1, P2, R2"),
  marks(circle: "L8"),
)

#goban(size: 17, partial: "A1:R5", label: (at: (top, left)),
  stones(black: "*; B, D, H, M, R2, Q, F2:4, K2 r L5, O[1:2, 4]; B3"),
)

#let base = board(size: 5,
  stones(black: "C2, D3", white: "C3"),
  moves(white: "D2"),
)
#goban(resume: base, partial: "B2:D4", moves("B3"))
#goban(resume: (board: base, numbers: true), partial: "B2:D4", moves("B3"))

#goban(size: 5,
  stones(black: "B2, C3", white: "D4"),
  marks(triangle: "B2, D4, A5", square: "E1", cross: "A1", t-circle: "E5", player: auto),
  marks(sequence: "B4, C4, D3", label: (format: "A")),
  marks(custom: "E3", content: [?]),
  marks(dim: "A1:5"),
)
