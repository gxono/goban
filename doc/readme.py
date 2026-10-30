"""Renderiza las imágenes del README: cada bloque typ seguido de una imagen doc/readme-N.png se compila en esa imagen.

    python doc/readme.py

Los bloques se compilan con el paquete del repositorio (el import de @preview se cambia por /lib.typ) desde doc/, donde
están las partidas. El ancho de cada <img> pasa a ser el natural de su imagen. Borra las doc/readme-*.png que el README
ya no usa.
"""

import re
import subprocess
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
README = ROOT / "README.md"
PPI = 192  # el doble de 96: la imagen se muestra a la mitad de su ancho en píxeles
BLOCK = re.compile(r"```typ\n(.*?)```\s*\n\s*<img ([^>]*?)src=\"(doc/readme-\d+\.png)\"([^>]*)>", re.S)
PREAMBLE = """#import "/lib.typ": *
#set page(width: auto, height: auto, margin: 10pt, fill: white)
#set text(size: 11pt)
"""


def main():
    text = README.read_text(encoding="utf-8")
    used = set()
    source = ROOT / "doc" / "_readme.typ"

    def render(match):
        code, before, image, after = match.groups()
        code = re.sub(r'#import "@preview/gobanist:[^"]*": \*\n', "", code)
        source.write_text(PREAMBLE + code, encoding="utf-8")
        result = subprocess.run(["typst", "compile", "--root", str(ROOT), "--ppi", str(PPI), str(source),
                                 str(ROOT / image)], capture_output=True, text=True)
        if result.returncode != 0:
            sys.exit(f"{image}:\n{result.stderr}")
        used.add(image)
        width = Image.open(ROOT / image).width * 96 // PPI
        attributes = re.sub(r'\s*width="\d+"', "", before + after).strip()
        return match.group(0)[:match.start(2) - match.start(0)] + f'{attributes} src="{image}" width="{width}">'

    try:
        text = BLOCK.sub(render, text)
    finally:
        source.unlink(missing_ok=True)
    README.write_text(text, encoding="utf-8")
    for old in (ROOT / "doc").glob("readme-*.png"):
        if f"doc/{old.name}" not in used:
            old.unlink()
    print(f"{len(used)} imágenes")


if __name__ == "__main__":
    main()
