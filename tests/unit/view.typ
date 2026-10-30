// goban-view: lo que esconde y que no cambia lo que guarda el último tablero.

#import "/src/options.typ": apply, defaults
#import "/src/board.typ": board, resolve
#import "/src/view.typ": seen
#import "/src/game.typ": last
#import "/lib.typ": *

#let v = defaults.view
#assert.eq(v.goban, (scale: 0.8, background: (line: false)))
// view.goban es abierto: se mezcla rama por rama.
#let tree = apply(apply(defaults, (view: (goban: (background: false)))), (view: (marks: false, goban: (grid: false))))
#assert.eq(tree.view.goban, (scale: 0.8, background: false, grid: false))
#assert.eq(tree.view.marks, false)

#let b = board(size: 5, stones(black: "B2", mark: "circle"), stones(white: "D3", forget: true),
  moves("C2"), moves("C3", forget: "number"), marks(triangle: "B2"), arrows(("A1", "E5")), lines(("A5", "E1")),
  territory(white: "D4, D5, E5, E4"))
#let r = resolve(b, defaults)
#let hidden(s) = s.items.filter(i => i.at("hide", default: false)).map(i => i.kind)
#let numbered(s) = s.items.filter(i => i.kind == "stone" and i.numbered).map(i => i.number)

// Por defecto, todo menos lo olvidado; la jugada con forget: "number" sin su número.
#let s = seen(r, v)
#assert.eq(hidden(s), ("stone",))
#assert.eq(numbered(s), (1,))
#assert.eq(s.territory.len(), 4)
#let s = seen(r, v + (forgotten: true))
#assert.eq(hidden(s), ())
#assert.eq(numbered(s), (1, 2))
#let s = seen(r, v + (marks: false, arrows: false, lines: false, numbers: false, territory: false))
#assert.eq(hidden(s), ("stone", "mark", "arrows", "lines", "territory"))
#assert.eq(numbered(s), ())
#assert.eq(s.items.first().mark, none)
#assert.eq(s.territory, ())

// Una vista no cambia lo que guarda el último goban.
#goban(size: 5, captures: "remove", stones(black: "C3"), moves(white: "D4"))
#goban-view(board(size: 5, captures: "remove", stones(white: "A1"), moves(black: "A2, C3, B1")), "A1:C3")
#context assert.eq(last.get().prisoners, (black: 0, white: 0))
#context assert.eq(last.get().score, (black: 0, white: 0, neutral: 0))

// Una etiqueta de una partida bajo el número de una jugada se ve si la vista esconde el número.
#let etiqueta = board(sgf-read("(;SZ[5];B[dc];W[cc]LB[cc:A])"))
#let label(s) = s.items.find(i => i.kind == "mark").captured
#let r = resolve(etiqueta, defaults)
#assert.ne(label(seen(r, v)), none)
#assert.eq(label(seen(r, v + (numbers: false))), none)
