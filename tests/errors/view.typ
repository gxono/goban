// goban-view: el tablero, la parte y las opciones de la rama view.

// error: goban-view recibe un tablero, la parte y opciones con nombre
#goban-view(board(size: 5), "C3", "D4")

// error: goban-view espera un tablero hecho con board(...) o una partida
#goban-view("tablero", "C3")

// error: goban-view espera la parte como texto, "C3", "B2:E4" o "C3, D4"
#goban-view(board(size: 5), (3, 3))

// error: goban-view espera intersecciones o rectángulos separados por comas, "C3, B2:E4": «C3:D»
#goban-view(board(size: 5), "C3:D")

// error: goban-view: «F6» no está en el tablero de 5×5
#goban-view(board(size: 5), "F6")

// error: view.marks es true o false
#goban-view(board(size: 5), "C3", marks: "no")

// error: view.forgotten es true o false
#goban-view(board(size: 5), "C3", forgotten: 1)

// error: view.raise es auto o una longitud
#goban-view(board(size: 5), "C3", raise: 2)

// error: la opción view.goban no acepta "wain"
#goban-view(board(size: 5), "C3", goban: "wain")

// error: view.goban no puede cambiar captures: es del tablero que se ve
#goban-view(board(size: 5), "C3", goban: (captures: "remove"))

// error: view.goban no puede cambiar size: es del tablero que se ve
#gobanist-set(view: (goban: (size: 9)))
#goban-view(board(size: 5), "C3")

// error: goban-view espera intersecciones o rectángulos separados por comas, "C3, B2:E4": «»
#goban-view(board(size: 5), "C3, ")

// error: goban-view: «F6» no está en el tablero de 5×5
#goban-view(board(size: 5), "C3, F6")

// error: view.separator es un texto o un contenido
#goban-view(board(size: 5), "C3, D4", separator: 1)

// error: view.last es un texto o un contenido, o auto
#goban-view(board(size: 5), "C3, D4", last: none)

// error: goban-stone recibe el jugador, "black", "white" o "neutral"
#goban-stone("negro")

// error: goban-stone no tiene la opción at
#goban-stone("black", at: "C3")

// error: goban-stone: number es un número desde 1
#goban-stone("black", number: 0)

// error: goban-stone: una piedra con number es de negras o de blancas
#goban-stone(number: 3)

// error: goban-stone: una piedra con number no puede ser prisionera
#goban-stone("white", number: 3, prisoner: true)

// error: goban-stone: prisoner es true o false
#goban-stone("white", prisoner: "sí")
