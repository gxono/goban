#import "@preview/gobanist:0.1.0": *
#set page(width: 17cm, height: auto, margin: 0.5cm)

#gobanist-set(background: (fill: (color: rgb(220, 179, 92))))

// The statement and a diagram for each line of the solution, with its comments.
#sgf-problem(sgf-read(path("problem.sgf")), title: "Problem 1")
