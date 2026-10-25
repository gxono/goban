// Los valores que se comprueban al dibujar: etiquetas, flechas e imágenes.

// error: label.at espera top, bottom, left o right
#goban(size: 5, label: (at: (top, center)))

// error: label.columns-direction es ltr o rtl
#goban(size: 5, label: (columns-direction: ttb))

// error: label.rows-direction es btt o ttb
#goban(size: 5, label: (rows-direction: ltr))

// error: arrow.tip es stealth, triangle o circle
#goban(size: 5, arrows(("A1", "C3"), tip: "square"))

// error: arrow.tips es end o both
#goban(size: 5, arrows(("A1", "C3"), tips: "start"))

// error: background.fill.image.fit es "stretch", "cover" o "tile"
#goban(size: 5, background: (fill: (image: (file: path("/images/pgfgo-board.jpg"), fit: "contain"))))

// error: grid.image.fit es "stretch" o "tile"
#goban(size: 5, grid: (image: (file: path("/images/pgfgo-board.jpg"), fit: "cover")))

// error: una imagen es un path (path("piedra.png")) o sus bytes
#goban(size: 5, players: (black: (stone: (image: "pgfgo-shell-black.png"))), stones(black: "C3"))

// error: file: el arreglo de imágenes está vacío
#goban(size: 5, players: (black: (stone: (image: ()))), stones(black: "C3"))

// error: rotate espera un ángulo, "random" o (mínimo, máximo)
#goban(size: 5, players: (black: (stone: (image: (file: path("/images/pgfgo-shell-black.png"), rotate: 3)))),
  stones(black: "C3"))

// error: tiles espera un número o (columnas, filas)
#goban(size: 5, background: (fill: (image: (file: path("/images/pgfgo-board.jpg"), fit: "tile", tiles: "2"))))
