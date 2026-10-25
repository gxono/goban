// La partida que juega el kernel y lo que queda del último tablero.

// error: jugada en un punto ocupado: (3, 3)
#goban(size: 5, captures: "remove", moves("C3"), moves("C3"))

// error: jugada en un punto ocupado: (3, 3)
#goban(size: 5, captures: "remove", stones(white: "C3"), moves("C3"))

// error: goban-score necesita un goban antes
#goban-score("black")

// error: goban-prisoners necesita un goban antes
#goban-prisoners("black")

// error: goban-notes necesita un goban antes
#goban-notes()

// error: goban-region necesita un goban antes
#goban-region("black", "area")

// error: goban-score: el jugador es black, white o neutral
#goban(size: 5)
#goban-score("red")

// error: goban-prisoners: el jugador es black o white
#goban(size: 5)
#goban-prisoners("neutral")

// error: goban-region: la propiedad es polygons, outlines
#goban(size: 5)
#goban-region("black", "size")

// error: goban-region: "polygon" necesita n
#goban(size: 5)
#goban-region("black", "polygon")
