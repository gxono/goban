#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Sombra y brillo de las piedras, sombra del tablero y scale-line-width.
#goban(size: 5, partial: "B2:D4", stones(black: "C2, D3", white: "B4", shine: true))
#goban(size: 5, partial: "B2:D4", stone: (shine: (on: true, angle: 45deg)), stones(black: "C2, D3", white: "B4"))
#goban(size: 5, partial: "B2:D4", stones(black: "C2, D3", white: "B4", shadow: (on: true, angle: -45deg, offset: 1.5pt)))
#goban(size: 3, scale: 2, stones(black: "A1", shadow: (on: true, angle: -45deg)),
  stones(black: "C2", shadow: (on: true, angle: -45deg, scale: 1.3)), stones(white: "A3", shadow: (on: true, offset: 0pt, scale: 1.3, color: red)))
#goban(size: 5, partial: "B2:D4", stone: (shine: (on: false, color: red)), stones(black: "C3"))
#goban(size: 5, partial: "B2:D4", background: (shadow: true), stones(black: "C3"))
#goban(size: 5, partial: "B2:D4", background: (shadow: (on: true, color: blue, opacity: 0.3, angle: 45deg, offset: 4pt)))
#goban(size: 2, scale: 2, stones(black: "A1", mark: "circle"))
#goban(size: 2, scale: 2, scale-line-width: true, stones(black: "A1", mark: "circle"))
