#import "@preview/gobanist:0.2.0": *
#set page(width: 13cm, height: auto, margin: 0.5cm)

// The texts of gobanist follow the language of the text. The Japanese ones need a font that has them:
// MS Gothic comes with Windows; Noto Sans CJK JP is another one.
#set text(lang: "ja", font: ("Libertinus Serif", "MS Gothic"))

#gobanist-set(background: (fill: (color: rgb(220, 179, 92))),
  label: (at: (top, right), style: "japanese"))

#let kifu = sgf-read(path("kifu.sgf"))

#sgf-info(kifu, "GN")：#sgf-info(kifu, "PB")対#sgf-info(kifu, "PW")、コミ#sgf-info(kifu, "KM")。
#sgf-comment(kifu, 0)

#sgf-diagrams(kifu, step: 9, comments: true)
