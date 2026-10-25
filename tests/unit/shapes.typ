// Las formas propias: shapes guarda cada una por su nombre; una nueva con el mismo nombre la reemplaza.

#import "/src/options.typ": apply, defaults
#import "/lib.typ": marks

#let star = path("/tests/images/pgfgo-star.pdf")
#let f = m => none
#let tree = apply(defaults, (shapes: (a: f, b: [x], c: (image: star), d: (image: (file: star, width: 1em)))))
#assert.eq(tree.shapes.a, f)
#assert.eq(tree.shapes.b, [x])
#assert.eq(tree.shapes.c, (image: (width: auto, file: star)))
#assert.eq(tree.shapes.d.image.width, 1em)
#let again = apply(tree, (shapes: (c: [y])))
#assert.eq(again.shapes.c, [y])
#assert.eq(again.shapes.a, f)
// Un perfil no las borra.
#assert.eq(apply(tree, (profile: "wain")).shapes.a, f)

// marks acepta cualquier forma; si existe se sabe al dibujar.
#assert.eq(marks(rombo: "C3", line: (color: red)).groups, ((shape: "rombo", at: "C3"),))
