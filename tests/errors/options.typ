// Las opciones: las que no existen, los valores que una rama no acepta, los perfiles y las formas propias.

// error: opción desconocida: backgrund
#goban(size: 5, backgrund: false)

// error: opción desconocida: background.fill.colour
#goban(size: 5, background: (fill: (colour: red)))

// error: la opción grid.line no acepta "thick"
#goban(size: 5, grid: (line: "thick"))

// error: opción desconocida: players.black.mark.triangle
#goban-set(players: (black: (mark: (triangle: true))))
#goban()

// error: opción desconocida: players.white.mark.custom
#goban-set(players: (white: (mark: (custom: [?]))))
#goban()

// error: jugador desconocido: red (son neutral, black, white y all)
#goban(players: (red: (stone: (radius: 4pt))))

// error: la opción players espera un diccionario
#goban(players: "wain")

// error: goban-set solo recibe opciones con nombre
#goban-set("wain")

// error: perfil desconocido: does-not-exist
#goban-set(profile: "does-not-exist")
#goban()

// error: profile espera el nombre de un perfil o un diccionario de opciones
#goban(profile: 3)

// error: opción desconocida: backgrund
#goban(profile: (backgrund: false))

// error: label.style es western, japanese o chinese
#goban(label: (style: "korean"))

// error: la opción sgf espera un diccionario
#goban(sgf: true)

// error: opción desconocida: sgf.form
#goban(sgf: (form: 3))

// error: sgf.restart espera true, false, auto o un diccionario
#goban(sgf: (restart: 3))

// error: shapes espera un diccionario: (nombre: forma, ...)
#goban(shapes: "star")

// error: una forma de marca no puede llamarse fill: es una opción de marks
#goban(shapes: (fill: [x]))

// error: la forma star es una función, un contenido o (image: ...)
#goban(shapes: (star: 3))

// error: opción desconocida: shapes.star.image.rotate
#goban(shapes: (star: (image: (file: path("/images/pgfgo-shadow.png"), rotate: 3deg))))

// error: la forma star necesita image.file
#goban(shapes: (star: (image: (width: 3pt))))
