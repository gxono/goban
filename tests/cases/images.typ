#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

#let img(name) = path("/images/pgfgo-" + name + ".png")
#let shells = range(1, 6).map(n => img("shell-white-" + str(n)))

// Piedras con imagen: sin relleno ni borde; con varios archivos y rotate, cada punto con el suyo.
#goban(size: 5, partial: "B2:D4",
  stones(black: "C2, D3", image: img("yunzi-black"), shadow: (on: true, angle: -45deg, offset: 1.5pt)),
  stones(white: "B4", image: img("yunzi-white-1"), shadow: (on: true, angle: -45deg, offset: 1.5pt)))
#goban(size: 5, partial: "B2:D4", stones(white: "B2, C2, D2, B3, C3, D3", image: (file: shells, rotate: "random")))
#goban(size: 5, partial: "B2:D4", stones(white: "B2, C2, D2, B3, C3, D3", image: (file: shells, rotate: (-20deg, 20deg))))
// width, opacity y los prisioneros (la imagen toma la opacidad del relleno).
#goban(size: 5, partial: "B2:D4", stones(black: "C2", image: img("yunzi-black")),
  stones(black: "D3", image: (file: img("yunzi-black"), width: 8pt)),
  stones(white: "B4", image: (file: img("yunzi-white-1"), opacity: 0.5)),
  prisoners(white: "D4", image: img("yunzi-white-1")))
// La sombra con su imagen propia, con scale, y el brillo con imagen (silueta del color del brillo).
#goban(size: 5, partial: "B2:D4", players: (all: (stone: (shadow: (on: true, angle: -45deg, offset: 0.75pt, scale: 1.2,
  opacity: 0.6, image: img("shadow"))))), stones(black: "C2, D3", image: img("shell-black")), stones(white: "B4, C3"))
#goban(size: 5, partial: "B2:D4", stones(black: "C2, D3", shine: (on: true, color: red, image: (file: img("shadow"), width: 6pt, silhouette: true))),
  stones(white: "B4", image: img("yunzi-white-1"), shine: (on: true, opacity: 0.5, image: (file: img("shadow"), width: 5pt))))
// La imagen se quita con none.
#goban-set(stone: (image: img("yunzi-black")))
#goban(size: 3, stones(black: "A1", white: "B2"), stones(white: "C3", image: none))

#goban-set(stone: (image: none))

// El fondo con imagen: cover (la parte que toca con partial, recortada por las esquinas), stretch, tile y
// rotate. Las marcas sobre puntos vacíos muestran la imagen de debajo, y también dim.
#let board = path("/images/pgfgo-board.jpg")
#goban(size: 9, background: (fill: (image: board)), stones(black: "C3", white: "D4"), marks(circle: "E5, C3"))
#goban(size: 9, partial: "A1:E5", background: (fill: (image: board), rounded-corners: 6pt), marks(triangle: "C3", dim: "D2"))
#goban(size: 5, background: (fill: (image: (file: board, rotate: 90deg))))
#goban(size: 5, background: (fill: (image: (file: board, fit: "stretch"))))
#goban(size: 9, background: (fill: (image: (file: (img("shell-white-1"), img("yunzi-white-2"), board), fit: "tile", width: 1cm))))
#goban(size: 9, partial: "D4:H8", background: (fill: (image: (file: board, fit: "tile", width: 1cm))))
#goban(size: 5, background: (fill: (image: (file: board, fit: "tile", width: 1cm, anchor: top + right))))
#goban(size: 5, background: (fill: (image: (file: board, fit: "tile", width: 1cm, anchor: top))))
#goban(size: 5, background: (fill: (image: (file: board, fit: "tile", width: 1cm, rotate: "random"))))
#goban(size: 9, background: (fill: (image: (file: img("baduktv-goban"), fit: "tile", tiles: (3, 3)))))
// La opacidad del relleno vale para la imagen; el patrón va encima.
#goban(size: 5, background: (fill: (image: board, opacity: 0.4, pattern: tiling(size: (4pt, 4pt), circle(radius: 0.6pt)))),
  marks(square: "C3"))

// La cuadrícula con imagen: stretch (con partial, la parte que toca), tile, la malla tiles y varios archivos.
#let test(name) = path("/tests/images/pgfgo-" + name + ".png")
#goban(size: 9, grid: (image: test("grid")), hoshi: false, stones(black: "C3", white: "D4"))
#goban(size: 9, grid: (image: test("grid")), hoshi: false, partial: "C3:G7")
#goban(size: 9, grid: (image: (file: test("cell"), fit: "tile")), hoshi: false, stones(black: "C3", white: "D4"))
#goban(size: 9, grid: (image: (file: test("cell"), fit: "tile", tiles: 4)), hoshi: false)
#goban(size: 5, hoshi: false, grid: (image: (file: (test("cell"), test("tile")), fit: "tile", rotate: "random")))
// Los puntos de estrella con imagen: width, rotate y la opacidad.
#goban(size: 9, hoshi: (image: test("hoshi"), radius: 3pt))
#goban(size: 9, hoshi: (image: (file: test("hoshi"), width: 8pt, rotate: 45deg)))
#goban(size: 9, hoshi: (image: (file: test("hoshi"), width: 8pt, rotate: "random"), opacity: 0.4))
// Una imagen PDF (sin opacidad).
#goban(size: 5, partial: "B2:D4", stones(black: "C3", image: path("/tests/images/pgfgo-star.pdf")))
