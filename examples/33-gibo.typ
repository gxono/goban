#import "@preview/gobanist:0.2.0": *
#set page(width: 13cm, height: auto, margin: 0.5cm)

// The Korean texts need a font that has them: Malgun Gothic comes with Windows; Noto Serif CJK KR is another
// one.
#set text(lang: "ko", font: ("Libertinus Serif", "Malgun Gothic"))

#gobanist-set(background: (fill: (color: rgb(220, 179, 92))), label: (at: (bottom, left)))

// gibo.sgf is in EUC-KR (CA[EUC-KR]): sgf-read converts it.
#let gibo = sgf-read(path("gibo.sgf"))

#sgf-info(gibo, "GN"): #sgf-info(gibo, "PB") 대 #sgf-info(gibo, "PW"), 덤 #sgf-info(gibo, "KM").
#sgf-comment(gibo, 0)

#sgf-diagrams(gibo, step: 9, comments: true)
