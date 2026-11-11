"""Las pantallas de The Seal of Hades.

  - el titulo: EJECUTANDO la ROM (tools/bios.py: el Z80 con la BIOS que usa) desde 0x8010 hasta 0x80D6, cuando ya
    estan el nombre, CASIO y los textos; la presentacion de CASIO (0x8C42), que va por cuadros, se salta. Las letras
    son del cartucho (0x7D00); la pagina 0 es la C-BIOS japonesa de openMSX (la de las grabaciones), aunque el titulo
    no la lee;
  - logotipo.png, la cabecera de la web: el nombre (闇の竜王 ハデスの紋章).

El titulo se coteja con la VRAM grabada (work/atraccion.bin): el cuadro que menos puntos distintos tiene.

Uso: pantallas.py <dir> [cotejo]
"""
import os
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, AQUI)
import vdp                  # noqa: E402
from bios import Msx, SCREEN2        # noqa: E402

RAIZ = os.path.dirname(AQUI)
CBIOS = r"C:\Program Files\openMSX\share\machines\cbios_main_msx1_jp.rom"


class Hades(Msx):
    def _bios(self):
        if self.pc == 0x007E:                             # SETGRP: SCREEN 2
            self.vdp.regs[:] = SCREEN2
            self.pc = self._pop()
            return
        super()._bios()


def titulo(bios=CBIOS):
    rom = open(os.path.join(RAIZ, "hades.rom"), "rb").read()
    m = Hades(rom, 0x4000)
    m.mem[0:0x4000] = open(bios, "rb").read()[:0x4000]

    def sin_presentacion(z):
        z.pc = 0x8084

    m.sp = 0xF380
    m.hasta(0x8010, 0x80D6, {0x8081: sin_presentacion})
    return bytes(m.vdp.vram), bytes(m.vdp.regs)


def cotejo(v, regs):
    t1 = vdp.tela(v, regs, False)
    mejor = None
    for n, c in enumerate(vdp.cuadros(os.path.join(RAIZ, "work", "atraccion.bin"))):
        if n > 900:
            break
        t2 = vdp.tela(c["vram"], c["regs"], False)
        puntos = sum(1 for y in range(192) for x in range(256) if t1[y][x] != t2[y][x])
        if mejor is None or puntos < mejor[1]:
            mejor = (n, puntos, bytes(c["regs"]))
        if puntos == 0:
            break
    n, puntos, r2 = mejor
    print("titulo contra atraccion/%d: puntos distintos %d de 49152; registros %s"
          % (n, puntos, "iguales" if regs[:7] == r2[:7] else "%s / %s" % (regs.hex(), r2.hex())))
    return puntos


def main(argv):
    v, regs = titulo()
    vdp.imagen(v, regs, 2, con_sprites=False).save(os.path.join(argv[0], "titulo.png"))
    # el nombre: filas 7-12, columnas 8-24
    vdp.imagen(v, regs, 4, con_sprites=False).crop((8 * 32, 7 * 32, 25 * 32, 13 * 32)).save(
        os.path.join(argv[0], "logotipo.png"))
    if len(argv) > 1:
        cotejo(v, regs)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
