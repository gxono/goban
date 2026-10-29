// Las partidas en SGF: la lectura, sgf-info y lo que el elemento sgf pone en el tablero.

#import "/lib.typ": *
#import "/src/board.typ": board, resolve
#import "/src/options.typ": current
#import "/src/game.typ": last
#import "/src/texts.typ": word

#let partida = sgf-read(path("/tests/sgf/partida.sgf"))
#let variantes = sgf-read(path("/tests/sgf/variantes.sgf"))

// Las jugadas que dibuja un tablero: (columna, fila, número o none). Necesita context.
#let moves-of(..args) = {
  let r = resolve(board(..args), current())
  r.items.filter(i => i.kind == "stone" and i.move).map(i => (i.x, i.y, if i.numbered { i.number }))
}

// Lectura: el tamaño sale de SZ; un archivo, bytes o el texto.
#assert.eq(partida.size, (9, 9))
#assert.eq(sgf-read(bytes("(;SZ[13])")).size, (13, 13))
#assert.eq(sgf-read("(;SZ[5])(;SZ[7])", game: 2).size, (7, 7))

// Las codificaciones, con los archivos de la batería de pgf-go: cada uno tiene un comentario en la raíz y dos
// jugadas. En Shift_JIS, el segundo byte de ソ y 表 es \ y el de ‐ es ]: si se leyera antes de convertirlo,
// el comentario terminaría antes.
#let charset(name, ..options) = sgf-read(path("/tests/sgf/charsets/cs-" + name + ".sgf"), ..options)
#for (name, comment) in (
  gbk: "黑先活。", big5: "黑先活。", sjis: "ソ表示‐黒先", eucjp: "黒先、生き。ｿ", euckr: "흑선 활.",
  // UTF-16 con BOM, con un carácter fuera del BMP (un par sustituto).
  utf16: "黑先活。𠀀",
  // Una raíz sin ; (archivos viejos).
  noroot: "root",
) {
  let game = charset(name)
  assert.eq(sgf-info(game, "C"), comment, message: name)
  context assert.eq(moves-of(game), ((3, 7, 1), (4, 6, 2)), message: name)
}
// Sin CA, con charset; sin ninguno, Latin-1.
#assert.eq(sgf-info(charset("forced", charset: "GBK"), "C"), "黑先活。")
#assert.eq(sgf-info(charset("forced"), "C"), "ºÚÏÈ»î¡£")
// Un archivo en UTF-8 se lee en UTF-8, digan lo que digan CA (Shift_JIS) o charset; también con una CA
// desconocida (KOI8-R).
#assert.eq(sgf-info(charset("utf8", charset: "Shift_JIS"), "C"), "黒先、生き。")
#assert.eq(sgf-info(charset("koi8r"), "C"), "x")

// sgf-info: la raíz o una jugada de una línea; lo que no está es "".
#assert.eq(sgf-info(variantes, "PB"), "Ana")
#assert.eq(sgf-info(variantes, "RE"), "B+R")
#assert.eq(sgf-info(variantes, "AB"), "dd")
#assert.eq(sgf-info(variantes, "MN", move: 4), "10")
#assert.eq(sgf-info(variantes, "TR", move: 3, variation: "C5, C3"), "ec")
#assert.eq(sgf-info(variantes, "XX"), "")

// Las jugadas: hasta to, sin número antes de from.
#context {
  let r = resolve(board(sgf(partida, from: 9, to: 10)), current())
  let moves = r.items.filter(i => i.kind == "stone" and i.move)
  assert.eq(moves.len(), 10)
  assert.eq(moves.filter(i => i.numbered).map(i => i.number), (9, 10))
  // Sigue el número 11, con negras.
  assert.eq((r.number, r.turn), (11, "black"))
}

// MN cambia el número; restart lo reinicia en cada tramo de step.
#context assert.eq(moves-of(variantes).map(m => m.at(2)), (1, 2, 3, 10, 11))
#context assert.eq(moves-of(sgf(variantes, step: 3, restart: true)).map(m => m.at(2)), (1, 2, 3, 1, 2))
#context assert.eq(moves-of(sgf(variantes, step: 3, restart: (on: true, from: 0))).map(m => m.at(2)), (1, 2, 3, 0, 1))
// Con to: 2, las marcas del archivo (SQ en la 1, CR en la 2) reemplazan los números; con marks: false, no.
#context assert.eq(moves-of(sgf(variantes, to: 2)).map(m => m.at(2)), (none, none))
#context assert.eq(moves-of(sgf(variantes, to: 2, marks: false)).map(m => m.at(2)), (1, 2))
#context assert.eq(moves-of(sgf(variantes, numbers: false)).map(m => m.at(2)), (none,) * 5)

// Las variantes, por números o por jugadas.
#context assert.eq(moves-of(sgf(variantes, variation: (2,))), moves-of(sgf(variantes, variation: "C5, C3")))
#context assert.eq(moves-of(sgf(variantes, variation: (1, 2))).len(), 4)

// Las opciones globales de sgf.
#gobanist-set(sgf: (numbers: false))
#context assert.eq(moves-of(variantes).map(m => m.at(2)), (none,) * 5)
#gobanist-set(sgf: (numbers: auto))

// Los pases cuentan para la numeración y se anotan; el que termina la línea, no.
#goban(notes: true, sgf-read("(;SZ[5];B[cc];W[];B[dd];W[cc];B[])"))
#context assert.eq(last.get().notes, ((2, none), (4, 1)))
// Los textos de las notas, en el idioma del texto; texts los cambia.
#[
  #set text(lang: "es")
  #context assert.eq(word(current(), "pass"), "pasa")
  #gobanist-set(texts: (es: (pass: "pase"), xx: (at: "@")))
  #context assert.eq(word(current(), "pass"), "pase")
  #set text(lang: "xx")
  #context assert.eq((word(current(), "at"), word(current(), "pass")), ("@", "pass"))
]

// AE quita piedras (con captures): no son prisioneros.
#goban(captures: "remove", sgf-read("(;SZ[5]AB[aa];W[bb];AE[aa];B[cc])"))
#context assert.eq(last.get().prisoners, (black: 0, white: 0))
#context {
  let r = resolve(board(captures: "remove", sgf-read("(;SZ[5]AB[aa];W[bb];AE[aa];B[cc])")), current())
  assert(r.items.first().removed)
}

// TB y TW son territorio y cuentan para el puntaje; la piedra blanca en territorio negro está muerta.
#goban(sgf-read("(;SZ[5]AB[cc]AW[aa];B[dd]TB[aa][ab])"))
#context assert.eq(last.get().score, (black: 3, white: 0, neutral: 0))

// Las letras de las variantes y la marca de la última jugada.
#context {
  let r = resolve(board(sgf(variantes, to: 1, marks: false, letters: "children")), current())
  assert.eq(r.items.filter(i => i.kind == "mark").map(i => i.options.content), ("A", "B"))
  let r = resolve(board(sgf(variantes, numbers: false, last-mark: "circle")), current())
  assert.eq(r.items.filter(i => i.kind == "mark").map(i => (i.x, i.y, i.shape)), ((3, 2, "circle"),))
}

// Una etiqueta del archivo no tapa una jugada numerada que se ve.
#context {
  let r = resolve(board(sgf-read("(;SZ[5];B[aa]LB[aa:X][bb:Y])")), current())
  let labels = r.items.filter(i => i.kind == "mark")
  assert.eq(labels.map(i => i.captured != none), (true, false))
}

// forget en sgf(...): resume no trae las piedras de la partida (con "number", las trae sin número). Era un error:
// «opción desconocida: sgf.forget».
#context {
  let p = sgf-read("(;SZ[5]AB[aa];B[cc];W[dd])")
  let kept(forget) = resolve(board(resume: (board: board(sgf(p, forget: forget)), numbers: true)), current())
    .items.map(i => (i.x, i.y, i.numbered))
  assert.eq(kept(false), ((1, 5, false), (3, 3, true), (4, 2, true)))
  assert.eq(kept(true), ())
  assert.eq(kept("number"), ((1, 5, false), (3, 3, false), (4, 2, false)))
}

// La vista (VW) en sgf (views.sgf, 9×9: A5:E9 desde la 1, todo el tablero desde la 3, F1:J4 desde la 5): con
// true, la que abarca las jugadas from a to; con un número, la de esa jugada. El partial del tablero le gana.
#let vistas = sgf-read(path("/tests/sgf/views.sgf"))
#context {
  let partial(..args) = resolve(board(..args), current()).tree.partial
  assert.eq(partial(vistas), none)
  assert.eq(partial(sgf(vistas, view: true)), none)
  assert.eq(partial(sgf(vistas, to: 2, view: true)), "A5:E9")
  assert.eq(partial(sgf(vistas, from: 5, view: true)), "F1:J4")
  assert.eq(partial(sgf(vistas, view: 0)), "A5:E9")
  assert.eq(partial(sgf(vistas, view: 3)), none)
  assert.eq(partial(sgf(vistas, view: 5)), "F1:J4")
  assert.eq(partial(partial: "A1:C3", sgf(vistas, view: 5)), "A1:C3")
}
#[
  #gobanist-set(sgf: (view: 5))
  #context assert.eq(resolve(board(vistas), current()).tree.partial, "F1:J4")
]
