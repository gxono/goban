#import "/lib.typ": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

// Los perfiles del paquete, uno al lado del otro, con piedras, jugadas y marcas.
#let muestra = board(size: 5, partial: "A1:D4", stones(black: "B2, C3", white: "B3"), stones("A1"),
  moves("C2, D3"), marks(triangle: "B2, B3", circle: "A3"))
#for p in ("default", "wain", "pgfgo", "pgfgosmooth", "simple") {
  box(goban(profile: p, resume: (board: muestra, numbers: true, marks: true)))
  h(0.5em)
}

// Un perfil vuelve el estilo al inicial antes de poner el suyo; lo que va después se suma.
#gobanist-set(stone: (shadow: true), background: (fill: (color: yellow)), label: (at: left))
#box(goban(size: 3, stones(black: "A1, B2", white: "C3")))
#box(goban(size: 3, profile: "default", stones(black: "A1, B2", white: "C3")))
#box(goban(size: 3, profile: "pgfgo", grid: (line: (color: red)), stones(black: "A1, B2", white: "C3")))

// Un perfil propio, que parte de otro (profile dentro del perfil).
#let azul = (
  profile: "wain",
  background: (fill: (color: blue.lighten(80%))),
  players: (all: (stone: (line: (color: navy))), white: (stone: (fill: (color: yellow)))),
)
#gobanist-set(profile: azul)
#box(goban(size: 3, partial: "A1:C3", moves("A1:3", numbers: false), stones(black: "B1, B3, C2", white: "C1, C3"), stones("B2")))

// draft: los patrones de las piedras, las marcas y el territorio.
#gobanist-set(profile: "default", label: (at: ()))
#box(goban(profile: "draft", resume: (board: muestra, numbers: true, marks: true)))
#box(goban(size: 5, profile: "draft", territory: (draw: "fill"), stones(black: "B1, B2, B3, B4, B5", white: "C1, C2, C3, C4, C5"),
  territory(auto)))
#box(goban(size: 5, profile: "draft", stones(black: "B1, B2, B3, B4, B5", white: "C1, C2, C3, C4, C5"),
  territory(auto), marks(filled-square: "D3", filled-circle: "D2")))
// fill.pattern en el fondo: las marcas sobre puntos vacíos lo repiten.
#box(goban(size: 3, background: (fill: (pattern: tiling(size: (4pt, 4pt), circle(radius: 0.6pt, fill: gray)))),
  stones(black: "B2"), marks(triangle: "A1, B2")))

// Los perfiles con imágenes.
#gobanist-set(profile: "default")
#for p in ("shell", "yunzi", "baduktv") {
  box(goban(profile: p, label: (at: (top, left)), stones(black: "B2, E2, J2, C3, D3, G3, H3, C5, D5, E5, F5, G5, E6, G6"),
    stones(white: "D8, F8, E7, H7, C6, D6, F6, H6, B5, J5, B4, E4, J4, J3, H2"), marks(triangle: "E5, A1"), moves("A9, B9")))
  h(0.5em)
}

// Las flechas y las líneas de cada perfil: rojas en pgfgo y pgfgosmooth, del color de la grilla en wain, más
// finas en simple y draft, sin halo en shell, yunzi y baduktv; otro perfil las vuelve a las iniciales.
#let trazos = board(size: 5, label: (at: ()), stones(black: "B2, C3", white: "C2"),
  arrows(("A1", "E3")), lines(("A5", "E4")))
#for p in ("default", "wain", "pgfgo", "pgfgosmooth", "simple", "draft", "shell", "yunzi", "baduktv") {
  box(goban(profile: p, trazos))
  h(0.3em)
}
#box(goban(profile: "default", board(trazos, profile: "pgfgo")))
