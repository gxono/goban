"""Compila el kernel a WebAssembly y lo deja en src/kernel.wasm, el plugin que carga src/kernel.typ.

    python kernel/build.py

Necesita Rust con el target wasm32-unknown-unknown (rustup target add wasm32-unknown-unknown).
"""

import shutil
import subprocess
import sys
from pathlib import Path

KERNEL = Path(__file__).resolve().parent
TARGET = KERNEL / "target" / "wasm32-unknown-unknown" / "release" / "goban_kernel.wasm"
PLUGIN = KERNEL.parent / "src" / "kernel.wasm"


def sources():
    return [KERNEL / "Cargo.toml", KERNEL / "Cargo.lock", *(KERNEL / "src").rglob("*.rs")]


def stale():
    """Si el plugin falta o es más viejo que el código del kernel."""
    if not PLUGIN.exists():
        return True
    built = PLUGIN.stat().st_mtime
    return any(p.exists() and p.stat().st_mtime > built for p in sources())


def build():
    subprocess.run(
        ["cargo", "build", "--release", "--target", "wasm32-unknown-unknown", "--lib"],
        cwd=KERNEL, check=True,
    )
    shutil.copy(TARGET, PLUGIN)
    print(f"{PLUGIN.relative_to(KERNEL.parent)}: {PLUGIN.stat().st_size // 1024} KB")


if __name__ == "__main__":
    try:
        build()
    except (OSError, subprocess.CalledProcessError) as error:
        sys.exit(f"no se pudo compilar el kernel: {error}")
