#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Etiquetas: formatos, direcciones y estilos.
#goban(size: 5, label: (at: (top, right), columns-direction: rtl, rows: "A"), stones(black: "B4"))
#goban(size: 5, label: (at: (top, left), columns: "1", rows-direction: ttb), stones(black: "C4"))
#goban(size: 9, label: (at: (top, right), style: "japanese", text: (font: "MS Gothic", size: 8pt)), stones(black: "G7"))
#goban(size: 13, partial: "A1:F6", label: (at: (bottom, left), style: "chinese", text: (font: "MS Gothic", size: 8pt)))
#goban(size: 5, label: (at: (bottom, left), text: (size: 6pt, fill: red), sep: 0.6cm), stones(black: "A1"))
#goban(size: 13, partial: "H1:M3", use-i: true, label: (at: (top, left)), stones(black: "J2"))
#goban(size: 5, moves("C3", from: 11, label: (format: "一", text: (font: "MS Gothic"))))

// Más de 25 columnas: las de dos letras, en el borde, en las coordenadas, en una partida (SZ[30:7]) y en una vista.
#goban(size: (30, 5), scale: 0.7, label: (at: bottom, text: (size: 5pt)),
  stones(black: "X2:AB2, Z3", white: "X3, Y3, AA3:AB3, Z4"))
#goban(sgf-read("(;SZ[30:7]AB[za];W[Aa])"), partial: "W3:AD7", label: (at: (top, left), text: (size: 6pt)))
#goban-view(board(size: (30, 5), stones(black: "AA3")), "Z2:AB4")
