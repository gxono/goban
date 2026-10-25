// El parser de coordenadas. Compila solo si todo da lo esperado.

#import "/src/coordinates.typ": parse, column-letter

// Las intersecciones como texto, en orden.
#let names(text, ..args) = parse(text, ..args).points.map(p => column-letter(p.at(0), false) + str(p.at(1))).join(" ")
#let sorted(text, ..args) = names(text, ..args).split(" ").sorted().join(" ")
#let ordered(text, ..args) = parse(text, ..args).ordered

// Intersecciones y tramos.
#assert.eq(names("C2, D3"), "C2 D3")
#assert.eq(names("B2:4, C:D2"), "B2 B3 B4 C2 D2")
#assert.eq(names("B 2:4, C:D 2"), "B2 B3 B4 C2 D2")
#assert.eq(names("H9:7, E:C2"), "H9 H8 H7 E2 D2 C2")
#assert.eq(names("I2"), "J2")

// Lo que va solo, en la parte visible.
#assert.eq(names("C, 3; C3", window: (2, 2, 4, 4)), "C2 C4 B3 D3")
#assert.eq(names("*", window: (2, 2, 3, 3)), "B2 B3 C2 C3")
#assert.eq(names("A:B 1:2"), "A1 A2 B1 B2")
#assert.eq(ordered("C"), false)
#assert.eq(ordered("A:B 1:2"), false)

// Corchetes.
#assert.eq(names("[A, D:F][2, 5, 7:9]"), names("A2, A5, A7:9, D:F2, D:F5, D:F 7:9"))
#assert.eq(names("A[:D 5:7, 1:2, 3, :G9]"), names("A:D 5:7, A1:2, A3, A:G9"))
#assert.eq(names("[A, C, E:G]12", window: (1, 1, 19, 19)), "A12 C12 E12 F12 G12")

// Operadores.
#assert.eq(names("A1 -| C3"), "A1 B1 C1 C2 C3")
#assert.eq(names("F1 |- J3"), "F1 F2 F3 G3 H3 J3")
#assert.eq(names("A1 -- C5"), "A1 A2 B3 C4 C5")
#assert.eq(names("C5 -- A1"), "C5 C4 B3 A2 A1")
#assert.eq(names("B9 -- D3"), "B9 B8 C7 C6 C5 D4 D3")
#assert.eq(names("D1 -|- F7"), "D1 D2 E2 E3 E4 E5 F5 F6 F7")
#assert.eq(names("G1 |-| J7"), "G1 G2 G3 H3 H4 H5 H6 J6 J7")
#assert.eq(names("B1 r D3"), "B1 C1 D1 D2 D3 C3 B3 B2")
#assert.eq(names("A1 r B2"), "A1 B1 B2 A2")
#assert.eq(ordered("B1 r D3"), false)
#assert.eq(ordered("A1 -- C5"), true)

// Encadenamiento: el punto que comparten dos tramos va una vez.
#assert.eq(names("A1 -| C3 -- E3"), "A1 B1 C1 C2 C3 D3 E3")
#assert.eq(names("A2 -| B5:7"), "A2 B2 B3 B4 B5 B6 B7")
#assert.eq(names("B7 -| A:B3"), "B7 A7 A6 A5 A4 A3 B3")
#assert.eq(names("G7:4 -| D2 -- A2"), "G7 G6 G5 G4 F4 E4 D4 D3 D2 C2 B2 A2")
#assert.eq(names("J8 r G6 r J4"), "J8 H8 G8 G7 G6 H6 J6 J7 J5 J4 H4 G4 G5")

// Grupos que suman y restan.
#assert.eq(sorted("A1:E6; C6 |- E3, A 1:2;"), sorted("A6:B3, B2:E1, D4:E6"))
#assert.eq(names("A1:C1; B1; B1"), "A1 C1 B1")
#assert.eq(ordered("C3; A1:B2"), true)

// Las jugadas se repiten.
#assert.eq(names("C3, C3"), "C3")
#assert.eq(names("C3, C3", moves: true), "C3 C3")

// use-i.
#assert.eq(parse("I2, J2", use-i: true).points, ((9, 2), (10, 2)))
#assert.eq(parse("I2, J2").points, ((9, 2),))
