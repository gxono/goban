#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// goban-view: el tablero como quedó, con las capturas, en una intersección o un rectángulo, en el texto.
#let tablero1 = board(size: 5, captures: "remove", stones(black: "B3, C2, C4", white: "D2, D4, E3"),
  moves(white: "C3, D3"))
#goban(resume: (board: tablero1, numbers: true))

La negra en D3 #goban-view(tablero1, "D3") captura la blanca de C3 #goban-view(tablero1, "C3").
Así quedó el ko: #goban-view(tablero1, "B2:E4").

// Las marcas, los números y el estilo.
#let tablero2 = board(size: 5, stones(black: "B2, C3"), moves(white: "C2, D3"), marks(triangle: "C3"))
#goban-view(tablero2, "B2:D3")
#goban-view(tablero2, "B2:D3", marks: false, numbers: false)
#goban-view(tablero2, "B2:D3", goban: (grid: false))
#goban-view(tablero2, "B2:D3", goban: (background: false))
#goban-view(tablero2, "B2:D3", goban: (profile: "wain"))

// Flechas, líneas y territorio.
#let flechas = board(size: 5, stones(black: "B2", white: "D4"), arrows(("B2", "D4")), lines(("B4", "D2")),
  marks(triangle: "C3"), territory(black: "A1, A3, C3, C1"))
#goban-view(flechas, "A1:E5")
#goban-view(flechas, "A1:E5", arrows: false, territory: false)
#goban-view(flechas, "A1:E5", lines: false, marks: false)

// Lo olvidado, solo con forgotten.
#let tablero3 = board(size: 5, stones(black: "B2, C3"), stones(white: "D3", forget: true), moves("D2", forget: "number"))
#goban-view(tablero3, "B2:D3")
#goban-view(tablero3, "B2:D3", forgotten: true)

// raise y las opciones de todas las vistas.
Texto #goban-view(tablero2, "C3", raise: 0pt) texto #goban-view(tablero2, "C3") texto
#goban-view(tablero2, "C3", raise: 0.7em).

#gobanist-set(view: (goban: (background: false, scale: 1)))
Sin fondo y más grande: #goban-view(tablero2, "C3").

// Una partida, y un tablero con resume.
#let partida = sgf-read(path("/tests/sgf/partida.sgf"))
#goban-view(sgf(partida, to: 10), "B3:G7")
#goban-view(board(resume: tablero2, moves("B3")), "B2:D3")

// Una etiqueta de una partida bajo el número de una jugada se ve si la vista esconde el número.
#let etiqueta = sgf-read("(;SZ[5];B[dc];W[cc]LB[cc:A])")
#goban-view(etiqueta, "B2:D4") #goban-view(etiqueta, "B2:D4", numbers: false)

// El fondo de las vistas va sin borde, aunque el tablero lo tenga (la sombra queda); vuelve con
// background.line o con un profile.
#gobanist-set(view: (goban: (background: (on: true, line: false), scale: 0.8)))
#let liso = board(size: 9, stones(black: "C3", white: "D4"))
#let madera = board(liso, profile: "wain")
#let sombra = board(liso, background: (shadow: (on: true, offset: 6pt, opacity: 1), line: (color: red)))
#goban-view(liso, "B2:E5") #goban-view(liso, "C3")
#goban-view(madera, "B2:E5") #goban-view(madera, "C3")
#goban-view(sombra, "B2:E5") #goban-view(sombra, "C3")

#goban-view(sombra, "B2:E5", goban: (background: (line: true)))
#goban-view(liso, "B2:E5", goban: (profile: "wain"))
#gobanist-set(view: (goban: (background: (line: true))))
#goban-view(sombra, "B2:E5")

// Varias partes, separadas por comas: una vista por parte, unidas con separator y, antes de la última, last (con
// auto, el texto and del idioma). Con dos partes, solo last. Las opciones valen para todas.
#gobanist-set(view: (goban: (background: (line: false))))
#let lista = board(size: 9, stones(black: "C3, D4, E5", white: "D3, E4"), marks(cross: "F7, G7, F6, G6, H6"))
Las piedras #goban-view(lista, "C3, D4") son negras. Las cruces #goban-view(lista, "F7, G7, F6, G6, H6").
Mezcla: #goban-view(lista, "C3, D3:E4, A8:B9").
#goban-view(lista, "C3, D4, E5", separator: "; ", last: " o ").
#text(lang: "en")[#goban-view(lista, "C3, D4, E5").]
#goban-view(lista, "F7, G7, F6", goban: (background: false), marks: false).

// goban-stone: una piedra en el texto, con marca, número o como prisionera, del tamaño y a la altura de la vista
// de una intersección.
Negra #goban-stone("black"), blanca #goban-stone("white"), neutral #goban-stone() y #goban-stone("neutral");
x#goban-stone("black")x#goban-stone("white")x.
#goban-stone("black", mark: "triangle") #goban-stone("white", mark: "circle")
#goban-stone("black", mark: (shape: "custom", content: [A]))
#goban-stone("black", number: 5) #goban-stone("white", number: 12) #goban-stone("black", number: 123)
#goban-stone("white", number: 6, mark: "square")
#goban-stone("black", prisoner: true) #goban-stone("white", prisoner: true, mark: "cross")
#let junto = board(size: 9, stones(black: "C3"), moves("D4"), marks(triangle: "C3"))
#goban-view(junto, "C3", goban: (background: false))#goban-stone("black", mark: "triangle")
#goban-view(junto, "D4", goban: (background: false))#goban-stone("black", number: 1)

// El estilo del lugar y el de las vistas; las opciones globales del tablero (partial, label) no la cambian.
#gobanist-set(stone: (fill: (pattern: tiling(size: (3pt, 3pt), circle(radius: 0.5pt, fill: red)))))
#goban-stone("black") #goban-stone("white")
#gobanist-set(profile: "default", partial: "A1:H8", label: (at: (top, left)), view: (goban: (scale: 1.5)))
#goban-stone("black", number: 5)
#gobanist-set(view: (goban: (scale: 0.8), raise: 0pt))
x#goban-stone("white")x
#gobanist-set(view: (raise: auto, goban: (profile: "draft")))
#goban-stone("black") #goban-stone("white", number: 3)
#gobanist-set(partial: none, label: (at: ()), view: (goban: (profile: "default", background: (line: false))))

// goban-stone no cambia lo que dice el último tablero.
#goban(size: 5, notes: true, moves("B2, C3, B2"))
Antes: #goban-notes(). #goban-stone("black", number: 4) Después: #goban-notes().
