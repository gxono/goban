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
