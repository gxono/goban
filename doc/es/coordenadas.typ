#import "../estilo.typ": *
#import "/lib.typ": *

= Sintaxis de coordenadas <coordenadas>

Las intersecciones se escriben como en el go: una letra para la columna, desde la izquierda, y un número para la fila, desde abajo. `"C3"` es la tercera columna y la tercera fila. Las letras van en mayúscula y sin la I, salvo con `use-i` (#pag(<use-i>)).

`stones`, `prisoners` y `marks` reciben, para cada jugador o cada forma, una cadena con una o muchas intersecciones, escritas con una sintaxis que permite abreviar:

- varias entradas separadas por comas;
- filas, columnas, tramos, rectángulos y caminos;
- intersecciones que se quitan de la lista, después de un `;`.

La misma sintaxis sirve para `moves` (sin el `;`), para los vértices de `territory` y para `hoshi.at`. Las flechas y las líneas, y `partial`, reciben intersecciones sueltas.

```ejemplo-abajo
#gobanist-set(profile: "pgfgosmooth")

#goban(size: 17, partial: "A1:R5", label: (at: (top, left)),
  stones(black: "*; B, D, H, M, R2, Q, F2:4, K2 r L5, O[1:2, 4]; B3"))
```

Una coordenada que no se entiende, o que está fuera del tablero, es un error. Los espacios separan los elementos, pero no pueden ir dentro de una intersección: `"B3"` es B3, y `"B 3"` es un error.

== Formas sueltas

Estas formas van solas: no se encadenan con los operadores de la #pag(<caminos>), y se separan de las demás con comas.

=== Todo el tablero

`*` son todas las intersecciones *visibles* del tablero: con `partial`, las de la parte que se ve.

```ejemplo
#gobanist-set(size: 5, partial: "B2:D4")

#goban(label: (at: (bottom, left)),
  stones(black: "*"))
```

=== Intersección

Una letra y un número, juntos: `"C2"`.

```ejemplo
#gobanist-set(size: 5, partial: "B2:D4")

#goban(label: (at: (bottom, left)),
  stones(black: "C2, D3", white: "B4"))
```

=== Columnas y filas enteras

Una letra sola es una columna entera: `D` es la columna D. Un número solo es una fila entera: `4` es la fila 4.

```ejemplo
#gobanist-set(size: 5, partial: "B2:D4")

#goban(stones(black: "B2, B3, B4"),
  stones("D", fill: (color: red)))
#goban(stones(black: "B2, C2, D2"),
  stones("4", fill: (color: blue)))
// Las líneas C y 3, menos C3.
#goban(stones("C, 3; C3",
  fill: (color: orange)))
```

=== Tramos

Un tramo es una parte de una fila o de una columna: `C:D2` es la fila 2, de C a D; `B2:4` es la columna B, de 2 a 4. Entre la letra y el número puede ir un espacio: `C:D 2`, `B 2:4`. Los tramos van del primer extremo al segundo: `H9:2` baja de H9 a H2, y `E:A2` va de E2 a A2.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A:E5", fill: (color: red)),
  stones("H9:2", fill: (color: blue)),
  stones("E:A2", fill: (color: orange)),
  stones("A:D7, A:C9", fill: (color: fuchsia)))
```

Con dos rangos, un tramo es un rectángulo: `A:E 7:8` son las columnas A a E de las filas 7 y 8. Los operadores de la sección siguiente lo escriben más claro: `A7:E8`.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A:E 7:8", fill: (color: red)),
  stones("J:G 9:2", fill: (color: blue)),
  stones("A:B 2:4, F:D 1:3",
    fill: (color: orange)))
```

=== Productos

Una letra seguida de una lista entre corchetes se reparte en cada elemento de la lista: `A[1:3, 5, 7:8]` es `A1:3, A5, A7:8`. Los elementos no tienen por qué ser números: `A[:D 5:7, 1:2]` es `A:D 5:7, A1:2`. Del mismo modo, una lista entre corchetes seguida de un número: `[A, C, E:G]12` es `A12, C12, E:G12`. Y dos listas, una tras otra, se combinan todas con todas: `[A, D:F][2, 5, 7:9]` es `A2, A5, A7:9, D:F2, D:F5, D:F 7:9`. Los corchetes no se anidan.

```ejemplo
#goban(stones(black: "[A, D:F][2, 5, 7:9]"),
  marks(cross: "A2, A5, A7:9, D:F2, D:F5,
    D:F 7:9", player: "black"))
```

== Caminos <caminos>

Los operadores unen dos intersecciones con un camino, y se encadenan.

=== En ángulo recto

`A1 -| D3` va de A1 hacia el costado hasta la columna D, y después hacia arriba hasta D3. `A1 |- D3` va primero por la columna y después por la fila. Encadenados, forman escaleras o recorridos con la métrica de Manhattan.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A1 -| D3", fill: (color: red)),
  stones("D4 -| A2", fill: (color: blue)),
  stones("A9 -| C7 -| G5", fill: (color: orange)),
  stones("F1 |- J3 -| E4", fill: (color: fuchsia)))
```

=== En cualquier dirección

`A1 -- C5` es la línea de piedras más parecida a la recta que une las dos intersecciones: una piedra por fila (o por columna, si la línea avanza más de lo que sube o baja), la más cercana a la recta. Si las dos intersecciones están en una misma fila o columna, es la línea recta entre ellas. Cuando la recta pasa justo entre dos intersecciones, la piedra va del lado del extremo más cercano, y en el medio exacto, a la columna (o la fila) menor: así, `A1 -- C5` y `C5 -- A1` dan las mismas piedras.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A1 -- A5", fill: (color: red)),
  stones("A1 -- D1", fill: (color: blue)),
  stones("B9 -- D3", fill: (color: fuchsia)),
  stones("J9 -| F6 -- J6", fill: (color: orange)))
```

=== Escaleras

Las piedras de una línea inclinada se tocan solo por las esquinas, así que en go no forman un grupo. `D1 -|- F7` y `G1 |-| J7` rellenan cada escalón con la esquina de `-|` (primero por la fila) o de `|-` (primero por la columna): el resultado es una escalera conectada. Si las dos intersecciones están en una misma fila o columna, dan la misma línea que `--`. En las escaleras, como en `-|` y `|-`, el orden de los extremos importa.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A1 -- C7", fill: (color: red)),
  stones("D1 -|- F7", fill: (color: blue)),
  stones("G1 |-| J7", fill: (color: orange)))
```

=== Rectángulos

`A1:D3` rellena el rectángulo que tiene esas dos esquinas opuestas (es la escritura de `partial`); `A5 r D8` es solo su contorno. Un rectángulo de una sola columna o de una sola fila es un tramo: `A5:A9` es `A5:9`.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A1:D3", fill: (color: red)),
  stones("A5 r D8", fill: (color: blue)),
  // ¡Está vivo!
  stones("J8 r G4, H6", fill: (color: orange)))
```

=== Encadenar

Los operadores (`-|`, `|-`, `--`, `-|-`, `|-|` y `r`) se encadenan: `A1 -| C3 -- E3` es `A1 -| C3` seguido de `C3 -- E3`, y C3 va una sola vez. Entre dos operadores puede ir una intersección, un tramo (`B5:7`, `A:B3`) o un rectángulo (`A1:C3`). Cada operador va del último punto de lo anterior al primero de lo siguiente: `A2 -| B5:7` es `A2 -| B5` seguido de `B5:7`, y `B7 -| A:B3` es `B7 -| A3 -- B3`.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A2 -| B5:7", fill: (color: red)),
  stones("J9 -| D:F6", fill: (color: blue)),
  stones("F1:3 |- J5", fill: (color: orange)))
```

Los rectángulos también se encadenan.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("J8 r G6 r J4", fill: (color: orange)),
  marks(sequence: "J8, G6, J4"),
  stones("A1:E3 r A6 |- E9 -- E8",
    fill: (color: blue.lighten(80%))),
  marks(sequence: "A1, E3, A6, E9, E8"))
```

Las formas sueltas (`*`, una columna o una fila entera, un tramo con dos rangos) no se encadenan.

== El orden de las intersecciones <orden-coordenadas>

Las intersecciones salen en el orden en que se escriben: los tramos van del primer extremo al segundo (`N10:7` baja de N10 a N7), los operadores siguen su camino y los corchetes se reparten en su lugar (`D4, B[3:1]` es `D4, B3:1`). Ese es el orden que numeran `moves` y la marca `sequence`.

```ejemplo
#goban(size: 7, label: (at: (bottom, left)),
  stones(white: "A1 -|- F4"),
  marks(sequence: "A1 -|- F4"))
#goban(size: 7, label: (at: (bottom, left)),
  stones(white: "G7:4 -| D2 -- A2"),
  marks(sequence: "G7:4 -| D2 -- A2",
    label: (format: "A")))
```

Algunas formas no tienen un recorrido fijo: los rectángulos (`A1:C3`, `A:C 1:3` y `A1 r C3`), las columnas y las filas enteras y `*`. `moves` y `sequence` las aceptan, y las recorren en un orden que no elige quien escribe.

== Quitar intersecciones

Después de un `;`, las intersecciones se quitan de la lista en lugar de agregarse. Cada `;` cambia de agregar a quitar, o de quitar a agregar, tantas veces como se quiera. `moves` no acepta el `;`: solo agrega jugadas.

Supongamos que queremos dibujar esto:

#align(center, goban(stones(black: "A1:E6; C6 |- E3, A1:2")))

Puede dividirse en partes, o pensarse como un rectángulo completo al que se le quitan las piedras marcadas:

#align(center, goban(stones(black: "A1:E6"), marks(cross: "C6 |- E3, A1:2", line: (color: white))))

```ejemplo
#gobanist-set(label: (at: (top, bottom, left, right)),
  partial: "A1:E6")

#goban(stones(black: "A1:E6"))
#goban(stones(black: "A1:E6; A1:2"))
#goban(stones(black: "A1:E6; A1:2, C6 |- E3"))
```

Primero, el rectángulo `A1:E6`; después se quita el tramo `A1:2`, y por último el camino `C6 |- E3`. Los grupos se alternan con cada `;`:

```ejemplo
#gobanist-set(label: (at: (top, bottom, left, right)),
  partial: "A1:E6")

#goban(stones(black: "A1:E6"))
#goban(stones(black: "A1:E6; A1:C4, E6"))
#goban(stones(black: "A1:E6; A1:C4, E6; A1:2"))
```

En el último, se agrega el rectángulo, se quitan `A1:C4` y `E6`, y se vuelve a agregar `A1:2`.
