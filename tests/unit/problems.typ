// Lo que usa sgf-problem: quién juega y si cada solución es correcta.

#import "/lib.typ": *
#import "/src/sgf.typ": query
#import "/src/problems.typ": first-player, verdict

#let read(text, ..path) = query(sgf-read(text), (kind: "read", path: (numbers: path.pos()), chat: true))
#let problema = sgf-read(path("/tests/sgf/problema.sgf"))
#let line(..path) = query(problema, (kind: "read", path: (numbers: path.pos()), chat: true))

// Quién juega: PL; si no está, el color de la primera jugada; si no hay jugadas, nadie.
#assert.eq(first-player(read("(;SZ[9]PL[W];B[aa])")), "white")
#assert.eq(first-player(read("(;SZ[9]AB[aa];W[bb])")), "white")
#assert.eq(first-player(read("(;SZ[9]AB[aa])")), none)

// TE y BM: la primera jugada que tiene uno; las impares son de quien juega.
#assert.eq(verdict(line(1, 1), "black"), "correct")
#assert.eq(verdict(line(2), "black"), "wrong")
#assert.eq(verdict(line(3), "black"), none)
#assert.eq(verdict(read("(;SZ[9];B[aa];W[bb]BM[1])"), "black"), "correct")
#assert.eq(verdict(read("(;SZ[9];B[aa];W[bb]TE[1])"), "black"), "wrong")
#assert.eq(verdict(read("(;SZ[9];B[aa]BM[1];W[bb]TE[1])"), "black"), "wrong")
// GB y GW ganan, y vale el último; sin quién juega, no cuentan.
#assert.eq(verdict(read("(;SZ[9];B[aa]BM[1];W[bb]GB[1])"), "black"), "correct")
#assert.eq(verdict(read("(;SZ[9];B[aa]GW[1];W[bb]GB[1])"), "white"), "wrong")
#assert.eq(verdict(read("(;SZ[9];B[aa]GB[1])"), none), none)
// RIGHT en un comentario, como en goproblems.com.
#assert.eq(verdict(read("(;SZ[9];B[aa];W[bb]C[RIGHT])"), "black"), "correct")

// El veredicto se separa de «Variante 2» con un espacio que se puede cortar (antes, uno irrompible: en un tablero
// angosto, el epígrafe se salía de su lugar y pisaba al de al lado).
#import "/src/problems.typ": problem-group
#context {
  let p = sgf-read("(;SZ[9]AB[aa](;W[bb]TE[1])(;W[cc]BM[1]))")
  let items = problem-group((p,), (verdict: true, statement: false)).items
  let caption = items.first().caption
  assert(repr(caption).contains("[ ]") or repr(caption).contains("space"), message: repr(caption))
  assert(not repr(caption).contains("\u{a0}("), message: repr(caption))
}
