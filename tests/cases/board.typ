#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Tamaño, partial, cuadrícula, hoshi, fondo y etiquetas.
#goban(size: 19, partial: "K1:T9", label: (at: (top, right)))
#goban(size: 17, partial: "A1:R5", label: (at: (top, left)))
#goban(size: (7, 4), grid: (sep: (x: 1.8em)), hoshi: (at: "C2, E3"), label: (at: (top, bottom, left, right)))
#goban(size: 9, partial: "E5:A1", background: (rounded-corners: (outer: 8pt, inner: 2pt)))
#goban(size: 5, background: (rounded-corners: 6pt, fill: (color: rgb("#dcb35c"))), scale: 1.5)
#goban(size: 9, grid: false, use-i: true, label: (at: (top,)))
#goban(size: 9, grid: (line: false), hoshi: (radius: 2pt, color: red))
#goban(size: 5, background: false)
#goban(size: 5, background: (line: false, fill: (color: luma(220))), grid: (line: (color: blue, width: 1pt)))
