// Los comentarios (sgf-comment) y lo que usa sgf-diagrams: la numeración de cada diagrama, las piedras que
// no se quitan y el resultado en palabras.

#import "/lib.typ": *
#import "/src/board.typ": board, resolve
#import "/src/options.typ": current
#import "/src/sgf.typ": query, sgf-options, shown-numbers, comment-body, view-between
#import "/src/diagrams.typ": result-text, chosen-branches, diagram-spans, drawn-extent
#import "/src/arrange.typ": split
#import "/src/draw/goban.typ": draw
#set text(lang: "es")

#let partida = sgf-read(path("/tests/sgf/partida.sgf"))
#let problema = sgf-read(path("/tests/sgf/problema.sgf"))

// El texto de un contenido, sin formato.
#let plain(c) = {
  if c == none { "" }
  else if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(plain).join() }
  else if c.has("body") { plain(c.body) }
  else if c.func() == [ ].func() { " " }
  else { "" }
}

// sgf-comment: el nombre y las anotaciones, cada una con su punto, y el comentario.
#context {
  let tree = current()
  let step(game, move, ..args) = query(game, (kind: "read", chat: true, ..args.named())).steps.at(move)
  assert.eq(plain(comment-body(tree, step(partida, 7), true)), "Tesuji. Negras capturan.")
  assert.eq(plain(comment-body(tree, step(partida, 7), false)), "Negras capturan.")
  assert.eq(plain(comment-body(tree, step(partida, 0), true)), "Una partida corta.")
  assert.eq(comment-body(tree, step(partida, 3), true), none)
  assert.eq(plain(comment-body(tree, step(problema, 1, path: (numbers: (2,))), true)),
    "Mala jugada. Incorrecto: Blancas viven.")
  // N va en negrita, antes de las anotaciones; TE[2] es «muy buen tesuji».
  let named = sgf-read("(;SZ[5];B[aa]N[Clave]TE[2]C[Bien.])")
  let body = comment-body(tree, step(named, 1), true)
  assert.eq(plain(body), "Clave. Muy buen tesuji. Bien.")
  assert(repr(body).contains("strong"))
}

// La numeración de un diagrama: con first, la jugada from se muestra con ese número y las siguientes siguen.
#context {
  let r = query(partida, (kind: "read", chat: true))
  let o = sgf-options(sgf(partida, from: 6), current())
  assert.eq(shown-numbers(r, o, first: 1).slice(4, 8), (5, 1, 2, 3))
  assert.eq(shown-numbers(r, o).slice(4, 8), (5, 6, 7, 8))
}

// keep: una piedra numerada que se captura dentro del tramo sigue marcada para dibujarse.
#context {
  let game = sgf(sgf-read("(;SZ[5];B[ab];W[aa];B[ba])"), from: 1) + (keep: true)
  let r = resolve(board(captures: "remove", game), current())
  let white = r.items.find(i => i.kind == "stone" and i.player == "white")
  assert(white.captured != none and white.keep)
  // Antes de from, no.
  let game = sgf(sgf-read("(;SZ[5];B[ab];W[aa];B[ba])"), from: 3) + (keep: true)
  let r = resolve(board(captures: "remove", game), current())
  assert(not r.items.find(i => i.kind == "stone" and i.player == "white").keep)
}

// El resultado en palabras.
#context {
  let tree = current()
  let names = (black: "Negro", white: "Blanco")
  assert.eq(result-text(tree, "B+R", names), "Gana Negro por abandono")
  assert.eq(result-text(tree, "w+resign", names), "Gana Blanco por abandono")
  assert.eq(result-text(tree, "W+3.5", names), "Gana Blanco por 3.5 puntos")
  assert.eq(result-text(tree, "B+", names), "Gana Negro")
  assert.eq(result-text(tree, "B+T", names), "Gana Negro por tiempo")
  assert.eq(result-text(tree, "W+F", names), "Gana Blanco por incomparecencia")
  assert.eq(result-text(tree, "0", names), "Empate (jigo)")
  assert.eq(result-text(tree, "Void", names), "Sin resultado")
  assert.eq(result-text(tree, "?", names), "Resultado desconocido")
  assert.eq(result-text(tree, "B+mucho", names), "B+mucho")
}

// Las variantes que se dibujan: con on, las que elige select hasta depth y desde from; las de paths, siempre.
#context {
  let tree = sgf-read(path("/tests/sgf/var-tree.sgf"))
  let chosen(variation: none, ..v) = {
    let d = current().diagrams
    d.variation = variation
    d.variations += v.named()
    chosen-branches(tree, d, false)
  }
  let paths(..args) = chosen(..args).map(b => b.path)
  assert.eq(paths(), ())
  assert.eq(paths(on: true), ((2,),))
  assert.eq(paths(on: true, select: "all"), ((2,), (3,)))
  assert.eq(paths(on: true, select: "all", depth: 2), ((2,), (2, 2), (3,)))
  assert.eq(paths(paths: ((3,), (2, 2, 1))), ((2, 2), (3,)))
  assert.eq(paths(paths: ("E5 C7 C3",)), ((3,),))
  // Desde la 2, la principal es una variante; from cuenta desde la jugada donde nace.
  assert.eq(paths(variation: (2,), on: true, select: "all"), ((), (3,), (2, 2)))
  assert.eq(paths(variation: (2,), on: true, select: "all", from: 4), ((2, 2),))
  let b = chosen(variation: (2,), on: true, select: "all").last()
  assert.eq((b.born, b.start, b.last), (4, 4, 5))
}

// Los tramos por figura (FG): desde donde empieza cada una hasta antes de la siguiente; las jugadas antes de la
// primera son un tramo más. Una figura en un nodo sin jugada empieza en la siguiente; FG[] no tiene nombre.
#context {
  let figures = sgf-read("(;SZ[5];B[aa];W[ba]FG[:Uno];B[ca];W[da]FG[];B[ea]FG[3:Tres];W[ab];B[bb])")
  let r = query(figures, (kind: "read", chat: true))
  let spans(..options) = {
    let d = current().diagrams + options.named()
    d.step = if type(d.step) == int { (d.step,) } else { d.step }
    diagram-spans(d, r.figures, options.named().at("last", default: r.moves), r.moves).map(
      s => (s.n, s.start, s.from, s.to, s.name))
  }
  assert.eq(spans(), ((1, 1, 1, 1, none), (2, 2, 2, 3, "Uno"), (3, 4, 4, 4, none), (4, 5, 5, 7, "Tres")))
  // from deja los mismos tramos, con el mismo número; last corta el último y quita los que empiezan después.
  assert.eq(spans(from: 3), ((2, 2, 3, 3, "Uno"), (3, 4, 4, 4, none), (4, 5, 5, 7, "Tres")))
  assert.eq(spans(last: 4), ((1, 1, 1, 1, none), (2, 2, 2, 3, "Uno"), (3, 4, 4, 4, none)))
  // Con figures: false, o sin FG, los tramos de step.
  assert.eq(spans(figures: false, step: 4), ((1, 1, 1, 4, none), (2, 5, 5, 7, none)))
  // Un nodo sin jugada antes de la primera: la figura empieza en la 1.
  let root = sgf-read("(;SZ[5]FG[:Todo];B[aa];W[ba])")
  let d = current().diagrams + (step: (50,))
  let r = query(root, (kind: "read", chat: true))
  assert.eq(diagram-spans(d, r.figures, r.moves, r.moves).map(s => (s.start, s.to, s.name)), ((1, 2, "Todo"),))
}

// Una partida sin jugadas es un tramo vacío, con el nombre de su figura (FG en la raíz).
#context {
  let d = current().diagrams
  let vacia = sgf-read("(;SZ[5]FG[0:Posición]AB[cc])")
  let r = query(vacia, (kind: "read", chat: true))
  assert.eq(diagram-spans(d, r.figures, 0, 0), ((n: 1, start: 1, from: 1, to: 0, name: "Posición"),))
  assert.eq(diagram-spans(d + (figures: false), r.figures, 0, 0).first().name, none)
}

// La vista (VW) de cada diagrama: la que abarca las de sus jugadas (views.sgf, 9×9: A5:E9 desde la 1, todo el
// tablero desde la 3 y F1:J4 desde la 5, en un nodo sin jugada). La jugada 0 tiene la de la 1; antes de la
// primera vista, o si en alguna jugada se ve todo, none.
#{
  let r = query(sgf-read(path("/tests/sgf/views.sgf")), (kind: "read", chat: true))
  assert.eq(view-between(r, 1, 2), (1, 5, 5, 9))
  assert.eq(view-between(r, 0, 0), (1, 5, 5, 9))
  assert.eq(view-between(r, 1, 3), none)
  assert.eq(view-between(r, 3, 4), none)
  assert.eq(view-between(r, 4, 5), none)
  assert.eq(view-between(r, 5, 5), (6, 1, 9, 4))
  let r = query(sgf-read("(;SZ[9];B[aa];W[bb]VW[aa:cc];B[cc]VW[gg:hh])"), (kind: "read", chat: true))
  assert.eq(view-between(r, 1, 2), none)
  assert.eq(view-between(r, 2, 2), (1, 7, 3, 9))
  assert.eq(view-between(r, 2, 3), (1, 2, 8, 9))
  assert.eq(view-between(query(problema, (kind: "read", chat: true)), 1, 1), none)
}

// partial: auto: las piedras y jugadas de la línea entera (aunque pase de to) y de las variantes que se dibujan.
#{
  let game = sgf-read("(;SZ[9]AB[ia];B[cc](;W[dd];B[ee])(;W[gg]C[x]))")
  let main = (main: true, variation: none)
  assert.eq(drawn-extent(game, (main,), false), (3, 5, 9, 9))
  assert.eq(drawn-extent(game, (main, (main: false, variation: (2,))), false), (3, 3, 9, 9))
  assert.eq(drawn-extent(game, ((main: true, variation: "C7, G3"),), false), (3, 3, 9, 9))
  assert.eq(drawn-extent(sgf-read("(;SZ[9])"), (main,), false), none)
}

// comments.height: split corta entre palabras (acá, la altura es 1pt por letra), sin los espacios de las puntas;
// strong y emph quedan en las dos partes.
#{
  let size(c) = plain(c).len() * 1pt
  let body = [#strong("5"): Tesuji. Negras *capturan bien*.#parbreak()Otra]
  let (top, rest) = split(body, 12pt, size)
  assert.eq(plain(top), "5: Tesuji.")
  assert.eq(plain(rest), "Negras capturan bien.Otra")
  assert(repr(top).contains("strong") and repr(rest).contains("strong"))
  let (top, rest) = split(body, 28pt, size)
  assert.eq(plain(top), "5: Tesuji. Negras capturan")
  assert.eq(plain(rest), "bien.Otra")
  assert.eq(split(body, 100pt, size), (body, none))
  let (top, rest) = split(body, 0.5pt, size)
  assert.eq(top, none)
  assert.eq(plain(rest), plain(body))
}

// Una jugada en un punto ocupado (una partida que no es legal): en los diagramas quita la piedra que había, sin
// prisioneros. Si esa piedra es una jugada del diagrama, se ve ella y se anota «N en M»; si es de antes, se ve
// la jugada.
#context {
  let game = sgf-read(path("/tests/sgf/extreme/occupied.sgf"))
  let diagram(g) = resolve(board(captures: "remove", notes: true, g), current(), replace: true)
  let r = diagram(sgf(game))
  let stones = r.items.filter(i => i.kind == "stone")
  assert.eq(stones.map(i => i.at("removed", default: false)), (true, true, false))
  assert.eq(r.prisoners, (black: 0, white: 0))
  assert.eq(draw(r).notes, ((2, 1), (3, 1)))
  let r = diagram(sgf(game, from: 3))
  let stones = r.items.filter(i => i.kind == "stone")
  assert.eq(stones.map(i => (i.numbered, i.at("removed", default: false))),
    ((false, true), (false, true), (true, false)))
  assert.eq(draw(r).notes, ())
}
#sgf-diagrams(sgf-read(path("/tests/sgf/extreme/occupied.sgf")))
