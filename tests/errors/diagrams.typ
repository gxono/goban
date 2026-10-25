// sgf-diagrams, sgf-problem y goban-layout.

// error: sgf-diagrams espera una partida leída con sgf-read(...)
#sgf-diagrams(board(size: 5))

// error: sgf-diagrams recibe una partida y opciones con nombre
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), 10)

// error: sgf-diagrams: to va en sgf-diagrams(...), no en sgf(...)
#sgf-diagrams(sgf(sgf-read("(;SZ[5];B[cc])"), to: 1))

// error: diagrams.step es un número o un arreglo de números
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), step: "10")

// error: diagrams.from es un número desde 1
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), from: 0)

// error: diagrams.to es auto o un número
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), to: -1)

// error: diagrams.notes es true o false
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), notes: "no")

// error: diagrams.partial es none o auto
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), partial: "A1:C3")

// error: diagrams.comments.position es bottom, left, right o "after"
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), comments: (position: top))

// error: diagrams.comments.width es auto o una longitud
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), comments: (width: 50%))

// error: diagrams.comments.number es una función del número
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), comments: (number: "n"))

// error: la opción diagrams.goban no acepta "wain"
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), goban: "wain")

// error: diagrams.result.format es "text" o "raw"
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), result: (format: "short"))

// error: diagrams.variations.select es "commented" o "all"
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), variations: (select: "none"))

// error: diagrams.variations.depth es un número desde 1
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), variations: (depth: 0))

// error: diagrams.variations.paths es un arreglo de caminos
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), variations: (paths: "E5"))

// error: diagrams.variations.paths: la partida no tiene la variante
#sgf-diagrams(sgf-read("(;SZ[5];B[cc](;W[dd])(;W[bb]))"), variations: (paths: ((4,),)))

// error: diagrams.variation-title es auto o una función del número
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), variation-title: "Variante")

// error: la partida no tiene la variante
#sgf-diagrams(sgf-read("(;SZ[5];B[cc](;W[dd])(;W[bb]))"), variation: (3,))

// error: sgf-problem espera una partida leída con sgf-read(...), o varias
#sgf-problem()

// error: sgf-problem: view no va en sgf(...): lo fija cada diagrama
#sgf-problem(sgf(sgf-read("(;SZ[5]AB[cc];W[dd])"), view: true))

// error: problems.statement es true, false o "alone"
#sgf-problem(sgf-read("(;SZ[5]AB[cc];W[dd])"), statement: "first")

// error: problems.to-play es auto, "black", "white" o none
#sgf-problem(sgf-read("(;SZ[5]AB[cc];W[dd])"), to-play: "neutral")

// error: problems.partial es none o auto
#sgf-problem(sgf-read("(;SZ[5]AB[cc];W[dd])"), partial: "A1:C3")

// error: problems.variation-title es auto o una función del número
#sgf-problem(sgf-read("(;SZ[5]AB[cc];W[dd])"), variation-title: "Variante")

// error: layout.columns es auto o un número
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), layout: (columns: 0))

// error: layout.width es auto, una longitud o una fracción del ancho
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), layout: (width: "ancho"))

// error: layout.column-sep es una longitud
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), layout: (column-sep: 1))

// error: layout.fit es true o false
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), layout: (fit: "yes"))

// error: layout.align es left, center o right
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), layout: (align: top))

// error: layout.per-page es none o un número desde 1
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), layout: (per-page: 0))

// error: layout.fit no sirve con width: auto
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), layout: (columns: 2, width: auto, fit: true))

// error: opción desconocida: diagrams.layout.cols
#sgf-diagrams(sgf-read("(;SZ[5];B[cc])"), layout: (cols: 2))

// error: goban-layout dispone tableros hechos con board(...)
#goban-layout(goban(size: 5))

// error: goban-layout dispone tableros hechos con board(...)
#goban-layout("C3")

// error: opción desconocida: layout.cols
#goban-layout(board(size: 5), cols: 2)
