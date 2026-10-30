#import "/lib.typ": *
#set page(width: 16cm, height: auto, margin: 0.5cm)
#set text(lang: "es")

// Los casos de sgf-problem.tex de pgf-go. problema.sgf: 19×19, PL[B], comentario en la raíz; tres primeras
// jugadas, la primera con dos respuestas: cuatro líneas, 1.1, 1.2, 2 y 3.
#let problema = sgf-read(path("/tests/sgf/problema.sgf"))
#let views = sgf-read(path("/tests/sgf/views.sgf"))
// problemas.sgf: tres problemas de 9×9; el 1 sin PL ni jugadas, el 2 con PL[W], el 3 con dos soluciones
// (B A9 TE «Correcto.»; B D9 BM «Incorrecto.», W A9).
#let problemas = range(1, 4).map(n => sgf-read(path("/tests/sgf/problemas.sgf"), game: n))

// El enunciado (A16:F19) y las cuatro variantes, con sus comentarios.
#sgf-problem(problema)

// title, variation-title y caption; sin comentarios ni notas; los textos de quién juega (gobanist-set vale hasta
// que se cambia: después se deja como estaba).
#gobanist-set(texts: (es: (black-to-play: "Juegan negras")))
#sgf-problem(problema, title: [Problema 1], variation-title: n => [Variante #n],
  caption: (text: (style: "italic")), comments: false, notes: false)
#gobanist-set(texts: (es: (black-to-play: "Juega Negro")))

// Solo el enunciado, todo el tablero; las opciones de goban.
#sgf-problem(problema, solutions: false, partial: none, goban: (scale: 0.4))

// Solo las soluciones, con partial-margin: 3 (A14:H19), sin anotaciones.
#sgf-problem(problema, statement: false, goban: (partial-margin: 3), annotations: false)

// Una partida con vista: se usa la vista; con view: false, partial: auto.
#sgf-problem(views, solutions: false)
#sgf-problem(views, solutions: false, view: false)

// Varias partidas: los enunciados «Problema 1» (sin quién juega), «Problema 2: Juega Blanco», «Problema 3:
// Juega Negro» y después «Problema 3: Variante 1» y «2».
#sgf-problem(..problemas, goban: (scale: 0.5), layout: (columns: 4))

// Las partidas 1 y 3, to-play, title, sin comentarios ni soluciones.
#sgf-problem(problemas.at(0), problemas.at(2), to-play: "black", title: "Ejercicio", comments: false,
  solutions: false, goban: (scale: 0.5), layout: (columns: 4))

// verdict: en problemas.sgf 3, la variante 1 es correcta (TE en la jugada 1) y la 2 incorrecta (BM en la 1);
// en problema.sgf, la 1 y la 2 correctas (TE), la 3 incorrecta (BM) y la 4 sin nada.
#sgf-problem(problemas.at(2), verdict: true, statement: false, goban: (scale: 0.5), layout: (columns: 4))
#sgf-problem(problema, verdict: true, statement: false, comments: false, goban: (scale: 0.5),
  layout: (columns: 4))

// statement: "alone": el enunciado va solo en su fila; en el párrafo y en la grilla.
#sgf-problem(problema, statement: "alone", comments: false, notes: false, goban: (scale: 0.5))
#sgf-problem(problema, statement: "alone", comments: false, goban: (scale: 0.5), layout: (columns: 4))

// Los comentarios al costado y después.
#sgf-problem(problemas.at(2), comments: (position: right), goban: (scale: 0.5))
#sgf-problem(problemas.at(2), comments: (position: "after"), goban: (scale: 0.5))

// La vista de sgf no llega a los problemas: con view: false, partial: auto.
#[
  #gobanist-set(sgf: (view: 5))
  #sgf-problem(views, solutions: false, view: false)
]

// partial con dos esquinas: el enunciado y las soluciones muestran esa parte, aunque el archivo tenga vista.
#sgf-problem(views, solutions: false, partial: "D3:J9")
#sgf-problem(problema, partial: "A12:H19", goban: (scale: 0.5), layout: (columns: 5))
