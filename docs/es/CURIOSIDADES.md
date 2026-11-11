# Curiosidades

## The Stone of Wisdom en otro slot

Al encender, INIT (0x4010) lee con RDSLT el byte 0x92E1 de cada slot -los cuatro primarios y los diecis&eacute;is
expandidos- y busca un 0x23. En *The Stone of Wisdom*, el juego anterior de Casio, 0x92E1 es la "S" de THE STONE OF
WISDOM (su texto empieza en 0x92DD y 0x23 es la S en la codificaci&oacute;n de los dos); en *The Seal of Hades* ese
byte es un 0. Si lo encuentra, lo apunta en 0xE000, que el arranque no borra (empieza a borrar en 0xE001), y pasa a
0xE060: la partida empieza con **POWER a 32** en vez de 16 y con la **velocidad** (Leon anda de dos en dos y la
pantalla avanza m&aacute;s r&aacute;pido; `partida_nueva`, 0x810F). Los tests lo comprueban con las dos ROM.

## TAB y CAPS

Pulsadas al acabar la presentaci&oacute;n de CASIO, junto al t&iacute;tulo:

- **TAB** (0xE03A): Leon **no muere**. La rutina de la muerte (`muerte`, 0x8374) vuelve sin hacer nada, sea por un
  enemigo, una bala, el aire o un agujero. Solo F1 lo derriba.
- **CAPS** (0xE039): LEON **sin fin**: al caer la &uacute;ltima, vuelve a haber tres (`game_over_mira`, 0x840B).

Con las dos est&aacute;n grabados los GIF del guardi&aacute;n y de las escenas 2 y 3.

## La demostraci&oacute;n juega la cabecera

Los mandos de la demostraci&oacute;n se leen de una lista, un byte cada 16 cuadros (la palanca abajo, los botones
arriba), que empieza en **0x4000**: la cabecera del cartucho ("AB", INIT...) y el c&oacute;digo de INIT. No hay lista
hecha a prop&oacute;sito. En la grabada se lee hasta 0x407F.

## Las vueltas que nadie cuenta

Al acabar la escena 6, el final suma una vuelta en 0xE004 y pone la escena a 0, pero nadie vuelve a leer 0xE004: el
bot&oacute;n del final vuelve al t&iacute;tulo. Y el sonido de fondo del guardi&aacute;n tiene una casilla propia
(0xE18D) que nadie pone a 1.

## Sobrantes

- **Textos**: THE STONE OF WISDOM, ENERGY, " OVER", "T;POWER" y un resto de cr&eacute;ditos, "ER    T;MORIYAMA"
  (ver [Los textos](LOS-TEXTOS.html)).
- **La m&uacute;sica 5**, que nadie pide (ver [La m&uacute;sica](LA-MUSICA.html)).
- **C&oacute;digo muerto**: cinco trozos sueltos detr&aacute;s de un salto o un `ret` (0x880F, 0x885E, 0x8890, 0x8948 y
  0x8F41) y un `ret` en 0x9800; ning&uacute;n salto llega a ellos y la medida de cobertura en openMSX no pasa.
- **Datos**: el final de una fuente de 8 x 8 en 0x4EAC (340 bytes), 128 bytes en 0x5780 y otros 128 en 0x5F80, y el
  relleno FB 00 de la EPROM al final.
- **Las letras dentro de los colores**: las letras del juego (0x7D00, 0x180 bytes) est&aacute;n dentro de la tabla de
  colores de un juego de casillas (0x7C00-0x7FFF): los mismos bytes sirven para las dos cosas.
