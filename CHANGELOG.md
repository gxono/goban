# Changelog

## 0.1.0 (sin publicar)

- El paquete se llama `gobanist` (`@preview/gobanist`); las funciones siguen siendo `goban`, `goban-layout`, etc., salvo `goban-set`, que pasa a `gobanist-set`.
- El tablero no depende del tamaño de la fuente: la grilla (`grid.sep`, 12.5pt), el fondo (`background.sep`,
  8.25pt), los números de las jugadas, el texto de las marcas y las etiquetas (`label.text`, 10pt) tienen
  medidas absolutas, las de pgf-go con 10pt; antes estaban en `em`, y con otra fuente las piedras se separaban o
  se pisaban.
- Prototipo del núcleo: tablero, piedras, prisioneros, jugadas numeradas, `partial`, marcas y la sintaxis
  de coordenadas de pgf-go.
- Opciones como árbol de diccionarios, con `gobanist-set` para las globales.
- `board` y `resume`: un tablero como valor; `forget`.
- Sombra y brillo de las piedras, sombra del tablero y `scale-line-width`.
- Etiquetas con letras, números o kanji, en las dos direcciones, y `label.style`.
- Flechas y líneas: `arrows` y `lines`.
- El kernel, un plugin de WebAssembly (`kernel/`, en Rust): capturas (`captures`, `captured-marks`),
  territorio (`territory`, con polígonos o `auto`, y `draw: "marks"`, `"fill"` o `"region"`), regiones y
  puntaje.
- Notas «N en M» (`notes`) y los resultados del último tablero: `goban-prisoners`, `goban-score`,
  `goban-notes` y `goban-region`.
- Partidas en SGF: `sgf-read`, `sgf` y `sgf-info`, con variantes, marcas, `MN`, `PL`, `AE`, `TB`/`TW`,
  pases («N: pasa» en las notas), `restart`, `last-mark` y `letters`. El kernel lee el SGF y sus
  codificaciones. Pide Typst 0.15.
- Los textos de cada idioma: `texts`.
- `sgf-comment`: el comentario de una jugada, con su nombre y sus anotaciones.
- `sgf-diagrams`: la partida en diagramas como en los libros, con epígrafe, notas, comentarios (debajo, al
  costado o después) y resultado; las opciones `diagrams` y `layout` (en el párrafo o en una grilla, con `fit`).
- `sgf-diagrams`: las variantes, cada una en su diagrama (`variations`, `variation-title`).
- `sgf-diagrams`: un diagrama por figura del archivo (`FG`), con su nombre en el epígrafe (`figures`).
- `sgf-diagrams`: la vista del archivo (`VW`); cada diagrama muestra la que abarca las de sus jugadas (`view`).
- `sgf-diagrams`: `partial: auto`, la misma parte del tablero en todos los diagramas: la que usan las líneas
  que se dibujan.
- `sgf-diagrams`: `comments.height`, la altura máxima de los comentarios de un diagrama; lo que no entra va
  después de los diagramas.
- `sgf.view`: la vista del archivo (`VW`) en un tablero: la que abarca las jugadas `from` a `to` o la de una
  jugada.
- `sgf-problem`: un problema, o varios, con su enunciado y un diagrama por solución; las opciones `problems`
  (`statement`, `solutions`, `title`, `to-play`, `variation-title`, `verdict`, `view`, `partial`...).
- Perfiles: `profile`, con el nombre de uno del paquete (`default`, `wain`, `pgfgo`, `pgfgosmooth`, `simple`,
  `draft`, `shell`, `yunzi`, `baduktv`) o un diccionario de opciones.
- `fill.pattern`: un `tiling` encima del relleno de las piedras, las marcas, el territorio y el fondo.
- Imágenes: `stone.image`, `stone.shadow.image`, `stone.shine.image`, `background.fill.image`, `grid.image` y
  `hoshi.image`; varios archivos y giros elegidos por el lugar. El kernel hace la opacidad y las siluetas de
  los PNG y los JPEG.
- `goban-layout`: tableros sueltos, partidas y los diagramas de `sgf-diagrams` y `sgf-problem` en una misma
  disposición.
- `layout.width: auto`: las columnas de la grilla toman el ancho del diagrama más ancho.
- `layout.per-page`: cada tantos diagramas, la página siguiente.
- Una grilla más angosta que la línea (`layout.width`) se centra; antes quedaba a la izquierda.
- En la grilla, un diagrama que va solo en su fila (`statement: "alone"`) se centra; antes quedaba a la
  izquierda.
- Formas de marca propias: la opción `shapes`, con funciones, contenidos o imágenes.
- `goban-view`: una parte de un tablero, como quedó al terminar, en medio del texto; la opción `view`.
- `sgf-diagrams` y `sgf-problem`: una jugada en un punto ocupado quita la piedra que había; antes era error.
- El manual en español (`doc/es/manual.typ`): tutoriales, referencia, catálogo de perfiles e índice.
- El manual en inglés (`doc/en/manual.typ`), traducido del español.
- Un tablero hecho con `board` puede ir primero en `goban` y en `board`: `goban(base)` lo dibuja, y
  `board(base, moves("C3"))` es ese tablero con más cosas. Las opciones se aplican rama por rama.
- El epígrafe de un diagrama más ancho que su tablero se corta en líneas parejas («Problema 1:» y «Juegan
  Negras»); antes la última línea podía quedar con una sola palabra.
- `sgf-problem` con `verdict`: el veredicto se separa de «Variante 2» con un espacio común; antes, con uno
  irrompible, el epígrafe podía salirse de su lugar y pisar al de al lado.
- `goban-layout`, `sgf-diagrams` y `sgf-problem` con `fit`, medidos sin un ancho disponible: la grilla toma el
  ancho de los diagramas; antes era un error.
- `sgf-diagrams` y `sgf-problem`: lo que capturan las jugadas del diagrama no se quita, aunque no tenga número
  (las piedras del enunciado o las jugadas anteriores), como en pgf-go; antes solo quedaban las numeradas.
