#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Piedras, prisioneros, jugadores y la regla de prender y apagar.
#goban(size: 17, partial: "A1:R5", stones(black: "*; B, D, H, M, R2, Q, F2:4, K2 r L5, O[1:2, 4]; B3"))
#goban(size: 5, stones(black: "B2", white: "C3"), stones("D4"), prisoners(black: "A1", white: "E5"))
#goban(size: (7, 4), stones(black: "A1 -- G4", fill: (color: blue)), stones(white: "G1", line: false, fill: (opacity: 0.5)))
#goban(size: 5, players: (all: (stone: (line: (color: red))), white: (stone: (fill: (color: orange)))),
  stone: (fill: false), stones(black: "B2", white: "C3"), stones(black: "D4", fill: true))
#goban(size: 5, stones(black: "B2", radius: 4pt), stones(white: "C3", scale: 1.3), stones(black: "D4", scale: 0.7, mark: "circle"))
#goban(size: 5, prisoner: (line: (color: red)), prisoners(white: "C3"), stones(white: "B3"))

// shift: (columnas, filas) corre las coordenadas de stones, prisoners, moves y marks; cada forma se escribe una
// vez, desde A1.
#let salto = "A1, A3"
#let caballo = "A1, B3"
#let bambu = "A1:2, C1:2"
#let tigre = "A2, B1, C2"
#goban(size: (15, 9), label: (at: bottom),
  stones(black: salto, shift: (1, 5)), stones(black: caballo, shift: (4, 5)),
  stones(black: bambu, shift: (7, 5)), stones(black: tigre, shift: (11, 5)),
  stones(white: salto, shift: (1, 1)), stones(white: caballo, shift: (4, 1)),
  stones(white: bambu, shift: (7, 1)), stones(white: tigre, shift: (11, 1)),
  moves("A1, B1", shift: (0, 8)), marks(triangle: "A1", shift: (14, 0)), prisoners(black: "A1", shift: (14, 8)))
