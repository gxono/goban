#import "../estilo.typ": *
#import "/lib.typ": *

= The board <tablero>

The board is what `goban` draws: the grid, the background, the coordinates and everything on top.

#funcion("goban(..options, ..elements)")[
  Draws a board. The elements are what goes on it, in order: stones (`stones`, `prisoners`), moves (`moves`), marks (`marks`), arrows and lines (`arrows`, `lines`), territory (`territory`) and games (`sgf-read`, `sgf`). A board made with `board` can go first: it is that board, with its options and what it has, and the options and the elements of the `goban` are added to it. The options are named, and they are those of `goban-set` (#pag(<configuracion>)): they hold only for this board. By default, the board is 9×9, with a visible border, a white background and no coordinates.

  ```ejemplo
  #goban()
  ```

  The options of the board (`size`, `use-i`, `partial`, `scale`, …) go at the first level; those of its parts, in their branches: `grid`, `hoshi`, `background` and `label`.

  ```ejemplo
  #goban(size: 19, partial: "K1:T9",
    label: (at: (top, right)),
    stones(black: "L8, S8, R5, S5, P4, R4, M3,
      P3, N2, O2",
      white: "L6, S4, S3, Q3, O1, P2, R2"),
    marks(circle: "L8"),
    arrows(("L8", "S8"), color: blue,
      shorten: 6pt))
  ```
]

#funcion("board(..options, ..elements)")[
  A board as a value: it takes the same as `goban`, but draws nothing. It is resolved when it is drawn, with the global options of the place where it is drawn. Another board made with `board` can go first, as in `goban`: `board(base, moves("C3"))` is `base` with one more move. It is drawn with `goban(board)`, in `goban-layout` (#pag(<disposicion>)) and with `goban-view` (#pag(<vistas>)); with `resume`, another board goes on from it (#pag(<memoria>)).

  ```ejemplo
  #let base = board(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"))

  #goban(base)
  #goban(base, moves("C3"),
    background: (line: false))
  ```
]

#opcion("size", valor: [a number or `(columns, rows)`], inicial: `9`)[
  The size of the board: the vertical and horizontal lines. A number is a square board; `(5, 3)`, one with 5 columns and 3 rows. Columns go from 2 to 25, and rows, from 2 to 99. With a game (`sgf-read`), the board takes the size of the file (`SZ`), and another `size` is an error.

  ```ejemplo
  #goban(size: 5)
  #goban(size: (5, 3))
  ```
]

#opcion("use-i", valor: [`true` or `false`], inicial: `false`, etiqueta: <use-i>)[
  Uses the letter I in the coordinates and in the labels. Without it, as is customary in Go, the columns go from H to J, and an I in the coordinates is the J.

  ```ejemplo
  #goban-set(size: 13, label: (at: top))

  #goban(use-i: true, partial: "H1:M3",
    label: (at: (top, left)),
    stones(black: "J2"))
  #goban(partial: "H1:N3",
    stones(black: "J2"))
  // Without use-i, I is J.
  #goban(partial: "H1:N3",
    label: (at: (top, right)),
    stones(white: "I2"))
  ```
]

#opcion("scale", valor: [a number], inicial: `1`)[
  The scale of the board: its measures. The width of the lines does not change, except with `scale-line-width`.

  ```ejemplo
  #goban(size: 2, scale: 2,
    stones(black: "A1", mark: "cross"))
  #goban(size: 2,
    stones(black: "A1", mark: "cross"))
  #goban(size: 2, scale: 0.5,
    stones(black: "A1", mark: "cross"))
  ```
]

#opcion("scale-line-width", valor: [`true` or `false`], inicial: `false`)[
  With `true`, `scale` also multiplies the width of the lines: the grid, the border, the stones, the marks, the arrows, the lines and the territory. With `layout.fit`, which chooses the scale to fill the column, the width does not change (#pag(<disposicion>)).

  ```ejemplo
  #goban(size: 2, scale: 2,
    stones(black: "A1", mark: "cross"))
  #goban(size: 2, scale: 2,
    scale-line-width: true,
    stones(black: "A1", mark: "cross"))
  ```
]

== The grid

#opcion("grid", valor: [`true`, `false` or a dictionary])[
  The grid: the lines of the board. With `false`, no grid and no star points.

  ```ejemplo
  #goban(size: 3,
    stones(black: "A1", white: "B2"))
  #goban(size: 3, grid: false,
    stones(black: "A1", white: "B2"))
  ```
]

#opcion("grid.line", valor: [`true`, `false` or a dictionary])[
  The lines. With `false`, no lines, but with the star points (unlike `grid: false`).

  ```ejemplo
  #goban(grid: (line: false),
    hoshi: (radius: 2pt),
    stones(black: "C3, E5"))
  ```
]

#opcion("grid.line.color", valor: [a color], inicial: `black`)[The color of the lines.]
#opcion("grid.line.opacity", valor: [a number from 0 to 1], inicial: `1`)[The opacity of the lines.]
#opcion("grid.line.width", valor: [a length], inicial: `0.55pt`)[
  The width of the lines.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, grid: (line: (color: blue)))
  #goban(b, grid: (line: (opacity: 0.2)))
  #goban(b, grid: (line: (width: 1.5pt)))
  ```
]

#opcion("grid.sep", valor: [a length or `(x: ..., y: ...)`], inicial: `(x: 1.25em, y: 1.25em)`)[
  The distance between the lines: `x`, between the vertical ones, and `y`, between the horizontal ones. A single length goes to both.

  ```ejemplo
  #goban(size: 5, grid: (sep: (x: 1.8em)),
    stones(black: "B2, C3", white: "D3"))
  #goban(size: 5, grid: (sep: 0.9em),
    stones(black: "B2, C3", white: "D3"))
  ```
]

#opcion("grid.image", valor: [a file or a dictionary])[
  An image instead of the lines, with the opacity of `grid.line.opacity`. With `partial`, the corresponding part is seen. The star points are still drawn (#pag(<hoshi>)). What is not a dictionary is the file; `none` removes it.

  ```ejemplo
  #let grid-image = path("img/pgfgo-grid.png")

  #goban(grid: (image: grid-image),
    hoshi: false,
    stones(black: "C3", white: "D4"))
  #goban(grid: (image: grid-image),
    hoshi: false, partial: "C3:G7")
  ```
]

#opcion("grid.image.file", valor: [a file or an array], inicial: `none`)[
  The file: a `path` (relative to the document that names it) or its `bytes`. With several files and `fit: "tile"`, each tile uses one, chosen by its place in the mesh: always the same one in each place, in every diagram. With `"stretch"`, the first one is used.

  ```ejemplo
  #goban(size: 5, hoshi: false,
    grid: (image: (fit: "tile", file: (
      path("img/pgfgo-cell.png"),
      path("img/pgfgo-tile.png")))))
  ```
]

#opcion("grid.image.fit", valor: [`"stretch"` or `"tile"`], inicial: `"stretch"`)[
  With `"stretch"`, the image is stretched from A1 to the opposite corner of the full board: the outer lines must be on the edges of the image. With `"tile"`, it is drawn once in each cell (between four intersections), stretched to the size of the cell: with the image of one square the whole board is built.

  ```ejemplo
  #goban(hoshi: false, grid: (image: (
      file: path("img/pgfgo-cell.png"),
      fit: "tile")),
    stones(black: "C3", white: "D4"))
  ```
]

#opcion("grid.image.tiles", valor: [`auto`, a number or `(columns, rows)`], inicial: `auto`)[
  With `fit: "tile"`, the mesh in which the image is repeated, over the area that goes from A1 to the opposite corner of the full board; each image is stretched to the size of its cell. A number holds for both directions. With `auto`, one image per cell of the board.

  ```ejemplo
  #goban(hoshi: false, grid: (image: (
    file: path("img/pgfgo-cell.png"),
    fit: "tile", tiles: 4)))
  ```
]

#opcion("grid.image.rotate", valor: [an angle, `"random"` or `(min, max)`], inicial: `0deg`)[
  Rotates the image, like `background.fill.image.rotate`: in quarter turns, and with `"random"` or a range, each tile with its own.
]

== Star points <hoshi>

The star points (_hoshi_) are drawn on the grid, with its color. By default they are the usual ones: on each side, the fourth line from the border (the third on boards of fewer than 13 lines); the center if both sides are odd; and, from 15 lines on, the middle of the sides. A 19×19 board has nine, and a 13×13 or 9×9 one, five. Boards of fewer than 7 lines have none. Stones cover them.

#opcion("hoshi", valor: [`true`, `false` or a dictionary])[
  The star points.

  ```ejemplo
  #goban(stones(black: "C3, E5"))
  #goban(hoshi: false, stones(black: "C3, E5"))
  ```
]

#opcion("hoshi.radius", valor: [a length], inicial: `1.5pt`)[The radius of the points.]
#opcion("hoshi.color", valor: [`auto` or a color], inicial: `auto`)[The color of the points. With `auto`, that of the grid.]
#opcion("hoshi.opacity", valor: [`auto` or a number from 0 to 1], inicial: `auto`)[
  The opacity of the points (also that of their image). With `auto`, that of the grid.

  ```ejemplo
  #goban(hoshi: (radius: 2.5pt, color: red))
  #goban(hoshi: (radius: 3pt, opacity: 0.3),
    stones(black: "C3"))
  ```
]

#opcion("hoshi.at", valor: [`auto` or coordinates], inicial: `auto`)[
  The points, with the syntax of `stones` (#pag(<coordenadas>)). With `auto`, the usual ones.

  ```ejemplo
  #goban(hoshi: (at: "C3, G7"))
  ```
]

#opcion("hoshi.image", valor: [a file or a dictionary])[
  An image on each point, instead of the circle. What is not a dictionary is the file; `none` removes it.

  ```ejemplo
  #goban(hoshi: (radius: 3pt,
    image: path("img/pgfgo-hoshi.png")))
  ```
]

#opcion("hoshi.image.file", valor: [a file], inicial: `none`)[The file of the image.]
#opcion("hoshi.image.width", valor: [`auto` or a length], inicial: `auto`)[The width of the image; the height keeps the proportion. With `auto`, the diameter of the points.]
#opcion("hoshi.image.rotate", valor: [an angle, `"random"` or `(min, max)`], inicial: `0deg`)[
  Rotates the image, counterclockwise. With `"random"` or a range, each point with its angle, always the same one (#pag(<piedras-imagen>)).

  ```ejemplo
  #let hoshi = path("img/pgfgo-hoshi.png")

  #goban(hoshi: (image: (file: hoshi,
    width: 8pt)))
  #goban(hoshi: (image: (file: hoshi,
    width: 8pt, rotate: 45deg)))
  ```
]

== The background

The background of the board is the rectangle under the grid, with its fill and its border. By default, the fill is white and the border, black.

#opcion("background", valor: [`true`, `false` or a dictionary])[
  The background: the fill and the border. With `false`, no background.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b)
  #goban(b, background: false)
  ```
]

#opcion("background.fill", valor: [`true`, `false` or a dictionary])[
  The fill. With `false`, the background is transparent and only the border remains.
]

#opcion("background.fill.color", valor: [a color], inicial: `white`)[The color of the fill.]
#opcion("background.fill.opacity", valor: [a number from 0 to 1], inicial: `1`)[
  The opacity of the fill, also that of its image.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, background: (fill: false))
  #goban(b, background: (fill: (
    color: orange.lighten(60%))))
  #goban(b, background: (fill: (
    color: orange.lighten(60%), opacity: 0.5)))
  ```
]

#opcion("background.fill.pattern", valor: [`none` or a `tiling`], inicial: `none`)[
  A pattern over the color and the image of the background: a Typst `tiling`. The marks on empty points and the `dim` mark, which cover the grid with the background, repeat the pattern.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    background: (fill: (pattern: tiling(
      size: (4pt, 4pt),
      circle(radius: 0.6pt, fill: gray)))),
    stones(black: "C2, D3"),
    marks(triangle: "C3"))
  ```
]

#opcion("background.fill.image", valor: [a file or a dictionary])[
  A background image (for example, the wood of a board), over the fill color and with its same opacity. The image is placed according to the full board: with `partial`, the part that corresponds to it is seen, cut by the border and its rounded corners. The marks on empty points, which cover the grid with the background, show the part of the image underneath, and so does the `dim` mark. What is not a dictionary is the file; `none` removes it.

  ```ejemplo
  #let wood = path("img/pgfgo-board.jpg")

  #goban(background: (fill: (image: wood)),
    stones(black: "C3", white: "D4"),
    marks(circle: "E5, C3"))
  #goban(partial: "A1:E5", background: (
      fill: (image: wood),
      rounded-corners: 6pt),
    marks(triangle: "C3"))
  ```
]

#opcion("background.fill.image.file", valor: [a file or an array], inicial: `none`)[
  The file of the image. With several files and `fit: "tile"`, each tile uses one, chosen by its place: always the same one in each place, also with `partial`. The tiles have the size of the first image (or that of their cell, with `tiles`). With `"stretch"` and `"cover"`, the first one is used.

  ```ejemplo
  #goban(background: (fill: (image: (
    file: (path("img/pgfgo-tile.png"),
      path("img/pgfgo-cell.png"),
      path("img/pgfgo-board.jpg")),
    fit: "tile", width: 1cm))))
  ```
]

#opcion("background.fill.image.fit", valor: [`"cover"`, `"stretch"` or `"tile"`], inicial: `"cover"`)[
  How the image fills the background of the full board. `"stretch"` stretches it to fill the whole background, without keeping the proportion. `"cover"` enlarges or shrinks it, keeping the proportion, until it covers the background, centered: what is left over is not seen. `"tile"` repeats it as tiles, from a corner, a side or the center of the full board (`anchor`).

  ```ejemplo
  #let tile = (file: path("img/pgfgo-tile.png"),
    fit: "tile", width: 1cm)

  #goban(background: (fill: (image: tile)))
  #goban(partial: "D4:H8",
    background: (fill: (image: tile)))
  ```
]

#opcion("background.fill.image.anchor", valor: [an alignment], inicial: `bottom + left`)[
  With `fit: "tile"`, where the tiles start from, on the background of the full board. With a corner (`bottom + left`, `top + right`, …), a whole tile lies in that corner. With a side (`top`, `bottom`, `left` or `right`), the first tile lies against that side, centered along it. With `center`, a tile lies at the center of the board.

  ```ejemplo
  #let tile = (file: path("img/pgfgo-tile.png"),
    fit: "tile", width: 1cm)

  #goban(size: 5, background: (fill: (
    image: tile + (anchor: top + right))))
  #goban(size: 5, background: (fill: (
    image: tile + (anchor: top))))
  ```
]

#opcion("background.fill.image.width", valor: [`auto` or a length], inicial: `auto`)[With `fit: "tile"`, the width of each tile; the height keeps the proportion. With `auto`, the natural width of the image.]

#opcion("background.fill.image.tiles", valor: [`auto`, a number or `(columns, rows)`], inicial: `auto`)[
  With `fit: "tile"`, instead of tiles of width `width` from `anchor`, divides the background of the full board into that mesh and puts the image in each cell, stretched to its size. A number holds for both directions.

  ```ejemplo
  #goban(background: (fill: (image: (
    file: path("img/pgfgo-cell.png"),
    fit: "tile", tiles: (3, 3)))))
  ```
]

#opcion("background.fill.image.rotate", valor: [an angle, `"random"` or `(min, max)`], inicial: `0deg`)[
  Rotates the image in quarter turns: the angle is rounded to 0, 90, 180 or 270 degrees, so that the rotated image still fills its place without leaving gaps. With 90 or 270, the width and the height are swapped. With `"random"` or a range, each tile has its own rotation, always the same one.

  ```ejemplo
  #let wood = path("img/pgfgo-board.jpg")

  #goban(size: 5, background: (fill: (image: (
    file: wood, rotate: 90deg))))
  #goban(size: 5, background: (fill: (image: (
    file: wood, fit: "tile", width: 1cm,
    rotate: "random"))))
  ```
]

#opcion("background.line", valor: [`true`, `false` or a dictionary])[The border. With `false`, no border.]
#opcion("background.line.color", valor: [a color], inicial: `black`)[The color of the border.]
#opcion("background.line.opacity", valor: [a number from 0 to 1], inicial: `1`)[The opacity of the border.]
#opcion("background.line.width", valor: [a length], inicial: `0.75pt`)[
  The width of the border.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, background: (line: false))
  #goban(b, background: (line: (
    color: red, opacity: 0.5)))
  #goban(b, background: (line: (
    width: 1.5pt)))
  ```
]

#opcion("background.rounded-corners", valor: [a length or `(outer: ..., inner: ...)`], inicial: `(outer: 0pt, inner: 0pt)`)[
  The radius of the corners of the background: `outer`, that of the corners of the board, and `inner`, that of the ones seen on a partial board. A single length goes to both.

  ```ejemplo
  #goban-set(size: 5, partial: "A1:C3")
  #let b = board(stones(black: "B1, C2", white: "A3"))

  #goban(b, background: (
    rounded-corners: 10pt))
  #goban(b, background: (
    rounded-corners: (outer: 8pt, inner: 2pt)))
  ```
]

#opcion("background.sep", valor: [a length], inicial: `0.825em`)[
  The distance between the grid and the border.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, background: (sep: 0.625em))
  #goban(b, background: (sep: 1.5em))
  ```
]

#opcion("background.shadow", valor: [`true`, `false` or a dictionary])[
  A shadow under the board.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, background: (shadow: true))
  #goban(b, background: (shadow: (
    on: true, color: blue, opacity: 0.3,
    angle: 45deg, offset: 4pt)))
  ```
]

#opcion("background.shadow.angle", valor: [an angle], inicial: `-45deg`)[Where the shadow falls: with `0deg`, to the right; with `-45deg`, down and to the right.]
#opcion("background.shadow.offset", valor: [a length], inicial: `1.5pt`)[The distance between the board and its shadow.]
#opcion("background.shadow.opacity", valor: [a number from 0 to 1], inicial: `0.5`)[The opacity of the shadow.]
#opcion("background.shadow.color", valor: [a color], inicial: `black`)[The color of the shadow.]

== Partial board <parcial>

Often the whole board is not needed, only part of it. `partial` defines it with two opposite corners of a rectangle, in any order: `"A1:D3"` is the same as `"D3:A1"`, and as `"A3:D1"`.

#opcion("partial", valor: [`none`, `"A1:D3"` or `auto`], inicial: `none`)[
  Shows only part of the board: the rectangle with those two intersections as opposite corners. What falls outside is not drawn. With `auto`, the board chooses the part: the one used by the stones, moves, marks, arrows, lines and territories that are drawn, with `partial-margin` more lines. With `none`, the whole board.

  ```ejemplo
  #goban(partial: "A1:D3",
    arrows(("A1", "D3"), color: red))
  #goban(partial: "A9:J6",
    arrows(("A9", "J6"), color: red))
  #goban(partial: "E2:B4",
    arrows(("E2", "B4"), color: red))
  ```
]

#opcion("partial-margin", valor: [a number], inicial: `1`)[
  The lines that `partial: auto` adds around what is drawn. A side two lines or less from the border reaches the border. With nothing drawn, the whole board is seen.

  ```ejemplo
  #goban(size: 19, partial: auto,
    moves("Q16, R14, R16, P17"))
  #goban(size: 19, partial: auto,
    partial-margin: 0,
    stones(black: "J10, K11", white: "K9"))
  ```
]

== The border coordinates <etiquetas>

The labels are the coordinates written on the sides of the board.

#opcion("label.at", valor: [an alignment or an array], inicial: `()`)[
  On which sides the labels go: `top`, `bottom`, `left` and `right`, or an array of them. The columns go at the top and the bottom; the rows, on the sides. With `()`, no labels.

  ```ejemplo
  #goban(size: 12,
    label: (at: (top, bottom, left, right)))
  #goban(partial: "A6:J9", label: (at: top))
  #goban(partial: "B2:E4",
    label: (at: (top, right)))
  ```
]

#opcion("label.text", valor: [a dictionary], inicial: `(:)`)[
  The `text` options of the labels: the font, the size, the color.

  ```ejemplo
  #goban-set(size: 5)

  #goban(label: (at: (bottom, left),
    text: (size: 6pt)))
  #goban(label: (at: (bottom, right),
    text: (weight: "bold", fill: red)))
  ```
]

#opcion("label.sep", valor: [a length], inicial: `0.35cm`)[
  The distance between the labels and the border of the board.

  ```ejemplo
  #goban(size: 5, label: (at: (bottom, left),
    sep: 0.6cm), stones(black: "A1"))
  ```
]

#opcion("label.columns", valor: [`"A"` or a `numbering` pattern], inicial: `"A"`)[
  How the coordinates of the columns are written (at the top and the bottom): with `"A"`, the letters of Go (without the I, except with `use-i`); with another Typst `numbering` pattern, such as `"1"` or `"一"`, numbers.
]

#opcion("label.rows", valor: [`"A"` or a `numbering` pattern], inicial: `"1"`)[The same for the rows (on the sides). The kanji (`"一"`) of the rows are aligned on the side of the board, so that those with two characters do not run into it.]

#opcion("label.columns-direction", valor: [`ltr` or `rtl`], inicial: `ltr`)[
  In which direction the columns are counted: from the left or from the right.

  ```ejemplo
  #goban(size: 5, label: (at: (top, right),
      columns-direction: rtl, rows: "A"),
    stones(black: "B4"))
  ```
]

#opcion("label.rows-direction", valor: [`btt` or `ttb`], inicial: `btt`)[
  In which direction the rows are counted: from the bottom or from the top. These four options change only what is written on the border: the coordinates of the elements (`"C3"`) stay the same. On a partial board, they are counted from the border of the full board.

  ```ejemplo
  #goban(size: 5, label: (at: (top, left),
      columns: "1", rows-direction: ttb),
    stones(black: "C4"))
  ```
]

#opcion("label.style", valor: [`"western"`, `"japanese"` or `"chinese"`])[
  Sets the four previous options according to the custom of each place. `"western"`: columns with letters from the left and rows with numbers from the bottom, as at the start. `"japanese"`: columns with numbers from the right and rows with kanji from the top, as in Japanese books: the top right corner is 1-一. `"chinese"`: columns with numbers from the left and rows with kanji from the top. The kanji need a font that has them.

  ```ejemplo
  #goban(label: (at: (top, right),
      style: "japanese",
      text: (font: "MS Gothic", size: 8pt)),
    stones(black: "G7"))
  ```
]
