#import "../estilo.typ": *
#import "/lib.typ": *

= Los tableros de Kāru <tutoriales>

== La primera partida <tut-primera>

Kāru está escribiendo un artículo para sus estudiantes y decide probar gobanist. Lo primero que quiere mostrar es una partida corta que jugó en clase. La tiene guardada en un archivo SGF, `partida.sgf`: el formato en el que casi todos los programas y servidores de go guardan las partidas.

#align(center, goban(captures: "remove", label: (at: (top, left)), partidas.partida))

`sgf-read` lee el archivo y devuelve la partida como un valor, que Kāru guarda con `let` para usarlo muchas veces. Todo lo que se dibuja va en un `goban`, y la partida también: dentro de él, dibuja su línea principal. El tablero toma el tamaño del archivo.

```ejemplo
#let partida = sgf-read(path("partida.sgf"))

#goban(partida)
```

Las jugadas aparecen numeradas, como en los libros. Pero con la jugada 7 las negras capturaron la piedra blanca 2, que sigue en el tablero: gobanist dibuja lo que se le pide, sin aplicar las reglas. Con la opción `captures`, el `goban` retira las piedras capturadas (#pag(<capturas>)). Las opciones del tablero van con nombre, junto a lo que se dibuja.

```ejemplo
#goban(captures: "remove", partida)
```

Para comentar la partida en el texto, Kāru la detiene en la jugada 7 con `to`: `sgf(partida, ...)` es la misma partida con otras opciones. El archivo trae un comentario para esa jugada, y `sgf-comment` lo escribe.

```ejemplo
#goban(captures: "remove", sgf(partida, to: 7))

Jugada 7: #sgf-comment(partida, 7)
```

Esta partida es de 9×9; una de 19×19 se lee igual, y el tablero toma su tamaño. Así lo hará Kāru con la partida de la #pag(<tut-partida>), donde también verá cómo dibujar una partida larga en una serie de diagramas.

== Una posición a mano <tut-posicion>

Para la introducción del artículo, Kāru quiere una posición propia, que no está en ningún archivo. Tiene que dibujarla piedra por piedra.

#align(center, goban(profile: "pgfgo", label: (at: (top, left)),
  stones(black: "B2, E2, J2, C3, D3, G3, H3, C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6, H6, B5, J5, B4, E4, J4, J3, H2")))

Empieza por el tablero vacío. `goban` se encarga del tamaño del tablero, su color, sus coordenadas y todo lo que va encima.

```ejemplo
#goban()
```

El tablero es de 9×9, justo lo que necesita, pero le faltan las coordenadas en los bordes. Las opciones de cada parte del tablero se agrupan en ramas: `grid`, la cuadrícula; `background`, el borde y el relleno, y `label`, las coordenadas (#pag(<tablero>)). Dentro de `label`, `at` dice en qué lados van: `top`, `bottom`, `left` y `right`, las alineaciones de Typst. Kāru las quiere arriba y a la izquierda.

```ejemplo
#goban(label: (at: (top, left)))
```

Las columnas pasan de la H a la J: como es costumbre en el go, gobanist omite la I, en las coordenadas y en las etiquetas. Si alguna vez la necesita, la opción `use-i` (#pag(<use-i>)) la vuelve a poner.

Ahora sí, las piedras. `stones` recibe las intersecciones, como `"D8"`, y el jugador es la clave: `black` o `white`. Sin jugador, la piedra es neutral.

```ejemplo
#goban(label: (at: (top, left)),
  stones(black: "D8, F8, E7, H7"))
```

Una sola cadena lleva todas las piedras de un jugador, separadas por comas, y un mismo `stones` puede llevar las de los dos. En rigor, `black` y `white` no son colores sino jugadores: cada piedra toma el estilo del suyo (#pag(<jugadores>)).

```ejemplo
#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

Falta el estilo. En el catálogo (#pag(<catalogo>)), Kāru encuentra uno que le gusta: el perfil `pgfgo`. Lo aplica con `gobanist-set(profile: "pgfgo")` (#pag(<perfiles>)), y desde ahí vale para todos los tableros que siguen.

```ejemplo
#gobanist-set(profile: "pgfgo")

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

Las listas de este tutorial son largas, y la paciencia de Kāru, corta. En el último tutorial (#pag(<tut-abreviar>)) aprende a escribirlas más cortas.

== Jugadas <tut-jugadas>

Para explicar cómo empezó una pelea, Kāru quiere mostrar las piedras en el orden en que se jugaron. Con `stones` tendría que separar las de cada jugador y perdería el orden. Para eso está `moves` (#pag(<jugadas>)): juega las intersecciones en el orden en que se escriben, alterna los colores y numera las jugadas.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  moves("F7, E6, G3, D6"))
```

La pelea empezó con una negra en F7, que Kāru pone con `stones`. Las jugadas que siguen no las va a comentar: con `numbers: false`, se dibujan sin números. Con `white` como clave, la secuencia empieza con blancas: en `moves`, el jugador solo dice quién juega primero.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones(black: "F7"),
  moves(numbers: false, white: "E6, G3, D6, F5,
    E7, E2, F8, E6, D8, D3, G7, C5, C6, D5,
    B5, G5, B4, B2, H6, C3, J3, J2, J5, H3"))
```

Las últimas jugadas sí las comenta, así que van con número. La numeración y el turno siguen de un `moves` al siguiente, aunque las jugadas anteriores no lleven números, y con `from` se elige desde qué número se sigue.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  moves(numbers: false, white: "E6, G3, D6, F5,
    E7, E2, F8, E6, D8, D3, G7, C5, C6, D5,
    B5, G5, B4, B2, H6, C3, J3, J2, J5, H3"),
  moves("F6, E5, J4, G6", from: 26),
  moves("H2"))
```

`H2` va en otro `moves` y, sin decirlo, es blanca y lleva el 30: la jugada anterior, `G6`, fue la 29, de negras.

== Tablero parcial y marcas <tut-parcial>

Para un ejercicio del artículo, Kāru quiere mostrar solo una parte del tablero, con dos señales: un círculo en la piedra que está en atari y un «!» en el punto clave.

#align(center, goban(partial: "B2:E4", background: (line: false),
  stones(black: "C2, B3, C4", white: "D4, E3, D2"),
  stones(white: "C3", mark: (shape: "circle", line: (color: red))),
  marks(custom: "D3", content: [!])))

Empieza, como siempre, por las piedras.

```ejemplo
#goban(stones(black: "C2, B3, C4",
  white: "D4, E3, D2, C3"))
```

Con la opción `partial`, se indica qué parte del tablero mostrar: dos esquinas opuestas del rectángulo, separadas por dos puntos, como `"B2:E4"` (#pag(<parcial>)).

```ejemplo
#goban(partial: "B2:E4",
  stones(black: "C2, B3, C4",
    white: "D4, E3, D2, C3"))
```

Si Kāru no quiere buscar las esquinas, con `partial: auto` el tablero elige la parte: la que usa lo que se dibuja, con una línea más alrededor. Un lado que queda a dos líneas o menos del borde llega hasta el borde, como aquí el de abajo y el de la izquierda.

```ejemplo
#goban(partial: auto,
  stones(black: "C2, B3, C4",
    white: "D4, E3, D2, C3"))
```

Kāru prefiere el recorte justo, así que sigue con `"B2:E4"`. En un tablero parcial, el borde del tablero sobra: lo quita con `line: false` en el `background`.

```ejemplo
#goban(partial: "B2:E4",
  background: (line: false),
  stones(black: "C2, B3, C4",
    white: "D4, E3, D2, C3"))
```

Las marcas se ponen con `marks`, con la forma como clave; hay muchas (#pag(<marcas>)). A Kāru le alcanzan dos: `circle`, el círculo, y `custom`, que pone cualquier contenido (`content`), como «!». Una marca también puede ir en las opciones de la piedra, con `mark`.

```ejemplo
#goban(partial: "B2:E4",
  background: (line: false),
  stones(black: "C2, B3, C4",
    white: "D4, E3, D2"),
  stones(white: "C3", mark: "circle"),
  marks(custom: "D3", content: [!]))
```

Para que el círculo se distinga, Kāru lo pinta de rojo, con `line.color` de la marca. Con opciones, la marca es un diccionario, y la forma va en `shape`.

```ejemplo
#goban(partial: "B2:E4",
  background: (line: false),
  stones(black: "C2, B3, C4",
    white: "D4, E3, D2"),
  stones(white: "C3", mark: (shape: "circle",
    line: (color: red))),
  marks(custom: "D3", content: [!]))
```

== Explicar una pelea: flechas, letras y vistas <tut-pelea>

En la segunda parte del artículo, Kāru quiere explicar una pelea. Necesita señalar las jugadas posibles con letras, mostrar hacia dónde corre cada grupo y, en el texto, nombrar las piedras sin obligar al lector a buscarlas en el diagrama.

#align(center, goban(partial: "A1:G7", label: (at: (top, left)),
  stones(black: "C3, D3, E4, C5", white: "D4, D5, E5, F3"),
  marks(dim: "F3", triangle: "D5"), marks(custom: "E3", content: [A]), marks(custom: "C4", content: [B]),
  arrows(("C5", "C7"), shorten: 4pt), arrows(("E4", "G5"), color: red.darken(20%), bend: 30deg, shorten: 4pt),
  lines(("A6", "G6"), dash: "dashed")))

Empieza, como siempre, por las piedras. Para no ocupar espacio, muestra solo la esquina con `partial`.

```ejemplo
#goban(partial: "A1:G7",
  label: (at: (top, left)),
  stones(black: "C3, D3, E4, C5",
    white: "D4, D5, E5, F3"))
```

Las jugadas candidatas se marcan con letras, con `custom`, que acepta cualquier contenido. La marca `triangle` destaca la piedra de la que habla el texto, y `dim` apaga la piedra blanca de F3, que ya no importa. Un mismo `marks` puede llevar varias formas; dos `custom` con distinto contenido van en dos `marks`.

```ejemplo
#goban(partial: "A1:G7",
  label: (at: (top, left)),
  stones(black: "C3, D3, E4, C5",
    white: "D4, D5, E5, F3"),
  marks(dim: "F3", triangle: "D5"),
  marks(custom: "E3", content: [A]),
  marks(custom: "C4", content: [B]))
```

Para mostrar hacia dónde corren los grupos, Kāru usa `arrows`, que une dos intersecciones (#pag(<flechas>)). La flecha se dibuja con un halo del color del tablero, para que no se confunda con la cuadrícula. Con `bend`, es un arco; con `shorten`, no tapa las piedras de sus extremos.

```ejemplo
#goban(partial: "A1:G7",
  label: (at: (top, left)),
  stones(black: "C3, D3, E4, C5",
    white: "D4, D5, E5, F3"),
  arrows(("C5", "C7"), shorten: 4pt),
  arrows(("E4", "G5"), color: red.darken(20%),
    bend: 30deg, shorten: 4pt))
```

`lines` es como `arrows`, pero sin punta, y acepta las mismas opciones de trazo, como `dash`.

```ejemplo
#goban(partial: "A1:G7",
  label: (at: (top, left)),
  stones(black: "C3, D3, E4, C5",
    white: "D4, D5, E5, F3"),
  lines(("A6", "G6"), dash: "dashed"))
```

Ahora, el texto. Kāru quiere escribir «la piedra negra de E4» y mostrarla ahí mismo. Para eso guarda el tablero como un valor, con `board`, que recibe lo mismo que `goban` pero no dibuja nada. Para dibujarlo, el tablero va primero en un `goban`, que le agrega sus opciones, como la parte que se ve. Y `goban-view` muestra una parte de ese tablero en medio del párrafo, como quedó al final (#pag(<vistas>)): un punto o un rectángulo.

```ejemplo
#let pelea = board(
  stones(black: "C3, D3, E4, C5",
    white: "D4, D5, E5, F3"),
  marks(triangle: "D5"),
  marks(custom: "E3", content: [A]))

#goban(pelea, partial: "A1:G7")
```

#let pelea = board(stones(black: "C3, D3, E4, C5", white: "D4, D5, E5, F3"), marks(triangle: "D5"),
  marks(custom: "E3", content: [A]))

```codigo
La negra #goban-view(pelea, "E4") está separada de sus compañeras.
Si juega en A, conecta: #goban-view(pelea, "C3:E5").
Sin marcas: #goban-view(pelea, "C3:E5", marks: false).
```

La negra #goban-view(pelea, "E4") está separada de sus compañeras. Si juega en A, conecta: #goban-view(pelea, "C3:E5"). Sin marcas: #goban-view(pelea, "C3:E5", marks: false).

La vista tiene el estilo del tablero, pero `view.goban` puede cambiarlo: Kāru prefiere quitar el fondo en todas las vistas del artículo.

```codigo
#gobanist-set(view: (goban: (background: false)))

La negra #goban-view(pelea, "E4") está separada de sus compañeras.
Si juega en A, conecta: #goban-view(pelea, "C3:E5").
```

#aislado[
  #gobanist-set(view: (goban: (background: false)))
  La negra #goban-view(pelea, "E4") está separada de sus compañeras. Si juega en A, conecta: #goban-view(pelea, "C3:E5").
]

Como el tablero es un valor, la vista puede ir antes que el diagrama que lo dibuja: `pelea` se conoce desde el `let`, no desde el `goban`.

== Un ko: capturas y notas <tut-ko>

En el primer tutorial, `captures` retiró una piedra capturada de una partida en SGF. Para explicar un ko, Kāru necesita lo mismo con jugadas escritas a mano: ponerlas en orden y que gobanist retire las piedras capturadas.

#align(center, {
  goban(size: 7, captures: "remove", notes: true, stones(black: "B3, C2, C4", white: "C3, D2, D4, E3"),
    moves("D3, G6, G5, C3, A6, A5, D3"))
  parbreak()
  goban-notes()
})

Negras toman el ko en D3 (1), blancas amenazan en otro lado (2), negras responden (3) y blancas retoman (4). Sin más, las jugadas se dibujan unas sobre otras y ninguna piedra se va del tablero.

```ejemplo
#goban(size: 7,
  stones(black: "B3, C2, C4",
    white: "C3, D2, D4, E3"),
  moves("D3, G6, G5, C3"))
```

Con `captures: "remove"` (#pag(<capturas>)), el `goban` lleva la cuenta de las libertades y retira cada grupo que se queda sin ellas. La blanca de C3 desaparece con la jugada 1, y la negra 1, con la 4. `goban-prisoners` dice cuántas piedras capturó cada jugador.

```ejemplo
#goban(size: 7, captures: "remove",
  stones(black: "B3, C2, C4",
    white: "C3, D2, D4, E3"),
  moves("D3, G6, G5, C3"))

Negras capturaron
#goban-prisoners("black"), blancas
#goban-prisoners("white").
```

Si las piedras capturadas deben seguir viéndose, `captures: "fade"` las deja como prisioneras.

```ejemplo
#goban(size: 7, captures: "fade",
  stones(black: "B3, C2, C4",
    white: "C3, D2, D4, E3"),
  moves("D3, G6, G5, C3"))
```

El ko sigue: negras amenazan (5), blancas responden (6) y negras retoman en D3 (7), donde ya se había jugado la 1. En los libros, esa jugada no se dibuja: debajo del diagrama se escribe «7 en 1». Eso hace la opción `notes` (#pag(<notas>)), y `goban-notes` escribe las notas.

```ejemplo
#goban(size: 7, captures: "remove",
  notes: true,
  stones(black: "B3, C2, C4",
    white: "C3, D2, D4, E3"),
  moves("D3, G6, G5, C3, A6, A5, D3"))

#goban-notes().
```

== Una partida entera <tut-partida>

El artículo también comenta una partida larga: la primera entre Lee Sedol y AlphaGo, de 2016, guardada en `lee.sgf`. Como en el primer tutorial (#pag(<tut-primera>)), no hace falta escribir sus 186 jugadas: gobanist las lee del archivo (#pag(<sgf>)).

Lo primero son los datos de la partida, que `sgf-info` toma de la raíz del archivo.

```codigo
#let lee = sgf-read(path("lee.sgf"))

#sgf-info(lee, "PB") (negras) contra #sgf-info(lee, "PW") (blancas),
#sgf-info(lee, "EV"), #sgf-info(lee, "RO"), #sgf-info(lee, "DT").
Resultado: #sgf-info(lee, "RE").
```

#let lee = partidas.lee
#sgf-info(lee, "PB") (negras) contra #sgf-info(lee, "PW") (blancas), #sgf-info(lee, "EV"), #sgf-info(lee, "RO"), #sgf-info(lee, "DT"). Resultado: #sgf-info(lee, "RE").

`sgf-info` escribe el resultado tal como está en el archivo; más adelante, `sgf-diagrams` lo escribe en palabras.

La partida es de 19×19, y el tablero toma ese tamaño. Con `to`, Kāru la muestra hasta la jugada 30, y con `scale`, achica el tablero.

```ejemplo
#goban(captures: "remove", scale: 0.6,
  sgf(lee, to: 30))
```

Para comentar un tramo, Kāru numera solo las jugadas desde la 21 con `from`: las anteriores se dibujan sin número.

```ejemplo
#goban(captures: "remove", scale: 0.6,
  sgf(lee, from: 21, to: 30))
```

Después, Kāru quiere la partida entera, como en los libros: un diagrama cada 50 jugadas, cada uno con su epígrafe y sus notas «N en M», y el resultado al final. Eso hace `sgf-diagrams`, que va fuera de `goban`. Con `layout`, los diagramas van en una grilla de dos columnas, y con `fit` se escalan para llenarlas (#pag(<disposicion>)). Aquí se muestran solo los dos últimos, con `from`.

```ejemplo-abajo
#sgf-diagrams(lee, step: 50, from: 101,
  layout: (columns: 2, fit: true))
```

El epígrafe y el resultado están en castellano porque el documento está en castellano (`text.lang`, #pag(<idiomas>)). Algunos libros reinician la numeración en cada diagrama; con `restart`, cada diagrama, desde el segundo, numera desde 1.

```ejemplo-abajo
#sgf-diagrams(lee, step: 50, from: 51, to: 150,
  restart: true, goban: (label: (at: (top, left))),
  layout: (columns: 2, fit: true))
```

== Variantes: seguir desde un tablero <tut-variantes>

En los comentarios, Kāru suele mostrar qué habría pasado con otra jugada. Copiar la posición en cada diagrama es tedioso y propenso a errores: si cambia una piedra, hay que cambiarla en todos. En la pelea, Kāru guardó un tablero como un valor, con `board`. Con `resume`, otro tablero empieza con ese, como quedó: la numeración y el turno siguen desde ahí (#pag(<memoria>)).

```ejemplo
#gobanist-set(size: 5, partial: "A1:E4")

#let base = board(
  stones(black: "B2, C3, D2",
    white: "B3, C4, D3"))

#goban(base)
#goban(resume: base, moves(black: "C2, E3"))
#goban(resume: base, moves(black: "E3, C2"))
```

Una variante también puede ser un valor, y seguir desde ella: un `board` con `resume` tiene lo que trajo más lo suyo. Por defecto, `resume` trae solo las piedras; `numbers: true` trae también los números.

```ejemplo
#gobanist-set(size: 5, partial: "A1:E4")

#let base = board(
  stones(black: "B2, C3, D2",
    white: "B3, C4, D3"))
#let variante = board(resume: base,
  moves(black: "E3, C2"))

#goban(resume: variante)
#goban(resume: (board: variante,
  numbers: true), moves("E4"))
```

Un tablero guardado también sirve para comparar estilos. Antes de elegir el perfil de su artículo, Kāru dibuja el mismo tablero con varios perfiles del catálogo (#pag(<catalogo>)). Para ponerlos uno al lado del otro, del mismo ancho, usa `goban-layout` (#pag(<disposicion>)), que dispone tableros hechos con `board`. Cada uno es `estilos` con otro perfil: un tablero que va primero en `board` es ese mismo tablero, con lo que se le agrega.

```ejemplo-abajo
#let estilos = board(size: 5,
  stones(black: "B2, C3, D2", white: "B3, C4, D3"),
  marks(circle: "C2"))
#let con(perfil) = board(estilos,
  profile: perfil)

#goban-layout(columns: 4, fit: true,
  con("pgfgo"), con("pgfgosmooth"), con("wain"), con("simple"))
```

== El final del juego: territorio <tut-territorio>

#let final = board(
  stones(black: "A5, A6, B1, B2, B3, B4, B5, C1, C4, D1, D2, D5, D7, E2, E5, E7, E9, F4, F5, F6, F7, F8, F9, G5, G6, G7, H6, H8, J7",
    white: "A7, B6, B8, C2, C3, C5, C6, C7, C8, D3, D4, D6, D8, D9, E3, E4, E6, E8, F1, F2, F3, G4, H2, H3, H5, J5, J6"))
#definir(final: final)

#align(center, goban(final, profile: "pgfgo", label: (at: (top, left)),
  prisoners(black: "H1, J1, J2", white: "A1"),
  marks(t-circle: "A1, A2, A3, A4, G8, G9, H9, J9, J8, H7", player: "black"),
  marks(t-square: "A9, B9, C9, A8, B7, H4, J4, J3, J2, J1, H1, G1, G2, G3", player: "white"),
  marks(t-square: "E1", player: "neutral")))

Para terminar el artículo, Kāru quiere mostrar cómo se cuenta una partida. Parte de la posición final. Como tiene muchas piedras y va a dibujarla varias veces, la guarda con `board`, como las variantes del tutorial anterior, y los tableros siguientes la llevan primero, sin repetir las coordenadas.

```ejemplo
#gobanist-set(profile: "pgfgo")

#let final = board(stones(
  black: "A5, A6, B1, B2, B3, B4, B5, C1, C4,
    D1, D2, D5, D7, E2, E5, E7, E9, F4, F5,
    F6, F7, F8, F9, G5, G6, G7, H6, H8, J7",
  white: "A7, B6, B8, C2, C3, C5, C6, C7, C8,
    D3, D4, D6, D8, D9, E3, E4, E6, E8, F1,
    F2, F3, G4, H2, H3, H5, J5, J6"))

#goban(final, label: (at: (top, left)))
```

Lo siguiente son los prisioneros: las piedras muertas, que se retiran al contar. Se dibujan con `prisoners`, que recibe lo mismo que `stones` (#pag(<prisioneros>)). Kāru guarda también este tablero, con otro nombre.

```ejemplo
#gobanist-set(profile: "pgfgo")

#let final2 = board(final,
  prisoners(black: "H1, J1, J2",
    white: "A1"))

#goban(final2, label: (at: (top, left)))
```

#let final2 = board(final, prisoners(black: "H1, J1, J2", white: "A1"))
#definir(final: final, final2: final2)

Ahora, el territorio. Una forma es marcar cada punto con `t-square` o `t-circle`. Estas marcas toman como relleno el de las piedras de su jugador, y como borde, el de la cuadrícula. Sobre un punto vacío, una marca es neutral salvo que diga su jugador, con `player`.

```ejemplo
#gobanist-set(profile: "pgfgo")

#goban(final2, label: (at: (top, left)),
  marks(player: "black",
    t-circle: "A1, A2, A3, A4, G8, G9, H9,
      J9, J8, H7"),
  marks(player: "white",
    t-square: "A9, B9, C9, A8, B7, H4, J4,
      J3, J2, J1, H1, G1, G2, G3"),
  marks(t-square: "E1"))
```

Otra forma es `territory` (#pag(<territorio>)). Con un polígono, marca los puntos de esa región que no tienen una piedra viva; con `auto`, busca solo el territorio de cada jugador. `goban-score` escribe el puntaje.

```ejemplo
#gobanist-set(profile: "pgfgo")

#goban(final2, label: (at: (top, left)),
  territory(auto, dame: true))

Negras: #goban-score("black").
Blancas: #goban-score("white", komi: 6.5).
```

Para el artículo, Kāru prefiere que el territorio se vea como una mancha de color y no punto por punto. Con `draw: "region"`, el territorio de cada color es un solo polígono, cuyos lados van por las líneas del tablero.

```ejemplo
#gobanist-set(profile: "pgfgo")

#goban(final2, label: (at: (top, left)),
  territory(auto, draw: "region"))
```

== Un cuaderno de problemas <tut-problemas>

Para sus estudiantes, Kāru prepara un cuaderno de problemas de vida y muerte. Los problemas suelen guardarse también en SGF: la posición inicial, quién juega y un árbol con cada variante de la solución, correcta o no, con sus comentarios. `sgf-problem` dibuja todo eso: primero el enunciado y después un diagrama por variante. Si el archivo no dice qué parte del tablero mostrar, se muestra la que usa el problema, como con `partial: auto`.

```ejemplo-abajo
#let problema = sgf-read(path("problema.sgf"))

#sgf-problem(problema, title: "Problema 1")
```

En un cuaderno, las soluciones no van junto al enunciado. Kāru pone los enunciados en la primera parte, con `solutions: false`, y las soluciones al final, con `statement: false`.

```ejemplo-abajo
#sgf-problem(problema, title: "Problema 1",
  solutions: false)
// ... al final del cuaderno:
#sgf-problem(problema, statement: false,
  layout: (columns: 4, fit: true))
```

Algunos problemas no están en ningún archivo, y Kāru los dibuja a mano, con la misma parte del tablero que muestra `sgf-problem`. Aquí escribe la parte, `"A16:F19"`: con `partial: auto`, cada tablero mostraría solo la suya, y no coincidirían. Para que tengan el mismo tamaño que los demás, los pone junto con los de `sgf-problem` en un mismo `goban-layout`, que acomoda en una grilla todos los tableros que recibe.

```ejemplo-abajo
#goban-layout(columns: 3, fit: true,
  sgf-problem(problema, title: "Problema 1",
    solutions: false),
  board(size: 19, partial: "A16:F19",
    stones(black: "A16, B16, C16, D17, E18, E19",
      white: "A17, B17, C17, D18, D19")),
  board(size: 19, partial: "A16:F19",
    stones(black: "A17, B17, C17, D18, D19",
      white: "A18, B18, C18, C19")))
```

== Un tablero de madera: un perfil con imágenes <tut-madera>

#let conchas = range(1, 6).map(n => path("../img/pgfgo-shell-white-" + str(n) + ".png"))
#let madera-tutorial = (
  background: (fill: (image: path("../img/pgfgo-board.jpg"))),
  stone: (shadow: (on: true, offset: 0.75pt, angle: -45deg)),
  players: (
    black: (stone: (image: path("../img/pgfgo-shell-black.png"))),
    white: (stone: (image: (file: conchas, rotate: (-15deg, 15deg)))),
  ),
)
#definir(conchas: range(1, 6).map(n => path("../img/pgfgo-shell-white-" + str(n) + ".png")))

Para la portada del cuaderno, Kāru quiere un tablero que se parezca a uno de verdad, ya que el presupuesto no da para uno de kaya: madera, piedras con volumen y blancas con vetas. Los perfiles del catálogo dibujan las piedras como círculos; para esto hacen falta imágenes (PNG, JPEG, GIF, WebP, SVG o PDF). Kāru copia a su proyecto, en la carpeta `img`, las que usa el perfil `shell`, que están en la carpeta `images` del paquete: una foto de madera, `pgfgo-board.jpg`, una piedra negra de pizarra, `pgfgo-shell-black.png`, y cinco blancas de concha, `pgfgo-shell-white-1.png` a `pgfgo-shell-white-5.png`.

#align(center, goban(profile: madera-tutorial, label: (at: (top, left)),
  stones(black: "B2, E2, J2, C3, D3, G3, H3, C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6, H6, B5, J5, B4, E4, J4, J3, H2")))

Parte del primer tablero del artículo. La madera va en el fondo del tablero, con `background.fill.image` (#pag(<tablero>)). Una imagen es un archivo: un `path`, relativo al documento que lo nombra (o sus `bytes`). Por defecto, la imagen cubre todo el tablero, recortada si hace falta; con `fit`, puede estirarse o repetirse en baldosas.

```ejemplo
#gobanist-set(background: (fill: (
  image: path("img/pgfgo-board.jpg"))))

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

Las piedras de un jugador se dibujan con una imagen mediante `stone.image` (#pag(<piedras-imagen>)), en las opciones de ese jugador. La imagen ocupa el lugar del círculo: no se dibujan el relleno ni el borde. En una rama de imagen, lo que no es un diccionario es el archivo.

```ejemplo
#gobanist-set(
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

Las negras se ven bien, pero las blancas son todas iguales, y en un tablero de verdad cada piedra de concha tiene sus vetas. Con varios archivos en `file`, cada piedra usa uno, elegido por su lugar: una piedra en un punto muestra siempre la misma imagen, en todos los diagramas.

```ejemplo
#let conchas = range(1, 6).map(n => path(
  "img/pgfgo-shell-white-" + str(n) + ".png"))

#gobanist-set(
  background: (fill: (
    image: path("img/pgfgo-board.jpg"))),
  players: (
    black: (stone: (image:
      path("img/pgfgo-shell-black.png"))),
    white: (stone: (image: conchas))))

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

Para que las piedras parezcan apoyadas sobre la madera, falta una sombra. `shadow` la dibuja con la forma de la imagen (si la imagen tiene transparencia, como estos PNG). Como es la misma para los tres jugadores, va en `stone`, en el primer nivel: es `players: (all: (stone: ...))`.

```ejemplo
#gobanist-set(
  background: (fill: (
    image: path("img/pgfgo-board.jpg"))),
  stone: (shadow: (on: true, offset: 0.75pt,
    angle: -45deg)),
  players: (
    black: (stone: (image:
      path("img/pgfgo-shell-black.png"))),
    white: (stone: (image: conchas))))

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

Con cinco imágenes, todavía puede verse alguna repetida. `rotate` gira cada piedra un ángulo distinto, elegido también por su lugar. Estas piedras tienen la luz arriba a la izquierda, así que Kāru las gira poco, entre −15 y 15 grados; la sombra gira con la imagen, pero sigue cayendo hacia el mismo lado.

```ejemplo
#gobanist-set(
  background: (fill: (
    image: path("img/pgfgo-board.jpg"))),
  stone: (shadow: (on: true, offset: 0.75pt,
    angle: -45deg)),
  players: (
    black: (stone: (image:
      path("img/pgfgo-shell-black.png"))),
    white: (stone: (image: (file: conchas,
      rotate: (-15deg, 15deg))))))

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C5, D5, E5, F5, G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, J5, B4, E4, J4, J3, H2"))
```

Kāru va a usar este estilo en todo el cuaderno, y quizás en otros documentos. En lugar de repetir el `gobanist-set`, lo guarda como un perfil (#pag(<perfiles>)): un perfil es un diccionario de opciones, como las de `gobanist-set`, y se usa con la opción `profile`. Lo pone en un archivo propio, `madera.typ`, para importarlo desde cualquier documento.

```codigo
// madera.typ
#let conchas = range(1, 6).map(n => path("img/pgfgo-shell-white-" + str(n) + ".png"))
#let madera = (
  background: (fill: (image: path("img/pgfgo-board.jpg"))),
  stone: (shadow: (on: true, offset: 0.75pt, angle: -45deg)),
  players: (
    black: (stone: (image: path("img/pgfgo-shell-black.png"))),
    white: (stone: (image: (file: conchas, rotate: (-15deg, 15deg)))),
  ),
)

// El cuaderno:
#import "madera.typ": madera
#gobanist-set(profile: madera)
```

Antes de poner el suyo, `profile` vuelve el estilo al inicial, así que el perfil se ve igual en cualquier documento. Un perfil casi igual, con una sombra difusa y sin el borde del tablero, viene con gobanist: `shell` (#pag(<catalogo>)); con `profile: "shell"` no hace falta copiar nada. También está `yunzi`, con piedras mates.

Un perfil vale para todo lo que dibuja gobanist, también para los diagramas de un SGF. Así queda la partida de Lee Sedol y AlphaGo en madera, con un diagrama cada 50 jugadas y la numeración reiniciada en cada uno.

```codigo
#gobanist-set(profile: madera)

#sgf-diagrams(lee, step: 50, restart: true, layout: (columns: 2, fit: true))
```

#aislado[
  #gobanist-set(profile: madera-tutorial)
  #sgf-diagrams(lee, step: 50, restart: true, layout: (columns: 2, fit: true))
]

== Diapositivas <tut-diapositivas>

Kāru también da clases con diapositivas. Typst no hace PDF animados, pero un `goban` funciona en una diapositiva de Touying o de Polylux como en cualquier otro lugar, y `sgf` con `to` permite mostrar la partida jugada por jugada, una diapositiva por jugada, con su comentario al lado.

```codigo
#import "@preview/touying:0.6.1": *
#import themes.simple: *
#import "@preview/gobanist:0.1.0": *

#show: simple-theme
#let partida = sgf-read(path("partida.sgf"))

#for k in range(1, 11) [
  == Una partida corta
  #grid(columns: (1fr, 1fr), gutter: 1em,
    goban(captures: "remove", scale: 1.5, sgf(partida, to: k)),
    text(size: 0.8em, sgf-comment(partida, k)))
]
```

Para repasar la partida entera, en cambio, le alcanzan los diagramas de Lee Sedol y AlphaGo del artículo (#pag(<tut-partida>)), uno por diapositiva. Con `layout: (per-page: 1)`, `sgf-diagrams` pone cada diagrama en su propia página, con su epígrafe (#pag(<disposicion>)).

```codigo
#sgf-diagrams(lee, step: 50, goban: (scale: 0.6), layout: (per-page: 1))
```

Las diapositivas son otro documento, pero Kāru no quiere copiar los tableros del artículo. Los tableros son valores: los guarda en un módulo, `tableros.typ`, y los importa en el artículo y en las diapositivas, donde los dibuja, los muestra con `goban-view` o sigue desde ellos con `resume`.

```codigo
// tableros.typ
#import "@preview/gobanist:0.1.0": *
#let pelea = board(stones(black: "C3, D3, E4, C5", white: "D4, D5, E5, F3"),
  marks(triangle: "D5"), marks(custom: "E3", content: [A]))

// En las diapositivas:
#import "tableros.typ": pelea
== Si negras conectan
#goban(pelea, partial: auto, moves("E3"))
```

== Un diccionario de josekis <tut-josekis>

Para otra clase, Kāru quiere explicar las respuestas a la aproximación baja al punto 4-4. Las secuencias conocidas de la apertura en una esquina, los _josekis_, suelen guardarse en un SGF con forma de diccionario: un árbol con una rama por cada jugada posible, comentarios en las que importan y letras en las jugadas que pueden seguir. Kāru arma uno pequeño, `josekis.sgf`.

Primero, la posición: las dos primeras jugadas, con las letras de las respuestas. El tablero es de 19×19, pero todo pasa en una esquina; con `partial: auto` (#pag(<tut-parcial>)), el `goban` muestra solo la parte que usa lo que dibuja, también las letras.

```ejemplo
#let josekis = sgf-read(path("josekis.sgf"))

#goban(partial: auto, sgf(josekis, to: 2))
```

Para las respuestas, Kāru elige la línea con `variation`. En un diccionario hay tantas ramas que es más cómodo dar las jugadas de la línea, desde la primera, que buscar su número: `variation: "Q16, R14"` (#pag(<sgf>)). Con `variations`, `sgf-diagrams` dibuja además, cada una en su diagrama, las variantes con comentarios que se apartan de esa línea, y con `from: 3`, solo las que nacen en la jugada 3 o después: las respuestas, y no la invasión en el 3-3, que es otra jugada 2. Con `partial: auto`, todos los diagramas muestran la misma parte del tablero.

```ejemplo-abajo
#sgf-diagrams(josekis, variation: "Q16, R14",
  variations: (on: true, from: 3),
  partial: auto, comments: true,
  layout: (columns: 3, fit: true))
```

El primer diagrama es la línea elegida, hasta el final. Las jugadas de cada variante se numeran desde 1, y el epígrafe dice en qué jugada se aparta. En un diccionario grande, cada jugada trae letras en las que pueden seguir; con `marks: false`, los diagramas no las dibujan.

== Otros idiomas <tut-idiomas>

Un colega de Kāru quiere traducir el cuaderno al francés. Los textos que escribe gobanist (los epígrafes, el resultado, las notas «N en M» y las anotaciones de los comentarios) siguen el idioma del texto, `text.lang`, también si cambia dentro del documento: con `set text(lang: "fr")` se traducen solos (#pag(<idiomas>)).

```ejemplo-abajo
#set text(lang: "fr")

#sgf-diagrams(partida, step: 5,
  layout: (columns: 2))
#sgf-problem(problema, solutions: false)
```

El comentario del problema, «Negras matan.», no se traduce: está escrito así en el archivo. Cada texto del paquete puede cambiarse, además, con su propia opción, en cualquier idioma: por ejemplo, la palabra del epígrafe de los diagramas, con `diagrams.title`; o los textos de un idioma, con `texts`.

```codigo
#gobanist-set(diagrams: (title: "Figura"))
#gobanist-set(texts: (es: (diagram: "Figura")))
```

== Escribir menos: la sintaxis de coordenadas <tut-abreviar>

En todos los tutoriales, Kāru escribió las piedras una por una. Cuando son muchas, gobanist permite abreviar las listas de `stones`, `marks` y `prisoners` (#pag(<coordenadas>)). Las formas más útiles son los tramos de una fila o de una columna: `C:G5` es la fila 5, de C a G, y `J3:5` es la columna J, de 3 a 5. Con ellas, el primer tablero del artículo queda así:

```ejemplo
#gobanist-set(profile: "pgfgo")

#goban(label: (at: (top, left)),
  stones(
    black: "B2, E2, J2, C3, D3, G3, H3,
      C:G5, E6, G6",
    white: "D8, F8, E7, H7, C6, D6, F6,
      H6, B5, B4, E4, H2, J3:5"))
```

Para grupos más grandes, hay caminos que doblan en ángulo recto. `A6 |- B5` va de A6 hacia abajo hasta la fila 5 y después hacia la derecha hasta B5: son las piedras A6, A5 y B5. `E9 -| F4` va primero hacia la derecha y después hacia abajo. `D5 -- D7` es una línea recta. Los caminos pueden encadenarse, y con ellos la posición final del tutorial de territorio (#pag(<tut-territorio>)) cabe en dos líneas:

```ejemplo
#gobanist-set(profile: "pgfgo")

#goban(label: (at: (top, left)),
  stones(
    black: "A6|-B5|-D1|-E2, C4, E9-|F4,
      D5-|G7--D7, H6, H8, J7",
    white: "E8-|C5, B:E6, A7, B8, D9, J6|-H5,
      H2:3, F1|-C3, C2, D:E4, G4"),
  prisoners(black: "H1-|J2", white: "A1"),
  territory(auto, dame: true))
```

Entre dos intersecciones que no están en la misma fila ni en la misma columna, `--` es una línea inclinada: `D5 -- F7` son D5, E6 y F7. Esas piedras se tocan solo por las esquinas; para una cadena conectada, `-|-` rellena cada escalón, primero hacia el costado y después hacia arriba o hacia abajo: `D4 -|- F6` son D4, E4, E5, F5 y F6 (`|-|` empieza por la columna). Con eso, una escalera (_shicho_) se escribe con sus extremos:

```ejemplo
#goban(label: (at: (top, left)),
  stones(white: "D4 -|- F6 -- G6",
    black: "C4, D3, D5 -- F7, E3 -- G5"),
  // Blancas corren. No por mucho.
  arrows(("G6", "J8"), shorten: 4pt))
```

Hay más: rectángulos llenos (`A1:C3`) o solo su borde (`A1 r C3`), columnas y filas enteras (`D`, `4`), todo el tablero (`*`) y, después de un `;`, piedras que se quitan de la lista. Todo está en la referencia, en la #pag(<coordenadas>).
