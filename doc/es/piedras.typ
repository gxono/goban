#import "../estilo.typ": *
#import "/lib.typ": *

= Piedras, jugadas y prisioneros <piedras>

Las piedras se ponen con `stones`; las jugadas, con `moves`, y los prisioneros, con `prisoners`. Su estilo es el de su jugador (#pag(<jugadores>)), y cada elemento puede cambiarlo con sus opciones.

== Piedras

#funcion("stones(coordenadas, black: ..., white: ..., neutral: ..., ..opciones)")[
  Pone piedras en las intersecciones, escritas con la sintaxis de coordenadas (#pag(<coordenadas>)). El jugador es la clave: `stones(black: "C2, D3", white: "B4")`. Sin clave, las piedras son neutrales: `stones("C3")`. Las opciones cambian su estilo (las de la rama `stone`, más abajo) y les ponen una marca (`mark`).

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2", white: "D3"),
    stones("B4"))
  ```
]

Las piedras, marcas y etiquetas que caen fuera de la parte visible de un tablero parcial no se dibujan. Una coordenada que no existe en el tablero (`"E9"` en un tablero de 5×5) es un error. Una piedra en un punto donde ya hay otra la tapa.

El estilo de las piedras de los tres jugadores se cambia con `goban-set(stone: ...)`, que es `goban-set(players: (all: (stone: ...)))`; el de uno, con `goban-set(players: (black: (stone: ...)))`. Las opciones de la rama `stone` son:

#opcion("stone.fill", valor: [`true`, `false` o un diccionario])[
  El relleno de la piedra. Con `false`, sin relleno: queda lo demás (el borde, la sombra, el brillo).

  ```ejemplo
  #goban-set(profile: "pgfgosmooth", size: 5,
    partial: "B2:D4")

  #goban(stones(black: "C2, D3", white: "B4"))
  #goban(stones(black: "C2, D3"),
    stones(white: "B4", fill: false))
  ```
]

#opcion("stone.fill.color", valor: [un color o `none`])[
  El color del relleno: negro para las negras, blanco para las blancas y gris para las neutrales. Con `none`, sin color: queda el patrón, si lo hay.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones("C2, D3", fill: (color: aqua.darken(40%))),
    stones("B4", fill: (color: fuchsia.darken(20%))))
  ```
]

#opcion("stone.fill.opacity", valor: [un número de 0 a 1], inicial: `1`)[
  La opacidad del relleno.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", fill: (opacity: 0.8)),
    stones(white: "B4", fill: (opacity: 0.5)))
  ```
]

#opcion("stone.fill.pattern", valor: [`none` o un `tiling`], inicial: `none`)[
  Un patrón encima del color del relleno, con su misma opacidad: un `tiling` de Typst. Con `fill.color: none`, la piedra tiene solo el patrón. Las marcas `t-circle` y `t-square` del jugador usan el mismo relleno. El patrón no cambia de tamaño con `scale`.

  ```ejemplo
  #let rayas = tiling(size: (3pt, 3pt),
    line(start: (0pt, 3pt), end: (3pt, 0pt),
      stroke: 0.4pt))

  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3",
      fill: (color: white, pattern: rayas)),
    stones(white: "B4", fill: (color: none,
      pattern: tiling(size: (2pt, 2pt),
        circle(radius: 0.5pt, fill: black)))))
  ```
]

#opcion("stone.line", valor: [`true`, `false` o un diccionario])[
  El borde de la piedra.

  ```ejemplo
  #goban-set(profile: "pgfgosmooth", size: 5,
    partial: "B2:D4")

  #goban(stones(black: "C2, D3", white: "B4"))
  #goban(stones(black: "C2, D3"),
    stones(white: "B4", line: true))
  ```
]

#opcion("stone.line.color", valor: [un color], inicial: `black`)[El color del borde.]
#opcion("stone.line.opacity", valor: [un número de 0 a 1], inicial: `1`)[La opacidad del borde.]
#opcion("stone.line.width", valor: [una longitud], inicial: `0.7pt`)[
  El grosor del borde.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", line: (
      color: fuchsia, opacity: 0.5)),
    stones(white: "B4", line: (width: 2pt)))
  ```
]

#opcion("stone.radius", valor: [una longitud], inicial: `5.5pt`)[
  El radio de la piedra.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", radius: 0.15cm),
    stones(white: "B4", radius: 0.25cm))
  ```
]

#opcion("stone.scale", valor: [un número], inicial: `1`)[
  Escala la piedra entera: el radio, el borde y las marcas.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2", mark: "circle"),
    stones(black: "D3", scale: 0.7,
      mark: "circle"),
    stones(white: "B4", scale: 1.3,
      mark: "triangle"))
  ```
]

#opcion("stone.shadow", valor: [`true`, `false` o un diccionario])[
  La sombra de la piedra, dibujada debajo. Tiene la silueta de la piedra: el círculo, o la forma de la imagen si la piedra es una imagen (`image`). Con `shadow.image`, la sombra es una imagen propia. En los dos casos se corre `offset` hacia `angle` y se agranda `scale` veces.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stone: (shadow: (on: true, angle: -45deg,
      offset: 1.5pt)),
    stones(black: "C2, D3", white: "B4"))
  ```
]

#opcion("stone.shadow.angle", valor: [un ángulo], inicial: `0deg`)[Hacia dónde cae la sombra: con `0deg`, a la derecha; con `-45deg`, abajo a la derecha. No gira la forma de la sombra.]
#opcion("stone.shadow.offset", valor: [una longitud], inicial: `1pt`)[Cuánto se corre la sombra respecto del centro de la piedra, hacia `angle`.]
#opcion("stone.shadow.opacity", valor: [un número de 0 a 1], inicial: `0.5`)[
  La opacidad de la sombra (también la de la sombra con imagen).

  ```ejemplo
  #goban-set(profile: "pgfgosmooth", size: 3)
  #let b = board(stones(black: "B1, C2", white: "A3"))

  #goban(b, players: (white: (stone: (
    shadow: (angle: 225deg)))))
  #goban(b, players: (white: (stone: (
    shadow: (offset: 0.125cm, opacity: 0.1)))))
  #goban(b, players: (white: (stone: (
    shadow: false))))
  ```
]

#opcion("stone.shadow.color", valor: [un color], inicial: `black`)[El color de la sombra. Una sombra con imagen tiene sus propios colores, salvo con `image.silhouette`.]
#opcion("stone.shadow.scale", valor: [un número], inicial: `1`)[
  Agranda (o achica) la sombra respecto de la piedra. Una sombra más grande que la piedra la hace parecer más alta. También agranda la sombra con imagen.

  ```ejemplo
  #goban(size: 3, scale: 2,
    stones(black: "A1", shadow: (on: true,
      angle: -45deg)),
    stones(black: "C2", shadow: (on: true,
      angle: -45deg, scale: 1.3)),
    stones(white: "A3", shadow: (on: true,
      offset: 0pt, scale: 1.3, color: red)))
  ```
]

#opcion("stone.shadow.image", valor: [un archivo o un diccionario])[
  Una sombra propia: una imagen, centrada en la piedra y dibujada tal cual en lugar de la silueta, por ejemplo una sombra difusa. Se corre y se agranda como la silueta (`angle`, `offset`, `scale`) y usa `opacity`, pero no `color`. No gira con la imagen de la piedra, así que cae siempre hacia el mismo lado. Lo que no es un diccionario es el archivo; `none` la quita.

  ```ejemplo
  #goban(size: 3, scale: 2,
    stone: (shadow: (on: true, angle: -45deg,
      offset: 1.5pt, opacity: 0.8,
      image: (file: path("img/pgfgo-shadow.png"),
        width: 13pt))),
    stones(black: "B1, C2", white: "A3"))
  ```
]

#opcion("stone.shadow.image.file", valor: [un archivo], inicial: `none`)[El archivo de la imagen.]
#opcion("stone.shadow.image.width", valor: [`auto` o una longitud], inicial: `auto`)[El ancho de la imagen; el alto mantiene la proporción. Con `auto`, el diámetro de la piedra.]
#opcion("stone.shadow.image.rotate", valor: [un ángulo], inicial: `0deg`)[Gira la imagen de la sombra, igual en todas las piedras.]
#opcion("stone.shadow.image.silhouette", valor: [`true` o `false`], inicial: `false`)[
  Usa solo la forma de la imagen (su transparencia), pintada con `shadow.color`, en lugar de la imagen tal cual. Solo con PNG y JPEG.

  ```ejemplo
  #goban(size: 3, scale: 2,
    stone: (shadow: (on: true, angle: -45deg,
      offset: 2pt, color: blue,
      image: (file: path("img/pgfgo-shadow.png"),
        width: 16pt, silhouette: true))),
    stones(black: "B1, C2", white: "A3"))
  ```
]

#opcion("stone.shine", valor: [`true`, `false` o un diccionario])[
  El brillo de la piedra, dibujado encima de ella, sea un círculo o una imagen.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", shine: true),
    stones(white: "B4", shine: (on: true,
      color: luma(50%))))
  ```
]

#opcion("stone.shine.angle", valor: [un ángulo], inicial: `0deg`)[Gira el brillo dibujado. Con `0deg`, la luz viene de arriba a la izquierda.]
#opcion("stone.shine.opacity", valor: [un número de 0 a 1], inicial: `1`)[La opacidad del brillo (también la del brillo con imagen).]
#opcion("stone.shine.color", valor: [un color], inicial: `luma(75%)`)[
  El color del brillo dibujado.

  ```ejemplo
  #goban-set(profile: "pgfgosmooth", size: 3)
  #let b = board(stones(black: "B1, C2", white: "A3"))

  #goban(b, players: (black: (stone: (
    shine: (angle: 45deg)))))
  #goban(b, players: (black: (stone: (
    shine: (opacity: 0.5, color: red)))))
  #goban(b, players: (black: (stone: (
    shine: false))))
  ```
]

#opcion("stone.shine.image", valor: [un archivo o un diccionario])[
  Un brillo propio: una imagen, centrada en la piedra, en lugar del brillo dibujado. Si la piedra también es una imagen, el brillo se dibuja encima y no gira con ella: las piedras pueden tener vetas giradas al azar y la luz siempre del mismo lado. Lo que no es un diccionario es el archivo; `none` la quita.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(white: "B2:D3",
      image: (file: path("img/pgfgo-yunzi-white-1.png"),
        rotate: "random"),
      shine: (on: true,
        image: path("img/pgfgo-shine.png"))))
  ```
]

#opcion("stone.shine.image.file", valor: [un archivo], inicial: `none`)[El archivo de la imagen.]
#opcion("stone.shine.image.width", valor: [`auto` o una longitud], inicial: `auto`)[El ancho de la imagen; el alto mantiene la proporción. Con `auto`, el diámetro de la piedra.]
#opcion("stone.shine.image.rotate", valor: [un ángulo], inicial: `0deg`)[Gira la imagen del brillo, igual en todas las piedras.]
#opcion("stone.shine.image.silhouette", valor: [`true` o `false`], inicial: `false`)[
  Usa solo la forma de la imagen (su transparencia), pintada con `shine.color`, en lugar de la imagen tal cual. Solo con PNG y JPEG.

  ```ejemplo
  #goban(size: 3, scale: 2,
    players: (black: (stone: (shine: (on: true,
      color: red, image: (
        file: path("img/pgfgo-shine.png"),
        silhouette: true))))),
    stones(black: "B1, C2", white: "A3"))
  ```
]

=== Piedras con imagen <piedras-imagen>

#opcion("stone.image", valor: [un archivo o un diccionario])[
  Dibuja la piedra con una imagen en lugar del círculo: no se dibujan el relleno ni el borde, y la imagen no tiene por qué ser redonda. Si el brillo está prendido, se dibuja encima de la imagen. La sombra se dibuja con la forma de la imagen; para eso la imagen tiene que tener transparencia (un PNG con canal alfa): la sombra de un JPEG es un rectángulo. Un prisionero con imagen se ve translúcido, como cualquier prisionero. Lo que no es un diccionario es el archivo; `none` la quita.

  Un archivo es un `path`, relativo al documento que lo nombra, o sus `bytes`: PNG, JPEG, GIF, WebP, SVG o PDF. La opacidad y las siluetas (la sombra con la forma de la imagen) solo se pueden con PNG y JPEG: las hace el kernel (#pag(<kernel>)). Las imágenes de los perfiles `shell`, `yunzi` y `baduktv` están en la carpeta `images` del paquete.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stone: (shadow: (on: true, angle: -45deg,
      offset: 1.5pt)),
    stones(black: "C2, D3", image:
      path("img/pgfgo-yunzi-black.png")),
    stones(white: "B4", image:
      path("img/pgfgo-yunzi-white-1.png")))
  ```

  Para todas las piedras de un jugador, la imagen va en sus opciones:

  ```ejemplo
  #goban-set(players: (
    black: (stone: (image:
      path("img/pgfgo-yunzi-black.png"))),
    white: (stone: (image:
      path("img/pgfgo-yunzi-white-1.png")))))

  #goban(size: 5, partial: "B2:D4",
    moves("C3, D3, C2, B3", numbers: false))
  ```
]

#opcion("stone.image.file", valor: [un archivo o un arreglo], inicial: `none`)[
  El archivo de la imagen. Con varios archivos, cada piedra usa uno, elegido por su lugar: una piedra en un punto muestra siempre la misma imagen, en todos los diagramas.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(white: "B2:D3", image: (
      path("img/pgfgo-yunzi-white-1.png"),
      path("img/pgfgo-yunzi-white-2.png"))))
  ```
]

#opcion("stone.image.width", valor: [`auto` o una longitud], inicial: `auto`)[El ancho de la imagen; el alto mantiene la proporción. Con `auto`, el diámetro de la piedra: 2 × `radius` × `scale`.]

#opcion("stone.image.rotate", valor: [un ángulo, `"random"` o `(mínimo, máximo)`], inicial: `0deg`)[
  Gira la imagen, en sentido antihorario. Con `"random"`, cada piedra se gira un ángulo distinto, elegido por su lugar: una piedra en un punto queda siempre igual, en todos los diagramas. Con un rango `(mínimo, máximo)`, el ángulo se elige igual, entre esos dos (`"random"` es `(0deg, 360deg)`). La sombra gira con la imagen, pero sigue cayendo hacia el mismo lado.

  ```ejemplo
  #let concha = path("img/pgfgo-yunzi-white-1.png")

  #goban(size: 5, partial: "B2:D4",
    stones(white: "B2:D3", image: (file: concha,
      rotate: "random")))
  #goban(size: 5, partial: "B2:D4",
    stones(white: "B2:D3", image: (file: concha,
      rotate: (-20deg, 20deg))))
  ```
]

#opcion("stone.image.opacity", valor: [un número de 0 a 1], inicial: `1`)[
  La opacidad de la imagen. Se multiplica por la del relleno: así, un prisionero con imagen es translúcido.

  ```ejemplo
  #let negra = path("img/pgfgo-yunzi-black.png")

  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2", image: negra),
    stones(black: "D3", image: (file: negra,
      width: 8pt)),
    stones(white: "B4", image: (opacity: 0.5,
      file: path("img/pgfgo-yunzi-white-1.png"))))
  ```
]

=== Las demás opciones de las piedras

#opcion("mark", valor: [una forma o un diccionario], inicial: `none`)[
  Una marca sobre las piedras, con la forma (`"triangle"`) o, con opciones, un diccionario con la forma en `shape` y las opciones de las marcas (#pag(<marcas>)): `mark: (shape: "circle", line: (color: red))`. Es una opción de `stones`, `prisoners` y `moves`, no de la rama `stone`.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", mark: "triangle"),
    stones(white: "B4", mark: (shape: "custom",
      content: [!], label: (text: (fill: red)))))
  ```
]

#opcion("forget", valor: [`true` o `false`], inicial: `false`)[
  `resume` no trae estas piedras (#pag(<memoria>)). `goban-view` las dibuja solo con `forgotten`. Es una opción de `stones`, `prisoners` y `moves` (donde también puede ser `"number"`, #pag(<jugadas>)), de `marks`, `arrows`, `lines` y `territory`.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")

  #let a = board(stones(black: "C2, D3"),
    stones(white: "B4", forget: true))
  #goban(resume: a)
  ```
]

== Jugadas <jugadas>

#funcion("moves(jugadas, black: ..., white: ..., ..opciones)")[
  Juega las intersecciones en el orden en que se escriben, alternando negras y blancas, y las numera. Sin jugador, siguen el turno: `moves("C3, D4")`; con uno, empiezan con él: `moves(white: "D2, B3")`. Recibe una sola secuencia. Una intersección puede repetirse (por ejemplo, para retomar un ko con `captures`). Acepta la sintaxis de `stones` (#pag(<coordenadas>)) y juega cada elemento en su orden (#pag(<orden-coordenadas>)): un camino (`A1 -- A3 -- C3`) va de su primer punto al último, y un tramo, del primer extremo al segundo. Lo que no tiene un recorrido fijo (rectángulos, `r`, columnas y filas enteras, `*`) se juega igual. El `;` es un error: `moves` solo agrega jugadas.

  ```ejemplo
  #goban(size: 5,
    moves("B1 -| D3, C:A 4, E5"))
  ```

  Las opciones son las del estilo de la piedra (`fill`, `line`, `radius`, `shine`, `image`…), `mark`, `forget` y las de esta sección: `numbers`, `label` y `from`.
]

Dentro de un mismo `goban`, la numeración y el turno siguen de un `moves` al siguiente. Cada `goban` empieza en la jugada 1 con negras; para continuar una partida en otro diagrama, se usan `from` y el jugador, o `resume` (#pag(<memoria>)).

Las opciones de las piedras sirven, por ejemplo, para marcar la última jugada:

```ejemplo
#goban(size: 5, partial: "B2:D4",
  moves("C3, D3, C2", numbers: false),
  moves("B3", numbers: false, mark: "circle"))
```

El estilo de las jugadas de los tres jugadores se cambia con `goban-set(move: ...)`, que es `goban-set(players: (all: (move: ...)))`.

#opcion("from", valor: [un número])[
  El número de la primera jugada de este `moves`. Las siguientes siguen desde ahí.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    moves("C2, B4", from: 7),
    moves("D3"))
  ```
]

#opcion("move.numbers", valor: [`true` o `false`], inicial: `true`)[
  Si las jugadas llevan su número. Sin números, las jugadas igual cuentan: la siguiente sigue la numeración y el turno. En `moves(numbers: false)`, vale para esas jugadas; con `goban-set(move: (numbers: false))` o `goban(move: (numbers: false))`, para todas las que siguen.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    moves("C3, D3", numbers: false),
    moves("C2, B3"))
  #goban(size: 5, partial: "B2:D4",
    move: (numbers: false),
    moves("C3, D3"),
    moves("C2, B3", numbers: true))
  ```
]

#opcion("move.label", valor: [un diccionario])[
  Los números de las jugadas.

  ```ejemplo
  #goban(size: 3,
    players: (white: (move: (label: (
      text: (fill: red, style: "italic"),
      size: 6pt)))),
    moves("A1, B2, C3, A3"))
  ```
]

#opcion("move.label.format", valor: [un patrón de `numbering`], inicial: `"1"`)[
  El formato de los números: un patrón de `numbering` de Typst, como `"1"`, `"a"`, `"A"`, `"i"`, `"I"` o `"一"` (los kanji necesitan una fuente que los tenga).

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    move: (label: (format: "a")),
    moves("C2, B4", from: 7), moves("D3"))
  #goban(size: 5, partial: "B2:D4",
    move: (label: (format: "I")),
    moves("C2, B4", from: 7), moves("D3"))
  #goban(size: 5, partial: "B2:D4",
    move: (label: (format: "一",
      text: (font: "MS Gothic"))),
    moves("C2, B4", from: 7), moves("D3"))
  ```
]

#opcion("move.label.size", valor: [`auto` o una longitud], inicial: `auto`)[
  El tamaño de los números. Con `auto`, se ajusta según la cantidad de cifras.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    moves("C2, B4", from: 7),
    moves("D3", label: (size: 0.5em)))
  ```
]

#opcion("move.label.text", valor: [un diccionario], inicial: `(weight: "bold", fill: ...)`)[
  Las opciones de `text` de los números: la fuente, el peso, el color. El color es el contrario al de la piedra: blanco en las negras y negro en las blancas.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    moves("C2, B4", label: (text: (fill: red))),
    moves("D3", label: (text: (fill: blue))))
  ```
]

#opcion("forget", valor: [`true`, `false` o `"number"`], inicial: `false`)[
  En `moves`: con `true`, `resume` no trae estas jugadas, ni la piedra ni el número, y la numeración sigue desde la última jugada que trae. Con `"number"`, la jugada viene sin su número aunque se pida `numbers` (#pag(<memoria>)); con `goban-view`, el número solo se ve con `forgotten`.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")

  #let a = board(moves("C2"),
    moves("B4", forget: "number"),
    moves("D3"))
  #goban(resume: (board: a, numbers: true),
    moves("C:D4"))
  ```
]

== Prisioneros <prisioneros>

Los prisioneros son piedras capturadas que siguen en el tablero: por defecto, translúcidas.

#funcion("prisoners(coordenadas, black: ..., white: ..., neutral: ..., ..opciones)")[
  Como `stones`, con el estilo de los prisioneros: el de la piedra del jugador, con la rama `prisoner` encima.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2"),
    prisoners(black: "D3", white: "B4"))
  ```
]

#opcion("prisoner", valor: [opciones de piedra], inicial: `(fill: (opacity: 0.5))`)[
  El estilo de los prisioneros: opciones de la rama `stone`, que se ponen encima de las de la piedra del jugador. Con `goban-set(prisoner: ...)`, para los tres jugadores; con `goban-set(players: (white: (prisoner: ...)))`, para uno. Vale para los de `prisoners` y para las piedras capturadas con `captures: "fade"` (#pag(<capturas>)). Las demás piedras del jugador no cambian.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")

  #goban(prisoner: (fill: (opacity: 0.2),
      line: (color: red)),
    stones(black: "C2"),
    prisoners(black: "D3", white: "B4"))
  #goban(players: (white: (prisoner: (
      line: (color: red)))),
    stones(white: "B3"),
    prisoners(black: "C3", white: "D3"))
  ```
]
