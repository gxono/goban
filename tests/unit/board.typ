// Un tablero hecho con board va primero en goban y en board: es ese tablero, con sus opciones (rama por rama) y lo
// que tiene, más lo que se agrega.

#import "/lib.typ": *
#import "/src/board.typ": resolve
#import "/src/options.typ": defaults

#let base = board(size: 5, partial: "B2:D4", background: (fill: (color: red)), stones(black: "C3"), marks(triangle: "C3"))
#let mas = board(base, background: (line: false), moves(white: "D3"))
#assert.eq(mas.elements.len(), 3)
#import "/src/board.typ": options
#assert.eq(options(mas).size, 5)
#assert.eq(mas.layers.len(), 2)
#let r = resolve(mas, defaults)
// Las opciones se aplican rama por rama: el relleno de base y el borde de mas.
#assert.eq(r.tree.background.fill.color, red)
#assert.eq(r.tree.background.line.on, false)
#assert.eq(r.tree.partial, "B2:D4")
// Trae todo: las marcas y la numeración siguen.
#assert.eq(r.items.filter(i => i.kind == "mark").len(), 1)
#assert.eq(r.items.find(i => i.kind == "stone" and i.move).number, 1)
// Las opciones de afuera le ganan a las del tablero.
#assert.eq(resolve(board(base, partial: none), defaults).tree.partial, none)
#goban(base)
#goban(base, moves("D3"))

// El tamaño de la fuente no cambia el tablero: la grilla, el fondo, los números, las marcas y las etiquetas.
#let medido = goban(size: 5, label: (at: (bottom, left)), moves("B2, C3, D4"),
  marks(triangle: "B4", sequence: "A5, B5"), marks(custom: "D2", content: [ab]),
  moves("E5", label: (format: "1")))
#context {
  let chico = measure({ set text(size: 6pt); medido })
  let grande = measure({ set text(size: 20pt); medido })
  assert.eq(chico, grande)
}
