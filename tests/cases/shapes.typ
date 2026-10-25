#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Formas propias: una función (con el trazo, el relleno y el radio de la marca; lo que devuelve tiene su origen
// en el punto), un contenido y una imagen (centrados).
#goban-set(shapes: (
  rombo: m => polygon(fill: m.fill, stroke: m.stroke,
    (0pt, -0.7 * m.radius), (0.7 * m.radius, 0pt), (0pt, 0.7 * m.radius), (-0.7 * m.radius, 0pt)),
  barra: m => line(start: (-0.5 * m.radius, 0.5 * m.radius), end: (0.5 * m.radius, -0.5 * m.radius), stroke: m.stroke),
  estrella: (image: path("/tests/images/pgfgo-star.pdf")),
  estrellita: (image: (file: path("/tests/images/pgfgo-star.pdf"), width: 0.6em)),
  ojo: text(fill: red, size: 8pt)[◉],
))
#goban(size: 5, partial: "B2:D4", stones(black: "C2, D3", white: "B4"),
  marks(rombo: "C2, B4, B2", barra: "D3, C3", estrella: "D4"))
#goban(size: 5, partial: "B2:D4", stones(black: "C2, D3", white: "B4"),
  marks(estrella: "C3, B4", estrellita: "B3, D3", ojo: "D2"))
// Con varios archivos, cada punto usa uno; scale y el color del jugador también valen.
#goban(size: 5, partial: "A1:E3", shapes: (concha: (image: (file: range(1, 6).map(n =>
  path("/images/pgfgo-shell-white-" + str(n) + ".png")), width: 1em))), marks(concha: "A:E 1:3"))
#goban(size: 5, partial: "B2:D4", stones(black: "C2"), marks(rombo: "C2, B3", scale: 1.5), marks(rombo: "D4", line: (color: red)))
// En la opción mark de las piedras, en territory y como last-mark.
#goban(size: 5, partial: "B2:D4", stones(black: "C2", white: "D3", mark: "rombo"), moves("C4", mark: "barra"))
#goban(size: 5, stones(black: "B1, B2, B3, B4, B5", white: "C1, C2, C3, C4, C5"),
  territory(auto, mark: "rombo"))
// Una forma propia reemplaza a la del paquete con el mismo nombre.
#goban(size: 3, shapes: (triangle: m => place(center + horizon, circle(radius: 0.4 * m.radius, fill: blue))),
  marks(triangle: "B2"))
