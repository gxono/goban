#import "../estilo.typ": *
#import "/lib.typ": *

= Catalog of profiles <catalogo>

The profiles that come with goban, each one with a sample and with its definition, as it is in `src/profiles.typ`. They are used with `profile: "name"` (#pag(<perfiles>)). In the definitions, `xmix(a, p, b)` mixes `p` of `a` with the rest of `b`, like xcolor's `a!p!b`; `pgf-gray` is `luma(50%)`; and `picture("board.jpg")` is the image `images/pgfgo-board.jpg` of the package.

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
  default: [The initial style of the package: the one the board and the players have before a profile is used, and the one they go back to before any other is applied. Its definition is the empty dictionary: it is the tree of initial values of `src/options.typ`.],
  pgfgo: [A light wooden board, with a shadow and barely rounded corners, and stones with shadow and shine. It uses the colors of `wain` and the shadow and shine of `raised`, defined here.],
  pgfgosmooth: [Like `pgfgo`, without the border of the board or that of the stones, with more rounded corners.],
  wain: [A dark board, with light lines, and stones with shadow and shine. Its colors and `raised` are in `pgfgo`.],
  simple: [Like the initial style, without the border of the board and with thinner lines.],
  draft: [Black and white, for printing or photocopying: where there is a fill, stripes. The black stones, the filled marks and the territory use `fill.pattern`; the territory, with stripes in one direction for each player, is seen with `draw: "fill"` or `draw: "region"`. `lines` draws the stripes: a `tiling` of lines at 45 or −45 degrees.],
  shell: [A wooden board with slate and shell stones, drawn with the images in the `images` folder of the package. Each white stone uses one of five images, with a small rotation. The shadow is a soft image (`soft-shadow`).],
  yunzi: [Like `shell`, with matte stones, without grain, like the Chinese _yunzi_: two images for White, without rotation, because the light of each image comes from one side.],
  baduktv: [A light board, of plain wood, with plain stones, one image for each color, without rotation; the soft shadow is that of `shell`.],
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
