#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Jugadas: turno, numeración, formato, from, numbers, partial auto.
#goban(size: 19, partial: auto, moves("Q16, R14, R16, P17"))
#goban(size: 19, partial: auto, partial-margin: 0, stones(black: "J10, K11", white: "K9"))
#goban(size: 5, moves("B1 -| D3, C:A 4, E5"))
#goban(size: 5, partial: "B2:D4", moves("C3, D3", numbers: false), moves("C2, B3"))
#goban(size: 5, moves("C3, D3, C2", from: 9), moves("B3", from: 99, mark: "circle"))
#goban(size: 5, moves(white: "C3, D3"), moves("C2", label: (format: "a")), moves("B3", label: (text: (fill: red))))
#goban(size: 5, scale: 2, move: (label: (format: "I")), moves("C3, D3, C2, B3"))
