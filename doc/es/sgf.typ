#import "../estilo.typ": *
#import "/lib.typ": *

= Partidas en SGF <sgf>

SGF es el formato que usan casi todos los programas y servidores de go para guardar partidas. gobanist las lee con el kernel (#pag(<kernel>)): una partida en un tablero, sus datos y comentarios, la partida entera en diagramas y los problemas con sus soluciones.

En los ejemplos, `partida` es `partida.sgf`, una partida corta de 9×9:

#codigo(read("../partida.sgf").trim(), lang: none)

y `variantes` es `variantes.sgf`, una partida de 7×7 con dos bifurcaciones, marcas y `MN[10]` en la cuarta jugada de la línea principal:

#codigo(read("../variantes.sgf").trim(), lang: none)

== Leer una partida <sgf-leer>

#funcion("sgf-read(source, game: 1, charset: auto)")[
  Lee una partida SGF. `source` es un archivo (`path("partida.sgf")`, relativo al documento que lo nombra), su contenido (`bytes`) o el texto SGF (una cadena). Devuelve la partida como un valor, que se guarda con `let` y se usa en todas partes: en un tablero, en `sgf-info`, `sgf-comment`, `sgf-diagrams`, `sgf-problem`, `goban-layout` y `goban-view`.

  En un tablero, la partida es un elemento, como `stones` o `moves`: dibuja la línea principal, y el tablero toma el tamaño de su `SZ` (otro `size` es un error).

  ```ejemplo
  #let partida = sgf-read(path("partida.sgf"))

  #goban(label: (at: (top, left)), partida)
  ```
]

#opcion("game", valor: [un número], inicial: `1`)[
  En `sgf-read`: un archivo SGF puede tener varias partidas (una colección); `game` elige cuál se lee. Una que no existe es un error.

  ```codigo
  #let tercera = sgf-read(path("coleccion.sgf"), game: 3)
  ```
]

#opcion("charset", valor: [`auto` o un nombre], inicial: `auto`)[
  En `sgf-read`: la codificación del archivo, si no es UTF-8. Con `auto`, la que dice el archivo con `CA` o, si no dice ninguna, Latin-1 (la de SGF por defecto). Se leen Latin-1 (y windows-1252), GBK (GB2312, GB18030), Big5, Shift_JIS, EUC-JP y EUC-KR; los nombres no distinguen mayúsculas ni signos (`"shift-jis"` y `"EUC_KR"` también valen). Un archivo que es UTF-8 válido se lee siempre como UTF-8, aunque `CA` diga otra cosa; uno en UTF-16 (con la marca de orden de bytes al principio) también se lee. Otra codificación es un error: hay que convertir el archivo a UTF-8.

  Muchos archivos de servidores asiáticos no dicen su codificación: `sgf-read(path("qipu.sgf"), charset: "GBK")`. Para escribir sus comentarios hace falta una fuente con esos caracteres.
]

== Una partida en un tablero <sgf-tablero>

Una partida en un tablero dibuja las piedras iniciales (`AB` y `AW`), como con `stones`, y las jugadas de la línea principal, como con `moves`. Los pases cuentan para la numeración, pero no se dibujan (con `notes`, se anotan: «N: pasa», #pag(<notas>)). Las piedras que agregan (`AB`, `AW`) o quitan (`AE`) los nodos posteriores a la primera jugada se aplican junto con la jugada anterior; quitar piedras necesita `captures`, y sin `captures` es un error. Al terminar, la numeración y el turno quedan listos para seguir la partida con `moves`. La partida lee también `PL` (quién juega después) y `MN` (el número de una jugada).

```ejemplo
// Sin captures, 2 no se retira.
#goban(partida)
#goban(captures: "remove", partida)
```

#funcion("sgf(partida, ..opciones)")[
  La misma partida con otras opciones, las de la rama `sgf`, que se suman a las que ya tenía: `sgf(partida, to: 7)`. Además, `forget` (#pag(<memoria>)). Con `gobanist-set(sgf: ...)`, las opciones valen para todas las partidas.
]

#opcion("sgf.from", valor: [un número], inicial: `1`)[
  La primera jugada numerada. Las anteriores se dibujan sin número.

  ```ejemplo
  #goban(captures: "remove",
    sgf(partida, from: 7))
  ```
]

#opcion("sgf.to", valor: [`auto` o un número], inicial: `auto`)[
  La última jugada que se juega; las siguientes no se dibujan. Con `auto`, hasta la última.

  ```ejemplo
  #goban(captures: "remove",
    sgf(partida, to: 6),
    // Sigue con la 7 (negras), en otro lugar.
    moves("F5"))
  ```
]

`from` y `to` cuentan las jugadas del archivo. El número que se muestra puede ser otro: `MN` lo cambia (las jugadas siguientes siguen desde ahí), y también `restart`.

#opcion("sgf.variation", valor: [`none`, números o jugadas], inicial: `none`)[
  La línea que se dibuja. Con `none`, la principal. Con números, en cada bifurcación se toma, en orden, la variante indicada (1 es la principal): `(2, 1)` toma la segunda en la primera bifurcación y la primera en la segunda. Con un texto, las jugadas de la línea desde la primera, separadas por comas o espacios: `"R16, P17, Q15"`; en cada bifurcación se toma la variante que juega la siguiente, y un pase se escribe `pass`. En los dos casos, cuando la lista se termina, se sigue por la primera variante. Una variante o una jugada que no existe es un error.

  ```ejemplo
  #goban(sgf(variantes, variation: (2,)))
  #goban(sgf(variantes, variation: (1, 2)))
  #goban(sgf(variantes, variation: "C5, C3"))
  ```
]

#opcion("sgf.marks", valor: [`true` o `false`], inicial: `true`)[
  Dibuja las marcas del archivo (`TR`, `SQ`, `CR`, `MA`, `SL` y las etiquetas de `LB`), las flechas (`AR`) y las líneas (`LN`) del último nodo que se muestra, y atenúa los puntos de `DD` (que siguen atenuados hasta el próximo `DD`). Cada marca toma el jugador de la piedra que hay en ese punto, y reemplaza al número de la jugada; las etiquetas no tapan un número, así que sobre una piedra numerada no se dibujan. El territorio del archivo (`TB` y `TW`) se dibuja como el de `territory` (#pag(<territorio>)) y cuenta para `goban-score`.

  ```ejemplo
  #goban(sgf(variantes, to: 2))
  #goban(sgf(variantes, to: 2, marks: false))
  ```
]

#opcion("sgf.numbers", valor: [`auto`, `true` o `false`], inicial: `auto`)[
  Con `false`, las jugadas se dibujan sin número. Con `auto`, lo que pide el archivo con `PM`: con `PM[0]`, no se numeran.

  ```ejemplo
  #goban(sgf(variantes, numbers: false))
  ```
]

#opcion("sgf.step", valor: [un número o un arreglo], inicial: `100`)[El tamaño de los tramos en que `restart` reinicia la numeración. Con un arreglo, cada número es el tamaño de un tramo, y el último se repite: con `(50, 100)`, el primer tramo tiene 50 jugadas y los demás 100.]

#opcion("sgf.restart", valor: [`auto`, `true`, `false` o un diccionario], inicial: `auto`)[
  Desde el segundo tramo de `step` jugadas, cada uno numera desde 1 (o desde `restart.from`), como en los libros: con `step: 100, restart: true`, la jugada 101 se muestra como 1. El primer tramo conserva los números de la partida. Con `false`, las jugadas llevan los números de la partida (con `MN`). Con `auto`, lo que pide el archivo con `PM`: con `PM[2]`, la numeración se reinicia cada 100 jugadas, sin importar `step`.

  ```ejemplo
  #goban(variantes)
  #goban(sgf(variantes, step: 3,
    restart: true))
  #goban(sgf(variantes, step: 3,
    restart: (on: true, from: 0)))
  ```
]

#opcion("sgf.restart.from", valor: [un número], inicial: `1`)[El número de la primera jugada de cada tramo, desde el segundo. Con `step: 99` y `restart: (on: true, from: 0)`, la jugada 100 se muestra como 0, la 101 como 1, y así.]

#opcion("sgf.last-mark", valor: [`none`, una forma o un diccionario], inicial: `none`)[
  Marca la última jugada que se muestra, con una forma (`"circle"`) o con las opciones de una marca (`(shape: "triangle", line: (color: red))`). Un pase no se marca, y tampoco un punto que el archivo ya marca ni una jugada con número (el número ya dice cuál es la última): en la práctica, sirve con `numbers: false`.

  ```ejemplo
  #goban(sgf(variantes, numbers: false,
    last-mark: "circle"))
  ```
]

#opcion("sgf.letters", valor: [`none`, `"children"`, `"siblings"` o `auto`], inicial: `none`)[
  Marca con letras las variantes de la última jugada que se muestra: con `"children"`, las jugadas que pueden seguir; con `"siblings"`, las alternativas a esa jugada (la letra reemplaza a su número). Con `auto`, lo que pide el archivo con `ST`. Solo se marcan si hay más de una.

  ```ejemplo
  #goban(sgf(variantes, to: 1, marks: false,
    letters: "children"))
  ```
]

#opcion("sgf.view", valor: [`false`, `true` o un número], inicial: `false`)[
  Si el archivo tiene vista (`VW`), muestra solo esa parte del tablero, como `partial`. La vista puede cambiar durante la partida: un `VW` vale desde la jugada de su nodo (o desde la siguiente, si el nodo no tiene jugada) hasta el próximo `VW`, y `VW[]` vuelve a mostrar todo el tablero. Con `true`, la vista que abarca las de las jugadas `from` a `to`; con un número, la de esa jugada (con 0, la del principio). Un `partial` del tablero le gana.

  ```ejemplo
  // vistas: VW[aa:ee] al principio, VW[] en
  // la 3 y VW[ff:ii] en la 5.
  #goban(sgf(vistas, to: 2, view: true))
  #goban(sgf(vistas, view: 5))
  ```
]

== Datos y comentarios <sgf-datos>

#funcion("sgf-info(partida, property, move: 0, variation: none)")[
  Una propiedad de la raíz de la partida, como texto: `"PB"` y `"PW"` (los jugadores), `"RE"` (el resultado), `"KM"` (el komi), `"DT"` (la fecha), etc. Con `move`, la de esa jugada: la de su nodo y la de los nodos sin jugada que lo siguen (con 0, la de la raíz y los nodos anteriores a la primera jugada), en la línea de `variation` (como `sgf.variation`). Si no está, `""`. Si tiene varios valores, van separados por comas.

  ```ejemplo-abajo
  #sgf-info(variantes, "PB") (negras) contra
  #sgf-info(variantes, "PW") (blancas),
  komi #sgf-info(variantes, "KM").
  Resultado: #sgf-info(variantes, "RE").
  ```

  El valor es el del archivo, con los caracteres escapados ya resueltos y en la codificación de `CA`: `"RE"` queda como `B+R`, no en palabras (`sgf-diagrams` lo escribe en palabras). Sirve cualquier propiedad. Las de los datos de la partida, según el formato SGF, son:

  #{
    set text(size: 0.9em)
    table(columns: (auto, 1fr, auto), stroke: none, inset: (x: 4pt, y: 2pt),
      table.hline(),
      table.header([*Propiedad*], [*Qué es*], [*Ejemplo*]),
      table.hline(stroke: 0.5pt),
      [`PB`, `PW`], [El nombre de Negras y el de Blancas.], [`Lee Sedol`],
      [`BR`, `WR`], [El rango de Negras y el de Blancas.], [`9p`],
      [`BT`, `WT`], [El equipo de Negras y el de Blancas.], [],
      [`RE`], [El resultado: `B+` o `W+` y los puntos, `R` (abandono), `T` (tiempo) o `F` (falta); `0` o `Draw`, empate; `Void`, sin resultado; `?`, desconocido.], [`W+3.5`],
      [`KM`], [El komi.], [`6.5`],
      [`HA`], [El hándicap: cuántas piedras.], [`2`],
      [`DT`], [La fecha, `AAAA-MM-DD` (o varias, separadas por comas).], [`2016-03-09`],
      [`EV`], [El torneo o evento.], [`Meijin`],
      [`RO`], [La ronda.], [`3 (final)`],
      [`PC`], [El lugar.], [`Tokio`],
      [`GN`], [El nombre de la partida.], [],
      [`GC`], [Un comentario sobre la partida.], [],
      [`ON`], [La apertura (fuseki).], [],
      [`RU`], [Las reglas.], [`Japanese`],
      [`TM`], [El tiempo de cada jugador, en segundos.], [`7200`],
      [`OT`], [El tiempo extra (byo-yomi).], [`5x30 byo-yomi`],
      [`SO`], [La fuente: un libro, una revista.], [],
      [`AN`], [Quién comentó la partida.], [],
      [`US`], [Quién escribió el archivo.], [],
      [`CP`], [El copyright.], [],
      [`AP`], [El programa que escribió el archivo.], [`CGoban:3`],
      [`SZ`], [El tamaño del tablero (`19`, o `19:13`).], [`19`],
      [`CA`], [La codificación del archivo.], [`UTF-8`],
      table.hline(),
    )
  }
]

#funcion("sgf-comment(partida, move, variation: none, annotations: true, chat: true)")[
  El comentario de una jugada (0: el de antes de la primera jugada), en la línea de `variation`: el nombre del nodo (`N`), en negrita; las anotaciones de la jugada (`TE`, `BM`, `DO`, `IT`) y de la posición (`GB`, `GW`, `DM`, `UC`), con los textos del idioma (#pag(<idiomas>)); y el comentario (`C`). Los valores (`V`) y los puntos calientes (`HO`) no se escriben. `sgf-diagrams` y `sgf-problem` escriben los comentarios de la misma forma.

  ```ejemplo-abajo
  Jugada 7: #sgf-comment(partida, 7)

  #sgf-comment(problema, 1, variation: (2,))
  ```
]

#opcion("annotations", valor: [`true` o `false`], inicial: `true`)[
  En `sgf-comment`: con `false`, solo el comentario, sin el nombre ni las anotaciones.

  ```ejemplo-abajo
  Con: #sgf-comment(partida, 7) \
  Sin: #sgf-comment(partida, 7, annotations: false)
  ```
]

#opcion("chat", valor: [`true` o `false`], inicial: `true`)[En `sgf-comment`: con `false`, quita del comentario el chat de los servidores: en OGS, todo lo que sigue a la línea «`-- chat --`»; en KGS, las líneas «`nombre [rango]: ...`» y, si hay alguna, también las «`nombre: ...`» del mismo comentario. Si no queda nada, la jugada no tiene comentario.]

== Diagramas como en los libros <diagramas>

#funcion("sgf-diagrams(partida, ..opciones)")[
  Dibuja la partida como en los libros: un diagrama cada `step` jugadas (1–50, 51–100, …). Cada diagrama parte de la posición real, con las jugadas anteriores sin número y sus capturas; las piedras que capturan las jugadas del diagrama no se quitan (se quitan en el siguiente). Debajo de cada uno van su epígrafe y sus notas «N en M» (#pag(<notas>)), y debajo del último, el resultado. Una jugada en un punto ocupado quita la piedra que había, sin prisioneros, para dibujar partidas que no son legales. Va fuera de `goban`.

  Las opciones son las de la rama `diagrams`; con `gobanist-set(diagrams: ...)`, valen para todo el documento. Las de `sgf(partida, ...)` valen en cada tablero, salvo las que fija cada diagrama (`from`, `to`, `variation`, `numbers`, `marks`, `last-mark`, `step`, `restart` y `view`), que son un error.

  ```ejemplo-abajo
  #sgf-diagrams(partida, step: 5)
  ```
]

#opcion("diagrams.step", valor: [un número o un arreglo], inicial: `50`)[La cantidad de jugadas de cada diagrama. Con un arreglo, el primer diagrama tiene tantas jugadas como dice el primer número, el segundo como dice el segundo, y así; el último se repite: con `(5, 10, 3)`, los diagramas tienen 5, 10, 3, 3, 3… jugadas.]
#opcion("diagrams.from", valor: [un número], inicial: `1`)[La primera jugada. Los diagramas son los mismos que sin `from`, con el mismo número: solo se dibujan los que tienen jugadas desde `from`, y el primero empieza en `from`. Con `step: 50` y `from: 120`, el primero es «Diagrama 3 (120–150)».]
#opcion("diagrams.to", valor: [`auto` o un número], inicial: `auto`)[La última jugada. Con `auto`, la última de la partida.]
#opcion("diagrams.numbers", valor: [`true` o `false`], inicial: `true`)[Con `false`, las jugadas de cada diagrama se dibujan sin número (las notas «N en M» siguen usando los números de la partida).]
#opcion("diagrams.last-mark", valor: [`none`, una forma o un diccionario], inicial: `none`)[
  Como `sgf.last-mark`, en cada diagrama.

  ```ejemplo-abajo
  #sgf-diagrams(partida, step: 5, to: 10,
    numbers: false, last-mark: "circle")
  ```
]

#opcion("diagrams.restart", valor: [`auto`, `true`, `false` o un diccionario], inicial: `auto`)[
  Como `sgf.restart`, con un diagrama por tramo: desde el segundo diagrama, cada uno numera desde 1 (o desde `restart.from`), como algunos libros. El primer diagrama conserva los números de la partida. Con `auto`, lo que pide `PM[2]`: cada 100 jugadas, sin importar los diagramas.

  ```ejemplo-abajo
  #sgf-diagrams(partida, step: (2, 3), to: 8,
    restart: (on: true, from: 0))
  ```
]

#opcion("diagrams.restart.from", valor: [un número], inicial: `1`)[El número de la primera jugada de cada diagrama, desde el segundo.]
#opcion("diagrams.marks", valor: [`true` o `false`], inicial: `true`)[Como `sgf.marks`: cada diagrama muestra las marcas, flechas y líneas de su última jugada.]
#opcion("diagrams.notes", valor: [`true` o `false`], inicial: `true`)[Escribe debajo de cada diagrama sus notas: «N en M» y los pases, «N: pasa».]
#opcion("diagrams.title", valor: [`auto` o un texto], inicial: `auto`)[La palabra del epígrafe: «Diagrama 2 (51–100)». Con `auto`, la del idioma (`diagram` en `texts`).]
#opcion("diagrams.caption", valor: [un diccionario])[El epígrafe, las notas y el resultado.]
#opcion("diagrams.caption.text", valor: [un diccionario], inicial: `(size: 0.9em)`)[
  Las opciones de `text` del epígrafe, las notas y el resultado.

  ```ejemplo-abajo
  #sgf-diagrams(partida, from: 6, title: "Figura",
    caption: (text: (style: "italic")),
    goban: (label: (at: (top, left))))
  ```
]

#opcion("diagrams.caption.min-width", valor: [una longitud], inicial: `8em`)[Fuera de la grilla, un epígrafe más ancho que su tablero se corta en las líneas que le hacen falta al ancho del tablero o, si el tablero es más angosto, a esta medida; después se angosta hasta donde esas líneas siguen entrando, para que queden parejas. Nunca es más angosto que su palabra más larga. En la grilla, el epígrafe se corta al ancho de la celda.]
#opcion("diagrams.goban", valor: [opciones de tablero], inicial: `(:)`)[Las opciones de cada tablero, encima de las globales. Los tableros empiezan con `captures: "remove"` y `notes: true`, y tienen el tamaño de la partida.]
#opcion("diagrams.layout", valor: [opciones de disposición], inicial: `(:)`)[Cómo se disponen los diagramas: las opciones de `layout` (#pag(<disposicion>)), solo para estos diagramas: `layout: (columns: 3)`.]
#opcion("diagrams.variation", valor: [`none`, números o jugadas], inicial: `none`)[La línea que se dibuja, como `sgf.variation`.]

#opcion("diagrams.variations", valor: [`true`, `false` o un diccionario])[
  Dibuja también las variantes de la partida, cada una en su diagrama, después del diagrama donde nace: «Diagrama 1a», «Diagrama 1b»… Cada variante va entera, con sus jugadas numeradas desde 1; el epígrafe dice qué jugada reemplaza (`variation-title`), y las jugadas anteriores se ven sin número. Sus comentarios y notas se escriben como los de los demás diagramas. Las variantes son las que se apartan de la línea de `variation` (con `variation`, también la principal).

  ```ejemplo-abajo
  #sgf-diagrams(variantes, step: 2, to: 3,
    marks: false,
    variations: (on: true, select: "all"),
    goban: (scale: 0.7))
  ```
]

#opcion("diagrams.variations.select", valor: [`"commented"` o `"all"`], inicial: `"commented"`)[Cuáles se dibujan: las que tienen algún comentario (`C`) en sus jugadas propias, o todas.]
#opcion("diagrams.variations.depth", valor: [un número], inicial: `1`)[Hasta qué profundidad: con 1, las que se apartan de la línea que se dibuja; con 2, también las variantes de esas, y así. Las de una variante van después de ella, y su epígrafe dice qué jugada de ella reemplazan.]
#opcion("diagrams.variations.from", valor: [un número], inicial: `1`)[Solo las variantes que nacen en esa jugada o después.]
#opcion("diagrams.variations.paths", valor: [un arreglo de caminos], inicial: `()`)[
  Variantes que se dibujan siempre, aunque `variations` esté apagada, a cualquier profundidad: cada camino es como `sgf.variation`, con números (`(2,)`, `(2, 3, 1)`) o con jugadas (`"R16 P17 Q15"`). Los 1 del final no cambian la línea: `(2, 3, 1)` es `(2, 3)`. Un camino que la partida no tiene, o que no se aparta de la línea, es un error.

  ```codigo
  #sgf-diagrams(josekis, variations: (paths: ((2,), "Q16 R14 O16")))
  ```
]

#opcion("diagrams.variation-title", valor: [`auto` o una función], inicial: `auto`)[Lo que va entre paréntesis en el epígrafe de una variante: «Diagrama 3a (variante en 26)». Una función recibe el número de la jugada que reemplaza: `variation-title: n => [en la #n]`. Con `auto`, el texto del idioma (`variation-at` en `texts`).]

#opcion("diagrams.figures", valor: [`true` o `false`], inicial: `true`)[Si el archivo marca figuras (`FG`), cada figura es un diagrama, con su nombre en el epígrafe, en lugar de uno cada `step` jugadas.]
#opcion("diagrams.view", valor: [`true` o `false`], inicial: `true`)[Si el archivo tiene vista (`VW`), cada diagrama muestra solo la que abarca las vistas de sus jugadas, como `sgf.view`; una variante, la de su línea. Un `partial` en `goban` le gana.]
#opcion("diagrams.partial", valor: [`none` o `auto`], inicial: `none`)[
  Con `auto`, donde no hay vista del archivo, todos los diagramas muestran la misma parte del tablero: la que usan las líneas que se dibujan (la de `variation` y las de `variations`), como `partial: auto`.

  ```codigo
  #sgf-diagrams(josekis, partial: auto, variations: true)
  ```
]

#opcion("diagrams.comments", valor: [`true`, `false` o un diccionario])[
  Escribe los comentarios de las jugadas de cada diagrama, como `sgf-comment`, cada uno con el número de la jugada.

  ```ejemplo-abajo
  #sgf-diagrams(partida, step: 5,
    comments: (on: true, root: true),
    layout: (columns: 2))
  ```
]

#opcion("diagrams.comments.text", valor: [un diccionario], inicial: `(:)`)[Las opciones de `text` de los comentarios, encima de las de `caption.text`.]
#opcion("diagrams.comments.align", valor: [`left`, `center` o `right`], inicial: `left`)[La alineación de los comentarios en el ancho del diagrama.]
#opcion("diagrams.comments.justify", valor: [`true` o `false`], inicial: `false`)[Justifica los comentarios. En un diagrama angosto, quedan espacios grandes entre las palabras.]
#opcion("diagrams.comments.root", valor: [`true` o `false`], inicial: `false`)[Escribe también el comentario de la raíz (el de los nodos anteriores a la primera jugada), sin número, antes de los del diagrama que empieza en la jugada 1.]
#opcion("diagrams.comments.number", valor: [una función], inicial: `n => [#strong(str(n)): ]`)[Lo que va delante de cada comentario: una función del número de la jugada, el que se ve en el tablero (con `restart`, el reiniciado). Por ejemplo, `n => [Jugada #n. ]`.]
#opcion("diagrams.comments.separator", valor: [un contenido], inicial: `parbreak()`)[Lo que va entre los comentarios. Con el valor inicial, cada uno va en su párrafo; con `h(1em)`, van seguidos.]
#opcion("diagrams.comments.position", valor: [`bottom`, `left`, `right` o `"after"`], inicial: `bottom`)[
  Dónde van los comentarios: debajo del epígrafe; al costado del diagrama, como en los libros de partidas comentadas; o, con `"after"`, todos juntos después de los diagramas, a lo ancho, cada grupo con el epígrafe de su diagrama como encabezado. Al costado empiezan a la altura del borde de arriba del tablero; el epígrafe, las notas y el resultado siguen debajo del tablero.

  ```ejemplo-abajo
  #sgf-diagrams(partida, step: 5,
    comments: (on: true, position: right))
  ```
]

#opcion("diagrams.comments.width", valor: [`auto` o una longitud], inicial: `auto`)[El ancho de los comentarios al costado. Con `auto`, lo que queda: fuera de la grilla, el resto de la línea; en la grilla, el resto de la celda, y con `fit`, el tablero ocupa la mitad de la celda y los comentarios la otra mitad.]
#opcion("diagrams.comments.sep", valor: [una longitud], inicial: `1em`)[El espacio entre el diagrama y los comentarios al costado.]
#opcion("diagrams.comments.height", valor: [`none` o una longitud], inicial: `none`)[
  La altura máxima de los comentarios de un diagrama, debajo o al costado. Lo que no entra (se corta entre palabras) va después de los diagramas, como con `"after"`, con el epígrafe del diagrama como encabezado.

  ```codigo
  #sgf-diagrams(lee, step: 30, layout: (columns: 2),
    comments: (on: true, height: 6em))
  ```
]

#opcion("diagrams.annotations", valor: [`true` o `false`], inicial: `true`)[Con los comentarios, escribe también el nombre y las anotaciones de cada jugada.]
#opcion("diagrams.chat", valor: [`true` o `false`], inicial: `true`)[Con los comentarios, como `chat` de `sgf-comment`: con `false`, sin el chat de KGS y OGS. Una jugada a la que solo le quedaba chat no aparece.]

#opcion("diagrams.result", valor: [`true`, `false` o un diccionario])[
  Escribe debajo del último diagrama, si llega al final de la partida, el resultado (`RE`) y, si el archivo marca el territorio (`TB`, `TW`), el puntaje de cada jugador: «Resultado: Ganan Negras por 0.5 puntos (Negras 6, Blancas 5.5)». El puntaje se cuenta como con `goban-score`, con el komi del archivo (`KM`).
]

#opcion("diagrams.result.title", valor: [`auto` o un texto], inicial: `auto`)[La palabra que precede al resultado. Con `auto`, la del idioma (`result` en `texts`).]
#opcion("diagrams.result.format", valor: [`"text"` o `"raw"`], inicial: `"text"`)[Cómo se escribe el resultado: con `"text"`, en palabras, en el idioma del texto («Ganan Negras por abandono»); con `"raw"`, como está en el archivo («B+R»). Con `"text"` se entienden `0` o `Draw` (empate), `Void` (sin resultado), `?` (desconocido) y `B+` o `W+` seguido de nada, de la diferencia, de `R` o `Resign`, de `T` o `Time`, o de `F` o `Forfeit`. Otro resultado se escribe como está.]
#opcion("diagrams.result.black", valor: [`auto` o un texto], inicial: `auto`)[El nombre de las negras en el puntaje y en el resultado. Con `auto`, el del idioma.]
#opcion("diagrams.result.white", valor: [`auto` o un texto], inicial: `auto`)[
  El nombre de las blancas en el puntaje y en el resultado.

  ```ejemplo-abajo
  #sgf-diagrams(variantes,
    result: (title: "Final", format: "raw"))
  #sgf-diagrams(variantes,
    result: (black: "Ana", white: "Bruno"))
  ```
]

== Problemas <problemas>

#funcion("sgf-problem(..problemas, ..opciones)")[
  Dibuja un problema (tsumego). Primero, el enunciado: la posición inicial con sus marcas, quién juega (`PL`, o el color de la primera jugada) y el comentario de la raíz. Después, un diagrama por cada línea del árbol del archivo (cada variante de la solución, correcta o no), numerada desde 1, con sus notas «N en M» y los comentarios y anotaciones de sus jugadas, que suelen decir si la variante es correcta. Todos los diagramas muestran la misma parte del tablero: la vista del archivo (`VW`) o, sin vista, la que usa el problema. Va fuera de `goban`.

  Con varias partidas (`sgf-problem(p1, p2, p3)`), van primero todos los enunciados, cada uno con su número (el de la partida en su archivo), y después las soluciones de los que las tienen. Así se arma una hoja de problemas.

  Las opciones son las de la rama `problems`; con `gobanist-set(problems: ...)`, valen para todo el documento. Las de `sgf(problema, ...)` valen en cada tablero, salvo las que fija el diagrama (`from`, `to`, `variation`, `numbers`, `last-mark`, `step`, `restart` y `view`). En los ejemplos, `problema` es `problema.sgf`, un problema de vida y muerte: la jugada correcta y dos equivocadas, con sus comentarios.

  ```ejemplo-abajo
  #sgf-problem(problema, title: "Problema 1")
  ```

  ```ejemplo-abajo
  // problemas: las tres partidas de problemas.sgf.
  #sgf-problem(..problemas, comments: false,
    layout: (columns: 4, fit: true))
  ```
]

#opcion("problems.statement", valor: [`true`, `false` o `"alone"`], inicial: `true`)[Dibuja el enunciado. Con `"alone"`, el enunciado va solo en su fila, centrado, y las variantes debajo.]
#opcion("problems.solutions", valor: [`true` o `false`], inicial: `true`)[
  Dibuja las variantes. Con `false`, queda solo el enunciado; las soluciones van en otro lugar, con `statement: false`.

  ```ejemplo-abajo
  #sgf-problem(problema, solutions: false,
    title: "Problema 2")
  ```
]

#opcion("problems.title", valor: [`auto` o un texto], inicial: `auto`)[El comienzo del epígrafe del enunciado: «Problema 1: Juegan Negras». Con varias partidas, va seguido del número de cada una; con `auto`, nada, o con varias partidas, la palabra del idioma (`problem` en `texts`): «Problema 7: Juegan Negras». Las soluciones dicen también de qué problema son: «Problema 7: Variante 1».]
#opcion("problems.to-play", valor: [`auto`, `"black"`, `"white"` o `none`], inicial: `auto`)[Quién juega, para el epígrafe del enunciado. Con `auto`, lo que dice `PL` o, si no está, el color de la primera jugada; si no hay ninguna de las dos, no se dice. Muchas colecciones no lo dicen en el archivo: `to-play: "black"`. Con `none`, el epígrafe no lo dice.]
#opcion("problems.variation-title", valor: [`auto` o una función], inicial: `auto`)[El epígrafe de cada solución: una función de su número, `n => [Solución #n]`. Con `auto`, «Variante 2», con la palabra del idioma (`variation` en `texts`).]
#opcion("problems.verdict", valor: [`true` o `false`], inicial: `false`)[
  El epígrafe de cada solución dice si es correcta o incorrecta («Variante 2 (incorrecta)»), con los textos `correct` y `wrong` del idioma. Se decide con las anotaciones de la línea: el último `GB` o `GW` (la posición es buena para negras o para blancas), según quién juega; si no hay, la primera jugada con `TE` o `BM` (las jugadas impares son de quien juega: un `BM` suyo es un error, uno del rival no); si no, la palabra `RIGHT` en un comentario, como en los archivos de goproblems.com. Si no hay nada de eso, no dice nada.

  ```ejemplo-abajo
  #sgf-problem(problema, verdict: true,
    statement: false, comments: false,
    layout: (columns: 4, fit: true))
  ```
]

#opcion("problems.view", valor: [`true` o `false`], inicial: `true`)[Si el archivo tiene vista (`VW`) al principio, todos los diagramas muestran esa parte.]
#opcion("problems.partial", valor: [`auto` o `none`], inicial: `auto`)[
  Con `auto`, si no se usa la vista del archivo, todos los diagramas muestran la parte del tablero donde hay piedras, jugadas, marcas, flechas o líneas en alguna línea del problema, como `partial: auto`. Las líneas que se agregan alrededor se cambian con `goban: (partial-margin: ...)`. Con `none`, se ve todo el tablero.

  ```ejemplo-abajo
  #sgf-problem(problema, solutions: false,
    goban: (partial-margin: 3))
  ```
]

#opcion("problems.notes", valor: [`true` o `false`], inicial: `true`)[Escribe las notas «N en M» de cada variante.]
#opcion("problems.caption", valor: [un diccionario], inicial: `(text: (size: 0.9em), min-width: 8em)`)[
  Los epígrafes, las notas y los comentarios, como `diagrams.caption`.

  ```ejemplo-abajo
  #sgf-problem(problema, statement: "alone",
    comments: false, notes: false,
    caption: (text: (style: "italic")))
  ```
]

#opcion("problems.comments", valor: [`true`, `false` o un diccionario])[El comentario de la raíz debajo del enunciado y los de cada variante debajo de su diagrama, como `diagrams.comments` (sin `root`). Aquí están prendidos al empezar. `text`, `align` y `justify` valen también para el comentario del enunciado.]
#opcion("problems.annotations", valor: [`true` o `false`], inicial: `true`)[Con los comentarios, escribe también el nombre y las anotaciones de cada jugada (`TE`, `BM`…).]
#opcion("problems.chat", valor: [`true` o `false`], inicial: `true`)[Con los comentarios, como `chat` de `sgf-comment`.]
#opcion("problems.goban", valor: [opciones de tablero], inicial: `(:)`)[Las opciones de cada tablero, como `diagrams.goban`.]
#opcion("problems.layout", valor: [opciones de disposición], inicial: `(:)`)[Cómo se disponen el enunciado y las variantes: las opciones de `layout` (#pag(<disposicion>)), solo para estos diagramas.]
