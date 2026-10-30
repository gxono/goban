#import "../estilo.typ": *
#import "/lib.typ": *

= Presentación <presentacion>

== Qué es gobanist

gobanist es un paquete de Typst para dibujar tableros, posiciones, partidas y problemas de go. Es un port de pgf-go, un paquete de LaTeX publicado hace dos años por el mismo autor, con sus mismas ideas y casi todas sus opciones, escritas con los valores de Typst:

- Partidas en SGF: una partida en un tablero, series de diagramas como en los libros y problemas con sus soluciones.
- Las reglas del juego, en un kernel de WebAssembly: capturas, notas «N en M» para los kos, territorio y puntaje.
- Perfiles para el tablero y los jugadores, que pueden usar imágenes: madera en el fondo, piedras de pizarra y de concha.
- Tableros como valores, para seguir una variante desde una posición o mostrar una parte del tablero en medio de un párrafo.
- Marcas, flechas y líneas, y formas de marca propias.
- Una disposición en grilla para acomodar diagramas del mismo tamaño.
- Los textos del paquete en diez idiomas, y coordenadas del borde al estilo occidental, japonés o chino.
- Una sintaxis para escribir muchas coordenadas a la vez: filas, columnas, rectángulos, caminos y escaleras.

El dibujo, las coordenadas y las opciones están escritos en Typst. Lo que necesita jugar la partida (las capturas, el territorio, las regiones, el puntaje y la lectura de los archivos SGF) lo hace un plugin de WebAssembly compilado de código Rust (#pag(<kernel>)), que viene con el paquete.

== Primeros pasos <primeros-pasos>

gobanist se importa como cualquier paquete. Necesita Typst 0.15 o posterior.

```codigo
#import "@preview/gobanist:0.1.0": *

#goban(stones(black: "C3, D4", white: "E5"))
```

Todo lo que se dibuja va en un `goban`: las piedras, las jugadas, las marcas, las flechas, el territorio o una partida leída de un archivo. Las opciones del tablero van en el mismo `goban`, con nombre (`size: 13`), y las de todo el documento, en `gobanist-set` (#pag(<configuracion>)).

```ejemplo
#goban(size: 5, stones(black: "C3, D4", white: "B2"))
```

== Cómo leer este manual <como-leer>

El manual tiene tres partes: esta presentación; los tutoriales (#pag(<tutoriales>)), en los que Kāru prepara un artículo, un cuaderno de problemas y unas clases, y aprende el paquete en el camino; y la referencia, con cada función y cada opción, ordenada por objeto. Al final están el catálogo de perfiles y un índice de las funciones y las opciones.

Conviene leer primero los tutoriales, de corrido, para tener un pantallazo de todo, y después la referencia, para ver todo lo que se puede configurar. Para algo puntual:

- *Dibujar una partida guardada en SGF*: el tutorial de la #pag(<tut-primera>) y, para la partida entera en diagramas, el de la #pag(<tut-partida>). La referencia está en la #pag(<sgf>).
- *Dibujar una posición a mano*: el tutorial de la #pag(<tut-posicion>), y las piedras en la #pag(<piedras>). Para escribir menos coordenadas, el tutorial de la #pag(<tut-abreviar>) y la sintaxis completa en la #pag(<coordenadas>).
- *Numerar jugadas*: el tutorial de la #pag(<tut-jugadas>), y `moves` en la #pag(<jugadas>).
- *Mostrar solo una parte del tablero o marcar puntos*: el tutorial de la #pag(<tut-parcial>); `partial` en la #pag(<parcial>), y las marcas en la #pag(<marcas>).
- *Flechas, líneas y letras*: el tutorial de la #pag(<tut-pelea>), y la referencia en la #pag(<flechas>).
- *Mostrar una piedra o una parte del tablero dentro del texto*: el final del tutorial de la #pag(<tut-pelea>), y `goban-view` en la #pag(<vistas>).
- *Capturas, kos y notas «N en M»*: el tutorial de la #pag(<tut-ko>), y la referencia en la #pag(<juego>).
- *Marcar el territorio y contar los puntos*: el tutorial de la #pag(<tut-territorio>), y `territory` y `goban-score` en la #pag(<territorio>).
- *Seguir desde una posición, por ejemplo para mostrar variantes*: el tutorial de la #pag(<tut-variantes>), y `board` y `resume` en la #pag(<memoria>).
- *Josekis de un diccionario en SGF*: el tutorial de la #pag(<tut-josekis>), y `variation` y `variations` en la #pag(<sgf>).
- *Problemas (tsumego) con sus soluciones*: el tutorial de la #pag(<tut-problemas>), y `sgf-problem` en la #pag(<problemas>).
- *Acomodar varios diagramas en una grilla*: los tutoriales de las páginas #context counter(page).at(<tut-partida>).first() y #context counter(page).at(<tut-problemas>).first(), y `layout` y `goban-layout` en la #pag(<disposicion>).
- *Cambiar el estilo de todos los tableros*: el final del tutorial de la #pag(<tut-posicion>) y el catálogo (#pag(<catalogo>)). Para cambiar un detalle, `gobanist-set` (#pag(<configuracion>)) y las opciones de cada objeto; para guardar un estilo propio, los perfiles (#pag(<perfiles>)).
- *Usar imágenes en el tablero y en las piedras*: el tutorial de la #pag(<tut-madera>); el fondo y la cuadrícula en la #pag(<tablero>), y las piedras en la #pag(<piedras-imagen>).
- *Diapositivas*: el tutorial de la #pag(<tut-diapositivas>).
- *Escribir en otro idioma*: el tutorial de la #pag(<tut-idiomas>), y la referencia en la #pag(<idiomas>).

Una regla general: las ramas que prenden o apagan algo (la cuadrícula, el fondo, las sombras…) tienen la clave `on`; `true` y `false` las prenden y las apagan, y un diccionario cambia sus opciones sin prenderlas (#pag(<prender>)).

== Para quien viene de pgf-go <desde-pgf-go>

Las opciones de gobanist son las de pgf-go, con la sintaxis de Typst: un árbol de diccionarios en lugar de un árbol de _keys_, y valores de Typst en lugar de los de TikZ. Los cambios más visibles:

#table(columns: (1fr, 1fr), stroke: none, inset: (x: 4pt, y: 3pt),
  table.hline(),
  table.header([*pgf-go*], [*gobanist*]),
  table.hline(stroke: 0.5pt),
  [`\begin{goban}[13] ... \end{goban}`], [`#goban(size: 13, ...)`],
  [`\pgfgoset{goban = {...}}`], [`#gobanist-set(...)`],
  [`\stones[b]{C3, D4}`], [`stones(black: "C3, D4")`],
  [`\stone{C3}`, `\stones{C3}`], [`stones("C3")`],
  [`\moves[w]{D2, B3}`], [`moves(white: "D2, B3")`],
  [`\mark[triangle]{C3}`], [`marks(triangle: "C3")`],
  [`\mark[custom = {!}]{D3}`], [`marks(custom: "D3", content: [!])`],
  [`\arrow{B3}{F3}`, `\line{B3}{F3}`], [`arrows(("B3", "F3"))`, `lines(("B3", "F3"))`],
  [`\territory[b]{auto}`], [`territory(black: auto)`],
  [`shine = {true, angle = 45}`], [`shine: (on: true, angle: 45deg)`],
  [`format = Alph`], [`format: "A"` (un patrón de `numbering`)],
  [`label = {at = {north, west}}`], [`label: (at: (top, left))`],
  [`name = base`, `resume = base`], [`#let base = board(...)`, `goban(base)`, `resume: base`],
  [`\pgfgoview{base}{C3}`], [`goban-view(base, "C3")`],
  [`\pgfgodefinesgf{partida}{partida.sgf}`], [`#let partida = sgf-read(path("partida.sgf"))`],
  [`\pgfgodefinesgf[origin = top right]`], [`sgf-read(..., origin: top + right)`],
  [`\begin{pgfgosgf}{corta} ... \end{pgfgosgf}`], [`#let corta = sgf-read("(;SZ[9]...)")`],
  [`\sgf[to = 7]{partida}`], [`sgf(partida, to: 7)`],
  [`\sgfdiagrams`, `\sgfproblem`], [`sgf-diagrams`, `sgf-problem`],
  [`\pgfgomovenotes`, `\pgfgoscore{b}`], [`goban-notes()`, `goban-score("black")`],
  [`pgfgolayout`], [`goban-layout(...)`],
  [`\pgfgodefinemark`], [la opción `shapes`],
  [`\pgfgostone[b, number = 5]`], [`goban-stone("black", number: 5)`],
  [`label = {letter case = lower}`], [`label: (columns: "a")`],
  [`layout = {halign = left}`], [`layout: (halign: left)`],
  [`\pgfgodefineprofile{madera}{...}`], [`#let madera = (...)`, `profile: madera`],
  table.hline(),
)

Algunas cosas cambian de comportamiento:

- Una marca sin jugador sobre una piedra toma el jugador de la piedra (en pgf-go era neutral).
- Typst no tiene avisos: lo que en pgf-go avisaba (una coordenada que no se entiende o que está fuera del tablero, una partida de otro tamaño) es un error. Una jugada en un punto ocupado, con capturas, también es error, salvo en `sgf-diagrams` y `sgf-problem`.
- Los grises son los de xcolor: el gris de gobanist es `luma(50%)`, no el `gray` de Typst.
- El tablero tiene al menos 2×2 líneas.
- Las imágenes son `path` o `bytes`, no nombres de archivo.

Y algunas no se portan: `\sgfanimation` (Typst no hace PDF animados; para diapositivas están Touying y Polylux, #pag(<tut-diapositivas>)), `export` y `\pgfgoimport` (un tablero es un valor: se guarda en un módulo `.typ` y se importa), el dibujo con TikZ dentro del tablero, el sistema de coordenadas `go cs`, `\pgfgodefinegoban`, `\pgfgodefineplayer` y los perfiles parciales (`goban profile`, `players profile`): un perfil es un diccionario, y se toman sus ramas.
