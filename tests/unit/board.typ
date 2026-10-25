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
