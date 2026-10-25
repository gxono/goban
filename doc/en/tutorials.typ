#import "../estilo.typ": *
#import "/lib.typ": *

= Kāru's boards <tutoriales>

== The first game <tut-primera>

Kāru is writing an article for their students and decides to try goban. The first thing they want to show is a short game played in class. It is saved in an SGF file, `game.sgf`: the format in which almost every Go program and server saves games.

#align(center, goban(captures: "remove", label: (at: (top, left)), games.game))

`sgf-read` reads the file and returns the game as a value, which Kāru saves with `let` to use it many times. Everything that is drawn goes in a `goban`, and so does the game: inside it, its main line is drawn. The board takes the size of the file.

```ejemplo
#let game = sgf-read(path("game.sgf"))

#goban(game)
```

The moves are numbered, as in books. But with move 7 Black captured the white stone 2, which is still on the board: goban draws what it is asked to, without applying the rules. With the option `captures`, the `goban` removes the captured stones (#pag(<capturas>)). The options of the board are named, next to what is drawn.

```ejemplo
#goban(captures: "remove", game)
```

To comment on the game in the text, Kāru stops it at move 7 with `to`: `sgf(game, ...)` is the same game with other options. The file has a comment for that move, and `sgf-comment` writes it.

```ejemplo
#goban(captures: "remove", sgf(game, to: 7))

Move 7: #sgf-comment(game, 7)
```

This game is 9×9; a 19×19 one is read the same way, and the board takes its size. Kāru will do so with the game on #pag(<tut-partida>), where they will also see how to draw a long game in a series of diagrams.

== A position by hand <tut-posicion>

For the introduction of the article, Kāru wants a position of their own, which is not in any file. It has to be drawn stone by stone.

#align(center, goban(profile: "pgfgo", label: (at: (top, left)),
  stones(black: "B2, E2, J2, C3, D3, G3, H3, C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6, H6, B5, J5, B4, E4, J4, J3, H2")))

Kāru starts with the empty board. `goban` takes care of the size of the board, its color, its coordinates and everything drawn on it.

```ejemplo
#goban()
```

The board is 9×9, just what is needed, but the coordinates on the borders are missing. The options of each part of the board are grouped in branches: `grid`, the grid; `background`, the border and the fill, and `label`, the coordinates (#pag(<tablero>)). Inside `label`, `at` says on which sides they go: `top`, `bottom`, `left` and `right`, Typst's alignments. Kāru wants them at the top and on the left.

```ejemplo
#goban(label: (at: (top, left)))
```

The columns go from H to J: as is customary in Go, goban skips the I, both in the coordinates and in the labels. If it is ever needed, the option `use-i` (#pag(<use-i>)) brings it back.

Now, the stones. `stones` takes the intersections, such as `"D8"`, and the player is the key: `black` or `white`. Without a player, the stone is neutral.

```ejemplo
#goban(label: (at: (top, left)),
  stones(black: "D8, F8, E7, H7"))
```

A single string holds all the stones of a player, separated by commas, and the same `stones` can hold those of both. Strictly speaking, `black` and `white` are not colors but players: each stone takes the style of its own (#pag(<jugadores>)).

```ejemplo
#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

The style is missing. In the catalog (#pag(<catalogo>)), Kāru finds one they like: the `pgfgo` profile. They apply it with `goban-set(profile: "pgfgo")` (#pag(<perfiles>)), and from there on it holds for every board that follows.

```ejemplo
#goban-set(profile: "pgfgo")

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

The lists in this tutorial are long, and Kāru's patience is short. In the last tutorial (#pag(<tut-abreviar>)) they learn to write them shorter.

== Moves <tut-jugadas>

To explain how a fight began, Kāru wants to show the stones in the order in which they were played. With `stones` they would have to separate those of each player and would lose the order. That is what `moves` is for (#pag(<jugadas>)): it plays the intersections in the order in which they are written, alternates the colors and numbers the moves.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  moves("F7, E6, G3, D6"))
```

The fight began with a black stone at F7, which Kāru places with `stones`. They will not comment on the moves that follow: with `numbers: false`, they are drawn without numbers. With `white` as the key, the sequence starts with White: in `moves`, the player only says who plays first.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones(black: "F7"),
  moves(numbers: false, white: "E6, G3, D6, F5,
    E7, E2, F8, E6, D8, D3, G7, C5, C6, D5,
    B5, G5, B4, B2, H6, C3, J3, J2, J5, H3"))
```

They do comment on the last moves, so these go with numbers. The numbering and the turn carry on from one `moves` to the next, even if the previous moves have no numbers, and `from` chooses the number to carry on from.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  moves(numbers: false, white: "E6, G3, D6, F5,
    E7, E2, F8, E6, D8, D3, G7, C5, C6, D5,
    B5, G5, B4, B2, H6, C3, J3, J2, J5, H3"),
  moves("F6, E5, J4, G6", from: 26),
  moves("H2"))
```

`H2` goes in another `moves` and, without saying so, is white and numbered 30: the previous move, `G6`, was Black's 29.

== Partial board and marks <tut-parcial>

For an exercise in the article, Kāru wants to show only part of the board, with two signs: a circle on the stone in atari and a "!" on the key point.

#align(center, goban(partial: "B2:E4", background: (line: false),
  stones(black: "C2, B3, C4", white: "D4, E3, D2"),
  stones(white: "C3", mark: (shape: "circle", line: (color: red))),
  marks(custom: "D3", content: [!])))

They start, as always, with the stones.

```ejemplo
#goban(stones(black: "C2, B3, C4",
  white: "D4, E3, D2, C3"))
```

The option `partial` says which part of the board to show: two opposite corners of the rectangle, separated by a colon, such as `"B2:E4"` (#pag(<parcial>)).

```ejemplo
#goban(partial: "B2:E4",
  stones(black: "C2, B3, C4",
    white: "D4, E3, D2, C3"))
```

If Kāru does not want to look for the corners, with `partial: auto` the board chooses the part: the one used by what is drawn, with one more line around it. A side two lines or less from the border reaches the border, like the bottom and the left ones here.

```ejemplo
#goban(partial: auto,
  stones(black: "C2, B3, C4",
    white: "D4, E3, D2, C3"))
```

Kāru prefers the tight crop, so they go on with `"B2:E4"`. On a partial board, the border of the board is too much: they remove it with `line: false` in the `background`.

```ejemplo
#goban(partial: "B2:E4",
  background: (line: false),
  stones(black: "C2, B3, C4",
    white: "D4, E3, D2, C3"))
```

The marks are placed with `marks`, with the shape as the key; there are many (#pag(<marcas>)). Kāru needs only two: `circle`, the circle, and `custom`, which places any content (`content`), such as "!". A mark can also go in the options of the stone, with `mark`.

```ejemplo
#goban(partial: "B2:E4",
  background: (line: false),
  stones(black: "C2, B3, C4",
    white: "D4, E3, D2"),
  stones(white: "C3", mark: "circle"),
  marks(custom: "D3", content: [!]))
```

So that the circle stands out, Kāru paints it red, with the mark's `line.color`. With options, the mark is a dictionary, and the shape goes in `shape`.

```ejemplo
#goban(partial: "B2:E4",
  background: (line: false),
  stones(black: "C2, B3, C4",
    white: "D4, E3, D2"),
  stones(white: "C3", mark: (shape: "circle",
    line: (color: red))),
  marks(custom: "D3", content: [!]))
```

== Explaining a fight: arrows, letters and views <tut-pelea>

In the second part of the article, Kāru wants to explain a fight. They need to point out the possible moves with letters, show where each group runs and, in the text, name the stones without making the reader look for them in the diagram.

#align(center, goban(partial: "A1:G7", label: (at: (top, left)),
  stones(black: "C3, D3, E4, C5", white: "D4, D5, E5, F3"),
  marks(dim: "F3", triangle: "D5"), marks(custom: "E3", content: [A]), marks(custom: "C4", content: [B]),
  arrows(("C5", "C7"), shorten: 4pt), arrows(("E4", "G5"), color: red.darken(20%), bend: 30deg, shorten: 4pt),
  lines(("A6", "G6"), dash: "dashed")))

They start, as always, with the stones. To save space, they show only the corner with `partial`.

```ejemplo
#goban(partial: "A1:G7",
  label: (at: (top, left)),
  stones(black: "C3, D3, E4, C5",
    white: "D4, D5, E5, F3"))
```

The candidate moves are marked with letters, with `custom`, which takes any content. The `triangle` mark highlights the stone the text talks about, and `dim` dims the white stone at F3, which no longer matters. The same `marks` can hold several shapes; two `custom`s with different content go in two `marks`.

```ejemplo
#goban(partial: "A1:G7",
  label: (at: (top, left)),
  stones(black: "C3, D3, E4, C5",
    white: "D4, D5, E5, F3"),
  marks(dim: "F3", triangle: "D5"),
  marks(custom: "E3", content: [A]),
  marks(custom: "C4", content: [B]))
```

To show where the groups run, Kāru uses `arrows`, which joins two intersections (#pag(<flechas>)). The arrow is drawn with a halo the color of the board, so that it is not confused with the grid. With `bend`, it is an arc; with `shorten`, it does not cover the stones at its ends.

```ejemplo
#goban(partial: "A1:G7",
  label: (at: (top, left)),
  stones(black: "C3, D3, E4, C5",
    white: "D4, D5, E5, F3"),
  arrows(("C5", "C7"), shorten: 4pt),
  arrows(("E4", "G5"), color: red.darken(20%),
    bend: 30deg, shorten: 4pt))
```

`lines` is like `arrows`, but without a tip, and it takes the same stroke options, such as `dash`.

```ejemplo
#goban(partial: "A1:G7",
  label: (at: (top, left)),
  stones(black: "C3, D3, E4, C5",
    white: "D4, D5, E5, F3"),
  lines(("A6", "G6"), dash: "dashed"))
```

Now, the text. Kāru wants to write "the black stone at E4" and show it right there. For that they save the board as a value, with `board`, which takes the same as `goban` but draws nothing. To draw it, the board goes first in a `goban`, which adds its options to it, such as the visible part. And `goban-view` shows part of that board in the middle of the paragraph, as it was at the end (#pag(<vistas>)): a point or a rectangle.

```ejemplo
#let fight = board(
  stones(black: "C3, D3, E4, C5",
    white: "D4, D5, E5, F3"),
  marks(triangle: "D5"),
  marks(custom: "E3", content: [A]))

#goban(fight, partial: "A1:G7")
```

#let fight = board(stones(black: "C3, D3, E4, C5", white: "D4, D5, E5, F3"), marks(triangle: "D5"),
  marks(custom: "E3", content: [A]))

```codigo
The black stone #goban-view(fight, "E4") is cut off from its friends.
If it plays at A, it connects: #goban-view(fight, "C3:E5").
Without marks: #goban-view(fight, "C3:E5", marks: false).
```

The black stone #goban-view(fight, "E4") is cut off from its friends. If it plays at A, it connects: #goban-view(fight, "C3:E5"). Without marks: #goban-view(fight, "C3:E5", marks: false).

The view has the style of the board, but `view.goban` can change it: Kāru prefers to remove the background in every view of the article.

```codigo
#goban-set(view: (goban: (background: false)))

The black stone #goban-view(fight, "E4") is cut off from its friends.
If it plays at A, it connects: #goban-view(fight, "C3:E5").
```

#aislado[
  #goban-set(view: (goban: (background: false)))
  The black stone #goban-view(fight, "E4") is cut off from its friends. If it plays at A, it connects: #goban-view(fight, "C3:E5").
]

Since the board is a value, the view can go before the diagram that draws it: `fight` is known from the `let`, not from the `goban`.

== A ko: captures and notes <tut-ko>

In the first tutorial, `captures` removed a captured stone from a game in SGF. To explain a ko, Kāru needs the same with moves written by hand: to place them in order and have goban remove the captured stones.

#align(center, {
  goban(size: 7, captures: "remove", notes: true, stones(black: "B3, C2, C4", white: "C3, D2, D4, E3"),
    moves("D3, G6, G5, C3, A6, A5, D3"))
  parbreak()
  goban-notes()
})

Black takes the ko at D3 (1), White threatens elsewhere (2), Black answers (3) and White takes back (4). As it is, the moves are drawn on top of one another and no stone leaves the board.

```ejemplo
#goban(size: 7,
  stones(black: "B3, C2, C4",
    white: "C3, D2, D4, E3"),
  moves("D3, G6, G5, C3"))
```

With `captures: "remove"` (#pag(<capturas>)), the `goban` keeps count of the liberties and removes each group left without them. The white stone at C3 disappears with move 1, and black 1, with move 4. `goban-prisoners` says how many stones each player captured.

```ejemplo
#goban(size: 7, captures: "remove",
  stones(black: "B3, C2, C4",
    white: "C3, D2, D4, E3"),
  moves("D3, G6, G5, C3"))

Black captured
#goban-prisoners("black"), White
#goban-prisoners("white").
```

If the captured stones must still be seen, `captures: "fade"` leaves them as prisoners.

```ejemplo
#goban(size: 7, captures: "fade",
  stones(black: "B3, C2, C4",
    white: "C3, D2, D4, E3"),
  moves("D3, G6, G5, C3"))
```

The ko goes on: Black threatens (5), White answers (6) and Black takes back at D3 (7), where 1 had already been played. In books, that move is not drawn: below the diagram one writes "7 at 1". That is what the option `notes` does (#pag(<notas>)), and `goban-notes` writes the notes.

```ejemplo
#goban(size: 7, captures: "remove",
  notes: true,
  stones(black: "B3, C2, C4",
    white: "C3, D2, D4, E3"),
  moves("D3, G6, G5, C3, A6, A5, D3"))

#goban-notes().
```

== A whole game <tut-partida>

The article also comments on a long game: the first one between Lee Sedol and AlphaGo, from 2016, saved in `lee.sgf`. As in the first tutorial (#pag(<tut-primera>)), there is no need to write its 186 moves: goban reads them from the file (#pag(<sgf>)).

The first thing is the data of the game, which `sgf-info` takes from the root of the file.

```codigo
#let lee = sgf-read(path("lee.sgf"))

#sgf-info(lee, "PB") (Black) against #sgf-info(lee, "PW") (White),
#sgf-info(lee, "EV"), #sgf-info(lee, "RO"), #sgf-info(lee, "DT").
Result: #sgf-info(lee, "RE").
```

#let lee = games.lee
#sgf-info(lee, "PB") (Black) against #sgf-info(lee, "PW") (White), #sgf-info(lee, "EV"), #sgf-info(lee, "RO"), #sgf-info(lee, "DT"). Result: #sgf-info(lee, "RE").

`sgf-info` writes the result as it is in the file; later on, `sgf-diagrams` writes it in words.

The game is 19×19, and the board takes that size. With `to`, Kāru shows it up to move 30, and with `scale`, they shrink the board.

```ejemplo
#goban(captures: "remove", scale: 0.6,
  sgf(lee, to: 30))
```

To comment on a stretch, Kāru numbers only the moves from 21 on with `from`: the previous ones are drawn without numbers.

```ejemplo
#goban(captures: "remove", scale: 0.6,
  sgf(lee, from: 21, to: 30))
```

Then Kāru wants the whole game, as in books: a diagram every 50 moves, each one with its caption and its "N at M" notes, and the result at the end. That is what `sgf-diagrams` does, which goes outside `goban`. With `layout`, the diagrams go in a two-column grid, and with `fit` they are scaled to fill them (#pag(<disposicion>)). Here only the last two are shown, with `from`.

```ejemplo-abajo
#sgf-diagrams(lee, step: 50, from: 101,
  layout: (columns: 2, fit: true))
```

The caption and the result are in English because the document is in English (`text.lang`, #pag(<idiomas>)). Some books restart the numbering in each diagram; with `restart`, each diagram, from the second on, numbers from 1.

```ejemplo-abajo
#sgf-diagrams(lee, step: 50, from: 51, to: 150,
  restart: true, goban: (label: (at: (top, left))),
  layout: (columns: 2, fit: true))
```

== Variations: going on from a board <tut-variantes>

In the comments, Kāru often shows what would have happened with another move. Copying the position in each diagram is tedious and error-prone: if a stone changes, it has to be changed in all of them. In the fight, Kāru saved a board as a value, with `board`. With `resume`, another board starts with that one, as it was left: the numbering and the turn carry on from there (#pag(<memoria>)).

```ejemplo
#goban-set(size: 5, partial: "A1:E4")

#let base = board(
  stones(black: "B2, C3, D2",
    white: "B3, C4, D3"))

#goban(base)
#goban(resume: base, moves(black: "C2, E3"))
#goban(resume: base, moves(black: "E3, C2"))
```

A variation can also be a value, and one can go on from it: a `board` with `resume` has what it brought plus its own. By default, `resume` brings only the stones; `numbers: true` also brings the numbers.

```ejemplo
#goban-set(size: 5, partial: "A1:E4")

#let base = board(
  stones(black: "B2, C3, D2",
    white: "B3, C4, D3"))
#let variation = board(resume: base,
  moves(black: "E3, C2"))

#goban(resume: variation)
#goban(resume: (board: variation,
  numbers: true), moves("E4"))
```

A saved board also serves to compare styles. Before choosing the profile of their article, Kāru draws the same board with several profiles from the catalog (#pag(<catalogo>)). To put them side by side, with the same width, they use `goban-layout` (#pag(<disposicion>)), which lays out boards made with `board`. Each one is `styles` with another profile: a board that goes first in `board` is that same board, with what is added to it.

```ejemplo-abajo
#let styles = board(size: 5,
  stones(black: "B2, C3, D2", white: "B3, C4, D3"),
  marks(circle: "C2"))
#let styled(p) = board(styles, profile: p)

#goban-layout(columns: 4, fit: true,
  styled("pgfgo"), styled("pgfgosmooth"),
  styled("wain"), styled("simple"))
```

== The end of the game: territory <tut-territorio>

#let final = board(
  stones(black: "A5, A6, B1, B2, B3, B4, B5, C1, C4, D1, D2, D5, D7, E2, E5, E7, E9, F4, F5, F6, F7, F8, F9, G5, G6, G7, H6, H8, J7",
    white: "A7, B6, B8, C2, C3, C5, C6, C7, C8, D3, D4, D6, D8, D9, E3, E4, E6, E8, F1, F2, F3, G4, H2, H3, H5, J5, J6"))
#definir(final: final)

#align(center, goban(final, profile: "pgfgo", label: (at: (top, left)),
  prisoners(black: "H1, J1, J2", white: "A1"),
  marks(t-circle: "A1, A2, A3, A4, G8, G9, H9, J9, J8, H7", player: "black"),
  marks(t-square: "A9, B9, C9, A8, B7, H4, J4, J3, J2, J1, H1, G1, G2, G3", player: "white"),
  marks(t-square: "E1", player: "neutral")))

To finish the article, Kāru wants to show how a game is counted. They start from the final position. Since it has many stones and they will draw it several times, they save it with `board`, like the variations of the previous tutorial, and the boards that follow take it first, without repeating the coordinates.

```ejemplo
#goban-set(profile: "pgfgo")

#let final = board(stones(
  black: "A5, A6, B1, B2, B3, B4, B5, C1, C4,
    D1, D2, D5, D7, E2, E5, E7, E9, F4, F5,
    F6, F7, F8, F9, G5, G6, G7, H6, H8, J7",
  white: "A7, B6, B8, C2, C3, C5, C6, C7, C8,
    D3, D4, D6, D8, D9, E3, E4, E6, E8, F1,
    F2, F3, G4, H2, H3, H5, J5, J6"))

#goban(final, label: (at: (top, left)))
```

Next come the prisoners: the dead stones, which are removed when counting. They are drawn with `prisoners`, which takes the same as `stones` (#pag(<prisioneros>)). Kāru also saves this board, with another name.

```ejemplo
#goban-set(profile: "pgfgo")

#let final2 = board(final,
  prisoners(black: "H1, J1, J2",
    white: "A1"))

#goban(final2, label: (at: (top, left)))
```

#let final2 = board(final, prisoners(black: "H1, J1, J2", white: "A1"))
#definir(final: final, final2: final2)

Now, the territory. One way is to mark each point with `t-square` or `t-circle`. These marks take as their fill that of the stones of their player, and as their border, that of the grid. On an empty point, a mark is neutral unless it says its player, with `player`.

```ejemplo
#goban-set(profile: "pgfgo")

#goban(final2, label: (at: (top, left)),
  marks(player: "black",
    t-circle: "A1, A2, A3, A4, G8, G9, H9,
      J9, J8, H7"),
  marks(player: "white",
    t-square: "A9, B9, C9, A8, B7, H4, J4,
      J3, J2, J1, H1, G1, G2, G3"),
  marks(t-square: "E1"))
```

Another way is `territory` (#pag(<territorio>)). With a polygon, it marks the points of that region that have no living stone; with `auto`, it finds the territory of each player by itself. `goban-score` writes the score.

```ejemplo
#goban-set(profile: "pgfgo")

#goban(final2, label: (at: (top, left)),
  territory(auto, dame: true))

Black: #goban-score("black").
White: #goban-score("white", komi: 6.5).
```

For the article, Kāru prefers the territory to look like a patch of color and not point by point. With `draw: "region"`, the territory of each color is a single polygon, whose sides run along the lines of the board.

```ejemplo
#goban-set(profile: "pgfgo")

#goban(final2, label: (at: (top, left)),
  territory(auto, draw: "region"))
```

== A problem book <tut-problemas>

For their students, Kāru prepares a book of life-and-death problems. Problems are usually saved in SGF too: the initial position, who plays and a tree with each variation of the solution, right or wrong, with its comments. `sgf-problem` draws all that: first the statement and then one diagram per variation. If the file does not say which part of the board to show, the part the problem uses is shown, as with `partial: auto`.

```ejemplo-abajo
#let problem = sgf-read(path("problem.sgf"))

#sgf-problem(problem, title: "Problem 1")
```

In a book, the solutions do not go next to the statement. Kāru puts the statements in the first part, with `solutions: false`, and the solutions at the end, with `statement: false`.

```ejemplo-abajo
#sgf-problem(problem, title: "Problem 1",
  solutions: false)
// ... at the end of the book:
#sgf-problem(problem, statement: false,
  layout: (columns: 4, fit: true))
```

Some problems are not in any file, and Kāru draws them by hand, with the same part of the board that `sgf-problem` shows. Here they write the part, `"A16:F19"`: with `partial: auto`, each board would show only its own, and they would not match. So that they have the same size as the others, Kāru puts them together with those of `sgf-problem` in the same `goban-layout`, which arranges in a grid all the boards it receives.

```ejemplo-abajo
#goban-layout(columns: 3, fit: true,
  sgf-problem(problem, title: "Problem 1",
    solutions: false),
  board(size: 19, partial: "A16:F19",
    stones(black: "A16, B16, C16, D17, E18, E19",
      white: "A17, B17, C17, D18, D19")),
  board(size: 19, partial: "A16:F19",
    stones(black: "A17, B17, C17, D18, D19",
      white: "A18, B18, C18, C19")))
```

== A wooden board: a profile with images <tut-madera>

#let shells = range(1, 6).map(n => path("../img/pgfgo-shell-white-" + str(n) + ".png"))
#let wood-tutorial = (
  background: (fill: (image: path("../img/pgfgo-board.jpg"))),
  stone: (shadow: (on: true, offset: 0.75pt, angle: -45deg)),
  players: (
    black: (stone: (image: path("../img/pgfgo-shell-black.png"))),
    white: (stone: (image: (file: shells, rotate: (-15deg, 15deg)))),
  ),
)
#definir(shells: range(1, 6).map(n => path("../img/pgfgo-shell-white-" + str(n) + ".png")))

For the cover of the book, Kāru wants a board that looks like a real one, since the budget does not stretch to a kaya one: wood, stones with volume and white stones with grain. The profiles of the catalog draw the stones as circles; for this, images are needed (PNG, JPEG, GIF, WebP, SVG or PDF). Kāru copies to their project, in the `img` folder, the ones used by the `shell` profile, which are in the `images` folder of the package: a photo of wood, `pgfgo-board.jpg`, a black slate stone, `pgfgo-shell-black.png`, and five white shell stones, `pgfgo-shell-white-1.png` to `pgfgo-shell-white-5.png`.

#align(center, goban(profile: wood-tutorial, label: (at: (top, left)),
  stones(black: "B2, E2, J2, C3, D3, G3, H3, C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6, H6, B5, J5, B4, E4, J4, J3, H2")))

They start from the first board of the article. The wood goes in the background of the board, with `background.fill.image` (#pag(<tablero>)). An image is a file: a `path`, relative to the document that names it (or its `bytes`). By default, the image covers the whole board, cropped if needed; with `fit`, it can be stretched or repeated in tiles.

```ejemplo
#goban-set(background: (fill: (
  image: path("img/pgfgo-board.jpg"))))

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

The stones of a player are drawn with an image through `stone.image` (#pag(<piedras-imagen>)), in the options of that player. The image takes the place of the circle: neither the fill nor the border are drawn. In an image branch, what is not a dictionary is the file.

```ejemplo
#goban-set(
  background: (fill: (
    image: path("img/pgfgo-board.jpg"))),
  players: (
    black: (stone: (image:
      path("img/pgfgo-shell-black.png"))),
    white: (stone: (image:
      path("img/pgfgo-shell-white-1.png")))))

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

The black stones look good, but the white ones are all the same, and on a real board each shell stone has its own grain. With several files in `file`, each stone uses one, chosen by its place: a stone on a point always shows the same image, in every diagram.

```ejemplo
#let shells = range(1, 6).map(n => path(
  "img/pgfgo-shell-white-" + str(n) + ".png"))

#goban-set(
  background: (fill: (
    image: path("img/pgfgo-board.jpg"))),
  players: (
    black: (stone: (image:
      path("img/pgfgo-shell-black.png"))),
    white: (stone: (image: shells))))

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

For the stones to look as if they rest on the wood, a shadow is missing. `shadow` draws it with the shape of the image (if the image has transparency, like these PNGs). Since it is the same for the three players, it goes in `stone`, at the first level: it is `players: (all: (stone: ...))`.

```ejemplo
#goban-set(
  background: (fill: (
    image: path("img/pgfgo-board.jpg"))),
  stone: (shadow: (on: true, offset: 0.75pt,
    angle: -45deg)),
  players: (
    black: (stone: (image:
      path("img/pgfgo-shell-black.png"))),
    white: (stone: (image: shells))))

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

With five images, a repeated one can still be seen. `rotate` turns each stone by a different angle, also chosen by its place. These stones have the light at the top left, so Kāru turns them only a little, between −15 and 15 degrees; the shadow turns with the image, but it still falls to the same side.

```ejemplo
#goban-set(
  background: (fill: (
    image: path("img/pgfgo-board.jpg"))),
  stone: (shadow: (on: true, offset: 0.75pt,
    angle: -45deg)),
  players: (
    black: (stone: (image:
      path("img/pgfgo-shell-black.png"))),
    white: (stone: (image: (file: shells,
      rotate: (-15deg, 15deg))))))

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

Kāru is going to use this style in the whole book, and perhaps in other documents. Instead of repeating the `goban-set`, they save it as a profile (#pag(<perfiles>)): a profile is a dictionary of options, like those of `goban-set`, and it is used with the option `profile`. They put it in a file of its own, `wood.typ`, to import it from any document.

```codigo
// wood.typ
#let shells = range(1, 6).map(n => path("img/pgfgo-shell-white-" + str(n) + ".png"))
#let wood = (
  background: (fill: (image: path("img/pgfgo-board.jpg"))),
  stone: (shadow: (on: true, offset: 0.75pt, angle: -45deg)),
  players: (
    black: (stone: (image: path("img/pgfgo-shell-black.png"))),
    white: (stone: (image: (file: shells, rotate: (-15deg, 15deg)))),
  ),
)

// The book:
#import "wood.typ": wood
#goban-set(profile: wood)
```

Before setting its own, `profile` brings the style back to the initial one, so the profile looks the same in any document. An almost identical profile, with a soft shadow and without the border of the board, comes with goban: `shell` (#pag(<catalogo>)); with `profile: "shell"` there is nothing to copy. There is also `yunzi`, with matte stones.

A profile holds for everything goban draws, also for the diagrams of an SGF file. This is the game between Lee Sedol and AlphaGo on wood, with a diagram every 50 moves and the numbering restarted in each one.

```codigo
#goban-set(profile: wood)

#sgf-diagrams(lee, step: 50, restart: true, layout: (columns: 2, fit: true))
```

#aislado[
  #goban-set(profile: wood-tutorial)
  #sgf-diagrams(lee, step: 50, restart: true, layout: (columns: 2, fit: true))
]

== Slides <tut-diapositivas>

Kāru also teaches with slides. Typst does not make animated PDFs, but a `goban` works on a Touying or Polylux slide as anywhere else, and `sgf` with `to` lets them show the game move by move, one slide per move, with its comment beside it.

```codigo
#import "@preview/touying:0.6.1": *
#import themes.simple: *
#import "@preview/goban:0.1.0": *

#show: simple-theme
#let game = sgf-read(path("game.sgf"))

#for k in range(1, 11) [
  == A short game
  #grid(columns: (1fr, 1fr), gutter: 1em,
    goban(captures: "remove", scale: 1.5, sgf(game, to: k)),
    text(size: 0.8em, sgf-comment(game, k)))
]
```

To go over the whole game, on the other hand, the diagrams of Lee Sedol and AlphaGo from the article (#pag(<tut-partida>)) are enough, one per slide. With `layout: (per-page: 1)`, `sgf-diagrams` puts each diagram on its own page, with its caption (#pag(<disposicion>)).

```codigo
#sgf-diagrams(lee, step: 50, goban: (scale: 0.6), layout: (per-page: 1))
```

The slides are another document, but Kāru does not want to copy the boards of the article. Boards are values: they save them in a module, `boards.typ`, and import them in the article and in the slides, where they draw them, show them with `goban-view` or go on from them with `resume`.

```codigo
// boards.typ
#import "@preview/goban:0.1.0": *
#let fight = board(stones(black: "C3, D3, E4, C5", white: "D4, D5, E5, F3"),
  marks(triangle: "D5"), marks(custom: "E3", content: [A]))

// In the slides:
#import "boards.typ": fight
== If Black connects
#goban(fight, partial: auto, moves("E3"))
```

== A joseki dictionary <tut-josekis>

For another lesson, Kāru wants to explain the answers to the low approach to the 4-4 point. The known opening sequences in a corner, the _josekis_, are usually saved in an SGF file shaped like a dictionary: a tree with a branch for each possible move, comments on the ones that matter and letters on the moves that can follow. Kāru puts together a small one, `joseki.sgf`.

First, the position: the first two moves, with the letters of the answers. The board is 19×19, but everything happens in a corner; with `partial: auto` (#pag(<tut-parcial>)), the `goban` shows only the part used by what it draws, the letters included.

```ejemplo
#let josekis = sgf-read(path("joseki.sgf"))

#goban(partial: auto, sgf(josekis, to: 2))
```

For the answers, Kāru chooses the line with `variation`. In a dictionary there are so many branches that it is easier to give the moves of the line, from the first one, than to look for its number: `variation: "Q16, R14"` (#pag(<sgf>)). With `variations`, `sgf-diagrams` also draws, each in its own diagram, the commented variations that depart from that line, and with `from: 3`, only those born at move 3 or later: the answers, and not the 3-3 invasion, which is another move 2. With `partial: auto`, every diagram shows the same part of the board.

```ejemplo-abajo
#sgf-diagrams(josekis, variation: "Q16, R14",
  variations: (on: true, from: 3),
  partial: auto, comments: true,
  layout: (columns: 3, fit: true))
```

The first diagram is the chosen line, to the end. The moves of each variation are numbered from 1, and the caption says at which move it departs. In a large dictionary, each move brings letters on the moves that can follow; with `marks: false`, the diagrams do not draw them.

== Other languages <tut-idiomas>

A colleague of Kāru's wants to translate the book into French. The texts written by goban (the captions, the result, the "N at M" notes and the annotations of the comments) follow the language of the text, `text.lang`, also if it changes inside the document: with `set text(lang: "fr")` they translate themselves (#pag(<idiomas>)).

```ejemplo-abajo
#set text(lang: "fr")

#sgf-diagrams(game, step: 5,
  layout: (columns: 2))
#sgf-problem(problem, solutions: false)
```

The comment of the problem, "Black to kill.", is not translated: it is written that way in the file. Each text of the package can also be changed with its own option, in any language: for example, the word in the caption of the diagrams, with `diagrams.title`; or the texts of a language, with `texts`.

```codigo
#goban-set(diagrams: (title: "Figure"))
#goban-set(texts: (en: (diagram: "Figure")))
```

== Writing less: the coordinate syntax <tut-abreviar>

In all the tutorials, Kāru wrote the stones one by one. When there are many, goban lets you abbreviate the lists of `stones`, `marks` and `prisoners` (#pag(<coordenadas>)). The most useful forms are the stretches of a row or of a column: `C:G5` is row 5, from C to G, and `J3:5` is column J, from 3 to 5. With them, the first board of the article becomes:

```ejemplo
#goban-set(profile: "pgfgo")

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C:G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, B4, E4, H2, J3:5"))
```

For larger groups, there are paths that turn at right angles. `A6 |- B5` goes from A6 down to row 5 and then right to B5: these are the stones A6, A5 and B5. `E9 -| F4` goes right first and then down. `D5 -- D7` is a straight line. Paths can be chained, and with them the final position of the territory tutorial (#pag(<tut-territorio>)) fits in two lines:

```ejemplo
#goban-set(profile: "pgfgo")

#goban(label: (at: (top, left)),
  stones(
    black: "A6|-B5|-D1|-E2, C4, E9-|F4,
      D5-|G7--D7, H6, H8, J7",
    white: "E8-|C5, B:E6, A7, B8, D9, J6|-H5,
      H2:3, F1|-C3, C2, D:E4, G4"),
  prisoners(black: "H1-|J2", white: "A1"),
  territory(auto, dame: true))
```

Between two intersections that are neither in the same row nor in the same column, `--` is a slanted line: `D5 -- F7` are D5, E6 and F7. Those stones touch only at the corners; for a connected chain, `-|-` fills each step, first sideways and then up or down: `D4 -|- F6` are D4, E4, E5, F5 and F6 (`|-|` starts with the column). With that, a ladder (_shicho_) is written with its ends:

```ejemplo
#goban(label: (at: (top, left)),
  stones(white: "D4 -|- F6 -- G6",
    black: "C4, D3, D5 -- F7, E3 -- G5"),
  // White runs. Not for long.
  arrows(("G6", "J8"), shorten: 4pt))
```

There is more: filled rectangles (`A1:C3`) or only their border (`A1 r C3`), whole columns and rows (`D`, `4`), the whole board (`*`) and, after a `;`, stones removed from the list. It is all in the reference, on #pag(<coordenadas>).
