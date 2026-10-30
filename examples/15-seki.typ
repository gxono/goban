#import "@preview/gobanist:0.1.0": *
#set page(width: 8cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo", label: (at: (bottom, left)))

// A seki at the top: each group has one eye (A9, J9) and they share E9. In Japanese rules the eyes of a seki
// are not territory: territory(auto) counts them, and a neutral territory for each eye takes them out.
#goban(
  stones(black: "A8:D8, B9:D9, E7:J7, E1:E6", white: "E8:J8, F9:H9, A7:D7, D1:D6"),
  prisoners(white: "G3", black: "B4"),
  territory(auto, dame: true),
  territory(neutral: "A9"),
  territory(neutral: "J9"))

Black #goban-score("black"), White #goban-score("white", komi: 6.5).
