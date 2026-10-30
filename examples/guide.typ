// La guía de los ejemplos: cada uno en su página, con lo que dibuja y su código. La usan examples/examples.typ (en
// inglés) y examples/ejemplos.typ (en español); los ejemplos son los mismos, en inglés. Está en la carpeta de los
// ejemplos porque eval resuelve las rutas desde el archivo que lo llama: así path("commented.sgf") es la misma en el
// ejemplo suelto y en la guía.

#import "/lib.typ" as gobanist
#import "/src/options.typ": global

#let version = toml("/typst.toml").package.version
#let ink = rgb("#2b2118")
#let wood = rgb("#b5832f")
#let paper = rgb("#fffdf7")

// Lo que fija gobanist-set en un ejemplo no pasa a los siguientes (como en el manual, doc/estilo.typ).
#let isolated(body) = {
  global.update(l => l + ((:),))
  body
  global.update(l => l.slice(0, l.len() - 1 - l.rev().position(x => x == (:))))
}

// El código sin el import del paquete ni la página (la página del ejemplo suelto es el recuadro de la guía), y el
// ancho de esa página.
#let prepare(code) = {
  let page = code.match(regex("(?m)^#set page\((.*)\)\r?\n"))
  let width = auto
  if page != none {
    let w = page.captures.at(0).match(regex("width: ([^,)]+)"))
    if w != none { width = eval(w.captures.at(0)) }
  }
  let body = code.replace(regex("(?m)^#import \"@preview/gobanist:[^\"]*\": \*\r?\n"), "")
  body = body.replace(regex("(?m)^#set page\(.*\)\r?\n"), "")
  (body: body, width: width)
}

// Un ejemplo: el título, lo que dibuja, en un recuadro del ancho de su página, y el código completo.
#let example(n, title, code) = {
  pagebreak(weak: true)
  heading(level: 1, numbering: none)[#n. #title]
  let (body, width) = prepare(code)
  // Los títulos del ejemplo no van en el índice de la guía, y son más chicos que los de la guía.
  let drawing = {
    set heading(outlined: false)
    show heading: set text(size: 12pt)
    // En inglés, como el ejemplo suelto, aunque la guía esté en otro idioma.
    set text(lang: "en")
    isolated(eval(body, mode: "markup", scope: dictionary(gobanist)))
  }
  align(center, block(width: if width == auto { auto } else { width + 1cm }, inset: 0.5cm, fill: white,
    stroke: 0.5pt + luma(80%), align(left, drawing)))
  v(1em)
  block(width: 100%, breakable: false, fill: paper, inset: 7pt, radius: 3pt, stroke: (left: 2pt + wood),
    text(size: 8pt, raw(code.replace("\r\n", "\n"), lang: "typ", block: true)))
}

// La guía: la portada, el índice y los ejemplos, pares (archivo, título).
#let guide(title: none, intro: none, lang: "en", examples) = {
  set document(title: title)
  set page(paper: "a4", margin: 1.5cm, numbering: "1")
  set text(lang: lang, size: 10.5pt, fill: ink)
  show raw: set text(font: "DejaVu Sans Mono")
  show heading: set text(font: ("Fira Sans", "Libertinus Serif"), weight: "bold", fill: ink)
  show heading.where(level: 1): set text(size: 14pt)
  show heading.where(level: 1): set block(below: 1em)

  align(center, text(size: 22pt, font: ("Fira Sans", "Libertinus Serif"), weight: "bold")[#title])
  align(center, text(size: 11pt)[gobanist #version])
  v(1em)
  intro
  v(1em)
  outline(title: none, depth: 1)
  for (i, (file, t)) in examples.enumerate() { example(i + 1, t, read(file)) }
}
