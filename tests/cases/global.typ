#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// gobanist-set: las opciones globales valen para los tableros que siguen.
#goban(size: 5, stones(black: "C3"))
#gobanist-set(background: (fill: (color: rgb("#dcb35c"))), label: (at: (bottom, left)), stone: (radius: 4.5pt))
#goban(size: 5, stones(black: "C3"))
#gobanist-set(players: (white: (stone: (fill: (color: yellow)))), background: (line: (width: 2pt)))
#goban(size: 5, stones(white: "C3"), background: (fill: (color: white)))
