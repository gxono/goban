"""Arma la carpeta del paquete para typst/packages: lo que se commitea en packages/preview/goban/<versión>.

    python bundle.py [destino]

Sin destino, la deja en dist/goban/<versión>. Copia el código, las imágenes, el README, la licencia y lo que
enlaza el README (los manuales en PDF y sus imágenes, excluidos del paquete en typst.toml); no copia los tests,
el kernel en Rust ni las fuentes del manual.
"""

import shutil
import sys
import tomllib
from pathlib import Path

ROOT = Path(__file__).resolve().parent
FILES = ["typst.toml", "lib.typ", "README.md", "LICENSE",
         "doc/en/manual.pdf", "doc/es/manual.pdf", "doc/readme-1.png", "doc/readme-2.png"]
FOLDERS = ["src", "images"]


def main():
    version = tomllib.loads((ROOT / "typst.toml").read_text(encoding="utf-8"))["package"]["version"]
    dest = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "dist" / "goban" / version
    if dest.exists():
        shutil.rmtree(dest)
    for name in FILES:
        (dest / name).parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(ROOT / name, dest / name)
    for name in FOLDERS:
        shutil.copytree(ROOT / name, dest / name)
    print(dest)


if __name__ == "__main__":
    main()
