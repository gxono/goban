// Los textos de cada idioma: todos tienen las claves del inglés, del mismo tipo; se eligen con el idioma del
// texto; lo que falta sale del inglés; y el resultado en palabras, en cada idioma.

#import "/lib.typ": *
#import "/src/options.typ": current
#import "/src/texts.typ": texts, word
#import "/src/diagrams.typ": result-text

#assert.eq(texts.keys(), ("en", "es", "fr", "de", "pt", "it", "eo", "ja", "zh", "ko"))

// Las mismas claves que el inglés, en el mismo orden; las funciones reciben lo mismo y devuelven una cadena
// que contiene lo que reciben.
#for (lang, table) in texts {
  assert.eq(table.keys(), texts.en.keys(), message: lang)
  for (key, value) in table {
    assert.eq(type(value), type(texts.en.at(key)), message: lang + " " + key)
    if type(value) == str { assert(value != "", message: lang + " " + key) }
  }
  let at = (table.variation-at)(37)
  assert(type(at) == str and at.contains("37"), message: lang)
  for key in ("win", "win-by-resignation", "win-on-time", "win-by-forfeit") {
    let said = table.at(key)("Ana")
    assert(type(said) == str and said.contains("Ana"), message: lang + " " + key)
  }
  let said = (table.win-by-points)("Ana", "6.5")
  assert(said.contains("Ana") and said.contains("6.5"), message: lang)
}

// Una palabra de cada idioma, la de pgf-go.
#let diagram = (en: "Diagram", es: "Diagrama", fr: "Diagramme", de: "Diagramm", pt: "Diagrama",
  it: "Diagramma", eo: "Diagramo", ja: "図", zh: "图", ko: "그림")
#for (lang, expected) in diagram {
  assert.eq(texts.at(lang).diagram, expected, message: lang)
}

// Con el idioma del texto, cada clave sale de su tabla.
#for lang in texts.keys() {
  set text(lang: lang)
  context for (key, value) in texts.at(lang) {
    assert.eq(repr(word(current(), key)), repr(value), message: lang + " " + key)
  }
}

// Un idioma sin tabla, o una clave que le falta a uno agregado con texts, sale del inglés.
#[
  #set text(lang: "nl")
  #context assert.eq(word(current(), "problem"), "Problem")
  #gobanist-set(texts: (nl: (problem: "Probleem")))
  #context assert.eq((word(current(), "problem"), word(current(), "diagram")), ("Probleem", "Diagram"))
]

// El resultado en palabras, en cada idioma: las formas de RE de results.sgf de pgf-go.
#let forms = ("B+R", "W+3.5", "B+Time", "W+F", "B+", "0", "Void", "?", "Black won")
#let expected = (
  en: ("Black wins by resignation", "White wins by 3.5 points", "Black wins on time", "White wins by forfeit",
    "Black wins", "Draw (jigo)", "No result", "Unknown result", "Black won"),
  fr: ("Noir gagne par abandon", "Blanc gagne de 3.5 points", "Noir gagne au temps", "Blanc gagne par forfait",
    "Noir gagne", "Partie nulle (jigo)", "Sans résultat", "Résultat inconnu", "Black won"),
  ja: ("黒 中押し勝ち", "白 3.5 目勝ち", "黒 時間切れ勝ち", "白 不戦勝", "黒 勝ち", "持碁", "無勝負", "結果不明",
    "Black won"),
)
#for (lang, said) in expected {
  set text(lang: lang)
  context {
    let tree = current()
    let names = (black: word(tree, "black"), white: word(tree, "white"))
    assert.eq(forms.map(re => result-text(tree, re, names)), said, message: lang)
  }
}
