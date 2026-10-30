#import "../estilo.typ": *
#import "/lib.typ": *

= Overview <presentacion>

== What gobanist is

gobanist is a Typst package to draw Go boards, positions, games and problems. It is a port of pgf-go, a LaTeX package published two years ago by the same author, with the same ideas and almost all of its options, written with Typst values:

- Games in SGF: a game on one board, series of diagrams as in books, and problems with their solutions.
- The rules of the game, in a WebAssembly kernel: captures, "N at M" notes for kos, territory and score.
- Profiles for the board and the players, which can use images: wood in the background, slate and shell stones.
- Boards as values, to follow a variation from a position or to show part of a board in the middle of a paragraph.
- Marks, arrows and lines, and mark shapes of your own.
- A grid layout to arrange diagrams of the same size.
- The texts of the package in ten languages, and border coordinates in the Western, Japanese or Chinese style.
- A syntax to write many coordinates at once: rows, columns, rectangles, paths and ladders.

The drawing, the coordinates and the options are written in Typst. What playing the game needs (captures, territory, regions, score and reading SGF files) is done by a WebAssembly plugin compiled from Rust code (#pag(<kernel>)), which comes with the package.

== First steps <primeros-pasos>

gobanist is imported like any other package. It needs Typst 0.15 or later.

```codigo
#import "@preview/gobanist:0.2.0": *

#goban(stones(black: "C3, D4", white: "E5"))
```

Everything that is drawn goes in a `goban`: the stones, the moves, the marks, the arrows, the territory or a game read from a file. The options of the board go in the same `goban`, named (`size: 13`), and those of the whole document, in `gobanist-set` (#pag(<configuracion>)).

```ejemplo
#goban(size: 5, stones(black: "C3, D4", white: "B2"))
```

== How to read this manual <como-leer>

The manual has three parts: this overview; the tutorials (#pag(<tutoriales>)), in which Kāru prepares an article, a problem book and some lessons, and learns the package along the way; and the reference, with every function and every option, ordered by object. At the end there are the catalog of profiles and an index of the functions and the options.

It is best to go through the tutorials first, in one go, to get an overall picture of everything, and then the reference, to see everything that can be configured. For something specific:

- *Drawing a game saved in SGF*: the tutorial on #pag(<tut-primera>) and, for the whole game in diagrams, the one on #pag(<tut-partida>). The reference is on #pag(<sgf>).
- *Drawing a position by hand*: the tutorial on #pag(<tut-posicion>), and the stones on #pag(<piedras>). To write fewer coordinates, the tutorial on #pag(<tut-abreviar>) and the complete syntax on #pag(<coordenadas>).
- *Numbering moves*: the tutorial on #pag(<tut-jugadas>), and `moves` on #pag(<jugadas>).
- *Showing only part of the board or marking points*: the tutorial on #pag(<tut-parcial>); `partial` on #pag(<parcial>), and the marks on #pag(<marcas>).
- *Arrows, lines and letters*: the tutorial on #pag(<tut-pelea>), and the reference on #pag(<flechas>).
- *Showing a stone or part of the board inside the text*: the end of the tutorial on #pag(<tut-pelea>), and `goban-view` on #pag(<vistas>).
- *Captures, kos and "N at M" notes*: the tutorial on #pag(<tut-ko>), and the reference on #pag(<juego>).
- *Marking the territory and counting the points*: the tutorial on #pag(<tut-territorio>), and `territory` and `goban-score` on #pag(<territorio>).
- *Going on from a position, for example to show variations*: the tutorial on #pag(<tut-variantes>), and `board` and `resume` on #pag(<memoria>).
- *Josekis from a dictionary in SGF*: the tutorial on #pag(<tut-josekis>), and `variation` and `variations` on #pag(<sgf>).
- *Problems (tsumego) with their solutions*: the tutorial on #pag(<tut-problemas>), and `sgf-problem` on #pag(<problemas>).
- *Laying out several diagrams in a grid*: the tutorials on pp.~#context counter(page).at(<tut-partida>).first() and~#context counter(page).at(<tut-problemas>).first(), and `layout` and `goban-layout` on #pag(<disposicion>).
- *Changing the style of every board*: the end of the tutorial on #pag(<tut-posicion>) and the catalog (#pag(<catalogo>)). To change a detail, `gobanist-set` (#pag(<configuracion>)) and the options of each object; to save a style of your own, the profiles (#pag(<perfiles>)).
- *Using images on the board and on the stones*: the tutorial on #pag(<tut-madera>); the background and the grid on #pag(<tablero>), and the stones on #pag(<piedras-imagen>).
- *Slides*: the tutorial on #pag(<tut-diapositivas>).
- *Writing in another language*: the tutorial on #pag(<tut-idiomas>), and the reference on #pag(<idiomas>).

A general rule: the branches that turn something on or off (the grid, the background, the shadows, …) have the key `on`; `true` and `false` turn them on and off, and a dictionary changes their options without turning them on (#pag(<prender>)).

== For pgf-go users <desde-pgf-go>

The options of gobanist are those of pgf-go, with Typst syntax: a tree of dictionaries instead of a tree of _keys_, and Typst values instead of TikZ ones. The most visible changes:

#table(columns: (1fr, 1fr), stroke: none, inset: (x: 4pt, y: 3pt),
  table.hline(),
  table.header([*pgf-go*], [*gobanist*]),
  table.hline(stroke: 0.5pt),
  [`\begin{goban}[13] ... \end{goban}`], [`#goban(size: 13, ...)`],
  [`\pgfgoset{goban = {...}}`], [`#gobanist-set(...)`],
  [`\stones[b]{C3, D4}`], [`stones(black: "C3, D4")`],
  [`\stone{C3}`, `\stones{C3}`], [`stones("C3")`],
  [`\moves[w]{D2, B3}`], [`moves(white: "D2, B3")`],
  [`\mark[triangle]{C3}`], [`marks(triangle: "C3")`],
  [`\mark[custom = {!}]{D3}`], [`marks(custom: "D3", content: [!])`],
  [`\arrow{B3}{F3}`, `\line{B3}{F3}`], [`arrows(("B3", "F3"))`, `lines(("B3", "F3"))`],
  [`\territory[b]{auto}`], [`territory(black: auto)`],
  [`shine = {true, angle = 45}`], [`shine: (on: true, angle: 45deg)`],
  [`format = Alph`], [`format: "A"` (a `numbering` pattern)],
  [`label = {at = {north, west}}`], [`label: (at: (top, left))`],
  [`name = base`, `resume = base`], [`#let base = board(...)`, `goban(base)`, `resume: base`],
  [`\pgfgoview{base}{C3}`], [`goban-view(base, "C3")`],
  [`\pgfgodefinesgf{game}{game.sgf}`], [`#let game = sgf-read(path("game.sgf"))`],
  [`\pgfgodefinesgf[origin = top right]`], [`sgf-read(..., origin: top + right)`],
  [`\begin{pgfgosgf}{short} ... \end{pgfgosgf}`], [`#let short = sgf-read("(;SZ[9]...)")`],
  [`\sgf[to = 7]{game}`], [`sgf(game, to: 7)`],
  [`\sgfdiagrams`, `\sgfproblem`], [`sgf-diagrams`, `sgf-problem`],
  [`\pgfgomovenotes`, `\pgfgoscore{b}`], [`goban-notes()`, `goban-score("black")`],
  [`pgfgolayout`], [`goban-layout(...)`],
  [`\pgfgodefinemark`], [the `shapes` option],
  [`\pgfgostone[b, number = 5]`], [`goban-stone("black", number: 5)`],
  [`label = {letter case = lower}`], [`label: (columns: "a")`],
  [`layout = {halign = left}`], [`layout: (halign: left)`],
  [`\pgfgodefineprofile{wood}{...}`], [`#let wood = (...)`, `profile: wood`],
  table.hline(),
)

Some things behave differently:

- A mark without a player on a stone takes the player of the stone (in pgf-go it was neutral).
- Typst has no warnings: what pgf-go warned about (a coordinate that cannot be understood or that is outside the board, a game of another size) is an error. A move on an occupied point, with captures, is also an error, except in `sgf-diagrams` and `sgf-problem`.
- The grays are those of xcolor: the gray of gobanist is `luma(50%)`, not Typst's `gray`.
- The board has at least 2×2 lines.
- Images are `path` or `bytes`, not file names.

And some are not ported: `\sgfanimation` (Typst does not make animated PDFs; for slides there are Touying and Polylux, #pag(<tut-diapositivas>)), `export` and `\pgfgoimport` (a board is a value: it is saved in a `.typ` module and imported), drawing with TikZ inside the board, the `go cs` coordinate system, `\pgfgodefinegoban`, `\pgfgodefineplayer` and the partial profiles (`goban profile`, `players profile`): a profile is a dictionary, and its branches are taken.
