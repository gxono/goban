#import "../estilo.typ": *
#import "/lib.typ": *
#import "/src/texts.typ": texts

= Configuración <configuracion>

== Las opciones

Las opciones de gobanist forman un árbol de diccionarios: cada objeto (el fondo, la cuadrícula, las piedras de cada jugador, los diagramas de una partida…) es una rama, y sus opciones son sus claves. Las de un tablero van en el `goban`, con nombre, junto a lo que se dibuja; las de todo el documento, en `gobanist-set`.

#funcion("gobanist-set(..opciones)")[
  Fija opciones para todo lo que sigue en el documento: los tableros, las vistas, los diagramas y los problemas. Recibe las mismas opciones que `goban`, y además las ramas de las partidas (`sgf`, `diagrams`, `problems`), la disposición (`layout`), las vistas (`view`), los textos (`texts`) y las formas de marca (`shapes`). Cada `gobanist-set` se suma a los anteriores. Como `set` de Typst, vale desde donde está hasta el final del bloque que lo contiene.

  ```ejemplo
  #gobanist-set(
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

Los `goban` que siguen heredan estas opciones, y cada uno puede cambiarlas con las suyas: `goban(size: 9, stone: (radius: 4pt), mark: (line: (color: red)), ...)`. Las opciones se resuelven al dibujar el tablero, con las de `gobanist-set` que hay en ese lugar del documento.

Las opciones se mezclan rama por rama: un diccionario cambia solo las claves que da, y las demás quedan como estaban. `gobanist-set(background: (fill: (color: red)))` cambia el color del relleno, y el borde, la opacidad y la imagen siguen igual. Una clave que no existe es un error. Una longitud sobre una rama de longitudes (`grid.sep`, `background.rounded-corners`) va a todas sus claves: `grid: (sep: 1em)` es `grid: (sep: (x: 1em, y: 1em))`.

=== Prender y apagar <prender>

Muchas ramas prenden o apagan algo: la cuadrícula, el fondo, el borde y el relleno de las piedras, sus sombras y sus brillos, etc. Todas tienen la clave `on`, y siguen la misma regla:

- `true` prende la rama: `shine: true`;
- `false` la apaga: `shine: false`;
- un diccionario cambia sus opciones sin prenderla: `shine: (angle: 45deg)` cambia el ángulo, pero el brillo sigue como estaba. Para prenderlo y cambiarlo a la vez, `shine: (on: true, angle: 45deg)`.

Así, `gobanist-set(stone: (shadow: (opacity: 0.3)))` fija la opacidad de las sombras de todo el documento sin prenderlas, y cada tablero que las quiera las prende con `stone: (shadow: true)`.

Las ramas de imagen (`stone.image`, `background.fill.image`, …) no tienen `on`: las prende el archivo. En ellas, lo que no es un diccionario es el archivo: `stone: (image: path("piedra.png"))` es `stone: (image: (file: path("piedra.png")))`, y `image: none` la quita.

=== Atajos de los jugadores

Las opciones de las piedras, los prisioneros, las jugadas y las marcas son de cada jugador (#pag(<jugadores>)). En el primer nivel, valen para los tres a la vez:

#opcion("stone", valor: [opciones de piedra])[Es `players: (all: (stone: ...))`: el estilo de las piedras de los tres jugadores (#pag(<piedras>)).]
#opcion("prisoner", valor: [opciones de piedra])[Es `players: (all: (prisoner: ...))`: el estilo de los prisioneros de los tres jugadores (#pag(<prisioneros>)).]
#opcion("move", valor: [opciones de jugada])[Es `players: (all: (move: ...))`: el estilo de las jugadas de los tres jugadores (#pag(<jugadas>)).]
#opcion("mark", valor: [opciones de marca])[Es `players: (all: (mark: ...))`: el estilo de las marcas de los tres jugadores (#pag(<marcas>)).]
#opcion("players", valor: [`neutral`, `black`, `white` y `all`])[Las opciones de cada jugador (#pag(<jugadores>)).]

Las demás ramas del primer nivel están en el capítulo de cada objeto: el tablero (`size`, `partial`, `background`, `grid`, `hoshi`, `label`…, #pag(<tablero>)), las flechas y las líneas (`arrow`, `line`, #pag(<flechas>)), el juego (`captures`, `notes`, `territory`, `score`, #pag(<juego>)), las partidas (`sgf`, `diagrams`, `problems`, #pag(<sgf>)), la disposición (`layout`, #pag(<disposicion>)), las vistas (`view`, #pag(<vistas>)), los perfiles (`profile`, #pag(<perfiles>)), los textos (`texts`, #pag(<idiomas>)) y las formas de marca (`shapes`, #pag(<formas-propias>)).

== El kernel <kernel>

gobanist separa el cálculo del dibujo. Las coordenadas, la numeración de las jugadas y el dibujo están escritos en Typst. Lo que necesita jugar la partida lo hace un _kernel_: un plugin de WebAssembly, `src/kernel.wasm`, compilado del código Rust de la carpeta `kernel/` del repositorio. El kernel:

- juega las jugadas y retira las piedras capturadas (`captures`, #pag(<capturas>));
- busca el territorio (`territory(auto)`), arma las regiones (`draw: "region"`) y cuenta el puntaje (#pag(<territorio>));
- lee los archivos SGF y sus codificaciones (#pag(<sgf>));
- hace la opacidad y las siluetas de las imágenes PNG y JPEG (#pag(<piedras-imagen>)).

Juega cada tablero en una sola llamada, cuando el tablero tiene capturas o territorio. Viene compilado con el paquete: no hace falta instalar nada.

== Idiomas <idiomas>

Algunos textos los escribe el propio paquete: los epígrafes de `sgf-diagrams` y `sgf-problem`, el resultado de la partida, las anotaciones de los comentarios, las palabras de las notas «N en M» y «N: pasa» y la «y» entre varias vistas. Están en inglés (`en`), español (`es`), francés (`fr`), alemán (`de`), portugués (`pt`), italiano (`it`), esperanto (`eo`), japonés (`ja`), chino (`zh`) y coreano (`ko`). Para el japonés, el chino y el coreano hace falta una fuente con esos caracteres.

Los textos están en el idioma del texto, `text.lang`, y lo siguen si cambia dentro del documento: `set text(lang: "fr")`. En un idioma sin traducción, están en inglés.

#opcion("texts", valor: [un diccionario de idiomas])[
  Los textos de cada idioma: `texts: (es: (diagram: "Figura"))`. Un idioma nuevo toma del inglés lo que no tiene. Los textos que tienen partes variables son funciones: `n` es el número de una jugada, `w` el nombre del ganador y `p` la diferencia de puntos.

  ```ejemplo
  #gobanist-set(texts: (
    es: (at: "sobre"),
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

Las claves de cada idioma, con su valor en inglés y en español, son:

#{
  set text(size: 0.9em)
  let valor(clave, v) = if type(v) != function { v }
    else if clave == "variation-at" { v(26) }
    else if clave == "win-by-points" { v([_w_], [_p_]) }
    else { v([_w_]) }
  table(columns: 3, stroke: none, inset: (x: 4pt, y: 2pt),
    table.hline(),
    table.header([*Clave*], [*Inglés*], [*Español*]),
    table.hline(stroke: 0.5pt),
    ..texts.en.keys().map(k => (raw(k), valor(k, texts.en.at(k)), valor(k, texts.es.at(k)))).flatten(),
    table.hline(),
  )
}
