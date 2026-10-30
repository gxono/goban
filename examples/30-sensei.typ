#import "@preview/gobanist:0.1.0": *
#set page(width: 17cm, height: auto, margin: 0.5cm)

#gobanist-set(profile: "pgfgo")

// Three problems written in the document, in the syntax of Sensei's Library: one game per diagram. The boards
// have different heights; align-captions puts their captions on the same line.
#let problems = ```
$$B Black to kill
$$ | . . . . .
$$ | X X X . .
$$ | O O X X .
$$ | . O O X .
$$ | . . O X .
$$ +----------

$$B Black to live
$$ ----------+
$$ . O X . |
$$ . O X . |
$$ . O X . |
$$ . O X X |
$$ . . O O |
$$ . . . . |

$$B Black to kill
$$ . . . . . . . . .
$$ . . X X X X X . .
$$ . X O O O O O X .
$$ . X O . . . O X .
$$ ------------------
```.text

#sgf-problem(..range(1, 4).map(n => sgf-read(problems, game: n)),
  layout: (columns: 3, align-captions: true))
