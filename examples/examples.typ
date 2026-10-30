// The examples guide: typst compile --root . examples/examples.typ
#import "guide.typ": guide

#guide(
  title: [Examples],
  lang: "en",
  intro: [
    Each example is a whole document: the code below the drawing compiles alone with `typst compile`. The
    examples and the SGF files they read are in the folder `examples` of the
    #link("https://github.com/gxono/gobanist/tree/v0.2.0/examples")[repository]. They are those of pgf-go, the LaTeX
    package by the same author. The reference of every function and option is in the manual.
  ],
  (
    ("01-position.typ", [A position]),
    ("02-liberties.typ", [Liberties]),
    ("03-resume.typ", [Going on from a board]),
    ("04-labels.typ", [Coordinates]),
    ("05-arrows.typ", [Arrows, lines and marks]),
    ("06-shapes.typ", [Shapes moved with shift]),
    ("07-board-shapes.typ", [Boards of other shapes]),
    ("08-ladder.typ", [A ladder]),
    ("09-moves.typ", [Moves]),
    ("10-variations.typ", [Variations]),
    ("11-ko.typ", [The ko, with views]),
    ("12-views.typ", [Views without arrows]),
    ("13-territory.typ", [Territory]),
    ("14-score.typ", [The score]),
    ("15-seki.typ", [A seki]),
    ("16-frameworks.typ", [Frameworks]),
    ("17-profiles.typ", [The nine profiles]),
    ("18-night.typ", [A profile of your own]),
    ("19-sgf.typ", [A game on a board]),
    ("20-counting.typ", [Counting a game]),
    ("21-commented-game.typ", [A commented game]),
    ("22-sgf-variations.typ", [The variations of a game]),
    ("23-collection.typ", [A collection of games]),
    ("24-maeda-segoe.typ", [A whole game]),
    ("25-joseki.typ", [A joseki]),
    ("26-symmetries.typ", [The symmetries of the board]),
    ("27-problem.typ", [A problem]),
    ("28-life-and-death.typ", [Problems drawn by hand]),
    ("29-hatsuyoron.typ", [Problems from a collection]),
    ("30-sensei.typ", [Problems from Sensei's Library]),
    ("31-kifu.typ", [A game in Japanese]),
    ("32-qipu.typ", [A game in Chinese]),
    ("33-gibo.typ", [A game in Korean]),
  ),
)
