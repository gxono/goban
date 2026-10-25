#import "../estilo.typ": *
#import "/lib.typ": *

= Catálogo de perfiles <catalogo>

Los perfiles que trae goban, cada uno con una muestra y con su definición, tal como está en `src/profiles.typ`. Se usan con `profile: "nombre"` (#pag(<perfiles>)). En las definiciones, `xmix(a, p, b)` mezcla `p` de `a` con el resto de `b`, como `a!p!b` de xcolor; `pgf-gray` es `luma(50%)`; y `picture("board.jpg")` es la imagen `images/pgfgo-board.jpg` del paquete.

#let fuente = read("/src/profiles.typ")

// La definición de name en src/profiles.typ: desde «#let name» hasta el paréntesis que la cierra, en la columna 0.
#let definicion(name) = {
  let lineas = fuente.split("\n")
  let desde = lineas.position(l => l.starts-with("#let " + name + " ") or l.starts-with("#let " + name + "("))
  if desde == none { return none }
  let primera = lineas.at(desde)
  let abiertos(l) = l.matches(regex("[({]")).len() - l.matches(regex("[)}]")).len()
  if abiertos(primera) == 0 { return primera }
  let hasta = desde + 1
  while hasta < lineas.len() and not (lineas.at(hasta).starts-with(")") or lineas.at(hasta).starts-with("}")) {
    hasta += 1
  }
  lineas.slice(desde, hasta + 1).join("\n")
}

#let muestra(perfil) = goban(profile: perfil, partial: "A1:G3", scale: 1.7,
  moves("A:F 3"),
  stones(white: "A1:2", black: "B1:2"), stones("C1:2"),
  stones(white: "D1", mark: "circle"), marks(circle: "D2", player: "white"),
  stones(black: "E1", mark: "circle"), marks(circle: "E2", player: "black"),
  stones("F1", mark: "circle"), marks(circle: "F2", player: "neutral"),
  marks(t-square: "G1", player: "white"), marks(t-circle: "G2", player: "black"),
  marks(t-square: "G3", player: "neutral"))

#let descripciones = (
  default: [El estilo inicial del paquete: el que tienen el tablero y los jugadores antes de usar un perfil, y al que vuelven antes de aplicar cualquier otro. Su definición es el diccionario vacío: es el árbol de valores iniciales de `src/options.typ`.],
  pgfgo: [Un tablero de madera clara, con sombra y esquinas apenas redondeadas, y piedras con sombra y brillo. Usa los colores de `wain` y la sombra y el brillo de `raised`, definidos aquí.],
  pgfgosmooth: [Como `pgfgo`, sin el borde del tablero ni el de las piedras, con las esquinas más redondeadas.],
  wain: [Un tablero oscuro, con líneas claras, y piedras con sombra y brillo. Sus colores y `raised` están en `pgfgo`.],
  simple: [Como el estilo inicial, sin el borde del tablero y con líneas más finas.],
  draft: [Blanco y negro, para imprimir o fotocopiar: donde hay relleno, rayas. Las piedras negras, las marcas rellenas y el territorio usan `fill.pattern`; el territorio, con rayas en un sentido para cada jugador, se ve con `draw: "fill"` o `draw: "region"`. `lines` dibuja las rayas: un `tiling` de líneas a 45 o a −45 grados.],
  shell: [Un tablero de madera con piedras de pizarra y de concha, dibujadas con las imágenes de la carpeta `images` del paquete. Cada piedra blanca usa una de cinco imágenes, con un pequeño giro. La sombra es una imagen difusa (`soft-shadow`).],
  yunzi: [Como `shell`, con piedras mates, sin vetas, como las _yunzi_ chinas: dos imágenes para las blancas, sin giro, porque la luz de cada imagen viene de un lado.],
  baduktv: [Un tablero claro, de madera lisa, con piedras lisas, una imagen para cada color, sin giro; la sombra difusa es la de `shell`.],
)

#for (nombre, texto) in descripciones [
  == #nombre
  #texto

  #align(center, muestra(nombre))

  #let def = definicion(nombre)
  #if def != none { codigo(def) }
  #if nombre == "pgfgo" [
    #codigo(fuente.split("\n").filter(l => l.starts-with("#let wain-") or l.starts-with("#let pgfgo-")
      or l.starts-with("#let pgfgosmooth-") or l.starts-with("#let pgf-gray")).join("\n"))
  ]
  #if nombre == "pgfgo" { codigo(definicion("raised")) }
  #if nombre == "draft" { codigo(definicion("lines")) }
  #if nombre == "shell" { codigo(definicion("picture") + "\n" + definicion("soft-shadow")) }
]
