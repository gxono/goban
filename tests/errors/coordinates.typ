// Las coordenadas que no se entienden y las que caen fuera del tablero (en pgf-go, avisos).

// error: coordenada desconocida: «c3»
#goban(size: 5, stones(black: "c3"))

// error: coordenada desconocida: «B 3»
#goban(size: 5, stones("B 3"))

// error: coordenada desconocida: «A1 R C3»
#goban(size: 5, stones(black: "A1 R C3"))

// error: coordenada desconocida: «A1:B2:C3»
#goban(size: 5, stones(black: "A1:B2:C3"))

// error: Z9 no está en el tablero de 5×5
#goban(size: 5, stones(black: "Z9"))

// error: E9 no está en el tablero de 5×5
#goban(size: 5, marks(circle: "E9"))

// error: A0 no está en el tablero de 5×5
#goban(size: 5, stones(black: "A0"))

// error: J5 no está en el tablero de 8×5
#goban(size: (8, 5), stones(black: "J5"))

// error: las coordenadas son texto
#goban(size: 5, moves(black: 3))

// error: las jugadas no tienen grupos que restan: «A1; B1»
#goban(size: 5, moves("A1; B1", numbers: false))

// error: arrows va de una intersección a otra: «A1:B2»
#goban(size: 5, arrows(("A1:B2", "C3")))

// error: lines va de una intersección a otra: «A1, B1»
#goban(size: 5, lines(("C3", "A1, B1")))
