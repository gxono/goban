#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Tamaño, partial, cuadrícula, hoshi, fondo y etiquetas.
#goban(size: 19, partial: "K1:T9", label: (at: (top, right)))
#goban(size: 17, partial: "A1:R5", label: (at: (top, left)))
#goban(size: (7, 4), grid: (sep: (x: 1.8em)), hoshi: (at: "C2, E3"), label: (at: (top, bottom, left, right)))
#goban(size: 9, partial: "E5:A1", background: (rounded-corners: (outer: 8pt, inner: 2pt)))
#goban(size: 5, background: (rounded-corners: 6pt, fill: (color: rgb("#dcb35c"))), scale: 1.5)
#goban(size: 9, grid: false, use-i: true, label: (at: (top,)))
#goban(size: 9, grid: (line: false), hoshi: (radius: 2pt, color: red))
#goban(size: 5, background: false)
#goban(size: 5, background: (line: false, fill: (color: luma(220))), grid: (line: (color: blue, width: 1pt)))

// blank: los puntos que no son del tablero, sin líneas ni puntos de estrella; una línea une solo dos vecinos del
// tablero. Una columna (dos tableros juntos), un rectángulo y una fila, puntos sueltos, con partial y etiquetas,
// con la imagen de la grilla (solo en las casillas del tablero) y con gobanist-set.
#box(goban(blank: "E", stones(black: "C3, D4, D5", white: "F3, F4, G5")))
#box(goban(blank: "A9:C7, 5", stones(black: "D8, D6", white: "C6")))
#box(goban(blank: "E5, A2, B1", stones(black: "E4, E6")))
#box(goban(blank: "D, 6", partial: "A1:G8", label: (at: (left, bottom)), stones(white: "C3, E3")))
#box(goban(blank: "E", grid: (image: (file: path("/tests/images/pgfgo-grid.png"))), stones(black: "C3")))
#gobanist-set(blank: "A, J")
#box(goban(stones(black: "B2")))
#gobanist-set(blank: none)

// grid.edge: las cuatro líneas de afuera; lo que no se da es como en la grilla. Con partial, solo las que se ven.
#box(goban(profile: "simple", grid: (edge: (width: 1.2pt)), stones(black: "C3, G7, C6", white: "G3, E7, C7")))
#box(goban(size: 5, grid: (edge: (color: red, width: 2pt)), partial: "A1:C3"))
#box(goban(size: 5, scale-line-width: true, scale: 1.5, grid: (edge: (width: 1pt, opacity: 0.5))))

// label con "a": las letras del go en minúsculas (sin la i, salvo con use-i).
#box(goban(label: (at: (bottom, left), columns: "a")))
#box(goban(use-i: true, label: (at: (bottom, left), columns: "a", rows: "a")))
