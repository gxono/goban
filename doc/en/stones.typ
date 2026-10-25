#import "../estilo.typ": *
#import "/lib.typ": *

= Stones, moves and prisoners <piedras>

Stones are placed with `stones`; moves, with `moves`, and prisoners, with `prisoners`. Their style is that of their player (#pag(<jugadores>)), and each element can change it with its options.

== Stones

#funcion("stones(coordinates, black: ..., white: ..., neutral: ..., ..options)")[
  Places stones on the intersections, written with the coordinate syntax (#pag(<coordenadas>)). The player is the key: `stones(black: "C2, D3", white: "B4")`. Without a key, the stones are neutral: `stones("C3")`. The options change their style (those of the `stone` branch, below) and put a mark on them (`mark`).

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2", white: "D3"),
    stones("B4"))
  ```
]

Stones, marks and labels that fall outside the visible part of a partial board are not drawn. A coordinate that does not exist on the board (`"E9"` on a 5×5 board) is an error. A stone on a point where there already is one covers it.

The style of the stones of the three players is changed with `goban-set(stone: ...)`, which is `goban-set(players: (all: (stone: ...)))`; that of one, with `goban-set(players: (black: (stone: ...)))`. The options of the `stone` branch are:

#opcion("stone.fill", valor: [`true`, `false` or a dictionary])[
  The fill of the stone. With `false`, no fill: the rest remains (the border, the shadow, the shine).

  ```ejemplo
  #goban-set(profile: "pgfgosmooth", size: 5,
    partial: "B2:D4")

  #goban(stones(black: "C2, D3", white: "B4"))
  #goban(stones(black: "C2, D3"),
    stones(white: "B4", fill: false))
  ```
]

#opcion("stone.fill.color", valor: [a color or `none`])[
  The color of the fill: black for Black, white for White and gray for neutral stones. With `none`, no color: the pattern remains, if there is one.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones("C2, D3", fill: (color: aqua.darken(40%))),
    stones("B4", fill: (color: fuchsia.darken(20%))))
  ```
]

#opcion("stone.fill.opacity", valor: [a number from 0 to 1], inicial: `1`)[
  The opacity of the fill.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", fill: (opacity: 0.8)),
    stones(white: "B4", fill: (opacity: 0.5)))
  ```
]

#opcion("stone.fill.pattern", valor: [`none` or a `tiling`], inicial: `none`)[
  A pattern over the color of the fill, with its same opacity: a Typst `tiling`. With `fill.color: none`, the stone has only the pattern. The `t-circle` and `t-square` marks of the player use the same fill. The pattern does not change size with `scale`.

  ```ejemplo
  #let stripes = tiling(size: (3pt, 3pt),
    line(start: (0pt, 3pt), end: (3pt, 0pt),
      stroke: 0.4pt))

  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3",
      fill: (color: white, pattern: stripes)),
    stones(white: "B4", fill: (color: none,
      pattern: tiling(size: (2pt, 2pt),
        circle(radius: 0.5pt, fill: black)))))
  ```
]

#opcion("stone.line", valor: [`true`, `false` or a dictionary])[
  The border of the stone.

  ```ejemplo
  #goban-set(profile: "pgfgosmooth", size: 5,
    partial: "B2:D4")

  #goban(stones(black: "C2, D3", white: "B4"))
  #goban(stones(black: "C2, D3"),
    stones(white: "B4", line: true))
  ```
]

#opcion("stone.line.color", valor: [a color], inicial: `black`)[The color of the border.]
#opcion("stone.line.opacity", valor: [a number from 0 to 1], inicial: `1`)[The opacity of the border.]
#opcion("stone.line.width", valor: [a length], inicial: `0.7pt`)[
  The width of the border.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", line: (
      color: fuchsia, opacity: 0.5)),
    stones(white: "B4", line: (width: 2pt)))
  ```
]

#opcion("stone.radius", valor: [a length], inicial: `5.5pt`)[
  The radius of the stone.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", radius: 0.15cm),
    stones(white: "B4", radius: 0.25cm))
  ```
]

#opcion("stone.scale", valor: [a number], inicial: `1`)[
  Scales the whole stone: the radius, the border and the marks.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2", mark: "circle"),
    stones(black: "D3", scale: 0.7,
      mark: "circle"),
    stones(white: "B4", scale: 1.3,
      mark: "triangle"))
  ```
]

#opcion("stone.shadow", valor: [`true`, `false` or a dictionary])[
  The shadow of the stone, drawn underneath. It has the silhouette of the stone: the circle, or the shape of the image if the stone is an image (`image`). With `shadow.image`, the shadow is an image of its own. In both cases it is shifted `offset` towards `angle` and enlarged `scale` times.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stone: (shadow: (on: true, angle: -45deg,
      offset: 1.5pt)),
    stones(black: "C2, D3", white: "B4"))
  ```
]

#opcion("stone.shadow.angle", valor: [an angle], inicial: `0deg`)[Where the shadow falls: with `0deg`, to the right; with `-45deg`, down and to the right. It does not rotate the shape of the shadow.]
#opcion("stone.shadow.offset", valor: [a length], inicial: `1pt`)[How far the shadow is shifted from the center of the stone, towards `angle`.]
#opcion("stone.shadow.opacity", valor: [a number from 0 to 1], inicial: `0.5`)[
  The opacity of the shadow (also that of the shadow with an image).

  ```ejemplo
  #goban-set(profile: "pgfgosmooth", size: 3)
  #let b = board(stones(black: "B1, C2", white: "A3"))

  #goban(b, players: (white: (stone: (
    shadow: (angle: 225deg)))))
  #goban(b, players: (white: (stone: (
    shadow: (offset: 0.125cm, opacity: 0.1)))))
  #goban(b, players: (white: (stone: (
    shadow: false))))
  ```
]

#opcion("stone.shadow.color", valor: [a color], inicial: `black`)[The color of the shadow. A shadow with an image has its own colors, except with `image.silhouette`.]
#opcion("stone.shadow.scale", valor: [a number], inicial: `1`)[
  Enlarges (or shrinks) the shadow relative to the stone. A shadow larger than the stone makes it look taller. It also enlarges the shadow with an image.

  ```ejemplo
  #goban(size: 3, scale: 2,
    stones(black: "A1", shadow: (on: true,
      angle: -45deg)),
    stones(black: "C2", shadow: (on: true,
      angle: -45deg, scale: 1.3)),
    stones(white: "A3", shadow: (on: true,
      offset: 0pt, scale: 1.3, color: red)))
  ```
]

#opcion("stone.shadow.image", valor: [a file or a dictionary])[
  A shadow of your own: an image, centered on the stone and drawn as it is instead of the silhouette, for example a soft shadow. It is shifted and enlarged like the silhouette (`angle`, `offset`, `scale`) and uses `opacity`, but not `color`. It does not rotate with the image of the stone, so it always falls to the same side. What is not a dictionary is the file; `none` removes it.

  ```ejemplo
  #goban(size: 3, scale: 2,
    stone: (shadow: (on: true, angle: -45deg,
      offset: 1.5pt, opacity: 0.8,
      image: (file: path("img/pgfgo-shadow.png"),
        width: 13pt))),
    stones(black: "B1, C2", white: "A3"))
  ```
]

#opcion("stone.shadow.image.file", valor: [a file], inicial: `none`)[The file of the image.]
#opcion("stone.shadow.image.width", valor: [`auto` or a length], inicial: `auto`)[The width of the image; the height keeps the proportion. With `auto`, the diameter of the stone.]
#opcion("stone.shadow.image.rotate", valor: [an angle], inicial: `0deg`)[Rotates the image of the shadow, the same on every stone.]
#opcion("stone.shadow.image.silhouette", valor: [`true` or `false`], inicial: `false`)[
  Uses only the shape of the image (its transparency), painted with `shadow.color`, instead of the image as it is. Only with PNG and JPEG.

  ```ejemplo
  #goban(size: 3, scale: 2,
    stone: (shadow: (on: true, angle: -45deg,
      offset: 2pt, color: blue,
      image: (file: path("img/pgfgo-shadow.png"),
        width: 16pt, silhouette: true))),
    stones(black: "B1, C2", white: "A3"))
  ```
]

#opcion("stone.shine", valor: [`true`, `false` or a dictionary])[
  The shine of the stone, drawn on top of it, be it a circle or an image.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", shine: true),
    stones(white: "B4", shine: (on: true,
      color: luma(50%))))
  ```
]

#opcion("stone.shine.angle", valor: [an angle], inicial: `0deg`)[Rotates the drawn shine. With `0deg`, the light comes from the top left.]
#opcion("stone.shine.opacity", valor: [a number from 0 to 1], inicial: `1`)[The opacity of the shine (also that of the shine with an image).]
#opcion("stone.shine.color", valor: [a color], inicial: `luma(75%)`)[
  The color of the drawn shine.

  ```ejemplo
  #goban-set(profile: "pgfgosmooth", size: 3)
  #let b = board(stones(black: "B1, C2", white: "A3"))

  #goban(b, players: (black: (stone: (
    shine: (angle: 45deg)))))
  #goban(b, players: (black: (stone: (
    shine: (opacity: 0.5, color: red)))))
  #goban(b, players: (black: (stone: (
    shine: false))))
  ```
]

#opcion("stone.shine.image", valor: [a file or a dictionary])[
  A shine of your own: an image, centered on the stone, instead of the drawn shine. If the stone is also an image, the shine is drawn on top and does not rotate with it: the stones can have grain rotated at random and the light always on the same side. What is not a dictionary is the file; `none` removes it.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(white: "B2:D3",
      image: (file: path("img/pgfgo-yunzi-white-1.png"),
        rotate: "random"),
      shine: (on: true,
        image: path("img/pgfgo-shine.png"))))
  ```
]

#opcion("stone.shine.image.file", valor: [a file], inicial: `none`)[The file of the image.]
#opcion("stone.shine.image.width", valor: [`auto` or a length], inicial: `auto`)[The width of the image; the height keeps the proportion. With `auto`, the diameter of the stone.]
#opcion("stone.shine.image.rotate", valor: [an angle], inicial: `0deg`)[Rotates the image of the shine, the same on every stone.]
#opcion("stone.shine.image.silhouette", valor: [`true` or `false`], inicial: `false`)[
  Uses only the shape of the image (its transparency), painted with `shine.color`, instead of the image as it is. Only with PNG and JPEG.

  ```ejemplo
  #goban(size: 3, scale: 2,
    players: (black: (stone: (shine: (on: true,
      color: red, image: (
        file: path("img/pgfgo-shine.png"),
        silhouette: true))))),
    stones(black: "B1, C2", white: "A3"))
  ```
]

=== Stones with images <piedras-imagen>

#opcion("stone.image", valor: [a file or a dictionary])[
  Draws the stone with an image instead of the circle: neither the fill nor the border are drawn, and the image need not be round. If the shine is on, it is drawn on top of the image. The shadow is drawn with the shape of the image; for that, the image must have transparency (a PNG with an alpha channel): the shadow of a JPEG is a rectangle. A prisoner with an image looks translucent, like any prisoner. What is not a dictionary is the file; `none` removes it.

  A file is a `path`, relative to the document that names it, or its `bytes`: PNG, JPEG, GIF, WebP, SVG or PDF. Opacity and silhouettes (the shadow with the shape of the image) are possible only with PNG and JPEG: they are made by the kernel (#pag(<kernel>)). The images of the `shell`, `yunzi` and `baduktv` profiles are in the `images` folder of the package.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stone: (shadow: (on: true, angle: -45deg,
      offset: 1.5pt)),
    stones(black: "C2, D3", image:
      path("img/pgfgo-yunzi-black.png")),
    stones(white: "B4", image:
      path("img/pgfgo-yunzi-white-1.png")))
  ```

  For all the stones of a player, the image goes in their options:

  ```ejemplo
  #goban-set(players: (
    black: (stone: (image:
      path("img/pgfgo-yunzi-black.png"))),
    white: (stone: (image:
      path("img/pgfgo-yunzi-white-1.png")))))

  #goban(size: 5, partial: "B2:D4",
    moves("C3, D3, C2, B3", numbers: false))
  ```
]

#opcion("stone.image.file", valor: [a file or an array], inicial: `none`)[
  The file of the image. With several files, each stone uses one, chosen by its place: a stone on a point always shows the same image, in every diagram.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(white: "B2:D3", image: (
      path("img/pgfgo-yunzi-white-1.png"),
      path("img/pgfgo-yunzi-white-2.png"))))
  ```
]

#opcion("stone.image.width", valor: [`auto` or a length], inicial: `auto`)[The width of the image; the height keeps the proportion. With `auto`, the diameter of the stone: 2 × `radius` × `scale`.]

#opcion("stone.image.rotate", valor: [an angle, `"random"` or `(min, max)`], inicial: `0deg`)[
  Rotates the image, counterclockwise. With `"random"`, each stone is rotated by a different angle, chosen by its place: a stone on a point always looks the same, in every diagram. With a range `(min, max)`, the angle is chosen the same way, between those two (`"random"` is `(0deg, 360deg)`). The shadow rotates with the image, but it still falls to the same side.

  ```ejemplo
  #let shell = path("img/pgfgo-yunzi-white-1.png")

  #goban(size: 5, partial: "B2:D4",
    stones(white: "B2:D3", image: (file: shell,
      rotate: "random")))
  #goban(size: 5, partial: "B2:D4",
    stones(white: "B2:D3", image: (file: shell,
      rotate: (-20deg, 20deg))))
  ```
]

#opcion("stone.image.opacity", valor: [a number from 0 to 1], inicial: `1`)[
  The opacity of the image. It is multiplied by that of the fill: so a prisoner with an image is translucent.

  ```ejemplo
  #let slate = path("img/pgfgo-yunzi-black.png")

  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2", image: slate),
    stones(black: "D3", image: (file: slate,
      width: 8pt)),
    stones(white: "B4", image: (opacity: 0.5,
      file: path("img/pgfgo-yunzi-white-1.png"))))
  ```
]

=== The other options of the stones

#opcion("mark", valor: [a shape or a dictionary], inicial: `none`)[
  A mark on the stones, with the shape (`"triangle"`) or, with options, a dictionary with the shape in `shape` and the options of the marks (#pag(<marcas>)): `mark: (shape: "circle", line: (color: red))`. It is an option of `stones`, `prisoners` and `moves`, not of the `stone` branch.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2, D3", mark: "triangle"),
    stones(white: "B4", mark: (shape: "custom",
      content: [!], label: (text: (fill: red)))))
  ```
]

#opcion("forget", valor: [`true` or `false`], inicial: `false`)[
  `resume` does not bring these stones (#pag(<memoria>)). `goban-view` draws them only with `forgotten`. It is an option of `stones`, `prisoners` and `moves` (where it can also be `"number"`, #pag(<jugadas>)), of `marks`, `arrows`, `lines` and `territory`.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")

  #let a = board(stones(black: "C2, D3"),
    stones(white: "B4", forget: true))
  #goban(resume: a)
  ```
]

== Moves <jugadas>

#funcion("moves(moves, black: ..., white: ..., ..options)")[
  Plays the intersections in the order in which they are written, alternating Black and White, and numbers them. Without a player, they follow the turn: `moves("C3, D4")`; with one, they start with it: `moves(white: "D2, B3")`. It takes a single sequence. An intersection can be repeated (for example, to take back a ko with `captures`). It accepts the syntax of `stones` (#pag(<coordenadas>)) and plays each element in its order (#pag(<orden-coordenadas>)): a path (`A1 -- A3 -- C3`) goes from its first point to its last, and a stretch, from the first end to the second. What has no fixed path (rectangles, `r`, whole columns and rows, `*`) is played all the same. The `;` is an error: `moves` only adds moves.

  ```ejemplo
  #goban(size: 5,
    moves("B1 -| D3, C:A 4, E5"))
  ```

  The options are those of the style of the stone (`fill`, `line`, `radius`, `shine`, `image`, …), `mark`, `forget` and those of this section: `numbers`, `label` and `from`.
]

Within the same `goban`, the numbering and the turn carry on from one `moves` to the next. Each `goban` starts at move 1 with Black; to continue a game in another diagram, use `from` and the player, or `resume` (#pag(<memoria>)).

The options of the stones serve, for example, to mark the last move:

```ejemplo
#goban(size: 5, partial: "B2:D4",
  moves("C3, D3, C2", numbers: false),
  moves("B3", numbers: false, mark: "circle"))
```

The style of the moves of the three players is changed with `goban-set(move: ...)`, which is `goban-set(players: (all: (move: ...)))`.

#opcion("from", valor: [a number])[
  The number of the first move of this `moves`. The following ones carry on from there.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    moves("C2, B4", from: 7),
    moves("D3"))
  ```
]

#opcion("move.numbers", valor: [`true` or `false`], inicial: `true`)[
  Whether the moves carry their number. Without numbers, the moves still count: the next one carries on the numbering and the turn. In `moves(numbers: false)`, it holds for those moves; with `goban-set(move: (numbers: false))` or `goban(move: (numbers: false))`, for all those that follow.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    moves("C3, D3", numbers: false),
    moves("C2, B3"))
  #goban(size: 5, partial: "B2:D4",
    move: (numbers: false),
    moves("C3, D3"),
    moves("C2, B3", numbers: true))
  ```
]

#opcion("move.label", valor: [a dictionary])[
  The numbers of the moves.

  ```ejemplo
  #goban(size: 3,
    players: (white: (move: (label: (
      text: (fill: red, style: "italic"),
      size: 6pt)))),
    moves("A1, B2, C3, A3"))
  ```
]

#opcion("move.label.format", valor: [a `numbering` pattern], inicial: `"1"`)[
  The format of the numbers: a Typst `numbering` pattern, such as `"1"`, `"a"`, `"A"`, `"i"`, `"I"` or `"一"` (the kanji need a font that has them).

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    move: (label: (format: "a")),
    moves("C2, B4", from: 7), moves("D3"))
  #goban(size: 5, partial: "B2:D4",
    move: (label: (format: "I")),
    moves("C2, B4", from: 7), moves("D3"))
  #goban(size: 5, partial: "B2:D4",
    move: (label: (format: "一",
      text: (font: "MS Gothic"))),
    moves("C2, B4", from: 7), moves("D3"))
  ```
]

#opcion("move.label.size", valor: [`auto` or a length], inicial: `auto`)[
  The size of the numbers. With `auto`, it is adjusted to the number of digits.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    moves("C2, B4", from: 7),
    moves("D3", label: (size: 0.5em)))
  ```
]

#opcion("move.label.text", valor: [a dictionary], inicial: `(weight: "bold", fill: ...)`)[
  The `text` options of the numbers: the font, the weight, the color. The color is the opposite of that of the stone: white on Black and black on White.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    moves("C2, B4", label: (text: (fill: red))),
    moves("D3", label: (text: (fill: blue))))
  ```
]

#opcion("forget", valor: [`true`, `false` or `"number"`], inicial: `false`)[
  In `moves`: with `true`, `resume` does not bring these moves, neither the stone nor the number, and the numbering carries on from the last move it brings. With `"number"`, the move comes without its number even if `numbers` is asked for (#pag(<memoria>)); with `goban-view`, the number is seen only with `forgotten`.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")

  #let a = board(moves("C2"),
    moves("B4", forget: "number"),
    moves("D3"))
  #goban(resume: (board: a, numbers: true),
    moves("C:D4"))
  ```
]

== Prisoners <prisioneros>

Prisoners are captured stones that are still on the board: by default, translucent.

#funcion("prisoners(coordinates, black: ..., white: ..., neutral: ..., ..options)")[
  Like `stones`, with the style of the prisoners: that of the stone of the player, with the `prisoner` branch on top.

  ```ejemplo
  #goban(size: 5, partial: "B2:D4",
    stones(black: "C2"),
    prisoners(black: "D3", white: "B4"))
  ```
]

#opcion("prisoner", valor: [stone options], inicial: `(fill: (opacity: 0.5))`)[
  The style of the prisoners: options of the `stone` branch, which are put on top of those of the stone of the player. With `goban-set(prisoner: ...)`, for the three players; with `goban-set(players: (white: (prisoner: ...)))`, for one. It holds for those of `prisoners` and for the stones captured with `captures: "fade"` (#pag(<capturas>)). The other stones of the player do not change.

  ```ejemplo
  #goban-set(size: 5, partial: "B2:D4")

  #goban(prisoner: (fill: (opacity: 0.2),
      line: (color: red)),
    stones(black: "C2"),
    prisoners(black: "D3", white: "B4"))
  #goban(players: (white: (prisoner: (
      line: (color: red)))),
    stones(white: "B3"),
    prisoners(black: "C3", white: "D3"))
  ```
]
