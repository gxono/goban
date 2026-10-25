#import "../estilo.typ": *
#import "/lib.typ": *

= Layout of the diagrams <disposicion>

The diagrams of `sgf-diagrams` and `sgf-problem` are laid out according to the `layout` branch, and `goban-layout` lays out single boards and those diagrams together. Without a grid (`columns: auto`), the diagrams go in the paragraph, side by side, and move to the next line when they do not fit. With a number of columns, they go in a grid of columns of the same width: each row is a separate line (the page can break between rows), the boards of a row are aligned at the top and an incomplete row leaves its last columns empty. With `fit`, the boards are also scaled to fill the width of their column.

#funcion("goban-layout(..boards, ..options)")[
  Lays out, in the order in which they come, boards made with `board(...)`, games (`sgf-read`, `sgf`) and the diagrams of `sgf-diagrams(...)` and `sgf-problem(...)`. The options are those of the `layout` branch; the `layout` options of the `sgf-diagrams` and `sgf-problem` inside are not used. With `fit`, each single board fills its column, and the diagrams of an `sgf-diagrams` or an `sgf-problem` use the scale of the first one. A `goban(...)` is already drawn, so inside it is an error: `board(...)` goes there.

  ```ejemplo-abajo
  #goban-layout(columns: 4, fit: true,
    board(size: 5, stones(black: "C3")),
    board(size: 5, stones(white: "C3")),
    sgf-diagrams(game, step: 5))
  ```
]

```ejemplo-abajo
#sgf-diagrams(game, step: 2, to: 6,
  layout: (columns: 3, fit: true))
```

#opcion("layout", valor: [a dictionary])[The options of the layout: with `goban-set(layout: ...)`, for the whole document; in `goban-layout`, for that layout; with `diagrams.layout` and `problems.layout`, for those of `sgf-diagrams` and `sgf-problem`, on top of those of `layout`.]

#opcion("layout.columns", valor: [`auto` or a number], inicial: `auto`)[The number of columns of the grid. With `auto`, the diagrams go in the paragraph, without a grid.]

#opcion("layout.width", valor: [a length, a fraction of the width or `auto`], inicial: `100%`)[
  The width of the grid. If it is less than that of the line, the grid is centered. Each column measures what is left after subtracting the `column-sep`s from `width`, shared among the columns; a narrower board lies in its column according to `align`, so between two boards there is more space than `column-sep`.

  With `auto`, the grid adjusts to the diagrams: the columns have the width of the widest diagram (with its caption, which is broken as without a grid, #pag(<diagramas>)) and between two boards of the same width there is exactly `column-sep`. The grid measures that times the number of columns (or of diagrams, if there are fewer) and is centered in the line. `fit` does not work with `width: auto`: it is an error.

  ```ejemplo-abajo
  #goban-layout(columns: 2, width: auto,
    column-sep: 0em, row-sep: 0em,
    board(partial: "A9:E5", scale: 0.9,
      stones(black: "C7")),
    board(partial: "E9:J5", scale: 0.9,
      stones(white: "G7")),
    board(partial: "A1:E5", scale: 0.9,
      stones(black: "C3")),
    board(partial: "E1:J5", scale: 0.9,
      stones(white: "G3")))
  ```
]

#opcion("layout.column-sep", valor: [a length], inicial: `1em`)[The space between the columns.]
#opcion("layout.row-sep", valor: [a length], inicial: `1em`)[The space between the rows.]

#opcion("layout.fit", valor: [`true` or `false`], inicial: `false`)[Scales each board so that it fills the width of its column; it replaces the `scale` of the board. The lines do not change width. In `sgf-diagrams` and `sgf-problem`, every board uses the scale that fills the column with the first one, so the stones have the same size in all of them; if with that scale a board does not fit in the column (a problem wider than the first one, for example), only that board is shrunk to fill it. Only with `columns`, and not with `width: auto`. Without an available width (a layout measured with `measure` without `width`), the grid takes the width of the diagrams, without `fit`.]

#opcion("layout.align", valor: [`left`, `center` or `right`], inicial: `center`)[
  Where each diagram goes within its column, with its caption and its notes. The comments always go according to `comments.align`.

  ```ejemplo-abajo
  #sgf-diagrams(game, step: 2, to: 6,
    layout: (columns: 2, width: 60%,
      column-sep: 3em, row-sep: 2em,
      align: left))
  ```
]

#opcion("layout.per-page", valor: [`none` or a number], inicial: `none`)[
  Every so many diagrams, a new page starts: with `per-page: 1`, one diagram per page. In the grid, a half-filled row is drawn before the break; the number should be a multiple of `columns`. With `none`, there are no breaks. In `sgf-problem` with `statement: "alone"`, the statement counts as a diagram. With several page columns (Typst's `columns`, or `columns` in `page`), the break moves to the next column.

  ```codigo
  #sgf-diagrams(lee, step: 50, layout: (columns: 2, fit: true, per-page: 4))
  ```
]
