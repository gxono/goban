// sgf-problem con links: el epígrafe del enunciado enlaza a la primera solución y el de cada solución, al
// enunciado, también entre dos sgf-problem. Un destino que no está, o que está dos veces, no lleva enlace.

#import "/lib.typ": *

#let problema = sgf-read(path("/tests/sgf/problema.sgf"))
#sgf-problem(problema, links: true, solutions: false)
#sgf-problem(problema, links: true, statement: false, goban: (scale: 0.3), layout: (columns: 4))

// Otro problema, dibujado dos veces: sus destinos están dos veces. Y uno sin links: no lleva destinos.
#let otro = sgf-read("(;SZ[5]PL[B]AW[bb];B[cb];W[bc])")
#sgf-problem(otro, links: true, goban: (scale: 0.3))
#sgf-problem(otro, links: true, goban: (scale: 0.3))
#sgf-problem(sgf-read("(;SZ[5]PL[W]AB[cc];W[dd])"), goban: (scale: 0.3))

#context {
  let dests = query(link).map(l => str(l.dest))
  let to(part) = dests.filter(d => d.ends-with("-" + part)).len()
  // Del enunciado a la solución 1; de las cuatro soluciones, al enunciado.
  assert.eq(dests.len(), 5, message: repr(dests))
  assert.eq(to("1"), 1)
  assert.eq(to("statement"), 4)
  // Los destinos: el enunciado y la primera solución de problema, dos veces los de otro.
  assert.eq(query(metadata).filter(m => m.has("label") and str(m.label).starts-with("gobanist-problem-")).len(), 6)
}
