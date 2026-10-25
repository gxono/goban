#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Territorio: polígonos, auto, dame, fill y region (los ejemplos de «El juego» en el manual de pgf-go).
#let partida = (
  stones(black: "A6 |- B5 |- D1 |- E2, C4, E9 -| F4, D5 -| G7 -- D7, H6, H8, J7"),
  stones(white: "E8 -| C5, B:E6, A7, B8, D9, J6 |- H5, H2:3, F1 |- C3, C2, D:E4, G4"),
  prisoners(black: "H1 -| J2"),
  prisoners(white: "A1"),
)
#goban(label: (at: (top, left)), ..partida,
  territory(black: "A1, A5, B5, B1"), territory(black: "F9, F7, G7, G6, J6, J9"),
  territory(white: "F1, F4, G4, G5, J5, J1"), territory(white: "A9, A6, C6, C8, D8, D9"))
#goban(label: (at: (top, left)), ..partida, territory(auto, dame: true))
#goban(label: (at: (top, left)), ..partida, territory(auto, draw: "fill"))
#goban(label: (at: (top, left)), ..partida, territory(auto, draw: "region"))
#goban(label: (at: (top, left)), ..partida,
  territory(black: auto, draw: "region", line: true, vertices: true),
  territory(white: auto, draw: "region", line: (on: true, color: red)))
Negras: #goban-score("black"). Blancas: #goban-score("white", komi: 6.5).

#goban(size: 5, stones(black: "C1:5"), stones(white: "D1:5"),
  territory(black: "A1, A5, B5, B1", mark: "t-square"), territory(white: "E1, E5"))
#goban(size: 5, stones(black: "C1:5"), stones(white: "D1:5"),
  territory(black: "A1, A5, B5, B1", draw: "fill", fill: (color: blue, opacity: 0.5)), territory(white: "E1, E5", draw: "fill"))
#goban(size: 5, stones(black: "C1:5"), stones(white: "D1:5"),
  territory(black: "A1, A5, B5, B1", draw: "region", fill: false, line: (on: true, color: red, width: 2pt, opacity: 0.7)))
#goban(size: 5, stones(black: "C1:5"), stones(white: "D1:5"),
  territory(black: "A1, A5, B5, B1", draw: "region", vertices: (on: true, radius: 3pt, color: red)))
#goban(label: (at: (top, left)), stones(white: "D4:F6"), territory(black: "B2, B8, H8, H2", draw: "region", line: true),
  marks(triangle: "D4, D6, F6, F4"))
Contornos: #goban-region("black", "polygons") (#goban-region("black", "holes") hueco).
Casillas: #goban-region("black", "area"). Hueco: #goban-region("black", "polygon", n: 2).

#goban(size: 19, partial: auto, stones(black: "C3:5, D5, E5:3, D3"), territory(black: auto))
