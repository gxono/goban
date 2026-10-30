#import "@preview/gobanist:0.1.0": *
#set page(width: 17cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo", size: 19, partial: auto, scale: 1.1, label: (at: (bottom, left)),
  view: (goban: (background: false, label: (at: ()))))

// Problems drawn by hand, each one in another part of the board: partial: auto shows only the part that is
// used, with one more line. The answers go on from the problems, and the text shows them before they are drawn.
#let one = board(stones(white: "A:B3, B:C2, C1", black: "A:C4, C3, D1:3"))
#let two = board(stones(black: "S16:19, T16", white: "R16:19, S:T15"))
#let three = board(stones(white: "H1:2, J:L2, M1:2", black: "G1:2, H:M3, N1:2"))
#let answers = (board(one, moves("A1")), board(two, moves("T18")), board(three, moves("K1")))

= Life and death
*1.* Black to kill. #h(1em) *2.* Black to live. #h(1em) *3.* Black to kill.

#goban-layout(columns: 3, width: auto, one, two, three)

= Answers
*1.* The eye space of White is a bent three, and its vital point is the one that touches the other two:
Black plays at the corner, #goban-view(answers.at(0), "A1").
*2.* Black lives with #goban-view(answers.at(1), "T18"), which makes two eyes, at T17 and T19.
*3.* The eye space of White is a straight three: Black plays in the middle, #goban-view(answers.at(2), "K1"),
and White has one eye at most.

#goban-layout(columns: 3, width: auto, ..answers)
