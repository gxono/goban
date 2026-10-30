#import "@preview/gobanist:0.1.0": *
#set page(width: 15cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo", label: (at: (bottom, left)))

// games.sgf is a collection: several games in one file, one after the other. game chooses one of them; each
// game keeps its own board size.
#for n in (1, 2) {
  let game = sgf-read(path("games.sgf"), game: n)
  [
    == Game #n: #sgf-info(game, "PB") -- #sgf-info(game, "PW")
    Result: #sgf-info(game, "RE").

    #sgf-diagrams(game, step: 20, to: 40, layout: (columns: 2, fit: true))
  ]
}
