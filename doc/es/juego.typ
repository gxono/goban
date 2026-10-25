#import "../estilo.typ": *
#import "/lib.typ": *

= El juego: capturas, notas y territorio <juego>

Un `goban` puede seguir las reglas del juego: retirar las piedras capturadas, anotar las jugadas que caen en puntos ya jugados y contar el territorio. Lo hace el kernel (#pag(<kernel>)), que juega el tablero entero al dibujarlo.

== Capturas <capturas>

#opcion("captures", valor: [`none`, `"remove"` o `"fade"`], inicial: `none`)[
  Las capturas. Cuando una jugada deja sin libertades a un grupo rival, ese grupo se retira del tablero; si deja sin libertades a su propio grupo (un suicidio), se retira ese grupo. Las piedras de `stones` también cuentan; las neutrales y los prisioneros, no. Una jugada fuera de un tablero parcial también captura. Una jugada en un punto ocupado es un error, porque en una partida no es posible (salvo en `sgf-diagrams` y `sgf-problem`, #pag(<diagramas>)). Con `none`, no hay capturas: las jugadas se dibujan unas sobre otras.

  ```ejemplo
  #goban-set(size: 5, partial: "A1:C3")

  #goban(moves("B1, A1, A2"))
  // 3 captura a 2.
  #goban(captures: "remove",
    moves("B1, A1, A2"))
  ```

  Con `"remove"`, las piedras capturadas desaparecen. Con `"fade"`, quedan en el tablero, dibujadas como prisioneros (con el estilo de `prisoner`, #pag(<prisioneros>)).

  ```ejemplo
  #goban(size: 5, partial: "A1:E3",
    captures: "fade",
    stones(white: "C1, D1",
      black: "B1, C2, D2"),
    moves("E1"))
  ```
]

#opcion("captured-marks", valor: [`"keep"` o `"remove"`], inicial: `"keep"`)[
  Qué pasa con las marcas que están sobre una piedra cuando la capturan. Con `"keep"`, quedan sobre el punto vacío. Con `"remove"`, se van con la piedra, también con `captures: "fade"`; las secuencias conservan su numeración. Las marcas sobre puntos vacíos no cambian.

  ```ejemplo
  #goban-set(size: 5, partial: "A1:C3",
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
  Cuántos prisioneros tiene el jugador (`"black"` o `"white"`) en el último `goban`: las piedras del rival que capturaron sus jugadas.

  ```ejemplo
  #goban(size: 5, partial: "A1:C3",
    captures: "remove",
    moves("B1, A1, A2"))

  Negras: #goban-prisoners("black").
  Blancas: #goban-prisoners("white").
  ```
]

== Jugadas en puntos ya jugados <notas>

En los diagramas numerados, cuando una jugada cae en un punto donde ya se jugó (por ejemplo, al retomar un ko), los libros no la dibujan: el punto sigue mostrando la primera piedra, y debajo del diagrama se anota, por ejemplo, «3 en 1».

#opcion("notes", valor: [`true`, `false` o un diccionario])[
  Una jugada numerada en un punto donde ya hubo una jugada numerada del mismo `goban` no se dibuja: el punto sigue mostrando la primera, aunque haya sido capturada, y se anota «N en M». Solo cuentan las jugadas numeradas que se ven en el tablero. Un pase de una partida que se numeraría se anota «N: pasa», en orden con las demás notas; los pases con los que termina la partida no se anotan.

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

#opcion("notes.at", valor: [`auto` o un texto], inicial: `auto`)[El texto entre los dos números. Con `auto`, el del idioma (`at` en `texts`, #pag(<idiomas>)).]
#opcion("notes.separator", valor: [un texto o un contenido], inicial: `", "`)[El texto entre las notas.]

#funcion("goban-notes(at: auto, separator: auto)")[
  Las notas del último `goban`, separadas por `separator`. Sin notas, nada. Con `auto`, `at` y `separator` son los de la rama `notes`.

  ```ejemplo
  #goban(size: 5, partial: "A2:E4",
    notes: true, captures: "remove",
    stones(black: "B3, C2, C4",
      white: "D2, D4, E3"),
    moves(white: "C3"), moves("D3"),
    moves(white: "C3", from: 3), moves("D3"))

  #goban-notes(at: "sobre", separator: "; ")
  ```
]

== Territorio <territorio>

#let fin = board(
  stones(black: "A6 |- B5 |- D1 |- E2, C4, E9 -| F4, D5 -| G7 -- D7, H6, H8, J7",
    white: "E8 -| C5, B:E6, A7, B8, D9, J6 |- H5, H2:3, F1 |- C3, C2, D:E4, G4"),
  prisoners(black: "H1 -| J2", white: "A1"))
#definir(fin: fin)

Al final de la partida, el territorio puede marcarse a mano con `marks` (#pag(<marcas>)) o con `territory`, que además lo cuenta. En los ejemplos, `fin` es esta posición, con sus prisioneros:

```ejemplo
#let fin = board(
  stones(black: "A6 |- B5 |- D1 |- E2, C4,
      E9 -| F4, D5 -| G7 -- D7, H6, H8, J7",
    white: "E8 -| C5, B:E6, A7, B8, D9,
      J6 |- H5, H2:3, F1 |- C3, C2, D:E4, G4"),
  prisoners(black: "H1 -| J2", white: "A1"))

#goban(label: (at: (top, left)), resume: fin)
```

#funcion("territory(polígono, black: ..., white: ..., neutral: ..., ..opciones)")[
  Marca como territorio los puntos del polígono que tiene esos vértices (en orden, con la sintaxis de coordenadas), incluido su borde. No marca los puntos que tienen una piedra viva: los prisioneros cuentan como territorio. Un vértice solo marca un punto, y dos, un tramo. El jugador es la clave: `territory(black: "A1, A5, B5, B1")`; sin jugador, el polígono es neutral.

  El territorio se dibuja al terminar el `goban`. Cada punto queda con el último `territory` que lo marcó, con el jugador y las opciones de ese `territory` (así, `territory(neutral: "A1")` después de otro `territory` vuelve neutral a A1), y no se dibuja ni se cuenta si al final tiene una piedra viva.

  ```ejemplo
  #goban(label: (at: (top, left)),
    resume: fin,
    territory(black: "A1, A5, B5, B1"),
    territory(black: "F9, F7, G7, G6, J6, J9"),
    territory(white: "F1, F4, G4, G5, J5, J1"),
    territory(white: "A9, A6, C6, C8, D8, D9"))
  ```

  Con `auto` en lugar de un polígono, busca solo el territorio: cada región de puntos sin piedras vivas es del color que la rodea. Si la tocan los dos colores (dame, seki) o ninguno, es neutral. Los prisioneros cuentan como piedras muertas. Sin jugador, `territory(auto)` marca el territorio de los dos; con `territory(black: auto)`, solo el de ese jugador.

  ```ejemplo
  #goban(label: (at: (top, left)),
    resume: fin,
    territory(auto, dame: true))
  ```

  `auto` solo mira qué color toca cada región; no sabe leer la posición. Por eso:

  - Es para partidas terminadas. En una posición abierta, casi todo el tablero toca los dos colores y es neutral; con piedras de un solo color, todo el tablero es suyo. Si un borde tiene un hueco, el territorio de adentro se junta con el dame y también queda neutral.
  - No sabe qué piedras están muertas: hay que ponerlas con `prisoners`. Una piedra muerta puesta con `stones` cuenta como viva, y la región que toca queda neutral.
  - Los ojos de un grupo en seki cuentan como territorio (en las reglas japonesas no se cuentan). Pueden volverse neutrales después, con un `territory(neutral: ...)` para cada uno.
  - Las piedras neutrales ocupan su punto, pero no son de nadie: una región que solo toca piedras neutrales es neutral.
  - Busca las regiones con las piedras que hay donde está el `territory`, así que conviene ponerlo al final del `goban`.
  - Con `partial: auto`, el tablero crece hasta mostrar todo el territorio (y el dame, con `dame`).
]

#opcion("territory.draw", valor: [`"marks"`, `"fill"` o `"region"`], inicial: `"marks"`)[
  Cómo se dibuja el territorio. Con `"marks"`, cada punto lleva la marca de territorio del jugador. Con `"fill"`, cada punto se rellena debajo de las piedras.

  ```ejemplo
  #goban(label: (at: (top, left)),
    resume: fin,
    territory(auto, draw: "fill"))
  ```

  Con `"region"`, el territorio de cada color es un solo polígono: se pinta cada casilla de la cuadrícula que tiene alguna esquina en el territorio (las piedras muertas cuentan como territorio). Sus lados van por las líneas del tablero, sus vértices están siempre en intersecciones, y llega hasta el borde del tablero. Dos zonas que se tocan por una sola esquina quedan separadas. Todos los `territory` de un color en el mismo `goban` (también el territorio `TB` y `TW` de una partida) forman una sola región, que se dibuja con el estilo del último. Los puntos neutrales se rellenan uno por uno, como con `"fill"`. El contorno y sus vértices pueden dibujarse encima, con `line` y `vertices`, y `goban-region` da sus propiedades.

  ```ejemplo
  #goban(label: (at: (top, left)),
    resume: fin,
    territory(auto, draw: "region"))
  ```

  Es una opción de `territory`, y con `goban-set(territory: (draw: ...))`, de todos.
]

#opcion("territory.dame", valor: [`true` o `false`], inicial: `false`)[Con `auto`, marca también los puntos neutrales.]

Las demás opciones de `territory` (`mark`, `fill`, `line` y `vertices`) cambian el estilo del territorio del jugador solo para ese `territory`. El estilo de cada jugador está en su rama `territory`:

#opcion("players.black.territory.mark", valor: [una forma o un diccionario], inicial: [`"t-circle"`])[
  La marca de cada punto, con `draw: "marks"`: `"t-circle"` para las negras y `"t-square"` para las blancas y los puntos neutrales. Con opciones, un diccionario con la forma en `shape`, como `mark` de las piedras.

  ```ejemplo
  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      mark: "t-square"),
    territory(white: "E1, E5"))
  ```
]

#opcion("players.black.territory.fill", valor: [`true`, `false` o un diccionario])[El relleno, con `draw: "fill"` y `draw: "region"`. Con `false`, sin relleno: con `"region"` quedan solo el contorno o los vértices.]
#opcion("players.black.territory.fill.color", valor: [un color o `none`], inicial: `black`)[El color del relleno: negro para las negras, `luma(80%)` para las blancas y `luma(50%)` para los puntos neutrales. Con `none`, sin color.]
#opcion("players.black.territory.fill.opacity", valor: [un número de 0 a 1], inicial: `0.35`)[
  La opacidad del relleno: `0.35` para las negras y los puntos neutrales, `0.7` para las blancas.

  ```ejemplo
  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      draw: "fill",
      fill: (color: blue, opacity: 0.5)),
    territory(white: "E1, E5", draw: "fill"))
  ```
]

#opcion("players.black.territory.fill.pattern", valor: [`none` o un `tiling`], inicial: `none`)[
  Un patrón encima del color del relleno, como `stone.fill.pattern` (#pag(<piedras>)). Con `fill.color: none`, queda solo el patrón.

  ```ejemplo
  #let rayas(a, b) = tiling(size: (3pt, 3pt),
    line(start: (0pt, a), end: (3pt, b),
      stroke: 0.4pt))

  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      draw: "fill", fill: (color: none,
        pattern: rayas(3pt, 0pt))),
    territory(white: "E1:5", draw: "region",
      fill: (color: none,
        pattern: rayas(0pt, 3pt))))
  ```
]

#opcion("players.black.territory.line", valor: [`true`, `false` o un diccionario])[
  El contorno de la región, con `draw: "region"`.

  ```ejemplo
  #goban(label: (at: (top, left)),
    resume: fin,
    territory(black: auto, draw: "region",
      line: true, vertices: true),
    territory(white: auto, draw: "region",
      line: (on: true, color: red)))
  ```
]

#opcion("players.black.territory.line.color", valor: [un color], inicial: `black`)[El color del contorno: negro para las negras y `luma(40%)` para las blancas.]
#opcion("players.black.territory.line.width", valor: [una longitud], inicial: `1.2pt`)[El grosor del contorno.]
#opcion("players.black.territory.line.opacity", valor: [un número de 0 a 1], inicial: `1`)[La opacidad del contorno y de los vértices.]
#opcion("players.black.territory.line.above", valor: [`true` o `false`], inicial: `true`)[
  Con `true`, el contorno y los vértices se dibujan encima de las piedras y de las marcas; con `false`, debajo de las piedras, junto con el relleno.

  ```ejemplo
  #let contorno = (on: true, color: red,
    width: 2pt, opacity: 0.7)

  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      draw: "region", fill: false,
      line: contorno))
  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      draw: "region", fill: false,
      line: contorno + (above: false)))
  ```
]

#opcion("players.black.territory.vertices", valor: [`true`, `false` o un diccionario])[Puntos en los vértices del contorno, con `draw: "region"`, en la misma capa que el contorno.]
#opcion("players.black.territory.vertices.radius", valor: [una longitud], inicial: `2pt`)[El radio de los puntos.]
#opcion("players.black.territory.vertices.color", valor: [`auto` o un color], inicial: `auto`)[
  El color de los puntos. Con `auto`, el del contorno.

  ```ejemplo
  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(black: "A1, A5, B5, B1",
      draw: "region", vertices: (on: true,
        radius: 3pt, color: red)))
  ```
]

== Puntaje

#funcion("goban-score(player, komi: auto)")[
  El puntaje del jugador (`"black"` o `"white"`) en el último `goban`, con las reglas japonesas: los puntos de su territorio, más las piedras muertas del rival que hay en él, más las piedras que capturó (con `captures`), más el komi para las blancas. Un punto marcado dos veces cuenta una vez. Con `"neutral"`, la cantidad de puntos neutrales marcados. Con `auto`, el komi es el de `score.komi`.

  ```ejemplo
  #goban(size: 5,
    stones(black: "C1:5", white: "D1:5"),
    territory(auto))

  Negras: #goban-score("black").
  Blancas: #goban-score("white", komi: 6.5).
  ```
]

#opcion("score.komi", valor: [un número], inicial: `0`)[El komi que `goban-score` le suma a las blancas: `goban-set(score: (komi: 6.5))`.]

#funcion("goban-region(player, property, n: none)")[
  Una propiedad de la región (`draw: "region"`) del jugador (`"black"` o `"white"`) en el último `goban`, como texto. Las propiedades son del contorno completo, aunque el tablero sea parcial. Sin región, los números son 0. Las propiedades son:

  - `"polygons"`: la cantidad de contornos, exteriores y huecos.
  - `"outlines"`: la cantidad de contornos exteriores, uno por cada zona separada.
  - `"holes"`: la cantidad de huecos.
  - `"vertices"`: la cantidad de vértices de todos los contornos.
  - `"area"`: la cantidad de casillas pintadas.
  - `"perimeter"`: el largo de todos los contornos, en casillas.
  - `"polygon"`, con `n`: los vértices del contorno `n` (desde 1), como coordenadas separadas por comas (`"A1, D1, D4, A4"`). Vacío si no hay tantos contornos.

  Cada contorno empieza en su vértice más bajo y, entre esos, en el de más a la izquierda. Los exteriores van en sentido antihorario y los huecos, en sentido horario. Los contornos están ordenados por ese primer vértice, de abajo hacia arriba.

  ```ejemplo
  #goban(label: (at: (top, left)),
    stones(white: "D4:F6"),
    territory(black: "B2, B8, H8, H2",
      draw: "region", line: true))

  Contornos: #goban-region("black", "polygons")
  (#goban-region("black", "holes") hueco).
  Casillas: #goban-region("black", "area").
  El hueco:
  #goban-region("black", "polygon", n: 2).
  ```
]

`goban-prisoners`, `goban-notes`, `goban-score` y `goban-region` hablan del último tablero dibujado: el de un `goban` o el último diagrama de `sgf-diagrams`, `sgf-problem` o `goban-layout`. Las vistas (`goban-view`) no cuentan. Devuelven contenido: lo que dicen se sabe al dibujar.
