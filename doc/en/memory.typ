#import "../estilo.typ": *
#import "/lib.typ": *

= Boards as values and views <memoria>

== Going on from a board

A board can be a value: `board` (#pag(<tablero>)) takes the same as `goban` and draws nothing. It is saved with `let`, and it is used in two ways:

- first in a `goban` or in another `board`: `goban(base, moves("C3"))` is the same board, with everything it has (its options, its marks, its numbers), plus what is added;
- with `resume`: another board starts with that one, as it was at the end, with the captures resolved; it brings only what is asked for (by default, the stones), and the numbering and the turn carry on from there.

`goban-view` shows a part in the middle of the text (#pag(<vistas>)).

```ejemplo
#gobanist-set(size: 5, partial: "B2:D4")

#let board1 = board(stones(black: "C2, D3"),
  moves(white: "B4"))

#goban(resume: board1)
// Carries on with 2 (Black).
#goban(resume: board1, moves("C3"))
#goban(resume: (board: board1,
  numbers: true), moves("C3"))
```

#opcion("resume", valor: [a board or `(board: ..., numbers: ..., marks: ..., territory: ...)`])[
  Starts the board with the board `board`, as it was at the end: with the captures resolved (if that board had `captures`, this one does too, unless it gives its own). The numbering and the turn carry on from there. A board alone, `resume: base`, brings only the stones, without numbers, marks or territory; in a dictionary, `numbers`, `marks` and `territory` ask for the rest.

  The size is that of the `resume` board, unless this one gives its own (`size`, or a game); one set with `gobanist-set` does not count. The other options of that board (`partial`, the coordinates, the style) do not come: they are given on each board.

  A `board` with `resume` has what it brought, as it was drawn, plus its own, and the `resume` board does not change: that is how variations are built.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")

  #let base = board(stones(black: "C2, D3",
    white: "C3"))
  #let variation1 = board(resume: base,
    moves(white: "D2"))
  #let variation2 = board(resume: base,
    moves(white: "B3"))

  #goban(resume: variation1)
  #goban(resume: variation2)
  #goban(resume: (board: variation1,
    numbers: true), moves("B4"))
  ```
]

#opcion("resume.numbers", valor: [`true` or `false`], inicial: `false`)[Also brings the numbers of the moves.]
#opcion("resume.marks", valor: [`true` or `false`], inicial: `false`)[Also brings the marks, the arrows and the lines.]
#opcion("resume.territory", valor: [`true` or `false`], inicial: `false`)[
  Also brings the territory.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")

  #let saved = board(stones(black: "C2:4"),
    moves(white: "D3"), marks(triangle: "B3"),
    territory(black: "B2, B4", draw: "fill"))

  #goban(resume: saved)
  #goban(resume: (board: saved,
    numbers: true, marks: true,
    territory: true))
  ```
]

So that `resume` does not bring a stone, a move, a mark, an arrow, a line or a territory, it is drawn with the option `forget: true` (`stones(white: "C3", forget: true)`, `marks(circle: "A1", forget: true)`, …); with `forget: "number"`, a move comes without its number even if `numbers` is asked for (#pag(<jugadas>)). What is forgotten is still on the board: `goban-view` shows it with `forgotten`.

Since a board is a value, it can be saved in a module and imported in another document: `#import "boards.typ": ko`. That way the same board is used in an article and in its slides (#pag(<tut-diapositivas>)).

== Views in the text <vistas>

#funcion("goban-view(board, part, ..options)")[
  Draws the intersection (`"C3"`) or the rectangle (`"B2:E4"`, written as in `partial`) of a board (a `board(...)` or a game), as it was at the end, with the captures resolved, in the middle of the text. With several parts separated by commas (`"F15, G15, C3:E5"`), one view per part, joined with `view.separator` and `view.last`. By default, everything the board drew in that part is seen (stones, numbers of the moves, marks, arrows, lines and territory), with its style, at the scale of `view.goban` and centered at the height of the lowercase letters. The options are those of the `view` branch.

  ```ejemplo-abajo
  #let board1 = board(size: 5,
    captures: "remove",
    stones(black: "B3, C2, C4",
      white: "D2, D4, E3"),
    moves(white: "C3, D3"))

  The black stone at D3 #goban-view(board1, "D3")
  captures the white one at C3
  #goban-view(board1, "C3"). This is the ko:
  #goban-view(board1, "B2:E4").
  ```

  The view is resolved with the global options of the place where it is, like a `goban`; on top go those of the board and, after them, those of `view.goban`. Since the board is a value, the view can go before or after the diagram that draws it. A view does not change what `goban-prisoners`, `goban-score`, `goban-notes` or `goban-region` say.

  ```ejemplo
  #let board2 = board(size: 5,
    stones(black: "B2, C3"),
    moves(white: "C2, D3"),
    marks(triangle: "C3"))

  #goban-view(board2, "B2:D3")
  #goban-view(board2, "B2:D3",
    marks: false, numbers: false)
  #goban-view(board2, "B2:D3",
    goban: (grid: false))
  #goban-view(board2, "B2:D3",
    goban: (background: false))
  ```
]

#opcion("view", valor: [a dictionary])[The options of the views: in `goban-view`, for that view, and with `gobanist-set(view: ...)`, for all of them.]
#opcion("view.marks", valor: [`true` or `false`], inicial: `true`)[With `false`, without the marks.]
#opcion("view.arrows", valor: [`true` or `false`], inicial: `true`)[With `false`, without the arrows.]
#opcion("view.lines", valor: [`true` or `false`], inicial: `true`)[
  With `false`, without the lines.

  ```ejemplo-abajo
  #let arrowed = board(size: 5,
    stones(black: "B2", white: "D4"),
    arrows(("B2", "D4")), lines(("B4", "D2")),
    marks(triangle: "C3"))

  Without arrows:
  #goban-view(arrowed, "A1:E5", arrows: false).
  Without lines or marks:
  #goban-view(arrowed, "A1:E5", lines: false,
    marks: false).
  ```
]

#opcion("view.numbers", valor: [`true` or `false`], inicial: `true`)[With `false`, without the numbers of the moves.]
#opcion("view.territory", valor: [`true` or `false`], inicial: `true`)[With `false`, without the territory.]
#opcion("view.forgotten", valor: [`true` or `false`], inicial: `false`)[
  Also draws what has `forget`.

  ```ejemplo
  #let board3 = board(size: 5,
    stones(black: "B2, C3"),
    stones(white: "D3", forget: true))

  #goban-view(board3, "B2:D3")
  #goban-view(board3, "B2:D3",
    forgotten: true)
  ```
]

#opcion("view.raise", valor: [`auto` or a length], inicial: `auto`)[
  How high above the baseline of the text the center of the view lies. With `auto`, half the height of the lowercase letters.

  ```ejemplo-abajo
  #let b = board(size: 5, stones(black: "C3"))

  Text #goban-view(b, "C3", raise: 0pt)
  text #goban-view(b, "C3")
  text #goban-view(b, "C3", raise: 0.8em).
  ```
]

#opcion("view.separator", valor: [a text or content], inicial: `", "`)[What goes between the views of several parts.]

#opcion("view.last", valor: [`auto`, a text or content], inicial: `auto`)[
  What goes before the last view, instead of `separator`; with two parts, only this. With `auto`, the text `and` of the language between spaces: " and ". The spaces are part of the text.

  ```ejemplo-abajo
  #let b = board(size: 5,
    stones(black: "B3, C2, C4", white: "C3"))

  The stones #goban-view(b, "B3, C2, C4")
  surround C3.
  #goban-view(b, "B3, C2, C4",
    separator: "; ", last: " or ").
  ```
]

#opcion("view.goban", valor: [board options], inicial: `(scale: 0.8, background: (line: false))`)[
  The options of the board of the view, on top of its own: the style (`profile`, `players`, `stone`, `mark`, `grid`, `background`, `label`, …) and the scale. Initially, the background has no border, even if the board has one; a `profile` brings back the style of its profile, with its border. They cannot be those that change the game or the visible part: `size`, `use-i`, `partial`, `captures`, `captured-marks`, `territory` or `sgf`.

  ```ejemplo
  #let ko = board(size: 5, captures: "remove",
    stones(black: "B3, C2, C4",
      white: "D2, D4, E3"),
    moves(white: "C3, D3"))

  #goban-view(ko, "B2:E4")
  #goban-view(ko, "B2:E4",
    goban: (profile: "simple"))
  #goban-view(ko, "B2:E4",
    goban: (profile: "wain", scale: 1))
  ```
]

== A stone in the text <piedra-texto>

#funcion("goban-stone(player, number: none, mark: none, prisoner: false, ..style)")[
  Draws a single stone in the text, without a board: of `"black"`, `"white"` or, without a player (or with `"neutral"`), neutral. `mark` is a mark on top, as in `stones`; with `number`, the stone is a move with that number; with `prisoner: true`, a prisoner. The other options are those of the style of the stone (`fill`, `line`, `radius`, …). It has the style of the place where it is and, on top, that of the views (`view.goban`, `view.raise`): it has the size and the height of the view of an intersection, without grid or background. It does not change what `goban-prisoners`, `goban-score`, `goban-notes` or `goban-region` say.

  ```ejemplo-abajo
  Black #goban-stone("black"), white
  #goban-stone("white"), neutral #goban-stone().
  #goban-stone("black", mark: "triangle")
  #goban-stone("white", number: 12)
  #goban-stone("black", prisoner: true)
  ```
]
