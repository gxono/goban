#import "@preview/gobanist:0.1.0": *
#set page(width: auto, height: auto, margin: 0.5cm)

// A profile of your own: a dictionary of options, like those of gobanist-set. Before setting its own,
// profile brings the style back to the initial one.
#let night = (
  background: (fill: (color: luma(15%)), line: false),
  grid: (line: (color: luma(60%))),
  label: (text: (fill: luma(50%))),
  arrow: (color: rgb(100%, 57%, 15%)),
  players: (
    neutral: (mark: (line: (color: luma(80%)), fill: (on: true, color: luma(50%)))),
    black: (stone: (fill: (color: rgb(0%, 0%, 55%)), line: (color: luma(70%)))),
    white: (stone: (fill: (color: rgb(100%, 57%, 15%)), line: (color: rgb(40%, 20%, 0%))))),
  // Marks of your own: a function of the radius of the stone and of the stroke and the fill of the mark,
  // drawn with its origin on the point.
  shapes: (
    diamond: m => polygon(fill: m.fill, stroke: m.stroke,
      (0pt, -0.7 * m.radius), (0.7 * m.radius, 0pt), (0pt, 0.7 * m.radius), (-0.7 * m.radius, 0pt)),
    slash: m => line(start: (-0.5 * m.radius, 0.5 * m.radius), end: (0.5 * m.radius, -0.5 * m.radius),
      stroke: m.stroke)),
)

#gobanist-set(profile: night)

#goban(size: 9, label: (at: (bottom, left)),
  stones(black: "C3, D3, E4, C5", white: "D4, D5, E5, F3"),
  moves("F4, G4, F5"),
  marks(diamond: "C3, E5, G7", slash: "D5, H3"),
  arrows(("F5", "F7")))
