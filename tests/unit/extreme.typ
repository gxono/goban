// Los límites (los extreme-*.tex de pgf-go): SGF raros, nombres de archivo, capturas y territorio en tableros
// llenos, polígonos degenerados y resume encadenado.

#import "/lib.typ": *
#import "/src/board.typ": board, resolve
#import "/src/options.typ": current
#import "/src/game.typ": last

#let extreme(name, ..args) = sgf-read(path("/tests/sgf/extreme/" + name + ".sgf"), ..args)

// Las piedras que dibuja un tablero: (columna, fila, jugador, número o none). Necesita context.
#let stones-of(..args) = {
  let r = resolve(board(..args), current())
  r.items.filter(i => i.kind == "stone" and i.captured == none)
    .map(i => (i.x, i.y, i.player, if i.numbered { i.number }))
}

// (;) es un tablero de 19×19 vacío; una raíz sin jugadas.
#assert.eq(extreme("empty").size, (19, 19))
#assert.eq(extreme("root-only").size, (9, 9))

// Espacios y saltos de línea en todos lados y basura después de la partida.
#context assert.eq(stones-of(extreme("whitespace")), (
  (1, 7, "black", none), (2, 6, "black", none), (3, 5, "black", none),
  (4, 4, "black", 1), (5, 3, "white", 2), (6, 2, "black", 3),
))
#assert.eq(sgf-info(extreme("whitespace"), "C", move: 1), " espacios ")

// CRLF, UTF-8 con BOM y FF[3] con los nombres largos de las propiedades.
#assert.eq(sgf-info(extreme("crlf"), "C").split(regex("\s+")), ("linea", "1", "linea", "2"))
#assert.eq(sgf-info(extreme("bom"), "PB"), "Ñoño")
#assert.eq(sgf-info(extreme("old-ff3"), "PB"), "Viejo")
#context assert.eq(stones-of(extreme("old-ff3")), ((3, 3, "black", 1), (4, 2, "white", 2), (2, 4, "black", 3)))

// Corchetes, paréntesis y punto y coma dentro de los valores.
#assert.eq(sgf-info(extreme("brackets"), "C"), "a (b) ; c [d] (e;f)")
#assert.eq(sgf-info(extreme("brackets"), "C", move: 1), ")")

// Los caracteres especiales de TeX son texto.
#assert.eq(sgf-info(extreme("tex-specials"), "PB"), "A & B #1 $x$ 100%")
#assert.eq(sgf-info(extreme("tex-specials"), "GN"), "{llaves} \\textbf{no}")
#assert.eq(sgf-info(extreme("tex-specials"), "C", move: 1), "%comentario que no debe comerse el resto")
#assert.eq(sgf-info(extreme("tex-specials"), "C", move: 5), "ñandú, cigüeña, Ærøskøbing")
#context {
  let r = resolve(board(extreme("labels")), current())
  assert.eq(r.items.filter(i => i.kind == "mark").map(i => (i.x, i.y, i.options.content)), (
    (1, 9, "#"), (9, 1, "$"), (1, 1, "%"), (9, 9, "&"), (3, 7, "_"), (7, 3, "~"), (3, 3, "]"), (7, 7, "{"),
  ))
}

// B[] y, hasta 19×19, W[tt] son pases; en 21×21, tt es U2 y uu es V1.
#context assert.eq(stones-of(extreme("passes")), (
  (1, 19, "black", 3), (19, 1, "black", 5), (19, 19, "black", 7), (1, 1, "white", 8),
))
#context assert.eq(stones-of(extreme("tt-21")), ((20, 2, "black", 1), (21, 1, "white", 2), (1, 21, "black", 3)))

// Tableros rectangulares: SZ[7:13] tiene 7 columnas.
#assert.eq(extreme("size-7x13").size, (7, 13))
#assert.eq(extreme("size-13x7").size, (13, 7))
#context assert.eq(stones-of(extreme("size-7x13")).map(s => (s.at(0), s.at(1))), ((1, 13), (7, 1), (7, 13), (1, 1), (4, 7)))

// AB[aa:ss] llena el tablero; AE quita K10 y la blanca 1 juega ahí y captura 360 piedras.
#context {
  let r = resolve(board(captures: "remove", extreme("fill-all")), current())
  assert.eq(r.prisoners, (black: 0, white: 360))
  assert.eq(stones-of(captures: "remove", extreme("fill-all")), ((10, 10, "white", 1),))
}

// 1200 jugadas sobre los mismos 361 puntos, sin captures; con from: 1100, solo las de 1100 en adelante tienen
// número.
#context {
  let r = resolve(board(extreme("long-1200")), current())
  assert.eq(r.number, 1201)
  assert.eq(r.items.filter(i => i.kind == "stone" and i.numbered).len(), 1200)
  let r = resolve(board(sgf(extreme("long-1200"), from: 1100)), current())
  assert.eq(r.items.filter(i => i.kind == "stone" and i.numbered).len(), 101)
}

// 300 variantes anidadas: la línea principal llega a la última. 200 variantes de la jugada 1.
#assert.eq(sgf-info(extreme("deep-nest"), "C", move: 300), "n300")
#context assert.eq(stones-of(sgf(extreme("wide-tree"), variation: (200,))), ((11, 10, "black", 1),))
#assert.eq(sgf-info(extreme("wide-tree"), "C", move: 1, variation: (200,)), "var 200")

// Una colección de 50 partidas.
#assert.eq(sgf-info(extreme("collection-50", game: 50), "GN"), "Partida 50")
#context assert.eq(stones-of(extreme("collection-50", game: 50)), ((6, 4, "black", 1),))

// Un comentario de 600 palabras.
#assert.eq(sgf-info(extreme("huge-comment"), "C", move: 1).split(" ").filter(w => w != "").len(), 600)

// Nombres de archivo con espacios, caracteres especiales y letras que no son ASCII.
#for name in ("a#b", "a$b", "a%b", "a&b", "a'b", "a=b", "a{b}", "con espacios", "paren (1)", "problema & 1",
  "punto.doble", "tilde~x", "ñandú", "日本語") {
  let game = sgf-read(path("/tests/sgf/names/" + name + ".sgf"))
  assert(game.size.at(0) >= 2, message: name)
}

// Capturas: el suicidio de 25 piedras deja el tablero vacío; una jugada captura cuatro grupos a la vez.
#context {
  assert.eq(stones-of(captures: "remove", size: 5, stones(black: "A1:E5; C3"), moves(black: "C3")), ())
  let r = resolve(board(captures: "remove", size: 5, stones(white: "C2, B3, D3, C4",
    black: "C1, B2, D2, A3, E3, B4, D4, C5"), moves(black: "C3")), current())
  assert.eq(r.prisoners, (black: 4, white: 0))
}

// Un ko tomado 30 veces: la negra 1 toma en D3 y cada una toma la anterior; la última es la negra 31, en D3.
#context {
  let takes = range(15).map(_ => "C3, D3").join(", ")
  let r = resolve(board(captures: "remove", size: 5, stones(black: "B3, C2, C4", white: "D2, D4, E3"),
    stones(white: "C3"), moves(black: "D3, " + takes)), current())
  let alive = r.items.filter(i => i.kind == "stone" and i.captured == none and i.move)
  assert.eq(alive.map(i => (i.x, i.y, i.number)), ((4, 3, 31),))
}

// Territorio: un ajedrezado de 40 puntos, cada uno solo; con region, el tablero entero es un cuadrado.
#let checkers = range(1, 10).map(x => range(1, 10).filter(y => calc.rem(x + y, 2) == 0)
  .map(y => "ABCDEFGHJ".at(x - 1) + str(y))).flatten().join(", ")
#goban(size: 9, stones(black: checkers), territory(auto))
#context assert.eq(last.get().score.black, 40)
#goban(size: 9, stones(black: checkers), territory(auto, draw: "region"))
#context {
  let region = last.get().regions.black
  assert.eq((region.polygons, region.holes, region.vertices, region.area, region.perimeter), (1, 0, 4, 64, 32))
}

// Muchas marcas (many-marks de pgf-go, en el tablero más grande): territory(auto) en un 25×25 con una fila
// de negras son 600 puntos; y una marca en cada punto, 625.
#goban(size: 25, stones(black: "A13:Z13"), territory(auto))
#context assert.eq(last.get().score.black, 600)
#context {
  let r = resolve(board(size: 25, stones(black: "A13:Z13"), territory(auto)), current())
  assert.eq(r.territory.len(), 600)
  let r = resolve(board(size: 25, marks(triangle: "A1:Z25")), current())
  assert.eq(r.items.filter(i => i.kind == "mark").len(), 625)
}

// Polígonos degenerados: un punto tres veces, tres puntos en línea y uno cruzado (los mismos 49 puntos con
// marks, fill y region).
#for (vertices, points) in (("E5, E5, E5", 1), ("A1, E1, J1", 9)) {
  goban(size: 9, territory(black: vertices))
  context assert.eq(last.get().score.black, points)
}
#for draw in ("marks", "fill", "region") {
  goban(size: 9, territory(black: "A1, J9, J1, A9", draw: draw))
  context assert.eq(last.get().score.black, 49)
}

// Todo el tablero son prisioneros (neutral, con dame); todos menos C3, una piedra negra (24 puntos y 24
// prisioneros); todo el tablero son piedras (nada).
#goban(size: 5, prisoners(white: "A1:E5"), territory(auto, dame: true))
#context assert.eq(last.get().score, (black: 0, white: 0, neutral: 25))
#goban(size: 5, prisoners(white: "A1:E5; C3"), stones(black: "C3"), territory(auto))
#context assert.eq(last.get().score.black, 48)
#goban(size: 5, stones(black: "A1:E5"), territory(auto, draw: "region"))
#context {
  let region = last.get().regions.black
  assert.eq(last.get().score.black, 0)
  assert(region == none or (region.polygons, region.area) == (0, 0))
}

// resume con territory: trae los puntos que le quedaron al territorio; sin territory, nada.
#let base = board(size: 5, stones(black: "B1, B2, A3, B3"), territory(black: "A1, A2"))
#context {
  let kinds(spec) = resolve(board(resume: spec), current()).items.map(i => i.kind)
  assert.eq(kinds(base).filter(k => k == "territory"), ())
  let r = resolve(board(resume: (board: base, territory: true)), current())
  assert.eq(r.territory.map(((x, y, o, _)) => (x, y, o)).sorted(), ((1, 1, "black"), (1, 2, "black")))
}

// Una cadena de 60 resume, cada uno con una jugada más: el último tiene las jugadas 1 a 61.
#let chain = range(1, 61).fold(board(size: 9, moves("J9")), (b, n) => board(resume: (board: b, numbers: true),
  moves("ABCDEFGHJ".at(calc.rem(n - 1, 9)) + str(calc.div-euclid(n - 1, 9) + 1))))
#context {
  let r = resolve(board(resume: (board: chain, numbers: true)), current())
  assert.eq(r.items.map(i => i.number), range(1, 62))
  assert.eq(r.number, 62)
}
