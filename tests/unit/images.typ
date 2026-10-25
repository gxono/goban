// Las imágenes: el archivo y el giro de cada lugar, siempre los mismos; los cuartos de vuelta; las baldosas.

#import "/src/draw/images.typ": pick, turn, quarter, tile-starts, mesh-size, files
#import "/src/options.typ": apply, defaults

#let all = (path("/images/pgfgo-shell-white-1.png"), path("/images/pgfgo-shell-white-2.png"), bytes((1, 2)))
#for x in range(1, 20) {
  for y in range(1, 20) {
    assert(pick(all, x, y) in all)
    assert.eq(pick(all, x, y), pick(all, x, y))
    let a = turn((-15deg, 15deg), x, y)
    assert(a >= -15deg and a <= 15deg)
    assert.eq(turn(30deg, x, y), 30deg)
  }
}
// Los lugares no usan todos el mismo archivo.
#assert(range(1, 10).map(x => pick(all, x, 1)).dedup().len() > 1)
#assert.eq(quarter(100deg), 90deg)
#assert.eq(quarter(-90deg), 270deg)
#assert.eq(quarter(359deg), 0deg)

// Las baldosas cubren el tramo: desde el principio, desde el final y con una en el medio.
#assert.eq(tile-starts(0pt, 25pt, 10pt, "start"), (0pt, 10pt, 20pt))
#assert.eq(tile-starts(0pt, 25pt, 10pt, "end"), (15pt, 5pt, -5pt))
#assert.eq(tile-starts(0pt, 30pt, 10pt, "center"), (0pt, 10pt, 20pt))
#assert.eq(mesh-size(3), (3, 3))
#assert.eq(mesh-size((2, 4)), (2, 4))
#assert.eq(files(bytes((1,))).len(), 1)

// En una rama de imagen, lo que no es un diccionario es el archivo: none la quita.
#let tree = apply(defaults, (stone: (image: all.first())))
#assert.eq(tree.players.black.stone.image.file, all.first())
#assert.eq(apply(tree, (players: (black: (stone: (image: none))))).players.black.stone.image.file, none)
#assert.eq(apply(defaults, (background: (fill: (image: (file: all, fit: "tile"))))).background.fill.image.fit, "tile")
