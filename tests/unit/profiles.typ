// Los perfiles: profile vuelve el estilo al inicial y pone el del perfil; lo que no es estilo queda.

#import "/src/options.typ": apply, defaults

#let tree = apply(defaults, (size: 13, partial: "A1:E5", scale: 2, hoshi: (at: "C3", radius: 3pt),
  label: (at: left, sep: 1cm, rows: "a"), stone: (shadow: true)))
#let reset = apply(tree, (profile: "default"))
#assert.eq(reset.size, 13)
#assert.eq(reset.partial, "A1:E5")
#assert.eq(reset.scale, 2)
#assert.eq(reset.hoshi.at, "C3")
#assert.eq(reset.hoshi.radius, defaults.hoshi.radius)
#assert.eq(reset.label.at, left)
#assert.eq(reset.label.rows, "a")
#assert.eq(reset.label.sep, defaults.label.sep)
#assert.eq(reset.players.black.stone.shadow.on, false)

// move.numbers no es estilo.
#let off = apply(defaults, (players: (black: (move: (numbers: false))), profile: "wain"))
#assert.eq(off.players.black.move.numbers, false)

// Lo que va después del perfil se suma a él.
#let after = apply(defaults, (profile: "wain", grid: (line: (width: 2pt))))
#assert.eq(after.grid.line.width, 2pt)
#assert.eq(after.grid.line.color, rgb("#FAE0B2"))

// Un perfil dentro de otro: pgfgosmooth parte de pgfgo.
#let smooth = apply(defaults, (profile: "pgfgosmooth"))
#assert.eq(smooth.background.fill.color, rgb(220, 179, 92))
#assert.eq(smooth.background.line.on, false)
#assert.eq(smooth.players.neutral.stone.radius, 0.19cm)
#assert.eq(smooth.players.black.stone.radius, 0.17cm)

// Un diccionario es un perfil propio.
#let mine = apply(defaults, (stone: (radius: 9pt), profile: (players: (white: (stone: (fill: (color: red)))))))
#assert.eq(mine.players.white.stone.fill.color, red)
#assert.eq(mine.players.white.stone.radius, defaults.players.white.stone.radius)
