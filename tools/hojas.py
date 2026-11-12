#!/usr/bin/env python3
"""Los sprites de The Seal of Hades MONTADOS DESDE LA ROM (ninguna imagen es una captura).

Los dibujos son los 0x800 bytes de 0x9000 que `sprites_dibujos` pone tal cual en 0x3800; sprites de 16 x 16. Cada
cosa son sprites de 16 bytes desde 0xE300 (los 4 primeros, sus atributos).

  protagonista.png   cuatro sprites (`prota_sprites` 0x9801, `prota_dibujos` 0x982D): A en 0xE320 (azul claro; con un
                     poder, rojo oscuro o amarillo claro), A + 4 en 0xE330 9 puntos por encima (cian), A + 8 en 0xE300
                     7 por debajo (rojo claro) y A + 12 en 0xE310 14 por debajo (negro); A es 0 o 0x10, cada 16 cuadros
                     quieto y cada 8 andando (0x9820); su disparo, el dibujo del arma (0x20, 0x24, 0x28 o 0x2C, negro)
  enemigos.png       los enemigos, dos sprites en el mismo sitio (el segundo, el hueco siguiente, con el tipo 15), el
                     dibujo y el + 4, cada 8 cuadros + 8: el 1 (0x30), el 0 y el 8 (0xB8), el 2 (0xC8), el 6 (0x70) de
                     `enemigo_a`; el 3 (0x40), el 4 (0xD8) y el 5 (0xB8) de `enemigo_b`; el 7 (0x60, `enemigo_c`), el 9
                     (0x50, `enemigo_d`) y el 10 (0x80); vencidos (`vencido` 0x9F2D), la explosion grande de los
                     tipos 1, 3 y 6 (0xA8 y 0xAC cada 8 cuadros, negro y verde claro cada 2) y la chica de los demas
                     (0xB0 y 0xB4, rojo claro y amarillo claro)
  enemigos_cuadros.gif  los enemigos con sus dos dibujos, cada 8 cuadros

Uso: hojas.py docs/imagenes | hojas.py cotejo
"""
import os
import sys

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(RAIZ, "tools"))
import vdp          # noqa: E402

ORG = 0x4000
ROM = open(os.path.join(RAIZ, "hades.rom"), "rb").read()
FONDO = (96, 104, 128)           # claro, para que se vea el negro
# (tipos, primer dibujo, color del primero, color del segundo)
ENEMIGOS = [((1, 2, 8), 0x30, 1, 5), ((0, 8), 0xB8, 12, 5), ((2,), 0xC8, 1, 10), ((6,), 0x70, 1, 15),
            ((3,), 0x40, 1, 11), ((4,), 0xD8, 9, 1), ((5,), 0xB8, 9, 1), ((7,), 0x60, 15, 1), ((9,), 0x50, 9, 1),
            ((10,), 0x80, 5, 1)]


def patrones():
    return ROM[0x9000 - ORG:0x9000 - ORG + 0x800]


def pinta(im, pat, n, x, y, color, escala=1):
    if color & 15 == 0:
        return
    n &= 0xFC
    d = pat[n * 8:n * 8 + 32]
    c = vdp.PALETA[color & 15]
    for fila in range(16):
        for col in range(16):
            if (d[fila + (16 if col >= 8 else 0)] >> (7 - (col & 7))) & 1:
                for ey in range(escala):
                    for ex in range(escala):
                        px, py = (x + col) * escala + ex, (y + fila) * escala + ey
                        if 0 <= px < im.width and 0 <= py < im.height:
                            im.putpixel((px, py), c)


def prota(a, color=5):
    """(dy, dibujo, color) de los cuatro sprites, del de mas prioridad (0xE300) al de menos (0xE330)."""
    return [(7, a + 8, 9), (14, a + 12, 1), (0, a, color), (-9, a + 4, 7)]


def grupo(im, pat, sprites, x, y, E):
    for dy, d, c in reversed(sprites):
        pinta(im, pat, d, x, y + dy, c, E)


def hoja(Image):
    pat, E = patrones(), 4
    im = Image.new("RGB", (6 * 20 * E, 2 * 44 * E), FONDO)
    for k, (a, c) in enumerate(((0, 5), (0x10, 5), (0, 6), (0x10, 11))):
        grupo(im, pat, prota(a, c), 2 + 20 * k, 12, E)
    for k, d in enumerate((0x20, 0x24, 0x28, 0x2C)):
        pinta(im, pat, d, 2 + 20 * k, 56, 1, E)          # el disparo, color 1 (disparo_pon)
    return im


def hoja_enemigos(Image):
    pat, E = patrones(), 3
    im = Image.new("RGB", (5 * 44 * E, 3 * 22 * E), FONDO)
    for k, (_, d, c1, c2) in enumerate(ENEMIGOS):
        x, y = 2 + 44 * (k % 5), 2 + 22 * (k // 5)
        for j in range(2):
            pinta(im, pat, d + 8 * j + 4, x + 20 * j, y, c2, E)
            pinta(im, pat, d + 8 * j, x + 20 * j, y, c1, E)
    for k, (d, c) in enumerate(((0xA8, 1), (0xAC, 3), (0xB0, 9), (0xB4, 11))):
        pinta(im, pat, d, 2 + 20 * k, 46, c, E)
    return im


def anima(Image):
    pat, E, cuadros = patrones(), 3, []
    for n in range(64):
        im = Image.new("RGB", (len(ENEMIGOS) * 20 * E + 20 * E, 36 * E), FONDO)
        grupo(im, pat, prota(0x10 if n & 8 else 0), 2, 12, E)
        for k, (_, d, c1, c2) in enumerate(ENEMIGOS):
            dd = d + (8 if n & 8 else 0)
            pinta(im, pat, dd + 4, 22 + 20 * k, 12, c2, E)
            pinta(im, pat, dd, 22 + 20 * k, 12, c1, E)
        cuadros.append(im)
    return cuadros


def guarda_gif(cuadros, ruta, ms=1000 / 60):
    imgs, durs = [], []
    for im in cuadros:
        if imgs and list(im.getdata()) == list(imgs[-1].getdata()):
            durs[-1] += ms
        else:
            imgs.append(im)
            durs.append(ms)
    imgs[0].save(ruta, save_all=True, append_images=imgs[1:], duration=[max(20, int(round(d))) for d in durs],
                 loop=0, disposal=1)


def cotejo():
    """Contra las grabaciones de openMSX (work/*.bin, la RAM 0xE000-0xEFFF):
    1) la tabla de dibujos de los sprites (VRAM 0x3800-0x3FFF) contra los 0x800 bytes de 0x9000;
    2) los cuatro sprites del protagonista (0xE300-0xE330) contra `prota()`: sus sitios, dibujos y colores (el de
       0xE320, el del poder);
    3) los enemigos (0xE380 en adelante, 16 bytes): el dibujo de su tipo (o + 8) y su color, y el hueco siguiente
       (tipo 15) en el mismo sitio con el dibujo + 4."""
    pat = patrones()
    tipos = {}
    for ts, d, c1, c2 in ENEMIGOS:
        for t in ts:
            tipos.setdefault(t, set()).update({(d, c1, c2), (d + 8, c1, c2)})
    tot = dict(patrones=0, pat_carga=0, pat_mal=0, prota=0, prota_sin_poner=0, prota_mal=0, enemigos=0,
               enemigos_salen=0, enemigos_vencidos=0, enemigos_otros=0, enemigos_mal=0)
    for grab in ("atraccion", "partida", "forzada", "trucos"):
        ruta = os.path.join(RAIZ, "work", grab + ".bin")
        if not os.path.exists(ruta):
            continue
        try:
            cuadros = list(vdp.cuadros(ruta))
        except AssertionError:
            continue
        for c in cuadros:
            v, ram = c["vram"], c["ram"]
            t = v[0x3800:0x4000]
            if any(t):
                n = len(t.rstrip(bytes(1)))
                if t == pat:
                    tot["patrones"] += 1
                elif t[:n] == pat[:n]:
                    tot["pat_carga"] += 1
                else:
                    tot["pat_mal"] += 1
            s = [ram[0x300 + 16 * k:0x304 + 16 * k] for k in range(4)]
            p = s[2]
            if p == bytes(4):
                tot["prota_sin_poner"] += 1
            elif p[0] < 0xC0 and p[2] in (0, 0x10):
                quiero = prota(p[2], p[3] & 15)
                hay = [((x[0] - p[0]) & 0xFF, x[2], x[3] & 15) for x in s]
                ok = hay == [(dy & 0xFF, d, cc) for dy, d, cc in quiero] and all(x[1] == p[1] for x in s)
                tot["prota"] += ok
                tot["prota_mal"] += not ok
            for k in range(8, 31):
                e = ram[0x300 + 16 * k:0x320 + 16 * k]
                if e[0] >= 0xC0 or e[4] not in tipos:
                    continue
                trio = (e[2], e[3] & 15, e[0x13] & 15)
                if trio in tipos[e[4]] and e[0x12] == e[2] + 4 and e[0x10:0x12] == e[0:2]:
                    tot["enemigos"] += 1
                elif e[5] == 0x0A or e[2] in (0xA8, 0xAC, 0xB0, 0xB4):
                    tot["enemigos_vencidos"] += 1   # `vencido` (0x9F2D): 0xA8 / 0xAC o 0xB0 / 0xB4
                elif e[2] in (0x30, 0x38) and e[0x12] == e[2] + 4:
                    tot["enemigos_salen"] += 1      # al salir, aun con el dibujo 0x30 hasta que su rutina pone el suyo
                elif e[2] >= 0xF0 or e[:4] == bytes(4):
                    tot["enemigos_otros"] += 1      # sin poner aun, o las piezas de 0xF0-0xFC
                else:
                    tot["enemigos_mal"] += 1
    return tot


def main(argv):
    if argv and argv[0] == "cotejo":
        print(cotejo())
        return 0
    from PIL import Image
    salida = argv[0]
    os.makedirs(salida, exist_ok=True)
    hoja(Image).save(os.path.join(salida, "protagonista.png"))
    hoja_enemigos(Image).save(os.path.join(salida, "enemigos.png"))
    guarda_gif(anima(Image), os.path.join(salida, "enemigos_cuadros.gif"))
    for f in ("protagonista.png", "enemigos.png", "enemigos_cuadros.gif"):
        print(f, os.path.getsize(os.path.join(salida, f)))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
