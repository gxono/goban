#import "@preview/gobanist:0.2.0": *
#set page(width: 12cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo")

// The boards are values: the layout draws them and goban-view shows parts of them in the text.
#let ko = board(size: 5, stones(black: "B3, C2, C4", white: "C3, D2, D4, E3"))
#let before = board(ko, marks(triangle: "C3"))
#let capture = board(ko, captures: "remove", moves("D3"))
#let retake = board(ko, captures: "remove", moves("D3, A5, A4, C3"))

= The ko
#goban-layout(columns: 3, fit: true, before, capture, retake)

The white stone #goban-stone("white", mark: "triangle") has three black neighbours,
#goban-view(before, "B3, C2, C4").
Black plays 1 #goban-view(capture, "D3") and takes it: now the shape is #goban-view(capture, "B2:E4").
White cannot take back at once, because the same position would come again. White plays a threat first,
2 #goban-view(retake, "A5"), Black answers with 3 #goban-view(retake, "A4"), and only then White retakes with
4 #goban-view(retake, "C3"): #goban-view(retake, "B2:E4").
