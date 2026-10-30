#import "/lib.typ": *
#set page(width: 16cm, height: auto, margin: 0.5cm)

// Los diagramas de Sensei's Library (los casos de diagram.tex y diagram-blank.tex de pgf-go): el título como
// epígrafe, la parte del tablero que dice el diagrama (su vista), 13×13, jugadas; flechas con coordenadas del
// tablero y del diagrama, y una línea; un tablero de 5×5 por sus cuatro bordes, con W primero y las jugadas que
// faltan (los números siguen); un archivo con tres diagramas (texto alrededor, [go] de L19); y _, el blank.
#let nadare = sgf-read("$$c13 Nadare joseki on a small board
$$  --------------
$$ | . . . . . . .
$$ | . . . . . . .
$$ | . . . 1 6 . .
$$ | . . 5 4 . . .
$$ | . . 3 2 . . .
$$ | . . . . . . .
$$ | . . . . . . .")
#sgf-diagrams(nadare, goban: (scale: 0.5))
#let arrows = sgf-read("$$Bc Example: using arrows to show influence
$$  ------------------
$$ | . . . . . . . . .
$$ | . . . . . . . . .
$$ | . O O O . O . . .
$$ | . O X X X . . . .
$$ | . X . . . . . . .
$$ | . . X . . . . . .
$$ | . . . . . . . . .
$$ | . . . . . . . . .
$$ | . . . . . . . . .
$$ {AR C14 C11}
$$ {AR 5:6 5:9}
$$ {LN 7:3 9:5}")
#sgf-diagrams(arrows, goban: (scale: 0.5))
#let small = sgf-read("$$W Ko (5 at 1, 8 at 2)
$$ +---------+
$$ |. . 3 4 .|
$$ |. . O X .|
$$ |. O 2 1 X|
$$ |. . O X .|
$$ |. . 7 6 .|
$$ +---------+")
#sgf-diagrams(small, goban: (scale: 0.5))
#for g in (1, 2, 3) { sgf-diagrams(sgf-read(path("/tests/sgf/sensei.txt"), game: g), goban: (scale: 0.4)) }
#let pair = sgf-read("$$B Two shapes
$$ ------------------------
$$  _ X O . O _ _ X . X O _
$$  _ X O . O _ _ X . X O _
$$  _ X O . O _ _ X . X O _
$$  _ X W . O _ _ X . . O _
$$  _ X . . O _ _ X . B O _
$$  _ X O O O _ _ X X X O _
$$  _ _ _ _ _ _ _ _ _ _ _ _

$$W Before and after
$$ +-------------------+
$$ | . . . _ . . . . . |
$$ | . X . _ . X 1 . . |
$$ | . O . _ . O . . . |
$$ +-------------------+")
#sgf-diagrams(pair, goban: (scale: 0.6))
#goban(pair, scale: 0.6)
#sgf-problem(sgf-read(pair.data, game: 2), goban: (scale: 0.6))

// syntax: "sgf" lee como SGF un texto que tiene líneas $$ (en un comentario).
#goban(sgf-read("(;SZ[5]C[$$ . X .];B[cc])", syntax: "sgf"))
