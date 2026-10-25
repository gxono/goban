// El tablero: su tamaño, su parte visible, resume y lo que va adentro.

// error: size espera un número o (columnas, filas)
#goban(size: "19x")

// error: size espera un número o (columnas, filas)
#goban(size: (5, 5, 5))

// error: tamaño fuera de rango: 1
#goban(size: 1)

// error: tamaño fuera de rango: (26, 5)
#goban(size: (26, 5))

// error: partial espera dos esquinas, como "B2:D4": «C3»
#goban(size: 5, partial: "C3")

// error: partial: «A1:F6» no está en el tablero
#goban(size: 5, partial: "A1:F6")

// error: captures es none, "remove" o "fade"
#goban(size: 5, captures: true)

// error: captured-marks es "keep" o "remove"
#goban(size: 5, captures: "remove", captured-marks: "fade")

// error: lo que va en un tablero son piedras, jugadas, marcas o una partida
#goban(size: 5, [C3])

// error: lo que va en un tablero son piedras, jugadas, marcas o una partida
#board(size: 5, (a: 1))

// error: resume espera un tablero hecho con board(...) o (board: ...
#goban(size: 5, resume: none)

// error: resume espera un tablero hecho con board(...) o (board: ...
#goban(size: 5, resume: "a")

// error: resume no tiene la opción captures
#let a = board(size: 5, stones(black: "C3"))
#goban(resume: (board: a, captures: true))

// error: resume espera un tablero hecho con board(...)
#goban(resume: (board: stones(black: "C3")))

// error: un tablero hecho con board(...) va primero, y uno solo
#let a = board(stones(black: "C3"))
#goban(stones(black: "C2"), a)

// error: un tablero hecho con board(...) va primero, y uno solo
#let a = board(stones(black: "C3"))
#goban(a, a)
