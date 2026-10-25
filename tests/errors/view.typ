// goban-view: el tablero, la parte y las opciones de la rama view.

// error: goban-view recibe un tablero, la parte y opciones con nombre
#goban-view(board(size: 5), "C3", "D4")

// error: goban-view espera un tablero hecho con board(...) o una partida
#goban-view("tablero", "C3")

// error: goban-view espera la parte como texto, "C3" o "B2:E4"
#goban-view(board(size: 5), (3, 3))

// error: goban-view espera una intersección o dos esquinas, "C3" o "B2:E4": «C3:D»
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
#goban-set(view: (goban: (size: 9)))
#goban-view(board(size: 5), "C3")
