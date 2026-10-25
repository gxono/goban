#import "../estilo.typ": *
#import "/lib.typ": *

= Players and profiles <jugadores>

Each stone, move and mark belongs to one of three players: the first one (`black`), the second one (`white`) or the neutral one (`neutral`). Their look is not in each element but in the player: the branch of each one gathers the options of their stones, their prisoners, their moves, their marks and their territory. Here are the players and, after them, the profiles.

== Players

#opcion("players", valor: [a dictionary])[
  The options of the players: `neutral`, `black` and `white`, and `all`, which goes to the three.

  ```ejemplo
  #goban-set(players: (
    all: (stone: (line: (color: red))),
    neutral: (stone: (fill: (color: yellow))),
    black: (stone: (fill: (
      color: blue.darken(40%))))))

  #goban(size: 3,
    stones(black: "A1, B2", white: "C3"),
    stones("A3"))
  ```
]

#opcion("players.all", valor: [player options])[The options of the three players.]
#opcion("players.neutral", valor: [player options])[The options of the neutral player: the stones and the marks without a player.]
#opcion("players.black", valor: [player options])[The options of the first player.]
#opcion("players.white", valor: [player options])[The options of the second player.]

Each player has the same tree of options. Each branch is documented with the object it applies to, without the player in the path: for the white player, `stone.radius` is `players.white.stone.radius`.

#opcion("players.white.stone", valor: [stone options])[The style of their stones (#pag(<piedras>)). `stone` at the first level is `players.all.stone`.]
#opcion("players.white.prisoner", valor: [stone options])[The style of their prisoners, on top of that of their stones (#pag(<prisioneros>)). `prisoner` at the first level is `players.all.prisoner`.]
#opcion("players.white.move", valor: [move options])[The style of their moves (#pag(<jugadas>)). `move` at the first level is `players.all.move`.]
#opcion("players.white.mark", valor: [mark options])[The style of their marks (#pag(<marcas>)). The shape is not part of the style: it goes in each `marks`. `mark` at the first level is `players.all.mark`.]
#opcion("players.white.territory", valor: [territory options])[The style of their territory (#pag(<territorio>)).]

Copying a player into another is copying their branch: the tree is a value.

```ejemplo
#goban-set(players: (neutral: (stone: (
  fill: (color: white)))))

// Neutral, but with the look of White.
#goban(partial: "A1:C3",
  stones("B2"), stones(black: "A1, C3"))
```

== Profiles <perfiles>

A profile is a complete style, for the board and the players, saved as a dictionary of options: the same as those of `goban-set`. The profiles of the package are named with a string (#pag(<catalogo>)); one of your own is a dictionary.

#opcion("profile", valor: [the name of a profile or a dictionary])[
  Applies a profile: `profile: "wain"` uses one of the package, and `profile: (background: ..., players: ...)`, one of your own. It goes in `goban-set`, in the options of a board and in `view.goban`.

  Before applying it, the board and the players go back to the initial style (that of the `default` profile): that way a profile does not inherit what it does not define, and a shadow or an image set before is lost. What is not style stays as it was: `size`, `use-i`, `partial`, `partial-margin`, `scale`, `scale-line-width`, `label.at`, `label.columns`, `label.rows` and their directions, `hoshi.at`, `move.numbers`, the arrows, the lines, the game and the branches of the games, the diagrams and the views. What goes after the profile is added to it.

  ```ejemplo
  #goban-set(stone: (shadow: (on: true,
    angle: -45deg, offset: 2pt)))

  #goban(size: 3,
    stones(black: "A1, B2", white: "C3"))
  #goban(size: 3, profile: "default",
    stones(black: "A1, B2", white: "C3"))
  ```

  A `profile` inside a profile is the profile it starts from: `pgfgosmooth` is `(profile: pgfgo, ...)`.

  ```ejemplo
  #let example = (
    background: (fill: (color: blue.lighten(95%))),
    players: (
      all: (stone: (line: (
        color: fuchsia.darken(80%)))),
      neutral: (stone: (fill: (color: gray))),
      white: (stone: (fill: (color: yellow))),
      black: (stone: (fill: (color: blue))),
    ),
  )
  #let example2 = (profile: example,
    background: (rounded-corners: 4pt))

  #goban-set(profile: example2)

  #goban(partial: "A1:C3",
    moves("A1:3", numbers: false),
    stones(black: "B1, B3, C2", white: "C1, C3"),
    stones("B2"))
  ```
]

A profile of your own can be saved in a module and imported in any document (#pag(<tut-madera>)).
