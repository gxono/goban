// Los elementos: piedras, jugadas, marcas, flechas, líneas y territorio.

// error: stones recibe las coordenadas como texto, en una sola cadena por jugador
#stones("A1", "B2")

// error: stones no tiene la opción color
#stones(black: "A1", color: red)

// error: moves no tiene la opción player
#moves("A1", player: "black")

// error: moves recibe una sola secuencia de jugadas
#moves(black: "A1", white: "B2")

// error: las jugadas son de negras o de blancas
#moves(neutral: "A1")

// error: mark espera una forma ("triangle") o un diccionario con shape
#stones(black: "A1", mark: (scale: 2))

// error: forget acepta true, false: "number"
#stones(black: "A1", forget: "number")

// error: forget acepta true, false, "number": 1
#moves("A1", forget: 1)

// error: marks recibe las coordenadas como texto, en una sola cadena por forma
#marks("A1", "B2")

// error: marks: las coordenadas de triangle son texto
#marks(triangle: 3)

// error: la marca custom necesita content
#marks(custom: "C3")

// error: jugador desconocido: "red"
#marks(circle: "C3", player: "red")

// error: forma de marca desconocida: trinagle
#goban(size: 5, marks(trinagle: "C3"))

// error: forma de marca desconocida: trinagle
#goban(size: 5, marks(trinagle: "A1, B2, C3"))

// error: forma de marca desconocida: trinagle
#goban(size: 5, stones(black: "C3", mark: "trinagle"))

// error: arrows recibe pares de intersecciones
#arrows("A1", "B2")

// error: arrows recibe pares de intersecciones
#arrows()

// error: lines no tiene la opción tip
#lines(("A1", "B2"), tip: "circle")

// error: territory recibe un solo polígono o auto por jugador
#territory("A1, A3", auto)

// error: territory no tiene la opción color
#territory(black: "A1, A3", color: red)

// error: territory necesita un polígono o auto
#territory(draw: "fill")

// error: territory espera los vértices como texto, o auto
#territory(black: 3)

// error: territory.draw es "marks", "fill" o "region"
#territory(auto, draw: "lines")

// error: forma de marca desconocida: trinagle
#goban(size: 5, territory(white: "A1, A3", mark: "trinagle"))

// error: shift espera (columnas, filas), dos números enteros
#stones(black: "A1", shift: 2)

// error: shift espera (columnas, filas), dos números enteros
#marks(triangle: "A1", shift: (1, 1.5))

// error: B2 (corrida (4, 0)) no está en el tablero de 5×5
#goban(size: 5, moves("A2, B2", shift: (4, 0)))
