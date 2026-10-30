#import "@preview/gobanist:0.2.0": *
#set page(width: auto, height: auto, margin: 0.5cm)

// The kanji need a font that has them: MS Gothic comes with Windows; Noto Sans CJK JP is another one.
#let kanji = (font: "MS Gothic", size: 8pt)
#gobanist-set(profile: "wain", label: (at: (top, bottom, left, right)))

#let position = board(size: 9, stones(black: "C7, G3, D3", white: "G7, C3"))

#grid(columns: 2, column-gutter: 1.5em, row-gutter: 0.6em, align: center,
  goban(position),
  goban(position, label: (style: "japanese", text: kanji)),
  [western: letters and numbers], [japanese: from the upper right],
  v(0.5em), v(0.5em),
  goban(position, label: (style: "chinese", text: kanji)),
  goban(position, label: (columns: "1", rows: "A", rows-direction: ttb)),
  [chinese: from the upper left], [numbers and letters, rows from the top])
