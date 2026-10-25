#import "/lib.typ": *
#set page(width: 16cm, height: auto, margin: 0.5cm)
#let extreme(name) = sgf-read(path("/tests/sgf/extreme/" + name + ".sgf"))

// 25×25: la última columna es Z (Z1, Z25 y la columna Z blancas; A25 negra); con use-i, es Y (I1 e Y25 negras).
#box(goban(size: 25, scale: 0.6, label: (at: (bottom, left)), stones(white: "Z1:25", black: "A25")))
#box(goban(size: 25, scale: 0.6, use-i: true, label: (at: (bottom, left)), stones(black: "I1, Y25")))

// Rectangulares, sin puntos de estrella (un eje de 3 líneas no tiene): 19×3 y 3×19.
#box(goban(size: (19, 3), scale: 0.3, stones(black: "A1, T3")))
#box(goban(size: (3, 19), scale: 0.3, stones(white: "A1, C19")))

// Ventanas: E5:A1 es A1:E5; E5:E5 es un punto; J1:J9 es la última columna.
#box(goban(size: 9, scale: 0.4, partial: "E5:A1", stones(black: "C3")))
#box(goban(size: 9, scale: 0.4, partial: "E5:E5", stones(black: "E5")))
#box(goban(size: 9, scale: 0.4, partial: "J1:J9", stones(white: "J1, J9")))

// Números de hasta tres caracteres en la piedra: 99, 100, 999 / iii, xii, ccc / z, aa, zz.
#goban(size: 5, scale: 1.5, partial: "A1:C3",
  moves(black: "A3", from: 99), moves(black: "B3", from: 100), moves(black: "C3", from: 999),
  moves(white: "A2", from: 3, label: (format: "i")), moves(white: "B2", from: 12, label: (format: "i")),
  moves(white: "C2", from: 300, label: (format: "i")),
  moves(black: "A1", from: 26, label: (format: "a")), moves(black: "B1", from: 27, label: (format: "a")),
  moves(black: "C1", from: 702, label: (format: "a")))

// SGF: etiquetas con caracteres especiales; SZ[7:13] y SZ[13:7]; los pases.
#box(goban(extreme("labels"), scale: 0.5))
#box(goban(extreme("size-7x13"), scale: 0.3))
#box(goban(extreme("size-13x7"), scale: 0.3))
#box(goban(extreme("passes"), scale: 0.25))

// Los caracteres especiales de TeX en los textos, también en los epígrafes y comentarios de los diagramas.
PB = [#sgf-info(extreme("tex-specials"), "PB")], PW = [#sgf-info(extreme("tex-specials"), "PW")],
GN = [#sgf-info(extreme("tex-specials"), "GN")]

0: [#sgf-comment(extreme("tex-specials"), 0)]

#sgf-diagrams(extreme("tex-specials"), step: 2, comments: true, goban: (scale: 0.5))

// komi 1000.5, -7.5 y 0.333333 para las blancas, que no tienen territorio.
#box(goban(size: 5, scale: 0.4, stones(black: "C1:5"), territory(auto)))
#goban-score("white", komi: 1000.5), #goban-score("white", komi: -7.5), #goban-score("white", komi: 0.333333)

// Muchas marcas en el tablero más grande: territory(auto) con una fila de negras (600 puntos) y una marca en
// cada punto (625).
#pagebreak()
#box(goban(size: 25, scale: 0.6, stones(black: "A13:Z13"), territory(auto)))
#box(goban(size: 25, scale: 0.6, marks(triangle: "A1:Z25")))
