// El estilo de los manuales: la página, los ejemplos (el código y lo que dibuja) y las entradas de la
// referencia (las funciones y las opciones, con su índice).

#import "/lib.typ" as paquete
#import "/src/options.typ": global

#let version = toml("/typst.toml").package.version

// Las partidas de los ejemplos, por su nombre.
#let partidas = (
  partida: paquete.sgf-read(path("partida.sgf")),
  variantes: paquete.sgf-read(path("variantes.sgf")),
  problema: paquete.sgf-read(path("problema.sgf")),
  problemas: (1, 2, 3).map(n => paquete.sgf-read(path("problemas.sgf"), game: n)),
  josekis: paquete.sgf-read(path("josekis.sgf")),
  lee: paquete.sgf-read(path("lee.sgf")),
  vistas: paquete.sgf-read(path("views.sgf")),
)

// Las mismas partidas, en inglés (los comentarios y los nombres), para el manual en inglés.
#let games = (
  game: paquete.sgf-read(path("game.sgf")),
  variations: paquete.sgf-read(path("variations.sgf")),
  problem: paquete.sgf-read(path("problem.sgf")),
  problems: (1, 2, 3).map(n => paquete.sgf-read(path("problems.sgf"), game: n)),
  josekis: paquete.sgf-read(path("joseki.sgf")),
  lee: partidas.lee,
  views: partidas.vistas,
)

// Lo que ven los ejemplos de cada idioma: el paquete y las partidas.
#let alcance = (es: dictionary(paquete) + partidas, en: dictionary(paquete) + games)

// Los colores y las fuentes: el papel crema, la tinta, la madera del tablero (kaya) y su tono claro.
#let papel = rgb("#fbf6ea")
#let tinta = rgb("#2b2118")
#let madera = rgb("#b5832f")
#let kaya = rgb("#f1e2bf")
#let fondo-codigo = rgb("#fffdf7")

#let fuentes = ("Libertinus Serif", "MS Gothic")
#let titulos = ("Fira Sans", "Libertinus Serif")
#let tamano = 10.5pt
#let mono(cuerpo) = text(font: "DejaVu Sans Mono", size: 0.85em, cuerpo)
#let idioma = state("manual-idioma", "es")
// Los valores que el texto les da a los ejemplos que siguen (definir).
#let definidos = state("manual-definidos", (:))

// Les da valores a los ejemplos que siguen: #definir(final: final).
#let definir(..valores) = definidos.update(d => d + valores.named())

// Lo que fija goban-set en el cuerpo no pasa a lo que sigue: antes va una marca en la lista de opciones
// globales (un diccionario vacío, que no cambia nada), y después se quita todo desde la marca.
#let aislado(cuerpo) = {
  global.update(l => l + ((:),))
  cuerpo
  global.update(l => l.slice(0, l.len() - 1 - l.rev().position(x => x == (:))))
}

// El resultado de un ejemplo, con el texto del manual (no el del código).
#let resultado(codigo) = aislado(context {
  set text(font: fuentes, size: tamano, lang: idioma.get())
  eval(codigo, mode: "markup", scope: alcance.at(idioma.get(), default: alcance.es) + definidos.get())
})

#let codigo(texto, lang: "typ") = block(width: 100%, fill: fondo-codigo, inset: 7pt, radius: 3pt,
  stroke: (left: 2pt + madera), raw(texto, lang: lang, block: true))

// Una piedra con algo encima, como una jugada numerada.
#let piedra(cuerpo, negra: true, radio: 0.9em, tamano: 1em) = box(baseline: 30%, circle(radius: radio,
  fill: if negra { tinta } else { white }, stroke: 0.8pt + tinta,
  align(center + horizon, text(font: titulos, weight: "bold", size: tamano,
    fill: if negra { white } else { tinta }, cuerpo))))

// Un ejemplo: lo que dibuja, sobre la madera, a la izquierda, y el código, a la derecha; con abajo, el código
// arriba y lo que dibuja debajo, a lo ancho.
#let ejemplo(texto, abajo: false) = {
  let dibujo(ancho) = block(width: ancho, fill: kaya, inset: 8pt, radius: 4pt, resultado(texto))
  // Lo que dibuja un ejemplo ocupa más de la mitad del ancho: va abajo del código.
  layout(espacio => {
    let ancho = measure(dibujo(auto), width: espacio.width).width
    if abajo or ancho > espacio.width * 0.5 {
      block(breakable: false, above: 1.1em, below: 1.1em, stack(spacing: 5pt, codigo(texto),
        if abajo { dibujo(100%) } else { align(center, dibujo(auto)) }))
    } else {
      block(breakable: false, above: 1.1em, below: 1.1em, grid(columns: (auto, 1fr), column-gutter: 12pt,
        align: (center + horizon, left + horizon), dibujo(auto), codigo(texto)))
    }
  })
}

// Una referencia a la página de una etiqueta.
#let pag(etiqueta) = context {
  let p = if idioma.get() == "en" [p.] else [pág.]
  if query(etiqueta).len() == 0 { return [#text(fill: red)[#p~??]#metadata(str(etiqueta))<pag-rota>] }
  let n = counter(page).at(etiqueta).first()
  link(etiqueta)[#p~#n]
}

// Una función de la referencia: su firma, en una barra de tinta.
#let funcion(firma, etiqueta: none, cuerpo) = block(above: 1.4em, below: 1em, {
  [#metadata((tipo: "funcion", nombre: firma.split("(").first()))<goban-indice>]
  if etiqueta != none [#metadata(firma)#etiqueta]
  block(width: 100%, fill: tinta, inset: (x: 8pt, y: 6pt), radius: 4pt, below: 0.7em, sticky: true,
    text(fill: white, mono(firma)))
  pad(left: 1.4em, cuerpo)
})

// Una opción de la referencia: su ruta en el árbol (background.fill.color), en una piedra negra; qué recibe;
// y su valor inicial, en una blanca.
#let opcion(ruta, valor: none, inicial: none, etiqueta: none, cuerpo) = block(above: 1.2em, below: 0.9em, {
  [#metadata((tipo: "opcion", nombre: ruta))<goban-indice>]
  if etiqueta != none [#metadata(ruta)#etiqueta]
  block(below: 0.55em, sticky: true, {
    box(fill: tinta, inset: (x: 5pt, y: 3pt), radius: 8pt, text(fill: white, mono(ruta)))
    if valor != none [ #h(3pt) #text(fill: madera.darken(25%), size: 0.95em, valor)]
    if inicial != none {
      h(1fr)
      box(stroke: 0.7pt + tinta, fill: white, inset: (x: 5pt, y: 3pt), radius: 8pt,
        text(size: 0.85em, context if idioma.get() == "en" [initially #inicial] else [inicial #inicial]))
    }
  })
  pad(left: 1.4em, cuerpo)
})

// El índice de las funciones y las opciones, en orden alfabético, con su página.
#let indice() = context {
  let entradas = query(<goban-indice>).map(m => (nombre: m.value.nombre, tipo: m.value.tipo,
    pagina: counter(page).at(m.location()).first(), lugar: m.location()))
  let nombres = entradas.map(e => e.nombre).dedup().sorted(key: n => lower(n))
  columns(2, for nombre in nombres {
    let de = entradas.filter(e => e.nombre == nombre)
    block(spacing: 0.45em, [#mono(nombre) #box(width: 1fr, repeat[.]) #de.map(e => link(e.lugar, str(e.pagina))).join(", ")])
  })
}

// La página y el texto.
#let manual(lang: "es", cuerpo) = {
  set document(author: "Jonatán Perren Hug")
  set text(lang: lang, font: fuentes, size: tamano, fill: tinta)
  idioma.update(lang)
  set page(paper: "a4", margin: (x: 2.3cm, top: 2.6cm, bottom: 2.3cm), fill: papel, numbering: "1",
    header: context {
      let pagina = here().page()
      let aqui = query(heading.where(level: 1)).any(h => h.location().page() == pagina)
      let antes = query(selector(heading.where(level: 1)).before(here()))
      if antes.len() > 0 and not aqui and counter(page).get().first() > 1 {
        set text(font: titulos, size: 0.8em, fill: luma(45%))
        [goban #h(1fr) #antes.last().body]
        v(-0.5em)
        line(length: 100%, stroke: 0.5pt + madera)
      }
    },
    footer: context align(center, piedra(counter(page).display(), radio: 0.75em, tamano: 0.8em)))
  set par(justify: true, leading: 0.68em)
  set heading(numbering: "1.1")
  set outline.entry(fill: repeat(text(fill: madera)[·], gap: 0.2em))
  show outline.entry.where(level: 1): set text(font: titulos, weight: "bold")
  show outline.entry.where(level: 1): set block(above: 1em)
  show heading: set text(font: titulos)
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(0.5em)
    if it.numbering != none {
      grid(columns: (auto, 1fr), column-gutter: 12pt, align: horizon,
        piedra(counter(heading).display("1")), text(size: 2em, weight: "bold", it.body))
    } else {
      text(size: 2em, weight: "bold", it.body)
    }
    v(-0.2em)
    // Una línea del tablero, con sus puntos de estrella.
    box(width: 100%, height: 6pt, {
      place(horizon, line(length: 100%, stroke: 0.8pt + madera))
      for x in (15%, 50%, 85%) { place(dx: x - 2.5pt, dy: 0.5pt, circle(radius: 2.5pt, fill: madera)) }
    })
    v(0.8em)
  }
  show heading.where(level: 2): it => block(above: 1.6em, below: 0.9em, text(size: 1.25em, weight: "bold", {
    if it.numbering != none {
      let n = counter(heading).display((..n) => str(n.pos().last()))
      grid(columns: (auto, 1fr), column-gutter: 7pt, align: horizon,
        box(baseline: 0pt, piedra(text(size: 0.75em, n), negra: false, radio: 0.7em)), it.body)
    } else { it.body }
  }))
  show heading.where(level: 3): it => block(above: 1.3em, below: 0.7em, text(size: 1.05em, weight: "bold",
    grid(columns: (auto, 1fr), column-gutter: 6pt, align: horizon, circle(radius: 3pt, fill: tinta), it.body)))
  show raw.where(block: false): box.with(fill: kaya, inset: (x: 2.5pt), outset: (y: 2.5pt), radius: 2pt)
  show raw.where(lang: "ejemplo"): it => ejemplo(it.text)
  show raw.where(lang: "ejemplo-abajo"): it => ejemplo(it.text, abajo: true)
  show raw.where(lang: "codigo"): it => codigo(it.text)
  show link: it => if type(it.dest) == str { underline(it) } else { it }
  cuerpo
}
