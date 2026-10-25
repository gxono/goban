#import "/lib.typ": *
#set page(width: 16cm, height: auto, margin: 0.5cm)
#set text(lang: "es")

// Los ejemplos de «Diagramas como en los libros» en el manual de pgf-go.
#let partida = sgf-read(path("/tests/sgf/partida.sgf"))
#let variantes = sgf-read(path("/tests/sgf/variantes.sgf"))
#let problema = sgf-read(path("/tests/sgf/problema.sgf"))

Jugada 7: #sgf-comment(partida, 7) \
Con: #sgf-comment(partida, 7) #h(1em) Sin: #sgf-comment(partida, 7, annotations: false) \
#sgf-comment(problema, 1, variation: (2,))

#sgf-diagrams(partida, step: 5)
#sgf-diagrams(partida, step: 5, to: 10, numbers: false, last-mark: "circle")
#sgf-diagrams(partida, step: (2, 3), to: 8, restart: (on: true, from: 0))
#sgf-diagrams(partida, from: 6, title: "Figura", caption: (text: (style: "italic")),
  goban: (label: (at: (top, left))))

// En el párrafo, los diagramas pasan a la línea siguiente cuando no entran.
#sgf-diagrams(partida, step: 2, goban: (scale: 0.7))

// La grilla, fit y los comentarios debajo, al costado y después.
#sgf-diagrams(partida, step: 5, comments: (on: true, root: true), layout: (columns: 2))
#sgf-diagrams(partida, step: 5, comments: (on: true, position: right))
#sgf-diagrams(partida, step: 4, layout: (columns: 3, fit: true))
#sgf-diagrams(partida, step: 5, comments: (on: true, position: "after", number: n => [Jugada #n. ]))

// comments.height: lo que no entra va después de los diagramas, con el epígrafe; el corte es entre palabras.
#let largos = sgf-read("(;SZ[9];B[ee]C[Negras toman el centro, una apertura poco común pero firme.];W[cc]
  C[Blancas responden en la esquina.];B[gg];W[gc]C[Una jugada lenta: Negras toman la iniciativa.];B[cg]
  C[El último comentario, bastante largo para que no entre en el espacio que queda debajo del tablero.])")
#sgf-diagrams(largos, step: 3, comments: (on: true, height: 2.5em), layout: (columns: 3), goban: (scale: 0.5))
#sgf-diagrams(largos, step: 3, comments: (on: true, position: right, height: 2em), goban: (scale: 0.4))
#sgf-diagrams(largos, step: 3, comments: (on: true, position: left, width: 4cm, height: 4em),
  layout: (columns: 2), goban: (scale: 0.4))

// Una piedra numerada capturada dentro del tramo no se quita: el ko se retoma como «12 en 4». Las de antes
// del tramo, sí.
#let ko = sgf-read("(;SZ[5];B[bb];W[cb];B[ac];W[bc];B[bd];W[dc];B[aa];W[cd];B[cc];W[ee];B[ea];W[bc])")
#sgf-diagrams(ko, step: 12)
#sgf-diagrams(ko, step: (8, 4))

// El resultado: en palabras, como está o con otros nombres; y el puntaje con TB y TW.
#sgf-diagrams(variantes)
#sgf-diagrams(variantes, result: (title: "Final", format: "raw"))
#sgf-diagrams(variantes, result: (black: "Ana", white: "Bruno"))
#sgf-diagrams(sgf-read("(;SZ[5]KM[0.5]AB[cc][cb][bc]AW[dd];B[dc]TB[aa][ab][ba][bb]TW[ee][ed][de])"))

// Las variantes (var-tree.sgf, 9×9: E5, C7 y tres líneas en la 3: la principal, G3, G7 «Main.», C3; la 2, G7
// comentada, con la 2.2 desde la 4, C3 comentada, G3; y la 3, C3, G3).
#let tree = sgf-read(path("/tests/sgf/var-tree.sgf"))
#sgf-diagrams(tree, step: 2, comments: true, variations: true, goban: (scale: 0.5))
#sgf-diagrams(tree, step: 2, comments: true, variations: (on: true, select: "all", depth: 2), goban: (scale: 0.5))
// Las de paths, en el orden del árbol; los 1 del final no cambian la línea.
#sgf-diagrams(tree, step: 2, variations: (paths: ((3,), (2, 2, 1))), goban: (scale: 0.5))
// Desde otra línea, la principal también es una variante; from y variation-title.
#sgf-diagrams(tree, variation: (2,), variations: (on: true, select: "all"), step: 3, goban: (scale: 0.4))
#sgf-diagrams(tree, variation: "E5 C7 G7", variations: true, step: 3, goban: (scale: 0.4))
#sgf-diagrams(tree, variation: (2, 2), variations: (paths: ((1,),)), step: 3, goban: (scale: 0.4))
#sgf-diagrams(tree, variation: (2,), variations: (on: true, select: "all", from: 4), step: 3,
  variation-title: n => [en la #n], comments: (on: true, position: "after"), goban: (scale: 0.4))

// Las figuras (FG): un diagrama por figura, con su nombre en el epígrafe; las jugadas antes de la primera, otro.
// Con figures: false, los de step.
#let figuras = sgf-read("(;SZ[7];B[cc];W[ec];B[ce]FG[:Apertura];W[ee];B[dd];W[de]FG[];B[cd];W[ed]FG[2:Final];B[dc])")
#sgf-diagrams(figuras, goban: (scale: 0.6))
#sgf-diagrams(figuras, from: 5, restart: (on: true, from: 1), goban: (scale: 0.6))
#sgf-diagrams(figuras, figures: false, step: 5, goban: (scale: 0.6))

// La vista (VW): cada diagrama muestra la de sus jugadas (A5:E9, todo el tablero, F1:J4); una variante, la de su
// línea. Con view: false, todo el tablero; el partial de goban le gana a la vista.
#let vistas = sgf-read(path("/tests/sgf/views.sgf"))
#sgf-diagrams(vistas, step: 2, goban: (scale: 0.4))
#sgf-diagrams(sgf-read("(;SZ[9]VW[aa:ee];B[cc](;W[dd])(;VW[ee:ii]W[gg]C[x]))"), variations: true,
  goban: (scale: 0.4))
#sgf-diagrams(vistas, step: 2, view: false, goban: (scale: 0.4))
#sgf-diagrams(vistas, step: 2, goban: (scale: 0.4, partial: "A1:G9"))

// partial: auto: la misma parte en todos los diagramas, también en los de las variantes (N10:T19, la que usan la
// línea y las variantes); con partial-margin: 0, O11:T19; con to, la de la línea entera. La vista le gana (A5:E9,
// todo el tablero, F1:J4) y el partial de goban, a las dos.
#let josekis = sgf-read(path("/tests/sgf/josekis.sgf"))
#sgf-diagrams(josekis, partial: auto, step: 2, variations: true, goban: (scale: 0.4))
#sgf-diagrams(josekis, partial: auto, goban: (scale: 0.4, partial-margin: 0))
#sgf-diagrams(josekis, partial: auto, step: 2, to: 2, goban: (scale: 0.4))
#sgf-diagrams(vistas, partial: auto, step: 2, goban: (scale: 0.4))
#sgf-diagrams(josekis, partial: auto, step: 3, goban: (scale: 0.4, partial: "M10:T19"))

// La vista de sgf no llega a los diagramas: eligen la suya (con view: false, todo el tablero).
#[
  #goban-set(sgf: (view: 5))
  #sgf-diagrams(vistas, step: 2, view: false, goban: (scale: 0.4))
]

// Lo que capturan las jugadas del diagrama no se quita, aunque no tenga número: la negra 1 captura la blanca
// de AW en C3, que queda; en el segundo, la blanca 2 retoma el ko en C3 (se ve la 2, no la de AW) y la negra 1
// queda.
#pagebreak()
#let ko = sgf-read("(;SZ[5]AB[bc][cb][cd]AW[cc][db][ec][dd];B[dc];W[cc])")
#sgf-diagrams(ko, step: 1, layout: (columns: 2))
#sgf-diagrams(ko, step: 2)
