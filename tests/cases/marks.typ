#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Marcas: formas, secuencia, custom, dim, y el jugador de la piedra de abajo.
#goban(size: 5, stones(black: "B2, C3", white: "D4"),
  marks(triangle: "B2, D4, A5", square: "E1", cross: "A1", t-circle: "E5"),
  marks(sequence: "B4, C4, D3", label: (format: "A")), marks(custom: "E3", content: [?]))
#goban(size: 5, stones(black: "B2, C3", white: "D4"), marks(dim: "A1:5, B2"))
#goban(size: 5, marks(filled-square: "A5", filled-circle: "E1", hatched-lines: "B5", circle: "C3", square: "D2"))
#goban(size: 5, stones(black: "C2, D3", white: "B4"), marks(t-square: "B2, C3", player: "black"),
  marks(t-square: "D2", player: "white"), marks(t-circle: "D4", player: "neutral"))
#goban(size: 5, players: (all: (mark: (line: (color: red)))), stones(black: "B2"), marks(triangle: "B2, C3", scale: 1.5))
#goban(size: 5, marks(sequence: "A1 -|- E4", from: 3), marks(custom: "C5", content: [abc]))
