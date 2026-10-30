#import "@preview/gobanist:0.2.0": *
#set page(width: 13cm, height: auto, margin: 0.5cm)

// The Chinese texts need a font that has them: SimSun comes with Windows; Noto Serif CJK SC is another one.
#set text(lang: "zh", font: ("Libertinus Serif", "SimSun"))

#gobanist-set(background: (fill: (color: rgb(220, 179, 92))),
  label: (at: (top, left), style: "chinese"))

// qipu.sgf is in GB2312 (CA[GB2312]): sgf-read converts it.
#let qipu = sgf-read(path("qipu.sgf"))

#sgf-info(qipu, "GN")：#sgf-info(qipu, "PB")对#sgf-info(qipu, "PW")，贴目#sgf-info(qipu, "KM")。
#sgf-comment(qipu, 0)

#sgf-diagrams(qipu, step: 9, comments: true)
