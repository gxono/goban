// La guía de los ejemplos en español (los ejemplos están en inglés): typst compile --root . examples/ejemplos.typ
#import "guide.typ": guide

#guide(
  title: [Ejemplos],
  lang: "es",
  intro: [
    Cada ejemplo es un documento entero: el código que va debajo del dibujo compila solo con `typst compile`.
    Los ejemplos, en inglés, y los archivos SGF que leen están en la carpeta `examples` del
    #link("https://github.com/gxono/gobanist/tree/v0.1.0/examples")[repositorio]. Son los de pgf-go, el paquete de
    LaTeX del mismo autor. La referencia de cada función y cada opción está en el manual.
  ],
  (
    ("01-position.typ", [Una posición]),
    ("02-liberties.typ", [Libertades]),
    ("03-resume.typ", [Seguir desde un tablero]),
    ("04-labels.typ", [Coordenadas]),
    ("05-arrows.typ", [Flechas, líneas y marcas]),
    ("06-shapes.typ", [Formas desplazadas con shift]),
    ("07-board-shapes.typ", [Tableros de otras formas]),
    ("08-ladder.typ", [Una escalera]),
    ("09-moves.typ", [Jugadas]),
    ("10-variations.typ", [Variantes]),
    ("11-ko.typ", [El ko, con vistas]),
    ("12-views.typ", [Vistas sin flechas]),
    ("13-territory.typ", [Territorio]),
    ("14-score.typ", [El puntaje]),
    ("15-seki.typ", [Un seki]),
    ("16-frameworks.typ", [Moyos]),
    ("17-profiles.typ", [Los nueve perfiles]),
    ("18-night.typ", [Un perfil propio]),
    ("19-sgf.typ", [Una partida en un tablero]),
    ("20-counting.typ", [El recuento de una partida]),
    ("21-commented-game.typ", [Una partida comentada]),
    ("22-sgf-variations.typ", [Las variantes de una partida]),
    ("23-collection.typ", [Una colección de partidas]),
    ("24-maeda-segoe.typ", [Una partida entera]),
    ("25-joseki.typ", [Un joseki]),
    ("26-symmetries.typ", [Las simetrías del tablero]),
    ("27-problem.typ", [Un problema]),
    ("28-life-and-death.typ", [Problemas dibujados a mano]),
    ("29-hatsuyoron.typ", [Problemas de una colección]),
    ("30-sensei.typ", [Problemas de Sensei's Library]),
    ("31-kifu.typ", [Una partida en japonés]),
    ("32-qipu.typ", [Una partida en chino]),
    ("33-gibo.typ", [Una partida en coreano]),
  ),
)
