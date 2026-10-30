#import "../estilo.typ": *
#import "/lib.typ": *

= Coordinate syntax <coordenadas>

Intersections are written as in Go: a letter for the column, from the left, and a number for the row, from the bottom. `"C3"` is the third column and the third row. The letters are capitals and skip the I, except with `use-i` (#pag(<use-i>)). After Z, on boards of more than 25 columns, the columns have two letters, now with the I: `AA`, `AB`, …, `AI`, …, `AZ`, `BA` (`"AA5"`, `"X2:AB2"`).

`stones`, `prisoners` and `marks` take, for each player or each shape, a string with one or many intersections, written with a syntax that allows abbreviating:

- several entries separated by commas;
- rows, columns, stretches, rectangles and paths;
- intersections removed from the list, after a `;`.

The same syntax serves for `moves` (without the `;`), for the vertices of `territory` and for `hoshi.at`. The arrows and the lines, and `partial`, take single intersections.

```ejemplo-abajo
#gobanist-set(profile: "pgfgosmooth")

#goban(size: 17, partial: "A1:R5", label: (at: (top, left)),
  stones(black: "*; B, D, H, M, R2, Q, F2:4, K2 r L5, O[1:2, 4]; B3"))
```

A coordinate that cannot be understood, or that is outside the board, is an error. Spaces separate the elements, but they cannot go inside an intersection: `"B3"` is B3, and `"B 3"` is an error.

== Single forms

These forms go alone: they are not chained with the operators on #pag(<caminos>), and they are separated from the others with commas.

=== The whole board

`*` is every *visible* intersection of the board: with `partial`, those of the visible part.

```ejemplo
#gobanist-set(size: 5, partial: "B2:D4")

#goban(label: (at: (bottom, left)),
  stones(black: "*"))
```

=== Intersection

A letter and a number, together: `"C2"`.

```ejemplo
#gobanist-set(size: 5, partial: "B2:D4")

#goban(label: (at: (bottom, left)),
  stones(black: "C2, D3", white: "B4"))
```

=== Whole columns and rows

A letter alone is a whole column: `D` is column D. A number alone is a whole row: `4` is row 4.

```ejemplo
#gobanist-set(size: 5, partial: "B2:D4")

#goban(stones(black: "B2, B3, B4"),
  stones("D", fill: (color: red)))
#goban(stones(black: "B2, C2, D2"),
  stones("4", fill: (color: blue)))
// Lines C and 3, without C3.
#goban(stones("C, 3; C3",
  fill: (color: orange)))
```

=== Stretches

A stretch is part of a row or of a column: `C:D2` is row 2, from C to D; `B2:4` is column B, from 2 to 4. There can be a space between the letter and the number: `C:D 2`, `B 2:4`. Stretches go from the first end to the second: `H9:2` goes down from H9 to H2, and `E:A2` goes from E2 to A2.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A:E5", fill: (color: red)),
  stones("H9:2", fill: (color: blue)),
  stones("E:A2", fill: (color: orange)),
  stones("A:D7, A:C9", fill: (color: fuchsia)))
```

With two ranges, a stretch is a rectangle: `A:E 7:8` are columns A to E of rows 7 and 8. The operators of the next section write it more clearly: `A7:E8`.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A:E 7:8", fill: (color: red)),
  stones("J:G 9:2", fill: (color: blue)),
  stones("A:B 2:4, F:D 1:3",
    fill: (color: orange)))
```

=== Products

A letter followed by a list in brackets is distributed over each element of the list: `A[1:3, 5, 7:8]` is `A1:3, A5, A7:8`. The elements need not be numbers: `A[:D 5:7, 1:2]` is `A:D 5:7, A1:2`. In the same way, a list in brackets followed by a number: `[A, C, E:G]12` is `A12, C12, E:G12`. And two lists, one after the other, are combined each with each: `[A, D:F][2, 5, 7:9]` is `A2, A5, A7:9, D:F2, D:F5, D:F 7:9`. Brackets are not nested.

```ejemplo
#goban(stones(black: "[A, D:F][2, 5, 7:9]"),
  marks(cross: "A2, A5, A7:9, D:F2, D:F5,
    D:F 7:9", player: "black"))
```

== Paths <caminos>

The operators join two intersections with a path, and they are chained.

=== At right angles

`A1 -| D3` goes from A1 sideways to column D, and then up to D3. `A1 |- D3` goes first along the column and then along the row. Chained, they make stairs or walks with the Manhattan metric.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A1 -| D3", fill: (color: red)),
  stones("D4 -| A2", fill: (color: blue)),
  stones("A9 -| C7 -| G5", fill: (color: orange)),
  stones("F1 |- J3 -| E4", fill: (color: fuchsia)))
```

=== In any direction

`A1 -- C5` is the line of stones closest to the straight line that joins the two intersections: one stone per row (or per column, if the line advances more than it goes up or down), the one closest to the straight line. If the two intersections are in the same row or column, it is the straight line between them. When the straight line passes exactly between two intersections, the stone goes on the side of the nearer end, and at the exact middle, on the lower column (or row): so `A1 -- C5` and `C5 -- A1` give the same stones.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A1 -- A5", fill: (color: red)),
  stones("A1 -- D1", fill: (color: blue)),
  stones("B9 -- D3", fill: (color: fuchsia)),
  stones("J9 -| F6 -- J6", fill: (color: orange)))
```

=== Ladders

The stones of a slanted line touch only at the corners, so in Go they do not make a group. `D1 -|- F7` and `G1 |-| J7` fill each step with the corner of `-|` (first along the row) or of `|-` (first along the column): the result is a connected ladder. If the two intersections are in the same row or column, they give the same line as `--`. In ladders, as in `-|` and `|-`, the order of the ends matters.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A1 -- C7", fill: (color: red)),
  stones("D1 -|- F7", fill: (color: blue)),
  stones("G1 |-| J7", fill: (color: orange)))
```

=== Rectangles

`A1:D3` fills the rectangle with those two opposite corners (it is the way `partial` is written); `A5 r D8` is only its outline. A rectangle of a single column or a single row is a stretch: `A5:A9` is `A5:9`.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A1:D3", fill: (color: red)),
  stones("A5 r D8", fill: (color: blue)),
  // It's alive!
  stones("J8 r G4, H6", fill: (color: orange)))
```

=== Chaining

The operators (`-|`, `|-`, `--`, `-|-`, `|-|` and `r`) are chained: `A1 -| C3 -- E3` is `A1 -| C3` followed by `C3 -- E3`, and C3 goes only once. Between two operators there can be an intersection, a stretch (`B5:7`, `A:B3`) or a rectangle (`A1:C3`). Each operator goes from the last point of what comes before to the first of what comes after: `A2 -| B5:7` is `A2 -| B5` followed by `B5:7`, and `B7 -| A:B3` is `B7 -| A3 -- B3`.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("A2 -| B5:7", fill: (color: red)),
  stones("J9 -| D:F6", fill: (color: blue)),
  stones("F1:3 |- J5", fill: (color: orange)))
```

Rectangles are chained too.

```ejemplo
#goban(label: (at: (top, bottom, left, right)),
  stones("J8 r G6 r J4", fill: (color: orange)),
  marks(sequence: "J8, G6, J4"),
  stones("A1:E3 r A6 |- E9 -- E8",
    fill: (color: blue.lighten(80%))),
  marks(sequence: "A1, E3, A6, E9, E8"))
```

The single forms (`*`, a whole column or row, a stretch with two ranges) are not chained.

== The order of the intersections <orden-coordenadas>

The intersections come out in the order in which they are written: stretches go from the first end to the second (`N10:7` goes down from N10 to N7), operators follow their path and brackets are distributed in place (`D4, B[3:1]` is `D4, B3:1`). That is the order numbered by `moves` and by the `sequence` mark.

```ejemplo
#goban(size: 7, label: (at: (bottom, left)),
  stones(white: "A1 -|- F4"),
  marks(sequence: "A1 -|- F4"))
#goban(size: 7, label: (at: (bottom, left)),
  stones(white: "G7:4 -| D2 -- A2"),
  marks(sequence: "G7:4 -| D2 -- A2",
    label: (format: "A")))
```

Some forms have no fixed path: rectangles (`A1:C3`, `A:C 1:3` and `A1 r C3`), whole columns and rows, and `*`. `moves` and `sequence` accept them, and go through them in an order not chosen by the writer.

== Removing intersections

After a `;`, intersections are removed from the list instead of added. Each `;` switches from adding to removing, or from removing to adding, as many times as wanted. `moves` does not accept the `;`: it only adds moves.

Suppose we want to draw this:

#align(center, goban(stones(black: "A1:E6; C6 |- E3, A1:2")))

It can be split into parts, or thought of as a full rectangle from which the marked stones are removed:

#align(center, goban(stones(black: "A1:E6"), marks(cross: "C6 |- E3, A1:2", line: (color: white))))

```ejemplo
#gobanist-set(label: (at: (top, bottom, left, right)),
  partial: "A1:E6")

#goban(stones(black: "A1:E6"))
#goban(stones(black: "A1:E6; A1:2"))
#goban(stones(black: "A1:E6; A1:2, C6 |- E3"))
```

First, the rectangle `A1:E6`; then the stretch `A1:2` is removed, and finally the path `C6 |- E3`. The groups alternate with each `;`:

```ejemplo
#gobanist-set(label: (at: (top, bottom, left, right)),
  partial: "A1:E6")

#goban(stones(black: "A1:E6"))
#goban(stones(black: "A1:E6; A1:C4, E6"))
#goban(stones(black: "A1:E6; A1:C4, E6; A1:2"))
```

In the last one, the rectangle is added, `A1:C4` and `E6` are removed, and `A1:2` is added again.
