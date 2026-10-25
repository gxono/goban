// The goban manual, in English. It is compiled from the root of the repository:
//   typst compile --root . doc/en/manual.typ

#import "../estilo.typ": *
#import "/lib.typ": *

#set document(title: "goban: manual")
#show: manual.with(lang: "en")

#page(numbering: none, footer: none, align(center + horizon, {
  text(font: titulos, size: 4em, weight: "bold")[goban]
  v(2em)
  goban(profile: "pgfgosmooth", partial: "B2:E3", scale: 2.5, stones(black: "C2, D2, E3", white: "B2, C3, D3"),
    marks(custom: "B2", content: [36], player: "white"), marks(custom: "E2", content: [a]),
    marks(circle: "C3, D3", line: (color: red.darken(20%))))
  v(2em)
  text(font: titulos, size: 1.3em)[Go boards, games and problems for Typst]
  v(1em)
  [Manual for version #version]
  v(3em)
  [Jonatán Perren Hug \ #link("mailto:jonatan.perren@gmail.com", raw("jonatan.perren@gmail.com"))]
}))

#outline(depth: 2)

#include "introduction.typ"
#include "tutorials.typ"
#include "settings.typ"
#include "coordinates.typ"
#include "board.typ"
#include "stones.typ"
#include "marks.typ"
#include "game.typ"
#include "memory.typ"
#include "sgf.typ"
#include "layout.typ"
#include "players.typ"
#include "catalog.typ"
#include "news.typ"

#heading(numbering: none)[Index of functions and options]
#indice()
