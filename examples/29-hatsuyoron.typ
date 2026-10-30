#import "@preview/gobanist:0.2.0": *
#set page(width: 17cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "shell")

// hatsuyoron.sgf: problems of the Igo Hatsuyōron (Inoue Dōsetsu Inseki, 1713), one game per problem, with the
// position only (no solutions). The numbers of the captions are those of the file.
#let problems = (1, 2, 3, 6, 7, 9, 10, 11).map(n => sgf-read(path("hatsuyoron.sgf"), game: n))

= Problems from the Igo Hatsuyōron
#sgf-problem(..problems, to-play: "black", comments: false, layout: (columns: 4, fit: true))
