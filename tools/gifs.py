"""Los GIF de la web: tramos de las grabaciones de openMSX (tools/guiones/*.tcl, grabados con
tools/lanza_graba.ps1 en C-BIOS_MSX1_JP, -bp 0x8B09 -ram "0xE000 0x1000"), pintados con tools/vdp.py; cada imagen
dura el tiempo emulado que dura en la grabacion.

Los tramos salen de la RAM grabada (work/resumen.py): 0xE000 jugando, 0xE027 la demostracion, 0xE003 la escena,
0xE053 la pantalla, 0xE001 LEON, 0xE183 la muerte, 0xE184 la escena acabada, 0xE2BD la musica.

  atraccion   sin tocar nada: la presentacion de CASIO, el titulo y la demostracion (una escena al azar: la 3)
  partida     el piloto (tools/guiones/piloto.tcl): la escena 1, sus pantallas y las tres muertes hasta GAME OVER
  trucos      TAB y CAPS en la presentacion (sin morir, LEON sin fin) y el piloto: el guardian y las escenas 1-3
  forzada     FORZADA con pokes: las escenas 4, 5 y 6 (0xE003 y F1) y el final (0xE184)

Las grabaciones son grandes: cada una se lee UNA vez.

Uso: gifs.py docs/imagenes
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vdp          # noqa: E402

# (fichero, grabacion, desde, hasta, cada)
TRAMOS = [
    ("presentacion.gif", "atraccion", 1, 209, 3),       # la presentacion de CASIO
    ("demostracion.gif", "atraccion", 3537, 4600, 3),   # la demostracion: la escena 3
    ("salida.gif", "partida", 300, 1300, 2),            # la escena 1 empieza y la pantalla avanza
    ("muerte.gif", "partida", 1600, 2060, 2),           # una muerte y otra vez
    ("game_over.gif", "partida", 2900, 3560, 3),        # la ultima y GAME OVER
    ("guardian.gif", "trucos", 4000, 4700, 2),          # el guardian de la escena 1
    ("escena_acabada.gif", "trucos", 17700, 18300, 2),  # el guardian vencido y la escena 2
    ("escena_2.gif", "trucos", 18300, 19300, 3),        # la escena 2
    ("escena_3.gif", "trucos", 23300, 24300, 3),        # la escena 3
    ("escena_4.gif", "forzada", 1000, 1900, 3),         # FORZADA: la escena 4
    ("escena_5.gif", "forzada", 2500, 3400, 3),         # FORZADA: la escena 5
    ("escena_6.gif", "forzada", 4000, 4900, 3),         # FORZADA: la escena 6
    ("final.gif", "forzada", 5500, 6600, 4),            # FORZADA: el final
]


def main(salida):
    raiz = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    for grab in dict.fromkeys(t[1] for t in TRAMOS):
        mios = [t for t in TRAMOS if t[1] == grab]
        gifs = {t[0]: vdp.Gif() for t in mios}
        tope = max(t[3] for t in mios) + max(t[4] for t in mios)
        espera = {}                                    # fichero -> (imagen, t) pendiente de su duracion
        for n, c in enumerate(vdp.cuadros(os.path.join(raiz, "work", grab + ".bin"))):
            if n > tope:
                break
            for fichero, _, desde, hasta, cada in mios:
                if desde <= n <= hasta + cada and (n - desde) % cada == 0:
                    if fichero in espera:
                        im, t = espera.pop(fichero)
                        gifs[fichero].pon(im, (c["t"] - t) * 1000.0 / gifs[fichero].ms)
                    if n <= hasta:
                        espera[fichero] = (vdp.imagen(c["vram"], c["regs"], 1), c["t"])
        for fichero, _, desde, hasta, cada in mios:
            if fichero in espera:                       # la grabacion acaba antes: la ultima, un paso
                im, _t = espera.pop(fichero)
                gifs[fichero].pon(im, cada)
            ruta = os.path.join(salida, fichero)
            gifs[fichero].guarda(ruta, 4000)
            print("%-24s %4d imagenes, %8d bytes" % (fichero, len(gifs[fichero]), os.path.getsize(ruta)))


if __name__ == "__main__":
    main(sys.argv[1])
