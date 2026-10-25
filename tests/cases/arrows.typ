#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Flechas y líneas.
#goban(size: 9, stones(black: "C3, D3", white: "E5"), arrows(("B3", "F3")), arrows(("C7", "G9"), color: red, halo: false))
#goban(size: 9, stones(black: "C3, D4", white: "E5"), lines(("C3", "G7")), lines(("A9", "J9"), color: blue, width: 2pt))
#goban(size: 5, stones(black: "C2, C4", white: "D3"), arrows(("A1", "E1"), width: 0.4pt),
  arrows(("A3", "E3"), color: blue, width: 2.5pt), arrows(("A5", "E5"), color: red, opacity: 0.4, width: 2.5pt))
#goban(size: 5, stones(black: "B2", white: "D4"), arrows(("B2", "D4"), shorten: 5pt),
  arrows(("A5", "E5"), dash: "dashed", tips: "both"), lines(("A1", "E1"), dash: "dotted"))
#goban(size: 5, stones(black: "B2", white: "D4"), arrows(("B2", "D4"), bend: 40deg, shorten: 5pt), lines(("A1", "E1"), bend: -30deg))
#goban(size: 5, arrows(("A1", "E1")), arrows(("A3", "E3"), tip: "triangle", tips: "both"), arrows(("A5", "E5"), tip: "circle"))
#goban(size: 5, stones(black: "B1, B3, B5", white: "D1, D3, D5"), arrows(("A1", "E1"), halo: false), arrows(("A3", "E3")),
  arrows(("A5", "E5"), halo: (color: yellow, width: 2pt)))
#goban(size: 19, partial: auto, arrows(("Q16", "R14")))
