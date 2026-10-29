#import "../estilo.typ": *
#import "/lib.typ": *

= Marks, arrows and lines <marcas>

Marks go on an intersection, with or without a stone: shapes (circle, triangle, cross, …), numbers in sequence or any content.

#funcion("marks(coordinates, shape: ..., ..options)")[
  Places marks on the intersections, written with the coordinate syntax (#pag(<coordenadas>)). The shape is the key: `marks(triangle: "C3", circle: "E5")`. Without a shape, a cross: `marks("C3")`. The same `marks` can hold several shapes, and its options hold for all of them.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, marks("C3"))
  #goban(b, marks(triangle: "C2",
    circle: "B4", square: "C3"))
  ```

  Without `player`, a mark on a stone belongs to the player of the stone, with their style, so that it can be seen; on an empty point, it is neutral. On an empty point, the mark covers the grid with the background of the board (except `t-circle`, `t-square` and `dim`).
]

== The shapes

#let formas = ("circle", "triangle", "square", "cross", "filled-square", "filled-circle", "t-circle", "t-square",
  "hatched-lines", "dim")

The shapes of the package are `circle`, `triangle`, `square`, `cross`, `filled-square`, `filled-circle`, `t-circle`, `t-square`, `hatched-lines`, `dim`, `sequence` and `custom`. Those of the `shapes` option (#pag(<formas-propias>)) are used the same way.

#align(center, table(columns: 5, stroke: none, align: center, row-gutter: 4pt,
  ..formas.map(f => stack(spacing: 4pt,
    goban(size: 3, scale: 1.2, partial: "A1:C2", stones(black: "A1", white: "C1"),
      marks(..((f): "A1, B1, C1"))),
    raw(f)))))

#opcion("circle")[A circle.]
#opcion("triangle")[A triangle.]
#opcion("square")[A square.]
#opcion("cross")[A cross. It is the shape of `marks` without a shape.]
#opcion("filled-square")[A filled square, with the fill of the mark (`fill`).]
#opcion("filled-circle")[A filled circle, with the fill of the mark.]
#opcion("t-circle")[A small circle, with the fill of the stones of the player and the border of the grid. It is the mark of Black's territory.]
#opcion("t-square")[Like `t-circle`, but square. It is the mark of White's territory and of the neutral points.]
#opcion("hatched-lines")[A hatching of lines, the color of the fill of the mark.]
#opcion("dim")[
  Dims the point: it covers it with the background of the board, translucent, over the stone and the grid. It is what a game draws for the `DD` property.

  ```ejemplo
  #goban(size: 5,
    stones(black: "B2, C3", white: "D4"),
    marks(dim: "A1:5, B2"))
  ```
]

#opcion("sequence")[
  Numbers the marks, in the order of the coordinates (#pag(<orden-coordenadas>)), from `from`. The format, the size and the color of the numbers are those of `label`, like the content of `custom`.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(sequence: "C3, B3, C4"),
    marks(sequence: "B2, D2, D4",
      label: (format: "A",
        text: (weight: "bold"))))
  ```
]

#opcion("from", valor: [a number], inicial: `1`)[
  In `marks`, the number of the first mark of `sequence`.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(sequence: "C3, B3, C4", from: 3))
  ```
]

#opcion("custom")[
  A mark with any content, that of `content`: a text, a symbol ("!", "?") or a drawing.
]

#opcion("content", valor: [content])[
  In `marks`, what `custom` draws. It is required with `custom`. Its size is adjusted to the number of characters, except with `label.size`.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, marks(custom: "C3",
    content: [!]))
  #goban(b, marks(custom: "C3",
    content: box(stroke: red, radius: 2pt,
      inset: 1pt, text(fill: red)[…])))
  ```
]

== The options of the marks

The style of the marks is that of their player: `gobanist-set(mark: ...)` is `gobanist-set(players: (all: (mark: ...)))`, and the options of each `marks` go on top.

#opcion("player", valor: [`auto`, `"black"`, `"white"` or `"neutral"`], inicial: `auto`)[
  The player of the marks, whose style they take. With `auto`, that of the stone on the point, or neutral if there is none.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(t-square: "B2, C3", player: "black"),
    marks(t-square: "D2, B3", player: "white"),
    marks(t-square: "D4", player: "neutral"),
    marks(triangle: "C2, D3, B4"))
  ```
]

#opcion("mark.scale", valor: [a number], inicial: `1`)[
  The size of the mark relative to the usual one: the shapes, the images and the text.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2"),
    marks(triangle: "C2, B3", scale: 1.5),
    marks(circle: "D4", scale: 0.6))
  ```
]

#opcion("mark.line", valor: [a dictionary])[The stroke of the mark.]
#opcion("mark.line.color", valor: [a color])[
  The color of the stroke: white on Black's marks and black on the others.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(triangle: "C3",
      line: (color: red)))
  ```
]

#opcion("mark.line.width", valor: [a length], inicial: `1pt`)[
  The width of the stroke.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(triangle: "C3", line: (width: 0.3pt)),
    marks(triangle: "B4", line: (width: 2pt)))
  ```
]

#opcion("mark.line.opacity", valor: [a number from 0 to 1], inicial: `1`)[The opacity of the stroke.]

#opcion("mark.fill", valor: [`true`, `false` or a dictionary])[The fill of the filled marks (`filled-square`, `filled-circle` and `hatched-lines`), and the `fill` of the shapes of your own (#pag(<formas-propias>)). With `false`, the filled marks are not seen.]
#opcion("mark.fill.color", valor: [a color or `none`], inicial: `luma(50%)`)[
  The color of the fill.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(filled-circle: "C3",
      fill: (color: red)))
  ```
]

#opcion("mark.fill.opacity", valor: [a number from 0 to 1], inicial: `1`)[
  The opacity of the fill.

  ```ejemplo
  #goban(size: 3,
    players: (white: (mark: (
      fill: (color: red, opacity: 0.5),
      line: (opacity: 0.3)))),
    stones(white: "A1"),
    marks(filled-square: "A1, B2",
      player: "white"),
    marks(triangle: "C3, A3", player: "white"))
  ```
]

#opcion("mark.fill.pattern", valor: [`none` or a `tiling`], inicial: `none`)[
  A pattern over the color of the fill of `filled-square` and `filled-circle`, like `stone.fill.pattern` (#pag(<piedras>)). `hatched-lines` and the shapes of your own use only the color.

  ```ejemplo
  #goban(size: 3,
    marks(filled-square: "A1, B2", fill: (
      color: yellow, pattern: tiling(
        size: (2pt, 2pt), square(size: 1pt,
          fill: black)))),
    marks(filled-circle: "C3", fill: (
      color: none, pattern: tiling(
        size: (2pt, 2pt), line(length: 2pt,
          stroke: red)))))
  ```
]

#opcion("mark.label", valor: [a dictionary])[The text of the marks that have one: `sequence` and `custom`.]
#opcion("mark.label.format", valor: [a `numbering` pattern], inicial: `"1"`)[
  The format of the numbers of `sequence`: a `numbering` pattern, such as `"1"`, `"a"`, `"A"`, `"i"`, `"I"` or `"一"`. The kanji need a font that has them, in `label.text`.

  ```ejemplo
  #goban(size: 3, scale: 1.6,
    marks(sequence: "A1, B2, C3", from: 9,
      label: (format: "一",
        text: (font: "MS Gothic"))))
  ```
]

#opcion("mark.label.size", valor: [`auto` or a length], inicial: `auto`)[The size of the text. With `auto`, it is adjusted to the number of characters.]
#opcion("mark.label.text", valor: [a dictionary])[
  The `text` options of the text: the font, the style, the color. The color is that of `line.color`.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(sequence: "C3, B3, C4",
      label: (text: (style: "italic"))),
    marks(custom: "D4", content: [!],
      label: (text: (fill: red))))
  ```
]

#opcion("forget", valor: [`true` or `false`], inicial: `false`)[In `marks`, `arrows` and `lines`: `resume` does not bring these marks, arrows or lines, even if `marks` is asked for (#pag(<memoria>)).]

== Shapes of your own <formas-propias>

#opcion("shapes", valor: [a dictionary of shapes], inicial: `(:)`)[
  Mark shapes of your own, by name: `shapes: (diamond: ..., star: ...)`. They are used like those of the package: in `marks`, in the `mark` option of the stones, in `territory` and in `last-mark`. A shape with the name of another replaces it. None can be named like an option of `marks` (`line`, `fill`, `label`, `scale`, `player`, `from`, `content` or `forget`). A shape is:

  - a function: it takes a dictionary with `radius` (the radius of the stone of the player, with `scale`), `stroke` (the stroke of the mark), `fill` (its fill, `none` if it is off) and `color` (the color of its lines), and what it returns is drawn with its origin on the point;
  - content, centered on the point;
  - an image, `(image: file)` or `(image: (file: file, width: ...))`, centered on the point, without the colors of the mark. `width` is its width (with `auto`, 1.2 stone radii), which changes with `scale`. With several files, each point uses one, always the same one.

  On an empty point, a shape of your own covers the grid like the others.

  ```ejemplo
  #gobanist-set(shapes: (
    diamond: m => polygon(fill: m.fill,
      stroke: m.stroke,
      (0pt, -0.7 * m.radius),
      (0.7 * m.radius, 0pt),
      (0pt, 0.7 * m.radius),
      (-0.7 * m.radius, 0pt)),
    bar: m => line(
      start: (-0.5 * m.radius, 0.5 * m.radius),
      end: (0.5 * m.radius, -0.5 * m.radius),
      stroke: m.stroke),
    star: (image: path("img/pgfgo-star.pdf")),
    eye: text(fill: red, size: 8pt)[◉],
  ))

  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(diamond: "C2, B4, B2", bar: "D3, C3",
      star: "D4", eye: "D2"))
  ```

  ```ejemplo
  #goban(size: 5, partial: "A1:E3",
    shapes: (shell: (image: (width: 1em,
      file: range(1, 6).map(n => path(
        "img/pgfgo-shell-white-" + str(n)
          + ".png"))))),
    marks(shell: "A:E 1:3"))
  ```
]

== Arrows and lines <flechas>

Arrows and lines join two intersections. They are drawn on top of the stones, with a halo the color of the background of the board that separates them from the stones and the grid. A game draws the arrows (`AR`) and the lines (`LN`) of the file.

#funcion("arrows(..pairs, ..options)")[
  Draws arrows, each one from one intersection to another: `arrows(("B3", "F3"), ("C7", "G9"))`. The options hold for all of them.

  ```ejemplo
  #goban(stones(black: "C3, D3", white: "E5"),
    arrows(("B3", "F3")),
    arrows(("C7", "G9"), color: red,
      halo: false))
  ```
]

#funcion("lines(..pairs, ..options)")[
  Draws lines, each one from one intersection to another. It has the options of `arrows`, except `tip` and `tips`.

  ```ejemplo
  #goban(stones(black: "C3, D4", white: "E5"),
    lines(("C3", "G7")),
    lines(("A9", "J9"), color: blue, width: 2pt))
  ```
]

The style of every arrow is set with `gobanist-set(arrow: ...)`, and that of every line, with `gobanist-set(line: ...)`.

#opcion("arrow.color", valor: [a color], inicial: `black`)[The color of the arrow.]
#opcion("arrow.width", valor: [a length], inicial: `1.2pt`)[The width of the arrow. The tip grows with it.]
#opcion("arrow.opacity", valor: [a number from 0 to 1], inicial: `1`)[
  The opacity of the arrow.

  ```ejemplo
  #goban(size: 5,
    stones(black: "C2, C4", white: "D3"),
    arrows(("A1", "E1"), width: 0.4pt),
    arrows(("A3", "E3"), color: blue,
      width: 2.5pt),
    arrows(("A5", "E5"), color: red,
      opacity: 0.4, width: 2.5pt))
  ```
]

#opcion("arrow.dash", valor: [`"solid"`, `"dashed"` or `"dotted"`], inicial: `"solid"`)[The stroke: solid, dashed or dotted. The halo and the tip are always solid.]
#opcion("arrow.shorten", valor: [a length], inicial: `0pt`)[
  Shortens both ends.

  ```ejemplo
  #goban(size: 5,
    stones(black: "B2", white: "D4"),
    arrows(("B2", "D4"), shorten: 5pt),
    arrows(("A5", "E5"), dash: "dashed",
      tips: "both"),
    lines(("A1", "E1"), dash: "dotted"))
  ```
]

#opcion("arrow.bend", valor: [an angle], inicial: `0deg`)[
  Draws an arc instead of a straight line: the arrow leaves turned that angle to the left and arrives turned the same. With a negative angle, it bends to the right.

  ```ejemplo
  #goban(size: 5,
    stones(black: "B2", white: "D4"),
    arrows(("B2", "D4"), bend: 40deg,
      shorten: 5pt),
    lines(("A1", "E1"), bend: -30deg))
  ```
]

#opcion("arrow.tip", valor: [`"stealth"`, `"triangle"` or `"circle"`], inicial: `"stealth"`)[The tip of the arrow.]
#opcion("arrow.tips", valor: [`"end"` or `"both"`], inicial: `"end"`)[
  Where the tip goes: at the end, or at both ends.

  ```ejemplo
  #goban(size: 5,
    arrows(("A1", "E1")),
    arrows(("A3", "E3"), tip: "triangle",
      tips: "both"),
    arrows(("A5", "E5"), tip: "circle"))
  ```
]

#opcion("arrow.halo", valor: [`true`, `false` or a dictionary])[The halo around the arrow.]
#opcion("arrow.halo.color", valor: [`auto` or a color], inicial: `auto`)[The color of the halo. With `auto`, that of the background of the board.]
#opcion("arrow.halo.width", valor: [a length], inicial: `0.8pt`)[
  The width of the halo on each side of the arrow.

  ```ejemplo
  #goban(size: 5,
    stones(black: "B1, B3, B5",
      white: "D1, D3, D5"),
    arrows(("A1", "E1"), halo: false),
    arrows(("A3", "E3")),
    arrows(("A5", "E5"), halo: (color: yellow,
      width: 2pt)))
  ```
]

Lines have the same options, in the `line` branch, except `tip` and `tips`:

#opcion("line.color", valor: [a color], inicial: `black`)[Like `arrow.color`.]
#opcion("line.width", valor: [a length], inicial: `1.2pt`)[Like `arrow.width`.]
#opcion("line.opacity", valor: [a number from 0 to 1], inicial: `1`)[Like `arrow.opacity`.]
#opcion("line.dash", valor: [`"solid"`, `"dashed"` or `"dotted"`], inicial: `"solid"`)[Like `arrow.dash`.]
#opcion("line.shorten", valor: [a length], inicial: `0pt`)[Like `arrow.shorten`.]
#opcion("line.bend", valor: [an angle], inicial: `0deg`)[Like `arrow.bend`.]
#opcion("line.halo", valor: [`true`, `false` or a dictionary])[Like `arrow.halo`, with `color` and `width`.]
