#!/usr/bin/env python3
"""EL CONTENIDO de la web de esta ROM: lo unico que es de este juego.

jekyll.py y make_web.py son la maquinaria y no llevan dentro el nombre de
ningun juego: lo leen de aqui.

Todas las cifras de aqui estan medidas sobre esta ROM, con las herramientas
de tools/: CODIGO y DATOS los imprime tools/presupuesto.py (make sanity),
INSTRUCCIONES, COMENTARIOS y RUTINAS los da tools/densidad.py (make densidad:
"de N" rutinas, "N instrucciones, M comentarios").
"""

NOMBRE = "The Seal of Hades"
EDITOR = "Casio"
ANIO = 1986
REPOSITORIO = "https://github.com/antxiko/SealOfHades-disassembly"
SHA1 = "fcc6b6b9f05de409492a1fb988fa671e46d54196"

CODIGO = 9874
DATOS = 22894
RUTINAS = 612
INSTRUCCIONES = 4464
COMENTARIOS = 1854


def densidad(idioma):
    """El porcentaje comentado, con la coma o el punto de cada idioma."""
    d = "%.1f" % (100.0 * COMENTARIOS / INSTRUCCIONES)
    return d.replace(".", ",") if idioma == "es" else d


PIE_LEGAL = {
    "es": "<em>The Seal of Hades</em> (闇の竜王 ハデスの紋章, Yami no Ryuuou Hadesu no Monshou) es un juego de Casio "
          "para MSX, de 1986, en un cartucho de 32 KB. Todos los derechos sobre el juego siguen siendo de sus "
          "titulares. Este trabajo es de preservaci&oacute;n, estudio y documentaci&oacute;n, y la imagen de la ROM no "
          "se distribuye.",
    "en": "<em>The Seal of Hades</em> (闇の竜王 ハデスの紋章, Yami no Ryuuou Hadesu no Monshou) is a 1986 Casio game "
          "for the MSX, on a 32 KB cartridge. All rights in the game remain with their holders. This is preservation, "
          "study and documentation work, and the ROM image is not distributed.",
}

PORTADA = {
    "es": dict(
        titulo="The Seal of Hades - desensamblado comentado",
        claim="Un matamarcianos a pie, hacia arriba: Leon dispara, rompe los bloques del suelo para sacar lo que "
              "guardan, vigila el aire y la fuerza, y al final de cada una de las seis escenas vence al guardi&aacute;n "
              "de piedra. Si encuentra The Stone of Wisdom en otro slot, empieza m&aacute;s fuerte. El t&iacute;tulo "
              "sale de ejecutar la ROM, cotejado con openMSX punto a punto; la partida en GIF, jugada en openMSX; las "
              "doce m&uacute;sicas que suenan, de su propio motor, id&eacute;nticas a openMSX cuadro a cuadro.",
        ficha=["Casio - <b>(c) 1986</b>",
               "Cartucho de <b>32 KB</b> (cabecera en 0x4000)",
               "<b>MSX</b>", "Volcado <b>fcc6b6b9...</b>"],
        aviso="<b>Aqu&iacute; no hay capturas del juego.</b> El t&iacute;tulo sale de ejecutar la ROM y los GIF son "
              "la ROM <b>funcionando en openMSX</b>: en cada cuadro se apuntan la VRAM, la RAM y los registros del "
              "VDP, y <b>c&oacute;digo nuestro los pinta</b>.",
    ),
    "en": dict(
        titulo="The Seal of Hades - commented disassembly",
        claim="A shoot-'em-up on foot, going up: Leon shoots, breaks the ground blocks to get what they keep, watches "
              "his air and his power, and at the end of each of the six scenes beats the stone guardian. If he finds "
              "The Stone of Wisdom in another slot, he starts stronger. The title comes from running the ROM, checked "
              "against openMSX point by point; the game in GIF, played in openMSX; the twelve tunes that play, from "
              "its own engine, identical to openMSX frame by frame.",
        ficha=["Casio - <b>(c) 1986</b>",
               "<b>32 KB</b> cartridge (header at 0x4000)",
               "<b>MSX</b>", "Dump <b>fcc6b6b9...</b>"],
        aviso="<b>There are no screenshots of the game here.</b> The title comes from running the ROM and the GIFs "
              "are the ROM <b>running in openMSX</b>: on every frame the VRAM, the RAM and the VDP registers are "
              "logged, and <b>our own code paints them</b>.",
    ),
}

PAGINAS = [
    [("THE-GAME.html", "LA-PARTIDA.html", "The game", "La partida",
      "the CASIO intro, the title, the controls, AIR, POWER and the shots, the blocks, the hearts and GAME OVER",
      "la presentaci&oacute;n de CASIO, el t&iacute;tulo, los mandos, AIR, POWER y los disparos, los bloques, los "
      "corazones y GAME OVER"),
     ("THE-SCENES.html", "LAS-ESCENAS.html", "The scenes", "Las escenas",
      "the six scenes, their screens, the enemies, the guardian and the ending",
      "las seis escenas, sus pantallas, los enemigos, el guardi&aacute;n y el final"),
     ("THE-SPRITES.html", "LOS-SPRITES.html", "The sprites", "Los sprites",
      "the hero in four sprites, his shots, every enemy and the explosions put together from the ROM tables",
      "el protagonista en cuatro sprites, sus disparos, cada enemigo y las explosiones montados desde la ROM"),
     ("THE-TEXTS.html", "LOS-TEXTOS.html", "The texts", "Los textos",
      "every text in the ROM, with its translation",
      "todos los textos de la ROM, con su traducci&oacute;n"),
     ("THE-MUSIC.html", "LA-MUSICA.html", "The music", "La m&uacute;sica",
      "the tunes, from its own sound engine and checked against openMSX",
      "las m&uacute;sicas, de su propio motor de sonido y cotejadas con openMSX")],
    [("CURIOSITIES.html", "CURIOSIDADES.html", "Curiosities", "Curiosidades",
      "The Stone of Wisdom in another slot, TAB and CAPS, a demo that plays the header, leftover texts",
      "The Stone of Wisdom en otro slot, TAB y CAPS, una demostraci&oacute;n que juega la cabecera, textos sobrantes"),
     ("SECRETS-AND-BUGS.html", "SECRETOS-Y-FALLOS.html", "Secrets and bugs", "Secretos y fallos",
      "what was searched for: the keys and the other cartridge, the high score set to zero past 9,999,990, the cursor keys and joystick mixed, and the extra life at 30,000 checked",
      "lo que se ha buscado: las teclas y el otro cartucho, el r&eacute;cord a cero pasados los 9.999.990, los cursores y el mando que se mezclan, y la vida de m&aacute;s a los 30.000 comprobada")],
    [("UNDER-THE-HOOD.html", "POR-DENTRO.html", "Under the hood", "Por dentro",
      "rebuilding the ROM, the cartridge, the BIOS it uses, the loop, the scroll, the RAM and the tools",
      "rehacer la ROM, el cartucho, la BIOS que usa, el bucle, el avance de la pantalla, la RAM y las herramientas")],
]

# Repositorio nuevo: no hay paginas viejas que redirigir.
VIEJAS = {}

LOGOTIPO = "logotipo.png"
