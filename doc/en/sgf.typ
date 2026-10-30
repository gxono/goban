#import "../estilo.typ": *
#import "/lib.typ": *

= Games in SGF <sgf>

SGF is the format used by almost every Go program and server to save games. gobanist reads them with the kernel (#pag(<kernel>)): a game on a board, its data and comments, the whole game in diagrams and problems with their solutions.

In the examples, `game` is `game.sgf`, a short 9×9 game:

#codigo(read("../game.sgf").trim(), lang: none)

and `variations` is `variations.sgf`, a 7×7 game with two branchings, marks and `MN[10]` on the fourth move of the main line:

#codigo(read("../variations.sgf").trim(), lang: none)

== Reading a game <sgf-leer>

#funcion("sgf-read(source, game: 1, charset: auto, origin: top + left, transpose: false, syntax: auto)")[
  Reads an SGF game. `source` is a file (`path("game.sgf")`, relative to the document that names it), its content (`bytes`) or the SGF text (a string). It returns the game as a value, which is saved with `let` and used everywhere: on a board, in `sgf-info`, `sgf-comment`, `sgf-diagrams`, `sgf-problem`, `goban-layout` and `goban-view`.

  On a board, the game is an element, like `stones` or `moves`: it draws the main line, and the board takes the size of its `SZ` (another `size` is an error).

  ```ejemplo
  #let game = sgf-read(path("game.sgf"))

  #goban(label: (at: (top, left)), game)
  ```
]

#opcion("game", valor: [a number], inicial: `1`)[
  In `sgf-read`: an SGF file can hold several games (a collection); `game` chooses which one is read. One that does not exist is an error.

  ```codigo
  #let third = sgf-read(path("collection.sgf"), game: 3)
  ```
]

#opcion("charset", valor: [`auto` or a name], inicial: `auto`)[
  In `sgf-read`: the encoding of the file, if it is not UTF-8. With `auto`, the one the file gives with `CA` or, if it gives none, Latin-1 (the SGF default). Latin-1 (and windows-1252), GBK (GB2312, GB18030), Big5, Shift_JIS, EUC-JP and EUC-KR are read; the names ignore case and punctuation (`"shift-jis"` and `"EUC_KR"` also work). A file that is valid UTF-8 is always read as UTF-8, even if `CA` says otherwise; one in UTF-16 (with the byte order mark at the start) is read too. Another encoding is an error: the file has to be converted to UTF-8.

  Many files from Asian servers do not state their encoding: `sgf-read(path("qipu.sgf"), charset: "GBK")`. To write their comments, a font with those characters is needed.
]

#opcion("origin", valor: [a corner], inicial: `top + left`)[
  In `sgf-read`: the corner of the board where the point `aa` of the file goes (`top + left`, `top + right`, `bottom + left` or `bottom + right`). Everything read from the file follows it, also `partial: auto`; the coordinates written in the options (`variation: "Q4, R6"`) are those of the board.
]

#opcion("transpose", valor: [`true` or `false`], inicial: `false`)[
  In `sgf-read`: the first letter of each point of the file is the row, and the size is turned. With `origin`, the eight symmetries of the board.

  ```ejemplo
  #let file = path("joseki.sgf")
  #gobanist-set(partial: auto)
  #goban-layout(columns: 4, fit: true,
    sgf-read(file, origin: top + right),
    sgf-read(file, origin: bottom + right,
      transpose: true),
    sgf-read(file, transpose: true),
    sgf-read(file, origin: bottom + left))
  ```
]

#opcion("syntax", valor: [`auto`, `"sgf"` or `"sensei"`], inicial: `auto`)[
  In `sgf-read`: the syntax of the file. `"sensei"` are the diagrams of Sensei's Library (#pag(<sgf-sensei>)); with `auto`, those read that way are the files without SGF nodes (`(;`) that have lines starting with `$$`. Every syntax is read as an SGF game: every function works the same with any of them.
]

== Sensei's Library diagrams <sgf-sensei>

Sensei's Library and forums such as L19 write diagrams as text, with lines starting with `$$`. Such a file is read as a collection: each block of consecutive `$$` lines is a game (`game: 2` is the second diagram), and what is between the blocks is not read. The `[go]` and `[/go]` tags of L19 can stay.

```ejemplo
#let nadare = sgf-read("$$Bc Nadare
$$  ---------------
$$ | . . . . . . .
$$ | . . . . . . .
$$ | . . . 1 6 . .
$$ | . . 5 4 . . .
$$ | . . 3 2 a . .
$$ | . . . . . . .")

#sgf-diagrams(nadare, goban: (scale: 0.5))
```

The first line is the header: `$$`, `B` or `W` (who plays move 1; if missing, Black), a board size (`$$B13`; if missing, 19), `m` and the number of move 1 (`$$Wm67`) and the title. The `c` of the coordinates is accepted but not used: the coordinates are those of `label`. Each diagram is read like this:

- The title is the name of the game (`GN`) and that of its figure (`FG`): `sgf-diagrams` puts it in the caption.
- `X` and `O` are initial stones (`AB` and `AW`). `B`, `#`, `Y` and `Z` are black stones with a circle, square, triangle and cross; `W`, `@`, `Q` and `P`, white ones. `C`, `S`, `T` and `M` are those marks on empty points, and the lowercase letters are letters.
- The numbers (`1` to `9`, and `0` is 10) are moves, in order: the odd ones are of whoever plays move 1. If a number is missing ("5 at 1"), the following moves keep theirs (`MN`).
- The marks, the letters and the lines `{AR C14 C11}` (arrow) and `{LN 5:6 5:9}` (line) go on the last move. Their points are of the board (`C14`) or of the diagram (`5:6`, column and row from the top left).
- The edges (`---`, `|`, `+`) say where the diagram is on the board. Without a size, two opposite edges give that side of the board. Without edges, the diagram goes in the middle. What is drawn is the view of the game (`VW`): `sgf-diagrams` only shows that part.
- `.` and `,` are empty points (the star points are put by `hoshi`). `_` is not part of the board: it is its `blank` (#pag(<blank>)). Links (`[a|page]`) are not read.

A line that is not understood, a diagram bigger than the size of the header and an arrow or line that goes off the board are errors.

== A game on a board <sgf-tablero>

A game on a board draws the initial stones (`AB` and `AW`), as with `stones`, and the moves of the main line, as with `moves`. Passes count for the numbering, but are not drawn (with `notes`, they are noted: "N: pass", #pag(<notas>)). The stones added (`AB`, `AW`) or removed (`AE`) by the nodes after the first move are applied together with the previous move; removing stones needs `captures`, and without `captures` it is an error. At the end, the numbering and the turn are ready to go on with the game with `moves`. The game also reads `PL` (who plays next) and `MN` (the number of a move).

```ejemplo
// Without captures, 2 is not removed.
#goban(game)
#goban(captures: "remove", game)
```

#funcion("sgf(game, ..options)")[
  The same game with other options, those of the `sgf` branch, which are added to those it already had: `sgf(game, to: 7)`. Also, `forget` (#pag(<memoria>)). With `gobanist-set(sgf: ...)`, the options hold for every game.
]

#opcion("sgf.from", valor: [a number], inicial: `1`)[
  The first numbered move. The previous ones are drawn without a number.

  ```ejemplo
  #goban(captures: "remove",
    sgf(game, from: 7))
  ```
]

#opcion("sgf.to", valor: [`auto` or a number], inicial: `auto`)[
  The last move played; the following ones are not drawn. With `auto`, up to the last one.

  ```ejemplo
  #goban(captures: "remove",
    sgf(game, to: 6),
    // Carries on with 7 (Black), elsewhere.
    moves("F5"))
  ```
]

`from` and `to` count the moves of the file. The number shown can be another: `MN` changes it (the following moves carry on from there), and so does `restart`.

#opcion("sgf.variation", valor: [`none`, numbers or moves], inicial: `none`)[
  The line that is drawn. With `none`, the main one. With numbers, at each branching the indicated variation is taken, in order (1 is the main one): `(2, 1)` takes the second at the first branching and the first at the second. With a text, the moves of the line from the first one, separated by commas or spaces: `"R16, P17, Q15"`; at each branching, the variation that plays the next one is taken, and a pass is written `pass`. In both cases, when the list runs out, the first variation is followed. A variation or a move that does not exist is an error.

  ```ejemplo
  #goban(sgf(variations, variation: (2,)))
  #goban(sgf(variations, variation: (1, 2)))
  #goban(sgf(variations, variation: "C5, C3"))
  ```
]

#opcion("sgf.marks", valor: [`true` or `false`], inicial: `true`)[
  Draws the marks of the file (`TR`, `SQ`, `CR`, `MA`, `SL` and the labels of `LB`), the arrows (`AR`) and the lines (`LN`) of the last node shown, and dims the points of `DD` (which stay dimmed until the next `DD`). Each mark takes the player of the stone on that point, and replaces the number of the move; labels do not cover a number, so they are not drawn on a numbered stone. The territory of the file (`TB` and `TW`) is drawn like that of `territory` (#pag(<territorio>)) and counts for `goban-score`.

  ```ejemplo
  #goban(sgf(variations, to: 2))
  #goban(sgf(variations, to: 2, marks: false))
  ```
]

#opcion("sgf.numbers", valor: [`auto`, `true` or `false`], inicial: `auto`)[
  With `false`, the moves are drawn without a number. With `auto`, what the file asks for with `PM`: with `PM[0]`, they are not numbered.

  ```ejemplo
  #goban(sgf(variations, numbers: false))
  ```
]

#opcion("sgf.step", valor: [a number or an array], inicial: `100`)[The size of the stretches in which `restart` restarts the numbering. With an array, each number is the size of a stretch, and the last one is repeated: with `(50, 100)`, the first stretch has 50 moves and the others 100.]

#opcion("sgf.restart", valor: [`auto`, `true`, `false` or a dictionary], inicial: `auto`)[
  From the second stretch of `step` moves on, each one numbers from 1 (or from `restart.from`), as in books: with `step: 100, restart: true`, move 101 is shown as 1. The first stretch keeps the numbers of the game. With `false`, the moves carry the numbers of the game (with `MN`). With `auto`, what the file asks for with `PM`: with `PM[2]`, the numbering restarts every 100 moves, regardless of `step`.

  ```ejemplo
  #goban(variations)
  #goban(sgf(variations, step: 3,
    restart: true))
  #goban(sgf(variations, step: 3,
    restart: (on: true, from: 0)))
  ```
]

#opcion("sgf.restart.from", valor: [a number], inicial: `1`)[The number of the first move of each stretch, from the second on. With `step: 99` and `restart: (on: true, from: 0)`, move 100 is shown as 0, move 101 as 1, and so on.]

#opcion("sgf.last-mark", valor: [`none`, a shape or a dictionary], inicial: `none`)[
  Marks the last move shown, with a shape (`"circle"`) or with the options of a mark (`(shape: "triangle", line: (color: red))`). A pass is not marked, nor is a point the file already marks or a move with a number (the number already tells which is the last one): in practice, it serves with `numbers: false`.

  ```ejemplo
  #goban(sgf(variations, numbers: false,
    last-mark: "circle"))
  ```
]

#opcion("sgf.letters", valor: [`none`, `"children"`, `"siblings"` or `auto`], inicial: `none`)[
  Marks with letters the variations of the last move shown: with `"children"`, the moves that can follow; with `"siblings"`, the alternatives to that move (the letter replaces its number). With `auto`, what the file asks for with `ST`. They are marked only if there is more than one.

  ```ejemplo
  #goban(sgf(variations, to: 1, marks: false,
    letters: "children"))
  ```
]

#opcion("sgf.view", valor: [`false`, `true` or a number], inicial: `false`)[
  If the file has a view (`VW`), shows only that part of the board, like `partial`. The view can change during the game: a `VW` holds from the move of its node (or from the next one, if the node has no move) until the next `VW`, and `VW[]` shows the whole board again. With `true`, the view that covers those of moves `from` to `to`; with a number, that of that move (with 0, that of the start). A `partial` of the board wins over it.

  ```ejemplo
  // views: VW[aa:ee] at the start, VW[] at
  // move 3 and VW[ff:ii] at move 5.
  #goban(sgf(views, to: 2, view: true))
  #goban(sgf(views, view: 5))
  ```
]

== Data and comments <sgf-datos>

#funcion("sgf-info(game, property, move: 0, variation: none)")[
  A property of the root of the game, as text: `"PB"` and `"PW"` (the players), `"RE"` (the result), `"KM"` (the komi), `"DT"` (the date), etc. With `move`, that of that move: that of its node and of the nodes without a move that follow it (with 0, that of the root and of the nodes before the first move), in the line of `variation` (like `sgf.variation`). If it is not there, `""`. If it has several values, they are separated by commas.

  ```ejemplo-abajo
  #sgf-info(variations, "PB") (Black) against
  #sgf-info(variations, "PW") (White),
  komi #sgf-info(variations, "KM").
  Result: #sgf-info(variations, "RE").
  ```

  The value is that of the file, with the escaped characters already resolved and in the encoding of `CA`: `"RE"` stays as `B+R`, not in words (`sgf-diagrams` writes it in words). Any property works. Those of the game data, according to the SGF format, are:

  #{
    set text(size: 0.9em)
    table(columns: (auto, 1fr, auto), stroke: none, inset: (x: 4pt, y: 2pt),
      table.hline(),
      table.header([*Property*], [*What it is*], [*Example*]),
      table.hline(stroke: 0.5pt),
      [`PB`, `PW`], [The name of Black and that of White.], [`Lee Sedol`],
      [`BR`, `WR`], [The rank of Black and that of White.], [`9p`],
      [`BT`, `WT`], [The team of Black and that of White.], [],
      [`RE`], [The result: `B+` or `W+` and the points, `R` (resignation), `T` (time) or `F` (forfeit); `0` or `Draw`, a draw; `Void`, no result; `?`, unknown.], [`W+3.5`],
      [`KM`], [The komi.], [`6.5`],
      [`HA`], [The handicap: how many stones.], [`2`],
      [`DT`], [The date, `YYYY-MM-DD` (or several, separated by commas).], [`2016-03-09`],
      [`EV`], [The tournament or event.], [`Meijin`],
      [`RO`], [The round.], [`3 (final)`],
      [`PC`], [The place.], [`Tokyo`],
      [`GN`], [The name of the game.], [],
      [`GC`], [A comment about the game.], [],
      [`ON`], [The opening (fuseki).], [],
      [`RU`], [The rules.], [`Japanese`],
      [`TM`], [The time of each player, in seconds.], [`7200`],
      [`OT`], [The overtime (byo-yomi).], [`5x30 byo-yomi`],
      [`SO`], [The source: a book, a magazine.], [],
      [`AN`], [Who commented on the game.], [],
      [`US`], [Who wrote the file.], [],
      [`CP`], [The copyright.], [],
      [`AP`], [The program that wrote the file.], [`CGoban:3`],
      [`SZ`], [The size of the board (`19`, or `19:13`).], [`19`],
      [`CA`], [The encoding of the file.], [`UTF-8`],
      table.hline(),
    )
  }
]

#funcion("sgf-comment(game, move, variation: none, annotations: true, chat: true)")[
  The comment of a move (0: the one before the first move), in the line of `variation`: the name of the node (`N`), in bold; the annotations of the move (`TE`, `BM`, `DO`, `IT`) and of the position (`GB`, `GW`, `DM`, `UC`), with the texts of the language (#pag(<idiomas>)); and the comment (`C`). Values (`V`) and hotspots (`HO`) are not written. `sgf-diagrams` and `sgf-problem` write the comments the same way.

  ```ejemplo-abajo
  Move 7: #sgf-comment(game, 7)

  #sgf-comment(problem, 1, variation: (2,))
  ```
]

#opcion("annotations", valor: [`true` or `false`], inicial: `true`)[
  In `sgf-comment`: with `false`, only the comment, without the name or the annotations.

  ```ejemplo-abajo
  With: #sgf-comment(game, 7) \
  Without: #sgf-comment(game, 7, annotations: false)
  ```
]

#opcion("chat", valor: [`true` or `false`], inicial: `true`)[In `sgf-comment`: with `false`, removes the chat of the servers from the comment: on OGS, everything after the line "`-- chat --`"; on KGS, the lines "`name [rank]: ...`" and, if there is any, also the lines "`name: ...`" of the same comment. If nothing is left, the move has no comment.]

== Diagrams as in books <diagramas>

#funcion("sgf-diagrams(game, ..options)")[
  Draws the game as in books: a diagram every `step` moves (1–50, 51–100, …). Each diagram starts from the real position, with the previous moves without numbers and their captures; the stones captured by the moves of the diagram are not removed (they are removed in the next one). Below each one go its caption and its "N at M" notes (#pag(<notas>)), and below the last one, the result. A move on an occupied point removes the stone that was there, without prisoners, to draw games that are not legal. It goes outside `goban`.

  The options are those of the `diagrams` branch; with `gobanist-set(diagrams: ...)`, they hold for the whole document. Those of `sgf(game, ...)` hold on each board, except those set by each diagram (`from`, `to`, `variation`, `numbers`, `marks`, `last-mark`, `step`, `restart` and `view`), which are an error.

  ```ejemplo-abajo
  #sgf-diagrams(game, step: 5)
  ```
]

#opcion("diagrams.step", valor: [a number or an array], inicial: `50`)[The number of moves of each diagram. With an array, the first diagram has as many moves as the first number says, the second as the second says, and so on; the last one is repeated: with `(5, 10, 3)`, the diagrams have 5, 10, 3, 3, 3, … moves.]
#opcion("diagrams.from", valor: [a number], inicial: `1`)[The first move. The diagrams are the same as without `from`, with the same number: only those with moves from `from` on are drawn, and the first one starts at `from`. With `step: 50` and `from: 120`, the first one is "Diagram 3 (120–150)".]
#opcion("diagrams.to", valor: [`auto` or a number], inicial: `auto`)[The last move. With `auto`, the last one of the game.]
#opcion("diagrams.numbers", valor: [`true` or `false`], inicial: `true`)[With `false`, the moves of each diagram are drawn without a number (the "N at M" notes still use the numbers of the game).]
#opcion("diagrams.last-mark", valor: [`none`, a shape or a dictionary], inicial: `none`)[
  Like `sgf.last-mark`, in each diagram.

  ```ejemplo-abajo
  #sgf-diagrams(game, step: 5, to: 10,
    numbers: false, last-mark: "circle")
  ```
]

#opcion("diagrams.restart", valor: [`auto`, `true`, `false` or a dictionary], inicial: `auto`)[
  Like `sgf.restart`, with one diagram per stretch: from the second diagram on, each one numbers from 1 (or from `restart.from`), as some books do. The first diagram keeps the numbers of the game. With `auto`, what `PM[2]` asks for: every 100 moves, regardless of the diagrams.

  ```ejemplo-abajo
  #sgf-diagrams(game, step: (2, 3), to: 8,
    restart: (on: true, from: 0))
  ```
]

#opcion("diagrams.restart.from", valor: [a number], inicial: `1`)[The number of the first move of each diagram, from the second on.]
#opcion("diagrams.marks", valor: [`true` or `false`], inicial: `true`)[Like `sgf.marks`: each diagram shows the marks, arrows and lines of its last move.]
#opcion("diagrams.notes", valor: [`true` or `false`], inicial: `true`)[Writes below each diagram its notes: "N at M" and the passes, "N: pass".]
#opcion("diagrams.title", valor: [`auto` or a text], inicial: `auto`)[The word of the caption: "Diagram 2 (51–100)". With `auto`, that of the language (`diagram` in `texts`).]
#opcion("diagrams.caption", valor: [a dictionary])[The caption, the notes and the result.]
#opcion("diagrams.caption.text", valor: [a dictionary], inicial: `(size: 0.9em)`)[
  The `text` options of the caption, the notes and the result.

  ```ejemplo-abajo
  #sgf-diagrams(game, from: 6, title: "Figure",
    caption: (text: (style: "italic")),
    goban: (label: (at: (top, left))))
  ```
]

#opcion("diagrams.caption.min-width", valor: [a length], inicial: `8em`)[Outside the grid, a caption wider than its board is broken into the lines it needs at the width of the board or, if the board is narrower, at this measure; then it is narrowed as far as those lines still fit, so that they are even. It is never narrower than its longest word. In the grid, the caption is broken at the width of the cell.]
#opcion("diagrams.goban", valor: [board options], inicial: `(:)`)[The options of each board, on top of the global ones. The boards start with `captures: "remove"` and `notes: true`, and have the size of the game.]
#opcion("diagrams.layout", valor: [layout options], inicial: `(:)`)[How the diagrams are laid out: the options of `layout` (#pag(<disposicion>)), only for these diagrams: `layout: (columns: 3)`.]
#opcion("diagrams.variation", valor: [`none`, numbers or moves], inicial: `none`)[The line that is drawn, like `sgf.variation`.]

#opcion("diagrams.variations", valor: [`true`, `false` or a dictionary])[
  Also draws the variations of the game, each one in its diagram, after the diagram where it is born: "Diagram 1a", "Diagram 1b", … Each variation goes whole, with its moves numbered from 1; the caption says which move it replaces (`variation-title`), and the previous moves are seen without numbers. Its comments and notes are written like those of the other diagrams. The variations are those that depart from the line of `variation` (with `variation`, the main one too).

  ```ejemplo-abajo
  #sgf-diagrams(variations, step: 2, to: 3,
    marks: false,
    variations: (on: true, select: "all"),
    goban: (scale: 0.7))
  ```
]

#opcion("diagrams.variations.select", valor: [`"commented"` or `"all"`], inicial: `"commented"`)[Which ones are drawn: those with some comment (`C`) on their own moves, or all of them.]
#opcion("diagrams.variations.depth", valor: [a number], inicial: `1`)[Down to which depth: with 1, those that depart from the line drawn; with 2, also the variations of those, and so on. Those of a variation go after it, and their caption says which of its moves they replace.]
#opcion("diagrams.variations.from", valor: [a number], inicial: `1`)[Only the variations born at that move or later.]
#opcion("diagrams.variations.paths", valor: [an array of paths], inicial: `()`)[
  Variations that are always drawn, even if `variations` is off, at any depth: each path is like `sgf.variation`, with numbers (`(2,)`, `(2, 3, 1)`) or with moves (`"R16 P17 Q15"`). Trailing 1s do not change the line: `(2, 3, 1)` is `(2, 3)`. A path the game does not have, or that does not depart from the line, is an error.

  ```codigo
  #sgf-diagrams(josekis, variations: (paths: ((2,), "Q16 R14 O16")))
  ```
]

#opcion("diagrams.variation-title", valor: [`auto` or a function], inicial: `auto`)[What goes in parentheses in the caption of a variation: "Diagram 3a (variation at 26)". A function takes the number of the move it replaces: `variation-title: n => [instead of #n]`. With `auto`, the text of the language (`variation-at` in `texts`).]

#opcion("diagrams.figures", valor: [`true` or `false`], inicial: `true`)[If the file marks figures (`FG`), each figure is a diagram, with its name in the caption, instead of one every `step` moves.]
#opcion("diagrams.view", valor: [`true` or `false`], inicial: `true`)[If the file has a view (`VW`), each diagram shows only the one that covers the views of its moves, like `sgf.view`; a variation, that of its line. A `partial` in `goban` wins over it.]
#opcion("diagrams.partial", valor: [`none`, `auto` or `"A1:E5"`], inicial: `none`)[
  With two corners, as in `partial` (`"K10:T19"`), every diagram shows that part, even if the file has a view. With `auto`, where there is no view in the file, every diagram shows the same part of the board: the one used by the lines drawn (that of `variation` and those of `variations`), like `partial: auto`.

  ```codigo
  #sgf-diagrams(josekis, partial: auto, variations: true)
  ```
]

#opcion("diagrams.comments", valor: [`true`, `false` or a dictionary])[
  Writes the comments of the moves of each diagram, like `sgf-comment`, each one with the number of the move.

  ```ejemplo-abajo
  #sgf-diagrams(game, step: 5,
    comments: (on: true, root: true),
    layout: (columns: 2))
  ```
]

#opcion("diagrams.comments.text", valor: [a dictionary], inicial: `(:)`)[The `text` options of the comments, on top of those of `caption.text`.]
#opcion("diagrams.comments.align", valor: [`left`, `center` or `right`], inicial: `left`)[The alignment of the comments in the width of the diagram.]
#opcion("diagrams.comments.justify", valor: [`true` or `false`], inicial: `false`)[Justifies the comments. In a narrow diagram, large spaces are left between the words.]
#opcion("diagrams.comments.root", valor: [`true` or `false`], inicial: `false`)[Also writes the comment of the root (that of the nodes before the first move), without a number, before those of the diagram that starts at move 1.]
#opcion("diagrams.comments.number", valor: [a function], inicial: `n => [#strong(str(n)): ]`)[What goes in front of each comment: a function of the number of the move, the one seen on the board (with `restart`, the restarted one). For example, `n => [Move #n. ]`.]
#opcion("diagrams.comments.separator", valor: [content], inicial: `parbreak()`)[What goes between the comments. With the initial value, each one goes in its own paragraph; with `h(1em)`, they run on.]
#opcion("diagrams.comments.position", valor: [`bottom`, `left`, `right` or `"after"`], inicial: `bottom`)[
  Where the comments go: below the caption; beside the diagram, as in books of commented games; or, with `"after"`, all together after the diagrams, across the full width, each group with the caption of its diagram as a heading. Beside the diagram, they start at the height of the top border of the board; the caption, the notes and the result stay below the board.

  ```ejemplo-abajo
  #sgf-diagrams(game, step: 5,
    comments: (on: true, position: right))
  ```
]

#opcion("diagrams.comments.width", valor: [`auto` or a length], inicial: `auto`)[The width of the comments beside the diagram. With `auto`, what is left: outside the grid, the rest of the line; in the grid, the rest of the cell, and with `fit`, the board takes half of the cell and the comments the other half.]
#opcion("diagrams.comments.sep", valor: [a length], inicial: `1em`)[The space between the diagram and the comments beside it.]
#opcion("diagrams.comments.height", valor: [`none` or a length], inicial: `none`)[
  The maximum height of the comments of a diagram, below or beside it. What does not fit (it is broken between words) goes after the diagrams, as with `"after"`, with the caption of the diagram as a heading.

  ```codigo
  #sgf-diagrams(lee, step: 30, layout: (columns: 2),
    comments: (on: true, height: 6em))
  ```
]

#opcion("diagrams.annotations", valor: [`true` or `false`], inicial: `true`)[With the comments, also writes the name and the annotations of each move.]
#opcion("diagrams.chat", valor: [`true` or `false`], inicial: `true`)[With the comments, like `chat` of `sgf-comment`: with `false`, without the chat of KGS and OGS. A move that had only chat left does not appear.]

#opcion("diagrams.result", valor: [`true`, `false` or a dictionary])[
  Writes below the last diagram, if it reaches the end of the game, the result (`RE`) and, if the file marks the territory (`TB`, `TW`), the score of each player: "Result: Black wins by 0.5 points (Black 6, White 5.5)". The score is counted as with `goban-score`, with the komi of the file (`KM`).
]

#opcion("diagrams.result.title", valor: [`auto` or a text], inicial: `auto`)[The word before the result. With `auto`, that of the language (`result` in `texts`).]
#opcion("diagrams.result.format", valor: [`"text"` or `"raw"`], inicial: `"text"`)[How the result is written: with `"text"`, in words, in the language of the text ("Black wins by resignation"); with `"raw"`, as it is in the file ("B+R"). With `"text"`, `0` or `Draw` (a draw), `Void` (no result), `?` (unknown) and `B+` or `W+` followed by nothing, by the difference, by `R` or `Resign`, by `T` or `Time`, or by `F` or `Forfeit` are understood. Another result is written as it is.]
#opcion("diagrams.result.black", valor: [`auto` or a text], inicial: `auto`)[The name of Black in the score and in the result. With `auto`, that of the language.]
#opcion("diagrams.result.white", valor: [`auto` or a text], inicial: `auto`)[
  The name of White in the score and in the result.

  ```ejemplo-abajo
  #sgf-diagrams(variations,
    result: (title: "Final", format: "raw"))
  #sgf-diagrams(variations,
    result: (black: "Ann", white: "Bob"))
  ```
]

== Problems <problemas>

#funcion("sgf-problem(..problems, ..options)")[
  Draws a problem (tsumego). First, the statement: the initial position with its marks, who plays (`PL`, or the color of the first move) and the comment of the root. Then, a diagram for each line of the tree of the file (each variation of the solution, right or wrong), numbered from 1, with its "N at M" notes and the comments and annotations of its moves, which usually say whether the variation is right. Every diagram shows the same part of the board: the view of the file (`VW`) or, without a view, the one the problem uses. It goes outside `goban`.

  With several games (`sgf-problem(p1, p2, p3)`), all the statements go first, each one with its number (that of the game in its file), and then the solutions of those that have them. That is how a problem sheet is made.

  The options are those of the `problems` branch; with `gobanist-set(problems: ...)`, they hold for the whole document. Those of `sgf(problem, ...)` hold on each board, except those set by the diagram (`from`, `to`, `variation`, `numbers`, `last-mark`, `step`, `restart` and `view`). In the examples, `problem` is `problem.sgf`, a life-and-death problem: the right move and two wrong ones, with their comments.

  ```ejemplo-abajo
  #sgf-problem(problem, title: "Problem 1")
  ```

  ```ejemplo-abajo
  // problems: the three games of problems.sgf.
  #sgf-problem(..problems, comments: false,
    layout: (columns: 4, fit: true))
  ```
]

#opcion("problems.statement", valor: [`true`, `false` or `"alone"`], inicial: `true`)[Draws the statement. With `"alone"`, the statement goes alone in its row, centered, and the variations below.]
#opcion("problems.solutions", valor: [`true` or `false`], inicial: `true`)[
  Draws the variations. With `false`, only the statement remains; the solutions go elsewhere, with `statement: false`.

  ```ejemplo-abajo
  #sgf-problem(problem, solutions: false,
    title: "Problem 2")
  ```
]

#opcion("problems.title", valor: [`auto` or a text], inicial: `auto`)[The start of the caption of the statement: "Problem 1: Black to play". With several games, it is followed by the number of each one; with `auto`, nothing, or with several games, the word of the language (`problem` in `texts`): "Problem 7: Black to play". The solutions also say which problem they belong to: "Problem 7: Variation 1".]
#opcion("problems.to-play", valor: [`auto`, `"black"`, `"white"` or `none`], inicial: `auto`)[Who plays, for the caption of the statement. With `auto`, what `PL` says or, if it is not there, the color of the first move; if neither is there, it is not said. Many collections do not say it in the file: `to-play: "black"`. With `none`, the caption does not say it.]
#opcion("problems.variation-title", valor: [`auto` or a function], inicial: `auto`)[The caption of each solution: a function of its number, `n => [Solution #n]`. With `auto`, "Variation 2", with the word of the language (`variation` in `texts`).]
#opcion("problems.verdict", valor: [`true` or `false`], inicial: `false`)[
  The caption of each solution says whether it is right or wrong ("Variation 2 (wrong)"), with the texts `correct` and `wrong` of the language. It is decided with the annotations of the line: the last `GB` or `GW` (the position is good for Black or for White), according to who plays; if there is none, the first move with `TE` or `BM` (the odd moves belong to the player to play: a `BM` of theirs is a mistake, one of the opponent's is not); if not, the word `RIGHT` in a comment, as in the files of goproblems.com. If there is none of that, it says nothing.

  ```ejemplo-abajo
  #sgf-problem(problem, verdict: true,
    statement: false, comments: false,
    layout: (columns: 4, fit: true))
  ```
]

#opcion("problems.links", valor: [`true` or `false`], inicial: `false`)[
  The caption of the statement is a link to its first solution, and the caption of each solution, a link to the statement, also if they are in another `sgf-problem` (with `solutions: false` and `statement: false`). A link whose target is missing, or is there more than once (a problem drawn twice), is not set.

  ```codigo
  #sgf-problem(problem, links: true, solutions: false)
  // …
  #sgf-problem(problem, links: true, statement: false)
  ```
]

#opcion("problems.view", valor: [`true` or `false`], inicial: `true`)[If the file has a view (`VW`) at the start, every diagram shows that part.]
#opcion("problems.partial", valor: [`auto`, `none` or `"A1:E5"`], inicial: `auto`)[
  With two corners, as in `partial`, every diagram shows that part, even if the file has a view. With `auto`, if the view of the file is not used, every diagram shows the part of the board where there are stones, moves, marks, arrows or lines in some line of the problem, like `partial: auto`. The lines added around are changed with `goban: (partial-margin: ...)`. With `none`, the whole board is seen.

  ```ejemplo-abajo
  #sgf-problem(problem, solutions: false,
    goban: (partial-margin: 3))
  ```
]

#opcion("problems.notes", valor: [`true` or `false`], inicial: `true`)[Writes the "N at M" notes of each variation.]
#opcion("problems.caption", valor: [a dictionary], inicial: `(text: (size: 0.9em), min-width: 8em)`)[
  The captions, the notes and the comments, like `diagrams.caption`.

  ```ejemplo-abajo
  #sgf-problem(problem, statement: "alone",
    comments: false, notes: false,
    caption: (text: (style: "italic")))
  ```
]

#opcion("problems.comments", valor: [`true`, `false` or a dictionary])[The comment of the root below the statement and those of each variation below its diagram, like `diagrams.comments` (without `root`). Here they are on at the start. `text`, `align` and `justify` also hold for the comment of the statement.]
#opcion("problems.annotations", valor: [`true` or `false`], inicial: `true`)[With the comments, also writes the name and the annotations of each move (`TE`, `BM`, …).]
#opcion("problems.chat", valor: [`true` or `false`], inicial: `true`)[With the comments, like `chat` of `sgf-comment`.]
#opcion("problems.goban", valor: [board options], inicial: `(:)`)[The options of each board, like `diagrams.goban`.]
#opcion("problems.layout", valor: [layout options], inicial: `(:)`)[How the statement and the variations are laid out: the options of `layout` (#pag(<disposicion>)), only for these diagrams.]
