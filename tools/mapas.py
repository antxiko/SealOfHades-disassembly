"""Los mapas de las seis escenas de The Seal of Hades, PINTADOS EJECUTANDO LA ROM: cada una de las once pantallas de
la escena (la tabla de 0x4068) montada por pantalla_monta (0x9B89) en la RAM (0xEA80, 24 x 24 casillas) y su juego de
casillas puesto por casillas_cambia (0x8635), sobre la pantalla que deja escena_empieza (0x814A) ejecutada hasta el
ENASCR: todas las casillas y colores salen de la ROM. Las pantallas entran por arriba: la 0 abajo y la 10
arriba. Sin marcador, sprites ni objetos que se mueven.

La pantalla de la RAM va de ABAJO ARRIBA (su fila 0 es la de abajo), y asi se pinta aqui.

Cotejo sobre work/forzada.bin (uno de cada cinco cuadros de juego): la RAM del juego lleva la pantalla anterior en
0xE840 y la nueva (0xE053) en 0xEA80, y la ventana 0xE190 es la fila de abajo de lo visible; con las dos pantallas
montadas AQUI en su lugar, la fila f de la pantalla tiene que ser la W + 23 - f, con W = (0xE190 - 0xE840) / 24.

Uso: mapas.py docs/imagenes
"""
import os
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, AQUI)
import vdp                  # noqa: E402
from bios import Msx        # noqa: E402
from PIL import Image       # noqa: E402

RAIZ = os.path.dirname(AQUI)
ROM = open(os.path.join(RAIZ, "hades.rom"), "rb").read()
LADO = 24


BASE = {}


def base(escena):
    """escena_empieza (0x814A) EJECUTADA hasta el ENASCR (0x8200): la pantalla, las casillas y los colores de la
    escena, todo desde la ROM."""
    if escena not in BASE:
        m = Msx(ROM, 0x4000)
        m.mem[0xE003] = escena
        m.sp = 0xF380
        m.hasta(0x814A, 0x8200)
        BASE[escena] = {"ram": bytes(m.mem[0xE000:0xF000]), "vram": bytes(m.vdp.vram)}
    return BASE[escena]


def monta(c, escena, pantalla):
    m = Msx(ROM, 0x4000)
    m.mem[0xE000:0xF000] = c["ram"]
    m.vdp.vram[:] = c["vram"]
    m.mem[0xE050] = escena
    m.mem[0xE053] = pantalla
    m.llama(0x9B89)
    filas = bytes(m.mem[0xEA80:0xEA80 + LADO * LADO])
    m.llama(0x8635)
    return filas, m.vdp.vram


def imagen(filas, vram, regs):
    """La pantalla de la RAM va de abajo arriba: la fila de arriba de la pantalla es la 23."""
    v = bytearray(vram)
    for f in range(LADO):
        v[0x1800 + 32 * f:0x1800 + 32 * f + LADO] = filas[LADO * (LADO - 1 - f):LADO * (LADO - f)]
    return vdp.imagen(bytes(v), regs, 1, con_sprites=False).crop((0, 0, 8 * LADO, 8 * LADO))


def main(salida):
    cuadro = {}
    cotejos = {}
    montadas = {}
    n = 0
    for c in vdp.cuadros(os.path.join(RAIZ, "work", "forzada.bin")):
        r = c["ram"]
        if not (r[0x000] and c["regs"][1] & 0x40) or r[0x050] > 5:
            continue
        e, k = r[0x050], r[0x053]
        cuadro.setdefault(e, c)
        n += 1
        if n % 5:
            continue
        for p in (k, k - 1):
            if p >= 0 and (e, p) not in montadas:
                montadas[(e, p)] = monta(base(e), e, p)[0]
        if k == 0:
            continue
        # la RAM: la anterior en 0xE840 y la nueva en 0xEA80, filas de abajo arriba; la ventana (0xE190) es la fila de
        # abajo de lo visible: la fila f de la pantalla es la W + 23 - f, con W = (0xE190 - 0xE840) / 24
        w = ((r[0x190] | r[0x191] << 8) - 0xE840) // LADO
        if not 0 <= w <= LADO:
            continue
        juntas = montadas[(e, k - 1)] + montadas[(e, k)]
        esperado = b"".join(juntas[LADO * (w + LADO - 1 - f):LADO * (w + LADO - f)] for f in range(LADO))
        grab = b"".join(c["vram"][0x1800 + 32 * f:0x1800 + 32 * f + LADO] for f in range(LADO))
        cotejos.setdefault(e, []).append(sum(1 for a, b in zip(esperado, grab) if a != b))
    columnas = []
    regs = next(iter(cuadro.values()))["regs"]
    for e in range(6):
        c = base(e)
        col = Image.new("RGB", (8 * LADO, 11 * 8 * LADO))
        for k in range(11):
            filas, vram = monta(c, e, k)
            col.paste(imagen(filas, vram, regs), (0, (10 - k) * 8 * LADO))
        columnas.append(col)
        ds = sorted(cotejos.get(e, []))
        print("escena %d: cotejo %d cuadros (uno de cada cinco), %d iguales, con 10 o menos distintas %d, mediana %s" % (
            e + 1, len(ds), ds.count(0), sum(1 for d in ds if d <= 10), ds[len(ds) // 2] if ds else "-"))
    hoja = Image.new("RGB", (6 * (8 * LADO + 8) - 8, 11 * 8 * LADO), (0, 0, 0))
    for i, col in enumerate(columnas):
        hoja.paste(col, (i * (8 * LADO + 8), 0))
    hoja = hoja.resize((hoja.size[0] // 2, hoja.size[1] // 2), Image.NEAREST)
    ruta = os.path.join(salida, "mapas.png")
    hoja.save(ruta, optimize=True)
    print(ruta, hoja.size)


if __name__ == "__main__":
    main(sys.argv[1])
