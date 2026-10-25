#import "../estilo.typ": *
#import "/lib.typ": *

= Disposición de los diagramas <disposicion>

Los diagramas de `sgf-diagrams` y `sgf-problem` se disponen según la rama `layout`, y `goban-layout` dispone juntos tableros sueltos y esos diagramas. Sin grilla (`columns: auto`), los diagramas van en el párrafo, uno al lado del otro, y pasan a la línea siguiente cuando no entran. Con un número de columnas, van en una grilla de columnas del mismo ancho: cada fila es una línea aparte (la página puede cortarse entre filas), los tableros de una fila quedan alineados arriba y una fila incompleta deja vacías las últimas columnas. Con `fit`, además, los tableros se escalan para llenar el ancho de su columna.

#funcion("goban-layout(..tableros, ..opciones)")[
  Dispone, en el orden en que vienen, tableros hechos con `board(...)`, partidas (`sgf-read`, `sgf`) y los diagramas de `sgf-diagrams(...)` y `sgf-problem(...)`. Las opciones son las de la rama `layout`; las `layout` de los `sgf-diagrams` y `sgf-problem` de adentro no se usan. Con `fit`, cada tablero suelto llena su columna, y los diagramas de un `sgf-diagrams` o un `sgf-problem` usan la escala del primero. Un `goban(...)` ya está dibujado, así que adentro es un error: va `board(...)`.

  ```ejemplo-abajo
  #goban-layout(columns: 4, fit: true,
    board(size: 5, stones(black: "C3")),
    board(size: 5, stones(white: "C3")),
    sgf-diagrams(partida, step: 5))
  ```
]

```ejemplo-abajo
#sgf-diagrams(partida, step: 2, to: 6,
  layout: (columns: 3, fit: true))
```

#opcion("layout", valor: [un diccionario])[Las opciones de la disposición: con `goban-set(layout: ...)`, para todo el documento; en `goban-layout`, para esa disposición; con `diagrams.layout` y `problems.layout`, para los de `sgf-diagrams` y `sgf-problem`, encima de las de `layout`.]

#opcion("layout.columns", valor: [`auto` o un número], inicial: `auto`)[La cantidad de columnas de la grilla. Con `auto`, los diagramas van en el párrafo, sin grilla.]

#opcion("layout.width", valor: [una longitud, una fracción del ancho o `auto`], inicial: `100%`)[
  El ancho de la grilla. Si es menor que el de la línea, la grilla se centra. Cada columna mide lo que queda al restarle los `column-sep` a `width`, repartido entre las columnas; un tablero más angosto queda en su columna según `align`, así que entre dos tableros hay más espacio que `column-sep`.

  Con `auto`, la grilla se ajusta a los diagramas: las columnas tienen el ancho del diagrama más ancho (con su epígrafe, que se corta como sin grilla, #pag(<diagramas>)) y entre dos tableros del mismo ancho queda exactamente `column-sep`. La grilla mide eso por la cantidad de columnas (o de diagramas, si son menos) y se centra en la línea. `fit` no sirve con `width: auto`: es un error.

  ```ejemplo-abajo
  #goban-layout(columns: 2, width: auto,
    column-sep: 0em, row-sep: 0em,
    board(partial: "A9:E5", scale: 0.9,
      stones(black: "C7")),
    board(partial: "E9:J5", scale: 0.9,
      stones(white: "G7")),
    board(partial: "A1:E5", scale: 0.9,
      stones(black: "C3")),
    board(partial: "E1:J5", scale: 0.9,
      stones(white: "G3")))
  ```
]

#opcion("layout.column-sep", valor: [una longitud], inicial: `1em`)[El espacio entre las columnas.]
#opcion("layout.row-sep", valor: [una longitud], inicial: `1em`)[El espacio entre las filas.]

#opcion("layout.fit", valor: [`true` o `false`], inicial: `false`)[Escala cada tablero para que llene el ancho de su columna; reemplaza el `scale` del tablero. Las líneas no cambian de grosor. En `sgf-diagrams` y `sgf-problem`, todos los tableros usan la escala que llena la columna con el primero, así las piedras tienen el mismo tamaño en todos; si con esa escala un tablero no entra en la columna (un problema más ancho que el primero, por ejemplo), solo ese tablero se achica hasta llenarla. Solo con `columns`, y no con `width: auto`. Sin un ancho disponible (una disposición medida con `measure` sin `width`), la grilla toma el ancho de los diagramas, sin `fit`.]

#opcion("layout.align", valor: [`left`, `center` o `right`], inicial: `center`)[
  Dónde va cada diagrama dentro de su columna, con su epígrafe y sus notas. Los comentarios van siempre según `comments.align`.

  ```ejemplo-abajo
  #sgf-diagrams(partida, step: 2, to: 6,
    layout: (columns: 2, width: 60%,
      column-sep: 3em, row-sep: 2em,
      align: left))
  ```
]

#opcion("layout.per-page", valor: [`none` o un número], inicial: `none`)[
  Cada tantos diagramas, empieza una página nueva: con `per-page: 1`, un diagrama por página. En la grilla, una fila a medias se dibuja antes del corte; conviene que el número sea un múltiplo de `columns`. Con `none`, no hay cortes. En `sgf-problem` con `statement: "alone"`, el enunciado cuenta como un diagrama. Con varias columnas de página (`columns` de Typst, o `columns` en `page`), el corte pasa a la columna siguiente.

  ```codigo
  #sgf-diagrams(lee, step: 50, layout: (columns: 2, fit: true, per-page: 4))
  ```
]
