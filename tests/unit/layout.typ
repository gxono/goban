// Lo que reconoce goban-layout: tableros, partidas y los diagramas de sgf-diagrams y sgf-problem.

#import "/lib.typ": *
#import "/src/layout.typ": source

#let partida = sgf-read("(;SZ[5];B[cc];W[dc])")
#let tablero = board(size: 5, stones(black: "C3"))

#assert.eq(source(tablero), (kind: "board", board: tablero))
#assert.eq(source(partida).kind, "board")
#assert.eq(source(partida).board.elements, (partida,))
#let d = source(sgf-diagrams(partida, step: 1))
#assert.eq(d.kind, "diagrams")
#assert.eq(d.options, (step: 1))
#let p = source(sgf-problem(partida, partida, statement: false))
#assert.eq(p.kind, "problem")
#assert.eq(p.games.len(), 2)
#assert.eq(p.options, (statement: false))

// Un epígrafe más ancho que su tablero se corta en las líneas que le hacen falta, parejas: «Problema 1:» y
// «Juegan Negras», no «Problema 1: Juegan» y «Negras». Nunca más angosto que su palabra más larga.
#import "/src/arrange.typ": caption-width, flat
#assert.eq(flat([Problema~1: Juegan Negras]), "Problema\u{a0}1: Juegan Negras")
#context {
  let caption = [Problema 1: Juegan Negras]
  let t = (size: 10pt)
  let line(body) = measure(text(..t, body)).width
  // Un tablero más ancho que «Problema 1: Juegan»: el texto se angosta igual.
  let w = caption-width(caption, t, line[Problema 1: Juegan] + 2pt, 8em)
  assert(w.text >= line[Juegan Negras] and w.text < line[Problema 1: Juegan], message: repr(w))
  assert(w.diagram >= w.text)
  assert.eq(caption-width([corto], t, 40pt, 8em), (diagram: 40pt, text: 40pt))
  assert.eq(caption-width(none, t, 40pt, 8em), (diagram: 40pt, text: 40pt))
  assert(caption-width([Variante~2 (incorrecta)], t, 10pt, 1em).text >= line[Variante~2])
}

// goban-layout con fit, medido sin un ancho disponible (measure sin width): la grilla toma el ancho de los
// diagramas; antes era el error «cannot create line with infinite length».
#context measure(goban-layout(columns: 2, fit: true, tablero, tablero))
