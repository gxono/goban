// El manual de gobanist, en español. Se compila desde la raíz del repositorio:
//   typst compile --root . doc/es/manual.typ

#import "../estilo.typ": *
#import "/lib.typ": *

#set document(title: "gobanist: manual")
#show: manual.with(lang: "es")

#page(numbering: none, footer: none, align(center + horizon, {
  text(font: titulos, size: 4em, weight: "bold")[gobanist]
  v(2em)
  goban(profile: "pgfgosmooth", partial: "B2:E3", scale: 2.5, stones(black: "C2, D2, E3", white: "B2, C3, D3"),
    marks(custom: "B2", content: [36], player: "white"), marks(custom: "E2", content: [a]),
    marks(circle: "C3, D3", line: (color: red.darken(20%))))
  v(2em)
  text(font: titulos, size: 1.3em)[Tableros, partidas y problemas de go para Typst]
  v(1em)
  [Manual de la versión #version]
  v(3em)
  [Jonatán Perren Hug \ #link("mailto:jonatan.perren@gmail.com", raw("jonatan.perren@gmail.com"))]
}))

#outline(depth: 2)

#include "introduccion.typ"
#include "tutoriales.typ"
#include "configuracion.typ"
#include "coordenadas.typ"
#include "tablero.typ"
#include "piedras.typ"
#include "marcas.typ"
#include "juego.typ"
#include "memoria.typ"
#include "sgf.typ"
#include "disposicion.typ"
#include "jugadores.typ"
#include "catalogo.typ"
#include "novedades.typ"

#heading(numbering: none)[Índice de funciones y opciones]
#indice()
