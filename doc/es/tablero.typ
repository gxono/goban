#import "../estilo.typ": *
#import "/lib.typ": *

= El tablero <tablero>

El tablero es lo que dibuja `goban`: la cuadrícula, el fondo, las coordenadas y todo lo que va encima.

#funcion("goban(..opciones, ..elementos)")[
  Dibuja un tablero. Los elementos son lo que va en él, en orden: piedras (`stones`, `prisoners`), jugadas (`moves`), marcas (`marks`), flechas y líneas (`arrows`, `lines`), territorio (`territory`) y partidas (`sgf-read`, `sgf`). Primero puede ir un tablero hecho con `board`: es ese tablero, con sus opciones y lo que tiene, y las opciones y los elementos del `goban` se le agregan. Las opciones van con nombre, y son las de `gobanist-set` (#pag(<configuracion>)): valen solo para este tablero. Por defecto, el tablero es de 9×9, con un borde visible, fondo blanco y sin coordenadas.

  ```ejemplo
  #goban()
  ```

  Las opciones del tablero (`size`, `use-i`, `partial`, `scale`, …) van en el primer nivel; las de sus partes, en sus ramas: `grid`, `hoshi`, `background` y `label`.

  ```ejemplo
  #goban(size: 19, partial: "K1:T9",
    label: (at: (top, right)),
    stones(black: "L8, S8, R5, S5, P4, R4, M3,
      P3, N2, O2",
      white: "L6, S4, S3, Q3, O1, P2, R2"),
    marks(circle: "L8"),
    arrows(("L8", "S8"), color: blue,
      shorten: 6pt))
  ```
]

#funcion("board(..opciones, ..elementos)")[
  Un tablero como valor: recibe lo mismo que `goban`, pero no dibuja nada. Se resuelve al dibujarlo, con las opciones globales del lugar donde se dibuja. Primero puede ir otro tablero hecho con `board`, como en `goban`: `board(base, moves("C3"))` es `base` con una jugada más. Se dibuja con `goban(tablero)`, en `goban-layout` (#pag(<disposicion>)) y con `goban-view` (#pag(<vistas>)); con `resume`, otro tablero sigue desde él (#pag(<memoria>)).

  ```ejemplo
  #let base = board(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", white: "B4"))

  #goban(base)
  #goban(base, moves("C3"),
    background: (line: false))
  ```
]

#opcion("size", valor: [un número o `(columnas, filas)`], inicial: `9`)[
  El tamaño del tablero: las líneas verticales y horizontales. Un número es un tablero cuadrado; `(5, 3)`, uno de 5 columnas y 3 filas. Las columnas van de 2 a 25, y las filas, de 2 a 99. Con una partida (`sgf-read`), el tablero toma el tamaño del archivo (`SZ`), y otro `size` es un error.

  ```ejemplo
  #goban(size: 5)
  #goban(size: (5, 3))
  ```
]

#opcion("use-i", valor: [`true` o `false`], inicial: `false`, etiqueta: <use-i>)[
  Usa la letra I en las coordenadas y en las etiquetas. Sin ella, como es costumbre en el go, las columnas pasan de la H a la J, y una I en las coordenadas es la J.

  ```ejemplo
  #gobanist-set(size: 13, label: (at: top))

  #goban(use-i: true, partial: "H1:M3",
    label: (at: (top, left)),
    stones(black: "J2"))
  #goban(partial: "H1:N3",
    stones(black: "J2"))
  // Sin use-i, I es J.
  #goban(partial: "H1:N3",
    label: (at: (top, right)),
    stones(white: "I2"))
  ```
]

#opcion("scale", valor: [un número], inicial: `1`)[
  La escala del tablero: sus medidas. El grosor de las líneas no cambia, salvo con `scale-line-width`.

  ```ejemplo
  #goban(size: 2, scale: 2,
    stones(black: "A1", mark: "cross"))
  #goban(size: 2,
    stones(black: "A1", mark: "cross"))
  #goban(size: 2, scale: 0.5,
    stones(black: "A1", mark: "cross"))
  ```
]

#opcion("scale-line-width", valor: [`true` o `false`], inicial: `false`)[
  Con `true`, `scale` multiplica también el grosor de las líneas: la cuadrícula, el borde, las piedras, las marcas, las flechas, las líneas y el territorio. Con `layout.fit`, que elige la escala para llenar la columna, el grosor no cambia (#pag(<disposicion>)).

  ```ejemplo
  #goban(size: 2, scale: 2,
    stones(black: "A1", mark: "cross"))
  #goban(size: 2, scale: 2,
    scale-line-width: true,
    stones(black: "A1", mark: "cross"))
  ```
]

== La cuadrícula

#opcion("grid", valor: [`true`, `false` o un diccionario])[
  La cuadrícula: las líneas del tablero. Con `false`, sin cuadrícula ni puntos de estrella.

  ```ejemplo
  #goban(size: 3,
    stones(black: "A1", white: "B2"))
  #goban(size: 3, grid: false,
    stones(black: "A1", white: "B2"))
  ```
]

#opcion("grid.line", valor: [`true`, `false` o un diccionario])[
  Las líneas. Con `false`, sin líneas, pero con los puntos de estrella (a diferencia de `grid: false`).

  ```ejemplo
  #goban(grid: (line: false),
    hoshi: (radius: 2pt),
    stones(black: "C3, E5"))
  ```
]

#opcion("grid.line.color", valor: [un color], inicial: `black`)[El color de las líneas.]
#opcion("grid.line.opacity", valor: [un número de 0 a 1], inicial: `1`)[La opacidad de las líneas.]
#opcion("grid.line.width", valor: [una longitud], inicial: `0.55pt`)[
  El grosor de las líneas.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, grid: (line: (color: blue)))
  #goban(b, grid: (line: (opacity: 0.2)))
  #goban(b, grid: (line: (width: 1.5pt)))
  ```
]

#opcion("grid.sep", valor: [una longitud o `(x: ..., y: ...)`], inicial: `(x: 12.5pt, y: 12.5pt)`)[
  La distancia entre las líneas: `x`, entre las verticales, e `y`, entre las horizontales. Una longitud sola va a las dos.

  ```ejemplo
  #goban(size: 5, grid: (sep: (x: 1.8em)),
    stones(black: "B2, C3", white: "D3"))
  #goban(size: 5, grid: (sep: 0.9em),
    stones(black: "B2, C3", white: "D3"))
  ```
]

#opcion("grid.image", valor: [un archivo o un diccionario])[
  Una imagen en lugar de las líneas, con la opacidad de `grid.line.opacity`. Con `partial` se ve la parte que corresponde. Los puntos de estrella se siguen dibujando (#pag(<hoshi>)). Lo que no es un diccionario es el archivo; `none` la quita.

  ```ejemplo
  #let grilla = path("img/pgfgo-grid.png")

  #goban(grid: (image: grilla), hoshi: false,
    stones(black: "C3", white: "D4"))
  #goban(grid: (image: grilla), hoshi: false,
    partial: "C3:G7")
  ```
]

#opcion("grid.image.file", valor: [un archivo o un arreglo], inicial: `none`)[
  El archivo: un `path` (relativo al documento que lo nombra) o sus `bytes`. Con varios archivos y `fit: "tile"`, cada baldosa usa uno, elegido por su lugar en la malla: siempre el mismo en cada lugar, en todos los diagramas. Con `"stretch"`, se usa el primero.

  ```ejemplo
  #goban(size: 5, hoshi: false,
    grid: (image: (fit: "tile", file: (
      path("img/pgfgo-cell.png"),
      path("img/pgfgo-tile.png")))))
  ```
]

#opcion("grid.image.fit", valor: [`"stretch"` o `"tile"`], inicial: `"stretch"`)[
  Con `"stretch"`, la imagen se estira desde A1 hasta la esquina opuesta del tablero completo: las líneas exteriores tienen que estar en los bordes de la imagen. Con `"tile"`, se dibuja una vez en cada casilla (entre cuatro intersecciones), estirada al tamaño de la casilla: con la imagen de un cuadrado se arma todo el tablero.

  ```ejemplo
  #goban(hoshi: false, grid: (image: (
      file: path("img/pgfgo-cell.png"),
      fit: "tile")),
    stones(black: "C3", white: "D4"))
  ```
]

#opcion("grid.image.tiles", valor: [`auto`, un número o `(columnas, filas)`], inicial: `auto`)[
  Con `fit: "tile"`, la malla en la que se repite la imagen, sobre el área que va de A1 a la esquina opuesta del tablero completo; cada imagen se estira al tamaño de su celda. Un número vale para las dos direcciones. Con `auto`, una imagen por casilla.

  ```ejemplo
  #goban(hoshi: false, grid: (image: (
    file: path("img/pgfgo-cell.png"),
    fit: "tile", tiles: 4)))
  ```
]

#opcion("grid.image.rotate", valor: [un ángulo, `"random"` o `(mínimo, máximo)`], inicial: `0deg`)[
  Gira la imagen, como `background.fill.image.rotate`: en cuartos de vuelta, y con `"random"` o un rango, cada baldosa con el suyo.
]

== Puntos de estrella <hoshi>

Los puntos de estrella (_hoshi_) se dibujan sobre la cuadrícula, con su color. Por defecto son los de siempre: en cada lado, la cuarta línea desde el borde (la tercera en los tableros de menos de 13 líneas); el centro si los dos lados son impares; y, desde 15 líneas, el medio de los lados. En un tablero de 19 hay nueve, y en uno de 13 o de 9, cinco. Los tableros de menos de 7 líneas no tienen. Las piedras los tapan.

#opcion("hoshi", valor: [`true`, `false` o un diccionario])[
  Los puntos de estrella.

  ```ejemplo
  #goban(stones(black: "C3, E5"))
  #goban(hoshi: false, stones(black: "C3, E5"))
  ```
]

#opcion("hoshi.radius", valor: [una longitud], inicial: `1.5pt`)[El radio de los puntos.]
#opcion("hoshi.color", valor: [`auto` o un color], inicial: `auto`)[El color de los puntos. Con `auto`, el de la cuadrícula.]
#opcion("hoshi.opacity", valor: [`auto` o un número de 0 a 1], inicial: `auto`)[
  La opacidad de los puntos (también la de su imagen). Con `auto`, la de la cuadrícula.

  ```ejemplo
  #goban(hoshi: (radius: 2.5pt, color: red))
  #goban(hoshi: (radius: 3pt, opacity: 0.3),
    stones(black: "C3"))
  ```
]

#opcion("hoshi.at", valor: [`auto` o coordenadas], inicial: `auto`)[
  Los puntos, con la sintaxis de `stones` (#pag(<coordenadas>)). Con `auto`, los de siempre.

  ```ejemplo
  #goban(hoshi: (at: "C3, G7"))
  ```
]

#opcion("hoshi.image", valor: [un archivo o un diccionario])[
  Una imagen en cada punto, en lugar del círculo. Lo que no es un diccionario es el archivo; `none` la quita.

  ```ejemplo
  #goban(hoshi: (radius: 3pt,
    image: path("img/pgfgo-hoshi.png")))
  ```
]

#opcion("hoshi.image.file", valor: [un archivo], inicial: `none`)[El archivo de la imagen.]
#opcion("hoshi.image.width", valor: [`auto` o una longitud], inicial: `auto`)[El ancho de la imagen; el alto mantiene la proporción. Con `auto`, el diámetro de los puntos.]
#opcion("hoshi.image.rotate", valor: [un ángulo, `"random"` o `(mínimo, máximo)`], inicial: `0deg`)[
  Gira la imagen, en sentido antihorario. Con `"random"` o un rango, cada punto con su ángulo, siempre el mismo (#pag(<piedras-imagen>)).

  ```ejemplo
  #let hoshi = path("img/pgfgo-hoshi.png")

  #goban(hoshi: (image: (file: hoshi,
    width: 8pt)))
  #goban(hoshi: (image: (file: hoshi,
    width: 8pt, rotate: 45deg)))
  ```
]

== El fondo

El fondo del tablero es el rectángulo que va debajo de la cuadrícula, con su relleno y su borde. Por defecto, el relleno es blanco y el borde, negro.

#opcion("background", valor: [`true`, `false` o un diccionario])[
  El fondo: el relleno y el borde. Con `false`, sin fondo.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b)
  #goban(b, background: false)
  ```
]

#opcion("background.fill", valor: [`true`, `false` o un diccionario])[
  El relleno. Con `false`, el fondo es transparente y queda solo el borde.
]

#opcion("background.fill.color", valor: [un color], inicial: `white`)[El color del relleno.]
#opcion("background.fill.opacity", valor: [un número de 0 a 1], inicial: `1`)[
  La opacidad del relleno, también la de su imagen.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, background: (fill: false))
  #goban(b, background: (fill: (
    color: orange.lighten(60%))))
  #goban(b, background: (fill: (
    color: orange.lighten(60%), opacity: 0.5)))
  ```
]

#opcion("background.fill.pattern", valor: [`none` o un `tiling`], inicial: `none`)[
  Un patrón encima del color y de la imagen del fondo: un `tiling` de Typst. Las marcas sobre puntos vacíos y la marca `dim`, que tapan la cuadrícula con el fondo, repiten el patrón.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    background: (fill: (pattern: tiling(
      size: (4pt, 4pt),
      circle(radius: 0.6pt, fill: gray)))),
    stones(black: "C2, D3"),
    marks(triangle: "C3"))
  ```
]

#opcion("background.fill.image", valor: [un archivo o un diccionario])[
  Una imagen de fondo (por ejemplo, la madera de un tablero), sobre el color de relleno y con su misma opacidad. La imagen se ubica según el tablero completo: con `partial` se ve la parte que le corresponde, recortada por el borde y sus esquinas redondeadas. Las marcas sobre puntos vacíos, que tapan la cuadrícula con el fondo, muestran la parte de la imagen que hay debajo, y lo mismo hace la marca `dim`. Lo que no es un diccionario es el archivo; `none` la quita.

  ```ejemplo
  #let madera = path("img/pgfgo-board.jpg")

  #goban(background: (fill: (image: madera)),
    stones(black: "C3", white: "D4"),
    marks(circle: "E5, C3"))
  #goban(partial: "A1:E5", background: (
      fill: (image: madera),
      rounded-corners: 6pt),
    marks(triangle: "C3"))
  ```
]

#opcion("background.fill.image.file", valor: [un archivo o un arreglo], inicial: `none`)[
  El archivo de la imagen. Con varios archivos y `fit: "tile"`, cada baldosa usa uno, elegido por su lugar: siempre el mismo en cada lugar, también con `partial`. Las baldosas tienen el tamaño de la primera imagen (o el de su celda, con `tiles`). Con `"stretch"` y `"cover"`, se usa el primero.

  ```ejemplo
  #goban(background: (fill: (image: (
    file: (path("img/pgfgo-tile.png"),
      path("img/pgfgo-cell.png"),
      path("img/pgfgo-board.jpg")),
    fit: "tile", width: 1cm))))
  ```
]

#opcion("background.fill.image.fit", valor: [`"cover"`, `"stretch"` o `"tile"`], inicial: `"cover"`)[
  Cómo ocupa la imagen el fondo del tablero completo. `"stretch"` la estira hasta ocupar todo el fondo, sin mantener la proporción. `"cover"` la agranda o la achica, manteniendo la proporción, hasta cubrir el fondo, centrada: lo que sobra no se ve. `"tile"` la repite como baldosas, desde una esquina, un borde o el centro del tablero completo (`anchor`).

  ```ejemplo
  #let baldosa = (file: path("img/pgfgo-tile.png"),
    fit: "tile", width: 1cm)

  #goban(background: (fill: (image: baldosa)))
  #goban(partial: "D4:H8",
    background: (fill: (image: baldosa)))
  ```
]

#opcion("background.fill.image.anchor", valor: [una alineación], inicial: `bottom + left`)[
  Con `fit: "tile"`, desde dónde se ponen las baldosas, en el fondo del tablero completo. Con una esquina (`bottom + left`, `top + right`…), en esa esquina queda una baldosa entera. Con un borde (`top`, `bottom`, `left` o `right`), la primera baldosa queda contra ese borde, centrada a lo largo de él. Con `center`, una baldosa queda en el centro del tablero.

  ```ejemplo
  #let baldosa = (file: path("img/pgfgo-tile.png"),
    fit: "tile", width: 1cm)

  #goban(size: 5, background: (fill: (
    image: baldosa + (anchor: top + right))))
  #goban(size: 5, background: (fill: (
    image: baldosa + (anchor: top))))
  ```
]

#opcion("background.fill.image.width", valor: [`auto` o una longitud], inicial: `auto`)[Con `fit: "tile"`, el ancho de cada baldosa; el alto mantiene la proporción. Con `auto`, el ancho natural de la imagen.]

#opcion("background.fill.image.tiles", valor: [`auto`, un número o `(columnas, filas)`], inicial: `auto`)[
  Con `fit: "tile"`, en lugar de baldosas de ancho `width` desde `anchor`, divide el fondo del tablero completo en esa malla y pone la imagen en cada celda, estirada a su tamaño. Un número vale para las dos direcciones.

  ```ejemplo
  #goban(background: (fill: (image: (
    file: path("img/pgfgo-cell.png"),
    fit: "tile", tiles: (3, 3)))))
  ```
]

#opcion("background.fill.image.rotate", valor: [un ángulo, `"random"` o `(mínimo, máximo)`], inicial: `0deg`)[
  Gira la imagen en cuartos de vuelta: el ángulo se redondea a 0, 90, 180 o 270 grados, para que la imagen girada siga ocupando su lugar sin dejar huecos. Con 90 o 270, el ancho y el alto se intercambian. Con `"random"` o un rango, cada baldosa tiene su propio giro, siempre el mismo.

  ```ejemplo
  #let madera = path("img/pgfgo-board.jpg")

  #goban(size: 5, background: (fill: (image: (
    file: madera, rotate: 90deg))))
  #goban(size: 5, background: (fill: (image: (
    file: madera, fit: "tile", width: 1cm,
    rotate: "random"))))
  ```
]

#opcion("background.line", valor: [`true`, `false` o un diccionario])[El borde. Con `false`, sin borde.]
#opcion("background.line.color", valor: [un color], inicial: `black`)[El color del borde.]
#opcion("background.line.opacity", valor: [un número de 0 a 1], inicial: `1`)[La opacidad del borde.]
#opcion("background.line.width", valor: [una longitud], inicial: `0.75pt`)[
  El grosor del borde.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, background: (line: false))
  #goban(b, background: (line: (
    color: red, opacity: 0.5)))
  #goban(b, background: (line: (
    width: 1.5pt)))
  ```
]

#opcion("background.rounded-corners", valor: [una longitud o `(outer: ..., inner: ...)`], inicial: `(outer: 0pt, inner: 0pt)`)[
  El radio de las esquinas del fondo: `outer`, el de las esquinas del tablero, e `inner`, el de las que se ven en un tablero parcial. Una longitud sola va a las dos.

  ```ejemplo
  #gobanist-set(size: 5, partial: "A1:C3")
  #let b = board(stones(black: "B1, C2", white: "A3"))

  #goban(b, background: (
    rounded-corners: 10pt))
  #goban(b, background: (
    rounded-corners: (outer: 8pt, inner: 2pt)))
  ```
]

#opcion("background.sep", valor: [una longitud], inicial: `8.25pt`)[
  La distancia entre la cuadrícula y el borde.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, background: (sep: 0.625em))
  #goban(b, background: (sep: 1.5em))
  ```
]

#opcion("background.shadow", valor: [`true`, `false` o un diccionario])[
  Una sombra debajo del tablero.

  ```ejemplo
  #gobanist-set(size: 5, partial: "B2:D4")
  #let b = board(stones(black: "C2, D3", white: "B4"))

  #goban(b, background: (shadow: true))
  #goban(b, background: (shadow: (
    on: true, color: blue, opacity: 0.3,
    angle: 45deg, offset: 4pt)))
  ```
]

#opcion("background.shadow.angle", valor: [un ángulo], inicial: `-45deg`)[Hacia dónde cae la sombra: con `0deg`, a la derecha; con `-45deg`, abajo a la derecha.]
#opcion("background.shadow.offset", valor: [una longitud], inicial: `1.5pt`)[La distancia entre el tablero y su sombra.]
#opcion("background.shadow.opacity", valor: [un número de 0 a 1], inicial: `0.5`)[La opacidad de la sombra.]
#opcion("background.shadow.color", valor: [un color], inicial: `black`)[El color de la sombra.]

== Tablero parcial <parcial>

Muchas veces no hace falta el tablero completo, sino una parte. `partial` la define con dos esquinas opuestas de un rectángulo, en cualquier orden: `"A1:D3"` es lo mismo que `"D3:A1"`, y que `"A3:D1"`.

#opcion("partial", valor: [`none`, `"A1:D3"` o `auto`], inicial: `none`)[
  Muestra solo una parte del tablero: el rectángulo que tiene esas dos intersecciones como esquinas opuestas. Lo que cae fuera no se dibuja. Con `auto`, la parte la elige el tablero: la que usan las piedras, jugadas, marcas, flechas, líneas y territorios que se dibujan, con `partial-margin` líneas más. Con `none`, el tablero completo.

  ```ejemplo
  #goban(partial: "A1:D3",
    arrows(("A1", "D3"), color: red))
  #goban(partial: "A9:J6",
    arrows(("A9", "J6"), color: red))
  #goban(partial: "E2:B4",
    arrows(("E2", "B4"), color: red))
  ```
]

#opcion("partial-margin", valor: [un número], inicial: `1`)[
  Las líneas que `partial: auto` agrega alrededor de lo dibujado. Un lado que queda a dos líneas o menos del borde llega hasta el borde. Sin nada dibujado, se ve todo el tablero.

  ```ejemplo
  #goban(size: 19, partial: auto,
    moves("Q16, R14, R16, P17"))
  #goban(size: 19, partial: auto,
    partial-margin: 0,
    stones(black: "J10, K11", white: "K9"))
  ```
]

== Las coordenadas del borde <etiquetas>

Las etiquetas son las coordenadas que se escriben a los lados del tablero.

#opcion("label.at", valor: [una alineación o un arreglo], inicial: `()`)[
  En qué lados van las etiquetas: `top`, `bottom`, `left` y `right`, o un arreglo de ellos. Arriba y abajo van las columnas; a los costados, las filas. Con `()`, sin etiquetas.

  ```ejemplo
  #goban(size: 12,
    label: (at: (top, bottom, left, right)))
  #goban(partial: "A6:J9", label: (at: top))
  #goban(partial: "B2:E4",
    label: (at: (top, right)))
  ```
]

#opcion("label.text", valor: [un diccionario], inicial: `(size: 10pt)`)[
  Las opciones de `text` de las etiquetas: la fuente, el tamaño, el color.

  ```ejemplo
  #gobanist-set(size: 5)

  #goban(label: (at: (bottom, left),
    text: (size: 6pt)))
  #goban(label: (at: (bottom, right),
    text: (weight: "bold", fill: red)))
  ```
]

#opcion("label.sep", valor: [una longitud], inicial: `0.35cm`)[
  La distancia entre las etiquetas y el borde del tablero.

  ```ejemplo
  #goban(size: 5, label: (at: (bottom, left),
    sep: 0.6cm), stones(black: "A1"))
  ```
]

#opcion("label.columns", valor: [`"A"` o un patrón de `numbering`], inicial: `"A"`)[
  Cómo se escriben las coordenadas de las columnas (arriba y abajo): con `"A"`, las letras del go (sin la I, salvo con `use-i`); con otro patrón de `numbering` de Typst, como `"1"` o `"一"`, números.
]

#opcion("label.rows", valor: [`"A"` o un patrón de `numbering`], inicial: `"1"`)[Lo mismo para las filas (a los costados). Los kanji (`"一"`) de las filas se alinean del lado del tablero, para que los de dos caracteres no lo pisen.]

#opcion("label.columns-direction", valor: [`ltr` o `rtl`], inicial: `ltr`)[
  En qué sentido se cuentan las columnas: desde la izquierda o desde la derecha.

  ```ejemplo
  #goban(size: 5, label: (at: (top, right),
      columns-direction: rtl, rows: "A"),
    stones(black: "B4"))
  ```
]

#opcion("label.rows-direction", valor: [`btt` o `ttb`], inicial: `btt`)[
  En qué sentido se cuentan las filas: desde abajo o desde arriba. Estas cuatro opciones cambian solo lo que se escribe en el borde: las coordenadas de los elementos (`"C3"`) siguen siendo las mismas. En un tablero parcial se cuenta desde el borde del tablero completo.

  ```ejemplo
  #goban(size: 5, label: (at: (top, left),
      columns: "1", rows-direction: ttb),
    stones(black: "C4"))
  ```
]

#opcion("label.style", valor: [`"western"`, `"japanese"` o `"chinese"`])[
  Fija las cuatro opciones anteriores según la costumbre de cada lugar. `"western"`: columnas con letras desde la izquierda y filas con números desde abajo, como al empezar. `"japanese"`: columnas con números desde la derecha y filas con kanji desde arriba, como en los libros japoneses: la esquina de arriba a la derecha es 1-一. `"chinese"`: columnas con números desde la izquierda y filas con kanji desde arriba. Los kanji necesitan una fuente que los tenga.

  ```ejemplo
  #goban(label: (at: (top, right),
      style: "japanese",
      text: (font: "MS Gothic", size: 8pt)),
    stones(black: "G7"))
  ```
]
