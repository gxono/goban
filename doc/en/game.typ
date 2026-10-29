#import "../estilo.typ": *
#import "/lib.typ": *

= The game: captures, notes and territory <juego>

A `goban` can follow the rules of the game: remove the captured stones, note the moves that fall on points already played and count the territory. This is done by the kernel (#pag(<kernel>)), which plays the whole board when drawing it.

== Captures <capturas>

#opcion("captures", valor: [`none`, `"remove"` or `"fade"`], inicial: `none`)[
  The captures. When a move leaves an opposing group without liberties, that group is removed from the board; if it leaves its own group without liberties (a suicide), that group is removed. The stones of `stones` count too; neutral stones and prisoners do not. A move outside a partial board also captures. A move on an occupied point is an error, because it is not possible in a game (except in `sgf-diagrams` and `sgf-problem`, #pag(<diagramas>)). With `none`, there are no captures: the moves are drawn on top of one another.

  ```ejemplo
  #gobanist-set(size: 5, partial: "A1:C3")

  #goban(moves("B1, A1, A2"))
  // 3 captures 2.
  #goban(captures: "remove",
    moves("B1, A1, A2"))
  ```

  With `"remove"`, the captured stones disappear. With `"fade"`, they stay on the board, drawn as prisoners (with the style of `prisoner`, #pag(<prisioneros>)).

  ```ejemplo
  #goban(size: 5, partial: "A1:E3",
    captures: "fade",
    stones(white: "C1, D1",
      black: "B1, C2, D2"),
    moves("E1"))
  ```
]

#opcion("captured-marks", valor: [`"keep"` or `"remove"`], inicial: `"keep"`)[
  What happens to the marks on a stone when it is captured. With `"keep"`, they stay on the empty point. With `"remove"`, they go away with the stone, also with `captures: "fade"`; sequences keep their numbering. The marks on empty points do not change.

  ```ejemplo
  #gobanist-set(size: 5, partial: "A1:C3",
    captures: "remove")

  #goban(
    stones(white: "A1", black: "B1"),
    marks(triangle: "A1"), moves("A2"))
  #goban(captured-marks: "remove",
    stones(white: "A1", black: "B1"),
    marks(triangle: "A1"), moves("A2"))
  ```
]

#funcion("goban-prisoners(player)")[
  How many prisoners the player (`"black"` or `"white"`) has in the last `goban`: the opponent's stones captured by their moves.

  ```ejemplo
  #goban(size: 5, partial: "A1:C3",
    captures: "remove",
    moves("B1, A1, A2"))

  Black: #goban-prisoners("black").
  White: #goban-prisoners("white").
  ```
]

== Moves on points already played <notas>

In numbered diagrams, when a move falls on a point where there was already a move (for example, when taking back a ko), books do not draw it: the point keeps showing the first stone, and below the diagram one notes, for example, "3 at 1".

#opcion("notes", valor: [`true`, `false` or a dictionary])[
  A numbered move on a point where there was already a numbered move of the same `goban` is not drawn: the point keeps showing the first one, even if it was captured, and "N at M" is noted. Only the numbered moves seen on the board count. A pass of a game that would be numbered is noted "N: pass", in order with the other notes; the passes with which the game ends are not noted.

  ```ejemplo
  #goban(size: 5, partial: "A2:E4",
    notes: true,
    stones(black: "B3, C2, C4",
      white: "D2, D4, E3"),
    moves(white: "C3"), moves("D3"),
    moves(white: "C3", from: 3))

  #goban-notes()
  ```
]

#opcion("notes.at", valor: [`auto` or a text], inicial: `auto`)[The text between the two numbers. With `auto`, that of the language (`at` in `texts`, #pag(<idiomas>)).]
#opcion("notes.separator", valor: [a text or content], inicial: `", "`)[The text between the notes.]

#funcion("goban-notes(at: auto, separator: auto)")[
  The notes of the last `goban`, separated by `separator`. Without notes, nothing. With `auto`, `at` and `separator` are those of the `notes` branch.

  ```ejemplo
  #goban(size: 5, partial: "A2:E4",
    notes: true, captures: "remove",
    stones(black: "B3, C2, C4",
      white: "D2, D4, E3"),
    moves(white: "C3"), moves("D3"),
    moves(white: "C3", from: 3), moves("D3"))

  #goban-notes(at: "on", separator: "; ")
  ```
]

== Territory <territorio>

#let end = board(
  stones(black: "A6 |- B5 |- D1 |- E2, C4, E9 -| F4, D5 -| G7 -- D7, H6, H8, J7",
    white: "E8 -| C5, B:E6, A7, B8, D9, J6 |- H5, H2:3, F1 |- C3, C2, D:E4, G4"),
  prisoners(black: "H1 -| J2", white: "A1"))
#definir(end: end)

At the end of the game, the territory can be marked by hand with `marks` (#pag(<marcas>)) or with `territory`, which also counts it. In the examples, `end` is this position, with its prisoners:

```ejemplo
#let end = board(
  stones(black: "A6 |- B5 |- D1 |- E2, C4,
      E9 -| F4, D5 -| G7 -- D7, H6, H8, J7",
    white: "E8 -| C5, B:E6, A7, B8, D9,
      J6 |- H5, H2:3, F1 |- C3, C2, D:E4, G4"),
  prisoners(black: "H1 -| J2", white: "A1"))

#goban(label: (at: (top, left)), resume: end)
```

#funcion("territory(polygon, black: ..., white: ..., neutral: ..., ..options)")[
  Marks as territory the points of the polygon with those vertices (in order, with the coordinate syntax), its border included. It does not mark the points that have a living stone: prisoners count as territory. A single vertex marks one point, and two, a stretch. The player is the key: `territory(black: "A1, A5, B5, B1")`; without a player, the polygon is neutral.

  The territory is drawn at the end of the `goban`. Each point keeps the last `territory` that marked it, with the player and the options of that `territory` (so `territory(neutral: "A1")` after another `territory` makes A1 neutral), and it is neither drawn nor counted if at the end it has a living stone.

  ```ejemplo
  #goban(label: (at: (top, left)),
    resume: end,
    territory(black: "A1, A5, B5, B1"),
    territory(black: "F9, F7, G7, G6, J6, J9"),
    territory(white: "F1, F4, G4, G5, J5, J1"),
    territory(white: "A9, A6, C6, C8, D8, D9"))
  ```

  With `auto` instead of a polygon, it finds the territory by itself: each region of points without living stones belongs to the color that surrounds it. If both colors touch it (dame, seki) or neither does, it is neutral. Prisoners count as dead stones. Without a player, `territory(auto)` marks the territory of both; with `territory(black: auto)`, only that of this player.

  ```ejemplo
  #goban(label: (at: (top, left)),
    resume: end,
    territory(auto, dame: true))
  ```

  `auto` only looks at which color touches each region; it cannot read the position. Therefore:

  - It is for finished games. In an open position, almost the whole board touches both colors and is neutral; with stones of a single color, the whole board is theirs. If a wall has a gap, the territory inside joins the dame and also becomes neutral.
  - It does not know which stones are dead: they have to be placed with `prisoners`. A dead stone placed with `stones` counts as alive, and the region it touches becomes neutral.
  - The eyes of a group in seki count as territory (under Japanese rules they are not counted). They can be made neutral afterwards, with a `territory(neutral: ...)` for each one.
  - Neutral stones occupy their point, but belong to no one: a region that only touches neutral stones is neutral.
  - It finds the regions with the stones on the board where the `territory` is, so it is best placed at the end of the `goban`.
  - With `partial: auto`, the board grows to show all the territory (and the dame, with `dame`).
]

#opcion("territory.draw", valor: [`"marks"`, `"fill"` or `"region"`], inicial: `"marks"`)[
  How the territory is drawn. With `"marks"`, each point carries the territory mark of the player. With `"fill"`, each point is filled under the stones.

  ```ejemplo
  #goban(label: (at: (top, left)),
    resume: end,
    territory(auto, draw: "fill"))
  ```

  With `"region"`, the territory of each color is a single polygon: every cell of the grid with a corner in the territory is painted (dead stones count as territory). Its sides run along the lines of the board, its vertices are always on intersections, and it reaches the border of the board. Two areas that touch at a single corner stay separate. All the `territory`s of a color in the same `goban` (also the `TB` and `TW` territory of a game) make a single region, drawn with the style of the last one. Neutral points are filled one by one, as with `"fill"`. The outline and its vertices can be drawn on top, with `line` and `vertices`, and `goban-region` gives its properties.

  ```ejemplo
  #goban(label: (at: (top, left)),
    resume: end,
    territory(auto, draw: "region"))
  ```

  It is an option of `territory`, and with `gobanist-set(territory: (draw: ...))`, of all of them.
]

#opcion("territory.dame", valor: [`true` or `false`], inicial: `false`)[With `auto`, also marks the neutral points.]

The other options of `territory` (`mark`, `fill`, `line` and `vertices`) change the style of the territory of the player only for that `territory`. The style of each player is in their `territory` branch:

#opcion("players.black.territory.mark", valor: [a shape or a dictionary], inicial: [`"t-circle"`])[
  The mark of each point, with `draw: "marks"`: `"t-circle"` for Black and `"t-square"` for White and the neutral points. With options, a dictionary with the shape in `shape`, like the `mark` of the stones.

  ```ejemplo
  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      mark: "t-square"),
    territory(white: "E1, E5"))
  ```
]

#opcion("players.black.territory.fill", valor: [`true`, `false` or a dictionary])[The fill, with `draw: "fill"` and `draw: "region"`. With `false`, no fill: with `"region"`, only the outline or the vertices remain.]
#opcion("players.black.territory.fill.color", valor: [a color or `none`], inicial: `black`)[The color of the fill: black for Black, `luma(80%)` for White and `luma(50%)` for the neutral points. With `none`, no color.]
#opcion("players.black.territory.fill.opacity", valor: [a number from 0 to 1], inicial: `0.35`)[
  The opacity of the fill: `0.35` for Black and the neutral points, `0.7` for White.

  ```ejemplo
  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      draw: "fill",
      fill: (color: blue, opacity: 0.5)),
    territory(white: "E1, E5", draw: "fill"))
  ```
]

#opcion("players.black.territory.fill.pattern", valor: [`none` or a `tiling`], inicial: `none`)[
  A pattern over the color of the fill, like `stone.fill.pattern` (#pag(<piedras>)). With `fill.color: none`, only the pattern remains.

  ```ejemplo
  #let stripes(a, b) = tiling(size: (3pt, 3pt),
    line(start: (0pt, a), end: (3pt, b),
      stroke: 0.4pt))

  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      draw: "fill", fill: (color: none,
        pattern: stripes(3pt, 0pt))),
    territory(white: "E1:5", draw: "region",
      fill: (color: none,
        pattern: stripes(0pt, 3pt))))
  ```
]

#opcion("players.black.territory.line", valor: [`true`, `false` or a dictionary])[
  The outline of the region, with `draw: "region"`.

  ```ejemplo
  #goban(label: (at: (top, left)),
    resume: end,
    territory(black: auto, draw: "region",
      line: true, vertices: true),
    territory(white: auto, draw: "region",
      line: (on: true, color: red)))
  ```
]

#opcion("players.black.territory.line.color", valor: [a color], inicial: `black`)[The color of the outline: black for Black and `luma(40%)` for White.]
#opcion("players.black.territory.line.width", valor: [a length], inicial: `1.2pt`)[The width of the outline.]
#opcion("players.black.territory.line.opacity", valor: [a number from 0 to 1], inicial: `1`)[The opacity of the outline and of the vertices.]
#opcion("players.black.territory.line.above", valor: [`true` or `false`], inicial: `true`)[
  With `true`, the outline and the vertices are drawn above the stones and the marks; with `false`, below the stones, together with the fill.

  ```ejemplo
  #let outline = (on: true, color: red,
    width: 2pt, opacity: 0.7)

  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      draw: "region", fill: false,
      line: outline))
  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      draw: "region", fill: false,
      line: outline + (above: false)))
  ```
]

#opcion("players.black.territory.vertices", valor: [`true`, `false` or a dictionary])[Dots on the vertices of the outline, with `draw: "region"`, on the same layer as the outline.]
#opcion("players.black.territory.vertices.radius", valor: [a length], inicial: `2pt`)[The radius of the dots.]
#opcion("players.black.territory.vertices.color", valor: [`auto` or a color], inicial: `auto`)[
  The color of the dots. With `auto`, that of the outline.

  ```ejemplo
  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      draw: "region", vertices: (on: true,
        radius: 3pt, color: red)))
  ```
]

== Score

#funcion("goban-score(player, komi: auto)")[
  The score of the player (`"black"` or `"white"`) in the last `goban`, with Japanese rules: the points of their territory, plus the dead stones of the opponent in it, plus the stones they captured (with `captures`), plus the komi for White. A point marked twice counts once. With `"neutral"`, the number of neutral points marked. With `auto`, the komi is that of `score.komi`.

  ```ejemplo
  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(auto))

  Black: #goban-score("black").
  White: #goban-score("white", komi: 6.5).
  ```
]

#opcion("score.komi", valor: [a number], inicial: `0`)[The komi that `goban-score` adds to White: `gobanist-set(score: (komi: 6.5))`.]

#funcion("goban-region(player, property, n: none)")[
  A property of the region (`draw: "region"`) of the player (`"black"` or `"white"`) in the last `goban`, as text. The properties are those of the whole outline, even if the board is partial. Without a region, the numbers are 0. The properties are:

  - `"polygons"`: the number of outlines, outer ones and holes.
  - `"outlines"`: the number of outer outlines, one for each separate area.
  - `"holes"`: the number of holes.
  - `"vertices"`: the number of vertices of all the outlines.
  - `"area"`: the number of painted cells.
  - `"perimeter"`: the length of all the outlines, in cells.
  - `"polygon"`, with `n`: the vertices of outline `n` (from 1), as coordinates separated by commas (`"A1, D1, D4, A4"`). Empty if there are not that many outlines.

  Each outline starts at its lowest vertex and, among those, at the leftmost one. Outer outlines run counterclockwise and holes, clockwise. The outlines are ordered by that first vertex, from bottom to top.

  ```ejemplo
  #goban(label: (at: (top, left)),
    stones(white: "D4:F6"),
    territory(black: "B2, B8, H8, H2",
      draw: "region", line: true))

  Outlines: #goban-region("black", "polygons")
  (#goban-region("black", "holes") hole).
  Cells: #goban-region("black", "area").
  The hole:
  #goban-region("black", "polygon", n: 2).
  ```
]

`goban-prisoners`, `goban-notes`, `goban-score` and `goban-region` speak of the last board drawn: that of a `goban` or the last diagram of `sgf-diagrams`, `sgf-problem` or `goban-layout`. Views (`goban-view`) do not count. They return content: what they say is known when drawing.
