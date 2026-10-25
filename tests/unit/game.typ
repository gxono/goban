// Los resultados del juego: prisioneros, notas, puntaje y regiones del último goban.

#import "/lib.typ": *
#import "/src/game.typ": last

#let check(..expected) = context {
  let data = last.get()
  for (key, value) in expected.named() { assert.eq(data.at(key), value, message: key) }
}

// La 3 captura a la 2.
#goban(size: 5, captures: "remove", moves("B1, A1, A2"))
#check(prisoners: (black: 1, white: 0))

// Sin capturas no hay prisioneros.
#goban(size: 5, moves("B1, A1, A2"))
#check(prisoners: (black: 0, white: 0))

// Un ko: la 3 retoma en el punto de la 1 y la 4, en el de la 2; cada una captura.
#goban(size: 5, notes: true, captures: "remove", stones(black: "B3, C2, C4"), stones(white: "D2, D4, E3"),
  moves(white: "C3"), moves("D3"), moves(white: "C3", from: 3), moves("D3"))
#check(notes: ((3, 1), (4, 2)), prisoners: (black: 2, white: 1))

// Las notas cuentan solo las jugadas numeradas que se ven.
#goban(size: 5, partial: "A1:B2", notes: true, moves("C3, D4, C3"))
#check(notes: ())
#goban(size: 5, notes: true, moves("C3, D4", numbers: false), moves("C3"))
#check(notes: ())

// El puntaje del manual de pgf-go: negras 10, blancas 5 (11.5 con komi 6.5).
#goban(size: 5, stones(black: "C1:5"), stones(white: "D1:5"), territory(auto))
#check(score: (black: 10, white: 5, neutral: 0))

// La región del manual: un territorio con un hueco.
#goban(stones(white: "D4:F6"), territory(black: "B2, B8, H8, H2", draw: "region"))
#context {
  let r = last.get().regions.black
  assert.eq((r.polygons, r.outlines, r.holes, r.vertices, r.area, r.perimeter), (2, 1, 1, 8, 60, 40))
  assert.eq(r.contours.at(1), ((4, 4), (4, 6), (6, 6), (6, 4)))
}

// Una jugada en un punto ocupado, con capturas, es un error (se prueba en errors: no compila).
