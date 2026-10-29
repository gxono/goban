#import "../estilo.typ": *
#import "/lib.typ": *

= Jugadores y perfiles <jugadores>

Cada piedra, jugada y marca pertenece a uno de tres jugadores: el primero (`black`), el segundo (`white`) o el neutral (`neutral`). Su aspecto no está en cada elemento sino en el jugador: la rama de cada uno reúne las opciones de sus piedras, sus prisioneros, sus jugadas, sus marcas y su territorio. Aquí están los jugadores y, después, los perfiles.

== Jugadores

#opcion("players", valor: [un diccionario])[
  Las opciones de los jugadores: `neutral`, `black` y `white`, y `all`, que va a los tres.

  ```ejemplo
  #gobanist-set(players: (
    all: (stone: (line: (color: red))),
    neutral: (stone: (fill: (color: yellow))),
    black: (stone: (fill: (
      color: blue.darken(40%))))))

  #goban(size: 3,
    stones(black: "A1, B2", white: "C3"),
    stones("A3"))
  ```
]

#opcion("players.all", valor: [opciones de jugador])[Las opciones de los tres jugadores.]
#opcion("players.neutral", valor: [opciones de jugador])[Las opciones del jugador neutral: las piedras y las marcas sin jugador.]
#opcion("players.black", valor: [opciones de jugador])[Las opciones del primer jugador.]
#opcion("players.white", valor: [opciones de jugador])[Las opciones del segundo jugador.]

Cada jugador tiene el mismo árbol de opciones. Cada rama se documenta con el objeto al que se aplica, sin el jugador en la ruta: para el jugador blanco, `stone.radius` es `players.white.stone.radius`.

#opcion("players.white.stone", valor: [opciones de piedra])[El estilo de sus piedras (#pag(<piedras>)). `stone` en el primer nivel es `players.all.stone`.]
#opcion("players.white.prisoner", valor: [opciones de piedra])[El estilo de sus prisioneros, encima del de sus piedras (#pag(<prisioneros>)). `prisoner` en el primer nivel es `players.all.prisoner`.]
#opcion("players.white.move", valor: [opciones de jugada])[El estilo de sus jugadas (#pag(<jugadas>)). `move` en el primer nivel es `players.all.move`.]
#opcion("players.white.mark", valor: [opciones de marca])[El estilo de sus marcas (#pag(<marcas>)). La forma no es parte del estilo: va en cada `marks`. `mark` en el primer nivel es `players.all.mark`.]
#opcion("players.white.territory", valor: [opciones de territorio])[El estilo de su territorio (#pag(<territorio>)).]

Copiar un jugador en otro es copiar su rama: el árbol es un valor.

```ejemplo
#gobanist-set(players: (neutral: (stone: (
  fill: (color: white)))))

// Neutral, pero con el aspecto de las blancas.
#goban(partial: "A1:C3",
  stones("B2"), stones(black: "A1, C3"))
```

== Perfiles <perfiles>

Un perfil es un estilo completo, para el tablero y los jugadores, guardado como un diccionario de opciones: las mismas de `gobanist-set`. Los perfiles del paquete se nombran con una cadena (#pag(<catalogo>)); uno propio es un diccionario.

#opcion("profile", valor: [el nombre de un perfil o un diccionario])[
  Aplica un perfil: `profile: "wain"` usa uno del paquete, y `profile: (background: ..., players: ...)`, uno propio. Va en `gobanist-set`, en las opciones de un tablero y en `view.goban`.

  Antes de aplicarlo, el tablero y los jugadores vuelven al estilo inicial (el del perfil `default`): así un perfil no hereda lo que no define, y una sombra o una imagen puesta antes se pierde. Lo que no es estilo queda como estaba: `size`, `use-i`, `partial`, `partial-margin`, `scale`, `scale-line-width`, `label.at`, `label.columns`, `label.rows` y sus direcciones, `hoshi.at`, `move.numbers`, las flechas, las líneas, el juego y las ramas de las partidas, los diagramas y las vistas. Lo que va después del perfil se suma a él.

  ```ejemplo
  #gobanist-set(stone: (shadow: (on: true,
    angle: -45deg, offset: 2pt)))

  #goban(size: 3,
    stones(black: "A1, B2", white: "C3"))
  #goban(size: 3, profile: "default",
    stones(black: "A1, B2", white: "C3"))
  ```

  Un `profile` dentro de un perfil es el perfil del que parte: `pgfgosmooth` es `(profile: pgfgo, ...)`.

  ```ejemplo
  #let ejemplo = (
    background: (fill: (color: blue.lighten(95%))),
    players: (
      all: (stone: (line: (
        color: fuchsia.darken(80%)))),
      neutral: (stone: (fill: (color: gray))),
      white: (stone: (fill: (color: yellow))),
      black: (stone: (fill: (color: blue))),
    ),
  )
  #let ejemplo2 = (profile: ejemplo,
    background: (rounded-corners: 4pt))

  #gobanist-set(profile: ejemplo2)

  #goban(partial: "A1:C3",
    moves("A1:3", numbers: false),
    stones(black: "B1, B3, C2", white: "C1, C3"),
    stones("B2"))
  ```
]

Un perfil propio puede guardarse en un módulo e importarse en cualquier documento (#pag(<tut-madera>)).
