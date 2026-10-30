#import "@preview/gobanist:0.1.0": *
#set page(width: 8cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo", label: (at: (bottom, left)))

// A ladder (shicho): the white chain is a connected staircase (-|-, then -- for its last stone) and the black
// stones that chase it are two diagonals (--). Each line is written with its ends only.
#goban(
  stones(white: "D4 -|- F6 -- G6", black: "C4, D3, D5 -- F7, E3 -- G5"),
  arrows(("G6", "J8")))

Black plays at G7 and White is in atari again: the chain keeps running towards the corner, where it is captured.
