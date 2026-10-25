#import "../estilo.typ": *
#import "/lib.typ": *

= Marcas, flechas y líneas <marcas>

Las marcas van sobre una intersección, con o sin piedra: formas (círculo, triángulo, cruz…), números en secuencia o cualquier contenido.

#funcion("marks(coordenadas, forma: ..., ..opciones)")[
  Pone marcas en las intersecciones, escritas con la sintaxis de coordenadas (#pag(<coordenadas>)). La forma es la clave: `marks(triangle: "C3", circle: "E5")`. Sin forma, una cruz: `marks("C3")`. Un mismo `marks` puede llevar varias formas, y sus opciones valen para todas.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, marks("C3"))
  #goban(b, marks(triangle: "C2",
    circle: "B4", square: "C3"))
  ```

  Sin `player`, una marca sobre una piedra es del jugador de la piedra, con su estilo, para que se vea; sobre un punto vacío, es neutral. Sobre un punto vacío, la marca tapa la cuadrícula con el fondo del tablero (salvo `t-circle`, `t-square` y `dim`).
]

== Las formas

#let formas = ("circle", "triangle", "square", "cross", "filled-square", "filled-circle", "t-circle", "t-square",
  "hatched-lines", "dim")

Las formas del paquete son `circle`, `triangle`, `square`, `cross`, `filled-square`, `filled-circle`, `t-circle`, `t-square`, `hatched-lines`, `dim`, `sequence` y `custom`. Las de la opción `shapes` (#pag(<formas-propias>)) se usan igual.

#align(center, table(columns: 5, stroke: none, align: center, row-gutter: 4pt,
  ..formas.map(f => stack(spacing: 4pt,
    goban(size: 3, scale: 1.2, partial: "A1:C2", stones(black: "A1", white: "C1"),
      marks(..((f): "A1, B1, C1"))),
    raw(f)))))

#opcion("circle")[Un círculo.]
#opcion("triangle")[Un triángulo.]
#opcion("square")[Un cuadrado.]
#opcion("cross")[Una cruz. Es la forma de `marks` sin forma.]
#opcion("filled-square")[Un cuadrado relleno, con el relleno de la marca (`fill`).]
#opcion("filled-circle")[Un círculo relleno, con el relleno de la marca.]
#opcion("t-circle")[Un círculo pequeño, con el relleno de las piedras del jugador y el borde de la cuadrícula. Es la marca del territorio de las negras.]
#opcion("t-square")[Como `t-circle`, pero cuadrado. Es la marca del territorio de las blancas y de los puntos neutrales.]
#opcion("hatched-lines")[Un tramado de líneas, del color del relleno de la marca.]
#opcion("dim")[
  Atenúa el punto: lo cubre con el fondo del tablero, translúcido, sobre la piedra y la cuadrícula. Es lo que dibuja una partida para la propiedad `DD`.

  ```ejemplo
  #goban(size: 5,
    stones(black: "B2, C3", white: "D4"),
    marks(dim: "A1:5, B2"))
  ```
]

#opcion("sequence")[
  Numera las marcas, en el orden de las coordenadas (#pag(<orden-coordenadas>)), desde `from`. El formato, el tamaño y el color de los números son los de `label`, como el contenido de `custom`.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(sequence: "C3, B3, C4"),
    marks(sequence: "B2, D2, D4",
      label: (format: "A",
        text: (weight: "bold"))))
  ```
]

#opcion("from", valor: [un número], inicial: `1`)[
  En `marks`, el número de la primera marca de `sequence`.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(sequence: "C3, B3, C4", from: 3))
  ```
]

#opcion("custom")[
  Una marca con cualquier contenido, el de `content`: un texto, un símbolo («!», «?») o un dibujo.
]

#opcion("content", valor: [un contenido])[
  En `marks`, lo que dibuja `custom`. Es obligatorio con `custom`. Su tamaño se ajusta a la cantidad de caracteres, salvo con `label.size`.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, marks(custom: "C3",
    content: [!]))
  #goban(b, marks(custom: "C3",
    content: box(stroke: red, radius: 2pt,
      inset: 1pt, text(fill: red)[…])))
  ```
]

== Las opciones de las marcas

El estilo de las marcas es el de su jugador: `goban-set(mark: ...)` es `goban-set(players: (all: (mark: ...)))`, y las opciones de cada `marks` van encima.

#opcion("player", valor: [`auto`, `"black"`, `"white"` o `"neutral"`], inicial: `auto`)[
  El jugador de las marcas, cuyo estilo toman. Con `auto`, el de la piedra que hay en el punto, o neutral si no hay ninguna.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(t-square: "B2, C3", player: "black"),
    marks(t-square: "D2, B3", player: "white"),
    marks(t-square: "D4", player: "neutral"),
    marks(triangle: "C2, D3, B4"))
  ```
]

#opcion("mark.scale", valor: [un número], inicial: `1`)[
  El tamaño de la marca respecto del de siempre: las formas, las imágenes y el texto.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2"),
    marks(triangle: "C2, B3", scale: 1.5),
    marks(circle: "D4", scale: 0.6))
  ```
]

#opcion("mark.line", valor: [un diccionario])[El trazo de la marca.]
#opcion("mark.line.color", valor: [un color])[
  El color del trazo: blanco en las marcas de las negras y negro en las demás.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(triangle: "C3",
      line: (color: red)))
  ```
]

#opcion("mark.line.width", valor: [una longitud], inicial: `1pt`)[
  El grosor del trazo.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(triangle: "C3", line: (width: 0.3pt)),
    marks(triangle: "B4", line: (width: 2pt)))
  ```
]

#opcion("mark.line.opacity", valor: [un número de 0 a 1], inicial: `1`)[La opacidad del trazo.]

#opcion("mark.fill", valor: [`true`, `false` o un diccionario])[El relleno de las marcas rellenas (`filled-square`, `filled-circle` y `hatched-lines`), y el `fill` de las formas propias (#pag(<formas-propias>)). Con `false`, las marcas rellenas no se ven.]
#opcion("mark.fill.color", valor: [un color o `none`], inicial: `luma(50%)`)[
  El color del relleno.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(filled-circle: "C3",
      fill: (color: red)))
  ```
]

#opcion("mark.fill.opacity", valor: [un número de 0 a 1], inicial: `1`)[
  La opacidad del relleno.

  ```ejemplo
  #goban(size: 3,
    players: (white: (mark: (
      fill: (color: red, opacity: 0.5),
      line: (opacity: 0.3)))),
    stones(white: "A1"),
    marks(filled-square: "A1, B2",
      player: "white"),
    marks(triangle: "C3, A3", player: "white"))
  ```
]

#opcion("mark.fill.pattern", valor: [`none` o un `tiling`], inicial: `none`)[
  Un patrón encima del color del relleno de `filled-square` y `filled-circle`, como `stone.fill.pattern` (#pag(<piedras>)). `hatched-lines` y las formas propias usan solo el color.

  ```ejemplo
  #goban(size: 3,
    marks(filled-square: "A1, B2", fill: (
      color: yellow, pattern: tiling(
        size: (2pt, 2pt), square(size: 1pt,
          fill: black)))),
    marks(filled-circle: "C3", fill: (
      color: none, pattern: tiling(
        size: (2pt, 2pt), line(length: 2pt,
          stroke: red)))))
  ```
]

#opcion("mark.label", valor: [un diccionario])[El texto de las marcas que lo tienen: `sequence` y `custom`.]
#opcion("mark.label.format", valor: [un patrón de `numbering`], inicial: `"1"`)[
  El formato de los números de `sequence`: un patrón de `numbering`, como `"1"`, `"a"`, `"A"`, `"i"`, `"I"` o `"一"`. Los kanji necesitan una fuente que los tenga, en `label.text`.

  ```ejemplo
  #goban(size: 3, scale: 1.6,
    marks(sequence: "A1, B2, C3", from: 9,
      label: (format: "一",
        text: (font: "MS Gothic"))))
  ```
]

#opcion("mark.label.size", valor: [`auto` o una longitud], inicial: `auto`)[El tamaño del texto. Con `auto`, se ajusta según la cantidad de caracteres.]
#opcion("mark.label.text", valor: [un diccionario])[
  Las opciones de `text` del texto: la fuente, el estilo, el color. El color es el de `line.color`.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(sequence: "C3, B3, C4",
      label: (text: (style: "italic"))),
    marks(custom: "D4", content: [!],
      label: (text: (fill: red))))
  ```
]

#opcion("forget", valor: [`true` o `false`], inicial: `false`)[En `marks`, `arrows` y `lines`: `resume` no trae estas marcas, flechas o líneas, aunque se pida `marks` (#pag(<memoria>)).]

== Formas propias <formas-propias>

#opcion("shapes", valor: [un diccionario de formas], inicial: `(:)`)[
  Formas de marca propias, por su nombre: `shapes: (rombo: ..., estrella: ...)`. Se usan como las del paquete: en `marks`, en la opción `mark` de las piedras, en `territory` y en `last-mark`. Una forma con el nombre de otra la reemplaza. Ninguna puede llamarse como una opción de `marks` (`line`, `fill`, `label`, `scale`, `player`, `from`, `content` o `forget`). Una forma es:

  - una función: recibe un diccionario con `radius` (el radio de la piedra del jugador, con `scale`), `stroke` (el trazo de la marca), `fill` (su relleno, `none` si está apagado) y `color` (el color de sus líneas), y lo que devuelve se dibuja con su origen en el punto;
  - un contenido, centrado en el punto;
  - una imagen, `(image: archivo)` o `(image: (file: archivo, width: ...))`, centrada en el punto, sin los colores de la marca. `width` es su ancho (con `auto`, 1.2 radios de piedra), que cambia con `scale`. Con varios archivos, cada punto usa uno, siempre el mismo.

  Sobre un punto vacío, una forma propia tapa la cuadrícula como las demás.

  ```ejemplo
  #goban-set(shapes: (
    rombo: m => polygon(fill: m.fill,
      stroke: m.stroke,
      (0pt, -0.7 * m.radius),
      (0.7 * m.radius, 0pt),
      (0pt, 0.7 * m.radius),
      (-0.7 * m.radius, 0pt)),
    barra: m => line(
      start: (-0.5 * m.radius, 0.5 * m.radius),
      end: (0.5 * m.radius, -0.5 * m.radius),
      stroke: m.stroke),
    estrella: (image: path("img/pgfgo-star.pdf")),
    ojo: text(fill: red, size: 8pt)[◉],
  ))

  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"),
    marks(rombo: "C2, B4, B2", barra: "D3, C3",
      estrella: "D4", ojo: "D2"))
  ```

  ```ejemplo
  #goban(size: 5, partial: "A1:E3",
    shapes: (concha: (image: (width: 1em,
      file: range(1, 6).map(n => path(
        "img/pgfgo-shell-white-" + str(n)
          + ".png"))))),
    marks(concha: "A:E 1:3"))
  ```
]

== Flechas y líneas <flechas>

Las flechas y las líneas unen dos intersecciones. Se dibujan encima de las piedras, con un halo del color del fondo del tablero que las separa de las piedras y de la cuadrícula. Una partida dibuja las flechas (`AR`) y las líneas (`LN`) del archivo.

#funcion("arrows(..pares, ..opciones)")[
  Dibuja flechas, cada una de una intersección a otra: `arrows(("B3", "F3"), ("C7", "G9"))`. Las opciones valen para todas.

  ```ejemplo
  #goban(stones(black: "C3, D3", white: "E5"),
    arrows(("B3", "F3")),
    arrows(("C7", "G9"), color: red,
      halo: false))
  ```
]

#funcion("lines(..pares, ..opciones)")[
  Dibuja líneas, cada una de una intersección a otra. Tiene las opciones de `arrows`, salvo `tip` y `tips`.

  ```ejemplo
  #goban(stones(black: "C3, D4", white: "E5"),
    lines(("C3", "G7")),
    lines(("A9", "J9"), color: blue, width: 2pt))
  ```
]

El estilo de todas las flechas se fija con `goban-set(arrow: ...)`, y el de todas las líneas, con `goban-set(line: ...)`.

#opcion("arrow.color", valor: [un color], inicial: `black`)[El color de la flecha.]
#opcion("arrow.width", valor: [una longitud], inicial: `1.2pt`)[El grosor de la flecha. La punta crece con él.]
#opcion("arrow.opacity", valor: [un número de 0 a 1], inicial: `1`)[
  La opacidad de la flecha.

  ```ejemplo
  #goban(size: 5,
    stones(black: "C2, C4", white: "D3"),
    arrows(("A1", "E1"), width: 0.4pt),
    arrows(("A3", "E3"), color: blue,
      width: 2.5pt),
    arrows(("A5", "E5"), color: red,
      opacity: 0.4, width: 2.5pt))
  ```
]

#opcion("arrow.dash", valor: [`"solid"`, `"dashed"` o `"dotted"`], inicial: `"solid"`)[El trazo: continuo, con guiones o con puntos. El halo y la punta son siempre continuos.]
#opcion("arrow.shorten", valor: [una longitud], inicial: `0pt`)[
  Acorta los dos extremos.

  ```ejemplo
  #goban(size: 5,
    stones(black: "B2", white: "D4"),
    arrows(("B2", "D4"), shorten: 5pt),
    arrows(("A5", "E5"), dash: "dashed",
      tips: "both"),
    lines(("A1", "E1"), dash: "dotted"))
  ```
]

#opcion("arrow.bend", valor: [un ángulo], inicial: `0deg`)[
  Dibuja un arco en lugar de una recta: la flecha sale girada ese ángulo hacia la izquierda y llega girada lo mismo. Con un ángulo negativo, se curva hacia la derecha.

  ```ejemplo
  #goban(size: 5,
    stones(black: "B2", white: "D4"),
    arrows(("B2", "D4"), bend: 40deg,
      shorten: 5pt),
    lines(("A1", "E1"), bend: -30deg))
  ```
]

#opcion("arrow.tip", valor: [`"stealth"`, `"triangle"` o `"circle"`], inicial: `"stealth"`)[La punta de la flecha.]
#opcion("arrow.tips", valor: [`"end"` o `"both"`], inicial: `"end"`)[
  Dónde va la punta: al final, o en los dos extremos.

  ```ejemplo
  #goban(size: 5,
    arrows(("A1", "E1")),
    arrows(("A3", "E3"), tip: "triangle",
      tips: "both"),
    arrows(("A5", "E5"), tip: "circle"))
  ```
]

#opcion("arrow.halo", valor: [`true`, `false` o un diccionario])[El halo alrededor de la flecha.]
#opcion("arrow.halo.color", valor: [`auto` o un color], inicial: `auto`)[El color del halo. Con `auto`, el del fondo del tablero.]
#opcion("arrow.halo.width", valor: [una longitud], inicial: `0.8pt`)[
  El ancho del halo a cada lado de la flecha.

  ```ejemplo
  #goban(size: 5,
    stones(black: "B1, B3, B5",
      white: "D1, D3, D5"),
    arrows(("A1", "E1"), halo: false),
    arrows(("A3", "E3")),
    arrows(("A5", "E5"), halo: (color: yellow,
      width: 2pt)))
  ```
]

Las líneas tienen las mismas opciones, en la rama `line`, salvo `tip` y `tips`:

#opcion("line.color", valor: [un color], inicial: `black`)[Como `arrow.color`.]
#opcion("line.width", valor: [una longitud], inicial: `1.2pt`)[Como `arrow.width`.]
#opcion("line.opacity", valor: [un número de 0 a 1], inicial: `1`)[Como `arrow.opacity`.]
#opcion("line.dash", valor: [`"solid"`, `"dashed"` o `"dotted"`], inicial: `"solid"`)[Como `arrow.dash`.]
#opcion("line.shorten", valor: [una longitud], inicial: `0pt`)[Como `arrow.shorten`.]
#opcion("line.bend", valor: [un ángulo], inicial: `0deg`)[Como `arrow.bend`.]
#opcion("line.halo", valor: [`true`, `false` o un diccionario])[Como `arrow.halo`, con `color` y `width`.]
