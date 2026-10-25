#import "../estilo.typ": *
#import "/lib.typ": *
#import "/src/texts.typ": texts

= Settings <configuracion>

== The options

The options of goban form a tree of dictionaries: each object (the background, the grid, the stones of each player, the diagrams of a game, …) is a branch, and its options are its keys. Those of a board go in the `goban`, named, next to what is drawn; those of the whole document, in `goban-set`.

#funcion("goban-set(..options)")[
  Sets options for everything that follows in the document: the boards, the views, the diagrams and the problems. It takes the same options as `goban`, and also the branches of the games (`sgf`, `diagrams`, `problems`), the layout (`layout`), the views (`view`), the texts (`texts`) and the mark shapes (`shapes`). Each `goban-set` is added to the previous ones. Like Typst's `set`, it holds from where it is to the end of the block that contains it.

  ```ejemplo
  #goban-set(
    background: (
      fill: (color: rgb("#dcb35c")),
      line: false),
    grid: (line: (color: white)),
    players: (
      black: (stone: (
        line: (color: fuchsia),
        fill: (color: blue.darken(50%)))),
      white: (
        stone: (line: (color: blue)),
        mark: (line: (color: orange)))))

  #goban(size: 3,
    stones(black: "A1"),
    stones(white: "A2", mark: "triangle"))
  #goban(size: 4,
    stones(black: "A2"),
    stones(white: "B2, A3", mark: "circle"))
  ```
]

The `goban`s that follow inherit these options, and each one can change them with its own: `goban(size: 9, stone: (radius: 4pt), mark: (line: (color: red)), ...)`. The options are resolved when the board is drawn, with the `goban-set`s in effect at that place of the document.

The options are merged branch by branch: a dictionary changes only the keys it gives, and the others stay as they were. `goban-set(background: (fill: (color: red)))` changes the color of the fill, and the border, the opacity and the image stay the same. A key that does not exist is an error. A length on a branch of lengths (`grid.sep`, `background.rounded-corners`) goes to all of its keys: `grid: (sep: 1em)` is `grid: (sep: (x: 1em, y: 1em))`.

=== Turning on and off <prender>

Many branches turn something on or off: the grid, the background, the border and the fill of the stones, their shadows and their shines, etc. They all have the key `on`, and they all follow the same rule:

- `true` turns the branch on: `shine: true`;
- `false` turns it off: `shine: false`;
- a dictionary changes its options without turning it on: `shine: (angle: 45deg)` changes the angle, but the shine stays as it was. To turn it on and change it at once, `shine: (on: true, angle: 45deg)`.

So `goban-set(stone: (shadow: (opacity: 0.3)))` sets the opacity of the shadows of the whole document without turning them on, and each board that wants them turns them on with `stone: (shadow: true)`.

The image branches (`stone.image`, `background.fill.image`, …) have no `on`: the file turns them on. In them, what is not a dictionary is the file: `stone: (image: path("stone.png"))` is `stone: (image: (file: path("stone.png")))`, and `image: none` removes it.

=== Player shortcuts

The options of the stones, the prisoners, the moves and the marks belong to each player (#pag(<jugadores>)). At the first level, they hold for the three at once:

#opcion("stone", valor: [stone options])[It is `players: (all: (stone: ...))`: the style of the stones of the three players (#pag(<piedras>)).]
#opcion("prisoner", valor: [stone options])[It is `players: (all: (prisoner: ...))`: the style of the prisoners of the three players (#pag(<prisioneros>)).]
#opcion("move", valor: [move options])[It is `players: (all: (move: ...))`: the style of the moves of the three players (#pag(<jugadas>)).]
#opcion("mark", valor: [mark options])[It is `players: (all: (mark: ...))`: the style of the marks of the three players (#pag(<marcas>)).]
#opcion("players", valor: [`neutral`, `black`, `white` and `all`])[The options of each player (#pag(<jugadores>)).]

The other first-level branches are in the chapter of each object: the board (`size`, `partial`, `background`, `grid`, `hoshi`, `label`, …, #pag(<tablero>)), the arrows and the lines (`arrow`, `line`, #pag(<flechas>)), the game (`captures`, `notes`, `territory`, `score`, #pag(<juego>)), the games in SGF (`sgf`, `diagrams`, `problems`, #pag(<sgf>)), the layout (`layout`, #pag(<disposicion>)), the views (`view`, #pag(<vistas>)), the profiles (`profile`, #pag(<perfiles>)), the texts (`texts`, #pag(<idiomas>)) and the mark shapes (`shapes`, #pag(<formas-propias>)).

== The kernel <kernel>

goban separates the computations from the drawing. The coordinates, the numbering of the moves and the drawing are written in Typst. What playing the game needs is done by a _kernel_: a WebAssembly plugin, `src/kernel.wasm`, compiled from the Rust code in the `kernel/` folder of the repository. The kernel:

- plays the moves and removes the captured stones (`captures`, #pag(<capturas>));
- finds the territory (`territory(auto)`), builds the regions (`draw: "region"`) and counts the score (#pag(<territorio>));
- reads SGF files and their encodings (#pag(<sgf>));
- makes the opacity and the silhouettes of PNG and JPEG images (#pag(<piedras-imagen>)).

It plays each board in a single call, when the board has captures or territory. It comes compiled with the package: there is nothing to install.

== Languages <idiomas>

Some texts are written by the package itself: the captions of `sgf-diagrams` and `sgf-problem`, the result of the game, the annotations of the comments and the words of the "N at M" and "N: pass" notes. They are in English (`en`), Spanish (`es`), French (`fr`), German (`de`), Portuguese (`pt`), Italian (`it`), Esperanto (`eo`), Japanese (`ja`), Chinese (`zh`) and Korean (`ko`). Japanese, Chinese and Korean need a font with those characters.

The texts are in the language of the text, `text.lang`, and they follow it if it changes inside the document: `set text(lang: "fr")`. In a language without a translation, they are in English.

#opcion("texts", valor: [a dictionary of languages])[
  The texts of each language: `texts: (en: (diagram: "Figure"))`. A new language takes from English what it lacks. The texts with variable parts are functions: `n` is the number of a move, `w` the name of the winner and `p` the difference in points.

  ```ejemplo
  #goban-set(texts: (
    en: (at: "on"),
    la: (pass: "transit"),
  ))

  #goban(size: 5, notes: true,
    moves("C3, D3, C4, D4"),
    moves("C3", from: 5))
  #goban-notes()

  #set text(lang: "la")
  #goban(notes: true, sgf-read(
    "(;SZ[5];B[cc];W[];B[dd])"))
  #goban-notes()
  ```
]

The keys of each language, with their value in English and in Spanish, are:

#{
  set text(size: 0.9em)
  let valor(clave, v) = if type(v) != function { v }
    else if clave == "variation-at" { v(26) }
    else if clave == "win-by-points" { v([_w_], [_p_]) }
    else { v([_w_]) }
  table(columns: 3, stroke: none, inset: (x: 4pt, y: 2pt),
    table.hline(),
    table.header([*Key*], [*English*], [*Spanish*]),
    table.hline(stroke: 0.5pt),
    ..texts.en.keys().map(k => (raw(k), valor(k, texts.en.at(k)), valor(k, texts.es.at(k)))).flatten(),
    table.hline(),
  )
}
