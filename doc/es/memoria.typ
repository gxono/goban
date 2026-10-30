#import "../estilo.typ": *
#import "/lib.typ": *

= Tableros como valores y vistas <memoria>

== Seguir desde un tablero

Un tablero puede ser un valor: `board` (#pag(<tablero>)) recibe lo mismo que `goban` y no dibuja nada. Se guarda con `let`, y se usa de dos maneras:

- primero en un `goban` o en otro `board`: `goban(base, moves("C3"))` es el mismo tablero, con todo lo que tiene (sus opciones, sus marcas, sus números), más lo que se agrega;
- con `resume`: otro tablero empieza con ese, como quedó al terminar, con las capturas resueltas; trae solo lo que se pide (por defecto, las piedras), y la numeración y el turno siguen desde ahí.

`goban-view` muestra una parte en medio del texto (#pag(<vistas>)).

```ejemplo
#gobanist-set(size: 5, partial: "B2:D4")

#let tablero1 = board(stones(black: "C2, D3"),
  moves(white: "B4"))

#goban(resume: tablero1)
// Sigue con la 2 (negras).
#goban(resume: tablero1, moves("C3"))
#goban(resume: (board: tablero1,
  numbers: true), moves("C3"))
```

#opcion("resume", valor: [un tablero o `(board: ..., numbers: ..., marks: ..., territory: ...)`])[
  Empieza el tablero con el tablero `board`, como quedó al terminar: con las capturas resueltas (si ese tablero tenía `captures`, este también, salvo que dé las suyas). La numeración y el turno siguen desde ahí. Un tablero solo, `resume: base`, trae solo las piedras, sin números, marcas ni territorio; en un diccionario, `numbers`, `marks` y `territory` piden el resto.

  El tamaño es el del tablero de `resume`, salvo que este dé el suyo (`size`, o una partida); uno puesto con `gobanist-set` no cuenta. Las demás opciones de ese tablero (`partial`, las coordenadas, el estilo) no vienen: se dan en cada tablero.

  Un `board` con `resume` tiene lo que trajo, tal como se dibujó, más lo suyo, y el tablero de `resume` no cambia: así se arman variantes.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")

  #let base = board(stones(black: "C2, D3",
    white: "C3"))
  #let variante1 = board(resume: base,
    moves(white: "D2"))
  #let variante2 = board(resume: base,
    moves(white: "B3"))

  #goban(resume: variante1)
  #goban(resume: variante2)
  #goban(resume: (board: variante1,
    numbers: true), moves("B4"))
  ```
]

#opcion("resume.numbers", valor: [`true` o `false`], inicial: `false`)[Trae también los números de las jugadas.]
#opcion("resume.marks", valor: [`true` o `false`], inicial: `false`)[Trae también las marcas, las flechas y las líneas.]
#opcion("resume.territory", valor: [`true` o `false`], inicial: `false`)[
  Trae también el territorio.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")

  #let guardado = board(stones(black: "C2:4"),
    moves(white: "D3"), marks(triangle: "B3"),
    territory(black: "B2, B4", draw: "fill"))

  #goban(resume: guardado)
  #goban(resume: (board: guardado,
    numbers: true, marks: true,
    territory: true))
  ```
]

Para que `resume` no traiga una piedra, una jugada, una marca, una flecha, una línea o un territorio, se dibuja con la opción `forget: true` (`stones(white: "C3", forget: true)`, `marks(circle: "A1", forget: true)`, …); con `forget: "number"`, una jugada viene sin su número aunque se pida `numbers` (#pag(<jugadas>)). Lo olvidado sigue en el tablero: `goban-view` lo muestra con `forgotten`.

Como un tablero es un valor, puede guardarse en un módulo e importarse en otro documento: `#import "tableros.typ": ko`. Así se usa el mismo tablero en un artículo y en sus diapositivas (#pag(<tut-diapositivas>)).

== Vistas en el texto <vistas>

#funcion("goban-view(tablero, parte, ..opciones)")[
  Dibuja la intersección (`"C3"`) o el rectángulo (`"B2:E4"`, escrito como en `partial`) de un tablero (un `board(...)` o una partida), como quedó al terminar, con las capturas resueltas, en medio del texto. Con varias partes separadas por comas (`"F15, G15, C3:E5"`), una vista por parte, unidas con `view.separator` y `view.last`. Por defecto se ve todo lo que dibujó el tablero en esa parte (piedras, números de las jugadas, marcas, flechas, líneas y territorio), con su estilo, a la escala de `view.goban` y centrado a la altura de las minúsculas. Las opciones son las de la rama `view`.

  ```ejemplo-abajo
  #let tablero1 = board(size: 5,
    captures: "remove",
    stones(black: "B3, C2, C4",
      white: "D2, D4, E3"),
    moves(white: "C3, D3"))

  La negra en D3 #goban-view(tablero1, "D3")
  captura la blanca de C3
  #goban-view(tablero1, "C3"). Así quedó el ko:
  #goban-view(tablero1, "B2:E4").
  ```

  La vista se resuelve con las opciones globales del lugar donde está, como un `goban`; encima van las del tablero y, después, las de `view.goban`. Como el tablero es un valor, la vista puede ir antes o después del diagrama que lo dibuja. Una vista no cambia lo que dicen `goban-prisoners`, `goban-score`, `goban-notes` ni `goban-region`.

  ```ejemplo
  #let tablero2 = board(size: 5,
    stones(black: "B2, C3"),
    moves(white: "C2, D3"),
    marks(triangle: "C3"))

  #goban-view(tablero2, "B2:D3")
  #goban-view(tablero2, "B2:D3",
    marks: false, numbers: false)
  #goban-view(tablero2, "B2:D3",
    goban: (grid: false))
  #goban-view(tablero2, "B2:D3",
    goban: (background: false))
  ```
]

#opcion("view", valor: [un diccionario])[Las opciones de las vistas: en `goban-view`, para esa vista, y con `gobanist-set(view: ...)`, para todas.]
#opcion("view.marks", valor: [`true` o `false`], inicial: `true`)[Con `false`, sin las marcas.]
#opcion("view.arrows", valor: [`true` o `false`], inicial: `true`)[Con `false`, sin las flechas.]
#opcion("view.lines", valor: [`true` o `false`], inicial: `true`)[
  Con `false`, sin las líneas.

  ```ejemplo-abajo
  #let flechas = board(size: 5,
    stones(black: "B2", white: "D4"),
    arrows(("B2", "D4")), lines(("B4", "D2")),
    marks(triangle: "C3"))

  Sin flechas:
  #goban-view(flechas, "A1:E5", arrows: false).
  Sin líneas ni marcas:
  #goban-view(flechas, "A1:E5", lines: false,
    marks: false).
  ```
]

#opcion("view.numbers", valor: [`true` o `false`], inicial: `true`)[Con `false`, sin los números de las jugadas.]
#opcion("view.territory", valor: [`true` o `false`], inicial: `true`)[Con `false`, sin el territorio.]
#opcion("view.forgotten", valor: [`true` o `false`], inicial: `false`)[
  Dibuja también lo que tiene `forget`.

  ```ejemplo
  #let tablero3 = board(size: 5,
    stones(black: "B2, C3"),
    stones(white: "D3", forget: true))

  #goban-view(tablero3, "B2:D3")
  #goban-view(tablero3, "B2:D3",
    forgotten: true)
  ```
]

#opcion("view.raise", valor: [`auto` o una longitud], inicial: `auto`)[
  A qué altura sobre la línea de base del texto queda el centro de la vista. Con `auto`, la mitad del alto de las minúsculas.

  ```ejemplo-abajo
  #let b = board(size: 5, stones(black: "C3"))

  Texto #goban-view(b, "C3", raise: 0pt)
  texto #goban-view(b, "C3")
  texto #goban-view(b, "C3", raise: 0.8em).
  ```
]

#opcion("view.separator", valor: [un texto o un contenido], inicial: `", "`)[Lo que va entre las vistas de varias partes.]

#opcion("view.last", valor: [`auto`, un texto o un contenido], inicial: `auto`)[
  Lo que va antes de la última vista, en lugar de `separator`; con dos partes, va solo esto. Con `auto`, el texto `and` del idioma entre espacios: « y ». Los espacios son parte del texto.

  ```ejemplo-abajo
  #let b = board(size: 5,
    stones(black: "B3, C2, C4", white: "C3"))

  Las piedras #goban-view(b, "B3, C2, C4")
  rodean a C3.
  #goban-view(b, "B3, C2, C4",
    separator: "; ", last: " o ").
  ```
]

#opcion("view.goban", valor: [opciones de tablero], inicial: `(scale: 0.8, background: (line: false))`)[
  Las opciones del tablero de la vista, encima de las suyas: el estilo (`profile`, `players`, `stone`, `mark`, `grid`, `background`, `label`, …) y la escala. Inicialmente, el fondo va sin borde, aunque el tablero lo tenga; un `profile` vuelve el estilo al de su perfil, con su borde. No pueden ser las que cambian la partida o la parte que se ve: `size`, `use-i`, `partial`, `captures`, `captured-marks`, `territory` ni `sgf`.

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

== Una piedra en el texto <piedra-texto>

#funcion("goban-stone(jugador, number: none, mark: none, prisoner: false, ..estilo)")[
  Dibuja una piedra sola en el texto, sin tablero: de `"black"`, `"white"` o, sin jugador (o con `"neutral"`), neutral. `mark` es una marca encima, como en `stones`; con `number`, la piedra es una jugada con ese número; con `prisoner: true`, un prisionero. Las demás opciones son las del estilo de la piedra (`fill`, `line`, `radius`, …). Lleva el estilo del lugar donde está y, encima, el de las vistas (`view.goban`, `view.raise`): queda del tamaño y a la altura de la vista de una intersección, sin grilla ni fondo. No cambia lo que dicen `goban-prisoners`, `goban-score`, `goban-notes` ni `goban-region`.

  ```ejemplo-abajo
  Negra #goban-stone("black"), blanca
  #goban-stone("white"), neutral #goban-stone().
  #goban-stone("black", mark: "triangle")
  #goban-stone("white", number: 12)
  #goban-stone("black", prisoner: true)
  ```
]
