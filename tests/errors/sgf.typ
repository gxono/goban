// Las partidas: la lectura, sgf, sgf-info y sgf-comment.

// error: sgf-read espera un archivo (path("partida.sgf")), bytes o el texto SGF
#sgf-read(3)

// error: sgf-read: game es un número desde 1
#sgf-read("(;SZ[5])", game: 0)

// error: sgf-read: charset es auto o un nombre
#sgf-read("(;SZ[5])", charset: 1)

// error: no tiene la 3
#sgf-read("(;SZ[5])(;SZ[5])", game: 3)

// error: codificación desconocida: klingon
#sgf-read(bytes("(;SZ[5]C[a])"), charset: "klingon")

// error: el archivo no es UTF-8 y su codificación es desconocida: KOI8-R
#sgf-read(bytes((..array(bytes("(;SZ[5]CA[KOI8-R]C[")), 0xE9, ..array(bytes("])")))))

// error: SGF: «jj» no está en el tablero de 9×9
#goban(sgf-read("(;SZ[9];B[ee];W[jj])"))

// error: jugada en un punto ocupado: (3, 3)
#goban(captures: "remove", sgf-read("(;SZ[5];B[cc];W[cc])"))

// error: la partida quita piedras (AE): hace falta captures
#goban(sgf-read("(;SZ[5]AB[cc];W[aa];B[bb]AE[cc])"))

// error: la partida es de 5×5 y el tablero, de 9
#goban(size: 9, sgf-read("(;SZ[5];B[cc])"))

// error: tamaño fuera de rango: (52, 52)
#goban(sgf-read("(;SZ[52];B[aa])"))

// error: sgf espera una partida leída con sgf-read(...)
#sgf(board(size: 5), to: 3)

// error: sgf recibe una partida y opciones con nombre
#sgf(sgf-read("(;SZ[5];B[cc])"), 3)

// error: sgf no tiene la opción size
#sgf(sgf-read("(;SZ[5];B[cc])"), size: 9)

// error: forget acepta true, false o "number"
#goban(sgf(sgf-read("(;SZ[5];B[cc])"), forget: 2))

// error: sgf.from es un número desde 1
#goban(sgf(sgf-read("(;SZ[5];B[cc])"), from: 0))

// error: sgf.to es auto o un número
#goban(sgf(sgf-read("(;SZ[5];B[cc])"), to: "fin"))

// error: sgf.marks es true o false
#goban(sgf(sgf-read("(;SZ[5];B[cc])"), marks: "no"))

// error: sgf.numbers es auto, true o false
#goban(sgf(sgf-read("(;SZ[5];B[cc])"), numbers: 1))

// error: sgf.step es un número o un arreglo de números
#goban(sgf(sgf-read("(;SZ[5];B[cc])"), step: "10"))

// error: sgf.restart.from es un número
#goban(sgf(sgf-read("(;SZ[5];B[cc])"), restart: (from: "1")))

// error: sgf.letters es none, auto, "children" o "siblings"
#goban(sgf(sgf-read("(;SZ[5];B[cc])"), letters: "all"))

// error: sgf.view es true, false o un número
#goban(sgf(sgf-read("(;SZ[5];B[cc])"), view: "B2:D4"))

// error: sgf.view: la partida tiene 1 jugadas: no tiene la 4
#goban(sgf(sgf-read("(;SZ[5];B[cc])"), view: 4))

// error: variation espera números desde 1
#goban(sgf(sgf-read("(;SZ[5];B[cc](;W[dd])(;W[bb]))"), variation: (0,)))

// error: variation espera números, como (2, 1), o jugadas
#goban(sgf(sgf-read("(;SZ[5];B[cc](;W[dd])(;W[bb]))"), variation: 2.5))

// error: variation: «C» no es una jugada
#goban(sgf(sgf-read("(;SZ[5];B[cc](;W[dd])(;W[bb]))"), variation: "C"))

// error: la partida no tiene la variante
#goban(sgf(sgf-read("(;SZ[5];B[cc](;W[dd])(;W[bb]))"), variation: (3,)))

// error: sgf-info espera el nombre de una propiedad, como "PB"
#sgf-info(sgf-read("(;SZ[5]PB[Ana])"), 3)

// error: sgf-info: move es un número desde 0
#sgf-info(sgf-read("(;SZ[5]PB[Ana])"), "PB", move: -1)

// error: sgf-comment: move es un número desde 0
#sgf-comment(sgf-read("(;SZ[5]C[hola])"), -1)

// error: sgf-comment: chat es true o false
#sgf-comment(sgf-read("(;SZ[5]C[hola])"), 0, chat: "no")

// error: sgf-comment: la partida tiene 1 jugadas: no tiene la 5
#sgf-comment(sgf-read("(;SZ[5];B[cc]C[hola])"), 5)

// error: la partida no tiene la variante
#sgf-comment(sgf-read("(;SZ[5];B[cc])"), 1, variation: (2,))

// error: opción desconocida: sgf.forget
#goban-set(sgf: (forget: true))
#goban()
