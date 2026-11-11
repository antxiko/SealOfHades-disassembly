"""Lo que se afirma de la ROM, comprobado contra sus bytes.

Corre con la ROM delante y sin ella: cuando no esta, la imagen se rehace desde
las filas defb/defw del listado, que si viaja con el repositorio. Sin la ROM
solo se comprueba lo que cae en datos.
"""

import os
import re
import subprocess
import sys
import unittest

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(RAIZ, "tools"))

ROM = os.path.join(RAIZ, "hades.rom")
ASM = os.path.join(RAIZ, "src", "hades.asm")
NOTAS = os.path.join(RAIZ, "src", "hades.notes")
ORG = 0x4000
TAM = 32768

FILA = re.compile(r"^\s+def(b|w)\s+([0-9a-fA-F,h ]+)\s*;\s*([0-9a-f]{4})")


def imagen_desde_el_listado():
    img = bytearray(TAM)
    with open(ASM, encoding="utf-8") as f:
        for ln in f:
            m = FILA.match(ln)
            if not m:
                continue
            ancho, cuerpo, dirr = m.group(1), m.group(2), int(m.group(3), 16)
            p = dirr - ORG
            for tok in cuerpo.split(","):
                tok = tok.strip().rstrip("h")
                if not tok:
                    continue
                v = int(tok, 16)
                if ancho == "b":
                    img[p] = v
                    p += 1
                else:
                    img[p] = v & 0xFF
                    img[p + 1] = v >> 8
                    p += 2
    return bytes(img)


def lee():
    if os.path.exists(ROM):
        with open(ROM, "rb") as f:
            return f.read()
    return imagen_desde_el_listado()


def b(a):
    return lee()[a - ORG]


def w(a):
    rom = lee()
    return rom[a - ORG] | (rom[a - ORG + 1] << 8)


def instruccion(dirr):
    """La instruccion del listado en esa direccion (sin el comentario)."""
    with open(ASM, encoding="utf-8") as f:
        for ln in f:
            m = re.match(r"^	(\S.*?)\s*;([0-9a-f]{4})", ln)
            if m and int(m.group(2), 16) == dirr:
                return m.group(1).replace("	", " ").strip()


def texto(a, n):
    """Casilla = letra - 0x30 (el orden de la fuente de la BIOS); 0x10 es el espacio."""
    return "".join(" " if c == 0x10 else chr(c + 0x30) for c in lee()[a - ORG:a - ORG + n])




KANA1 = "をぁぃぅぇぉゃゅょっ・あいうえおかきくけこさしすせそ"
KANA2 = "たちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわん"


def kana(a, n):
    """Las casillas 0x86-0x9F y 0xE0-0xFD son las letras de la BIOS con su mismo numero (final_letras)."""
    out = ""
    for c in lee()[a - ORG:a - ORG + n]:
        if 0x86 <= c <= 0x9F:
            out += KANA1[c - 0x86]
        elif 0xE0 <= c <= 0xFD:
            out += KANA2[c - 0xE0]
        elif c == 0xBE:
            out += "゛"
        elif c == 0x10:
            out += " "
        else:
            out += chr(c + 0x30)
    return out


class Cabecera(unittest.TestCase):
    def test_ab_e_init_en_0x4010(self):
        rom = lee()
        self.assertEqual(rom[:2], b"AB")
        self.assertEqual(w(0x4002), 0x4010)

    def test_init_pone_la_pagina_2_y_salta(self):
        self.assertEqual([instruccion(a) for a in (0x405E, 0x4060, 0x4063)],
                         ["ld h,080h", "call 00024h", "jp arranque_nop"])

    def test_son_32_kb(self):
        self.assertEqual(len(lee()), TAM)


class StoneOfWisdom(unittest.TestCase):
    def test_init_busca_la_s_en_0x92e1(self):
        self.assertEqual([instruccion(a) for a in (0x4014, 0x401C, 0x401F)],
                         ["ld hl,092e1h", "call 0000ch", "cp 023h"])

    def test_la_s_es_la_de_stone(self):
        self.assertEqual(texto(0x8DF1, 19), "THE STONE OF WISDOM")
        self.assertEqual(lee()[0x8DF1 + 4 - ORG], 0x23)

    def test_hades_no_la_tiene_en_0x92e1(self):
        self.assertNotEqual(b(0x92E1), 0x23)

    def test_con_stone_power_a_0x20(self):
        self.assertEqual([instruccion(a) for a in (0x813A, 0x8140, 0x8145)],
                         ["ld a,(0e060h)", "ld a,020h", "ld a,001h"])


class LaInterrupcion(unittest.TestCase):
    def test_va_por_h_timi(self):
        self.assertEqual([instruccion(a) for a in (0x802E, 0x8031, 0x8036)],
                         ["ld hl,08b09h", "ld (0fda0h),hl", "ld (0fd9fh),a"])


class LosTextos(unittest.TestCase):
    def test_el_titulo(self):
        self.assertEqual(texto(0x8E04, 20), "PUSH TRIG:1 OR SPACE")
        self.assertEqual(texto(0x8DE1, 10), "GAME START")

    def test_el_marcador(self):
        self.assertEqual(texto(0x8E2E, 7), "HISCORE")
        self.assertEqual(texto(0x8DD4, 8), "POWERAIR")
        self.assertEqual(texto(0x8E46, 10), "LEON SCENE")

    def test_textos_sin_usar(self):
        self.assertEqual(texto(0x8DCE, 6), "ENERGY")
        # ninguna instruccion los nombra (en la ROM, sus bytes salen por casualidad dentro de dibujos)
        with open(ASM, encoding="utf-8") as f:
            codigo = [ln for ln in f if ln.startswith("	") and "def" not in ln.split(";")[0]]
        for d in (0x8DCE, 0x8DF1, 0x8DDC):
            self.assertFalse(any("0%04xh" % d in ln for ln in codigo), hex(d))


class LaPartida(unittest.TestCase):
    def test_dos_leon_air_y_power(self):
        self.assertEqual([instruccion(a) for a in (0x8117, 0x8130, 0x8135)],
                         ["ld a,002h", "ld a,030h", "ld a,010h"])

    def test_seis_escenas(self):
        self.assertEqual([instruccion(a) for a in (0x8464, 0x8467)], ["ld (0e003h),a", "cp 006h"])

    def test_la_escena_5_repite_las_pantallas_de_la_1(self):
        e1 = [w(0x40CC + 2 * k) for k in range(7)]
        e5 = [w(0x4074 + 2 * k) for k in range(7)]
        self.assertEqual(e1, e5)

    def test_tab_y_caps(self):
        self.assertEqual([instruccion(a) for a in (0x8089, 0x8097)], ["bit 3,a", "bit 3,a"])

    def test_la_demostracion_lee_desde_la_cabecera(self):
        self.assertEqual(instruccion(0x80F7), "ld hl,04000h")


class Tablas(unittest.TestCase):
    def test_objetos_y_enemigos(self):
        self.assertEqual(w(0x9E9D + 2 * 6), 0xAA7E)
        self.assertEqual(w(0x9EF3 + 2 * 0x0A), 0xA295)

    def test_codigo_muerto_sin_punteros(self):
        rom = lee()
        for d in (0x885E, 0x8890, 0x8948, 0x8F41):
            self.assertNotIn(bytes([d & 0xFF, d >> 8]), rom)


class Sonido(unittest.TestCase):
    def test_nueve_musicas(self):
        for k in range(1, 9):
            for j in range(3):
                self.assertTrue(0xB13C <= w(0xAD00 + 6 * k + 2 * j) < 0xC000)

    def test_el_motor_es_el_de_stone(self):
        self.assertEqual(instruccion(0xB059), "ld hl,0ad00h")


class ElListado(unittest.TestCase):
    def test_densidad_y_flojas(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "densidad.py"), ASM],
            capture_output=True, text=True, check=True).stdout
        m = re.search(r"(\d+) instrucciones, (\d+) comentarios", salida)
        self.assertGreaterEqual(int(m.group(2)) * 100, 40 * int(m.group(1)))
        self.assertIn("---- 0 rutinas por debajo del 10 %", salida)

    def test_ningun_call_sin_nombre(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "sin_bautizar.py"), ASM],
            capture_output=True, text=True, check=True).stdout
        self.assertTrue(salida.startswith("0 rutinas sin bautizar"), salida[:200])

    def test_cada_comentario_en_su_instruccion(self):
        salida = subprocess.run(
            [sys.executable, os.path.join(RAIZ, "tools", "valida_c.py"), ASM, NOTAS],
            capture_output=True, text=True, check=True).stdout
        self.assertIn("0 fuera de sitio, 0 repetidos", salida)


if __name__ == "__main__":
    unittest.main()
