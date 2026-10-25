"""Tests de regresión de goban.

Antes, si el código del kernel (kernel/) es más nuevo que src/kernel.wasm, lo compila de nuevo. Corre los
tests del kernel en Rust (cargo test, el caso «kernel»). Compila tests/unit/*.typ (pasan si compilan: tienen assert), tests/errors/*.typ (cada caso tiene que fallar con su
mensaje) y tests/cases/*.typ, cuyas páginas se pasan a PNG y se comparan píxel por píxel con
tests/reference/. Las páginas que cambian quedan en tests/_build/diffs/, la referencia a la izquierda y lo
nuevo a la derecha.

En tests/errors/, cada caso empieza con una línea «// error: <parte del mensaje>» y sigue hasta el próximo;
se compila solo, después de importar el paquete.

    python tests/run.py               todos
    python tests/run.py marks moves   solo los que tienen "marks" o "moves" en el nombre
    python tests/run.py --update      reemplaza las referencias
"""

import re
import shutil
import subprocess
import sys
from pathlib import Path

from PIL import Image, ImageChops

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "kernel"))
import build as kernel  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
TESTS = ROOT / "tests"
BUILD = TESTS / "_build"
REFERENCE = TESTS / "reference"
PPI = "144"


def compile(source, output, *options):
    result = subprocess.run(
        ["typst", "compile", "--root", str(ROOT), *options, str(source), str(output)],
        capture_output=True, text=True, encoding="utf-8",
    )
    return result.returncode == 0, (result.stderr or "").strip()


def pages(name):
    out = BUILD / "pages"
    out.mkdir(parents=True, exist_ok=True)
    for old in out.glob(f"{name}-*.png"):
        old.unlink()
    ok, log = compile(TESTS / "cases" / f"{name}.typ", out / f"{name}-{{0p}}.png", "--ppi", PPI)
    return ok, log, sorted(out.glob(f"{name}-*.png"))


def side_by_side(a, b, path):
    image = Image.new("RGB", (a.width + b.width, max(a.height, b.height)), "white")
    image.paste(a, (0, 0))
    image.paste(b, (a.width, 0))
    image.save(path)


def check_case(name, update):
    ok, log, images = pages(name)
    if not ok:
        return False, log
    if update:
        for old in REFERENCE.glob(f"{name}-*.png"):
            old.unlink()
        for image in images:
            shutil.copy(image, REFERENCE / image.name)
        return True, f"{len(images)} páginas"
    references = sorted(REFERENCE.glob(f"{name}-*.png"))
    if [r.name for r in references] != [i.name for i in images]:
        return False, f"{len(images)} páginas, {len(references)} en la referencia"
    changed = []
    for reference, image in zip(references, images):
        a = Image.open(reference).convert("RGB")
        b = Image.open(image).convert("RGB")
        if a.size != b.size or ImageChops.difference(a, b).getbbox() is not None:
            changed.append(image.name)
            side_by_side(a, b, BUILD / "diffs" / image.name)
    return not changed, "cambió " + ", ".join(changed) if changed else ""


# Los tests del kernel en Rust: el resumen de cargo test o, si fallan, su salida.
def check_kernel():
    try:
        result = subprocess.run(
            ["cargo", "test", "--quiet"], cwd=kernel.KERNEL,
            capture_output=True, text=True, encoding="utf-8",
        )
    except OSError as error:
        return False, f"no se pudo correr cargo: {error}"
    log = (result.stdout + result.stderr).strip()
    if result.returncode != 0:
        return False, log
    passed = sum(int(n) for n in re.findall(r"test result: ok\. (\d+) passed", log))
    return True, f"{passed} tests"


ERROR_MARK = "// error:"


# Los casos de un archivo de tests/errors/: (línea, mensaje esperado, código).
def error_cases(source):
    cases = []
    for number, line in enumerate(source.read_text(encoding="utf-8").splitlines(), 1):
        if line.startswith(ERROR_MARK):
            cases.append((number, line[len(ERROR_MARK):].strip(), []))
        elif cases:
            cases[-1][2].append(line)
    return [(number, expected, "\n".join(code)) for number, expected, code in cases]


def check_errors(source):
    out = BUILD / "errors"
    out.mkdir(parents=True, exist_ok=True)
    failures = []
    cases = error_cases(source)
    for number, expected, code in cases:
        document = out / f"{source.stem}-{number}.typ"
        document.write_text('#import "/lib.typ": *\n' + code + "\n", encoding="utf-8")
        ok, log = compile(document, out / f"{source.stem}.pdf")
        if ok:
            failures.append(f"línea {number}: compiló sin error")
        elif expected not in log:
            failures.append(f"línea {number}: se esperaba «{expected}»\n{log.splitlines()[0]}")
    if not cases:
        failures.append("no tiene casos")
    return not failures, f"{len(cases)} casos" if not failures else "\n".join(failures)


def main(args):
    sys.stdout.reconfigure(encoding="utf-8")
    update = "--update" in args
    filters = [a for a in args if not a.startswith("--")]
    wanted = lambda name: not filters or any(f in name for f in filters)
    # El plugin tiene que estar al día con el código del kernel.
    if kernel.stale():
        print("el kernel cambió: se compila de nuevo")
        kernel.build()
    REFERENCE.mkdir(parents=True, exist_ok=True)
    shutil.rmtree(BUILD / "diffs", ignore_errors=True)
    (BUILD / "diffs").mkdir(parents=True)
    passed = failed = 0
    if wanted("kernel") and not update:
        ok, detail = check_kernel()
        print(("ok    " if ok else "FALLA ") + "kernel" + (f"  ({detail})" if ok else "\n" + detail))
        passed, failed = passed + ok, failed + (not ok)
    for source in sorted((TESTS / "unit").glob("*.typ")):
        if not wanted("unit/" + source.stem) or update:
            continue
        ok, log = compile(source, BUILD / f"{source.stem}.pdf")
        print(("ok    " if ok else "FALLA ") + "unit/" + source.stem + ("" if ok else "\n" + log))
        passed, failed = passed + ok, failed + (not ok)
    for source in sorted((TESTS / "errors").glob("*.typ")):
        if not wanted("errors/" + source.stem) or update:
            continue
        ok, detail = check_errors(source)
        print(("ok    " if ok else "FALLA ") + "errors/" + source.stem + (f"  ({detail})" if ok else "\n" + detail))
        passed, failed = passed + ok, failed + (not ok)
    for source in sorted((TESTS / "cases").glob("*.typ")):
        if not wanted(source.stem):
            continue
        ok, detail = check_case(source.stem, update)
        print(("ok    " if ok else "FALLA ") + source.stem + (f"  ({detail})" if detail else ""))
        passed, failed = passed + ok, failed + (not ok)
    print(f"{passed} pasaron, {failed} fallaron")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
