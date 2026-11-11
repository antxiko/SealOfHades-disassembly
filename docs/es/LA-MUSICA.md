# La m&uacute;sica

Las m&uacute;sicas, a tres voces. No son grabaciones hechas a mano: `tools/musica.py` **ejecuta el motor de sonido
de la propia ROM** con `tools/z80run.py` -la rutina del sonido (`sonido`, 0xAD82), cuadro a cuadro, con el
n&uacute;mero que escribe el juego- y apunta lo que escribe en el PSG por la BIOS (WRTPSG).

**Cotejadas con openMSX**: los registros de tono y volumen de los tres canales casan con los grabados, **0
distintos** en todos los cuadros mirados, en las doce que suenan. Se cotejan cuatro grabaciones (`tools/guiones/`):
la demostraci&oacute;n, la partida del piloto, la de TAB y CAPS y la forzada con las escenas 4-6 y el final. Cada
cuadro grabado se empareja con el cuadro del motor que tiene la misma RAM en sus canales (los fondos, solo B y C:
el A lleva los disparos).

## El motor

Es el de *The Stone of Wisdom*, byte a byte, 0x9FC bytes antes (0xAD5E-0xB13B): atiende tres **pedidos** -una
m&uacute;sica (0xE2BE), un efecto del canal A (0xE2C0) y otro de B y C (0xE2C2)- y gana el de n&uacute;mero menor. Las
tablas: nueve m&uacute;sicas en 0xAD00 (la 0, nada), seis efectos del canal A en 0xAD36, siete de B y C en 0xAD42 y
catorce duraciones en 0xB033.

Durante la partida el fondo es un **efecto** de los canales B y C, que el bucle pide en cada pasada
(`sonido_fondo`, 0x8349): uno por escena. El guardi&aacute;n pide otro, el 2, cada vez que cambia de dibujo
(0xAAE6); el bucle tambi&eacute;n lo pedir&iacute;a con 0xE18D, pero nadie pone esa casilla.

| | qui&eacute;n la pide | dura |
|---|---|---:|
| el t&iacute;tulo | 0x80DA (el bot&oacute;n la corta) | 55,5 s |
| la presentaci&oacute;n de CASIO | 0x8C85 | 1,1 s |
| la partida empieza | 0x820D | 6,4 s |
| cada escena empieza | 0x8212 | 3,2 s |
| las escenas 1, 3 y 5 | el bucle (efecto 6) | 57,6 s, vuelve a empezar |
| la escena 2 | el bucle (efecto 5) | 51,2 s, vuelve |
| la escena 4 | el bucle (efecto 4) | 28,8 s, vuelve |
| la escena 6 | el bucle (efecto 3) | 29,9 s, vuelve |
| el guardi&aacute;n | el guardi&aacute;n, cada 64 cuadros (efecto 2) | 1,1 s |
| la escena acabada | 0x8560 | 6,5 s |
| el final | 0x8477, una y otra vez | 8,6 s |
| GAME OVER | 0x842C | 4,4 s |

**La 5** no la pide nadie (no hay ning&uacute;n `ld a,5` delante de `musica_pide`): sale de ejecutar el motor con ese
n&uacute;mero y no se puede cotejar.

## El t&iacute;tulo

<audio controls src="../audio/musica_titulo.mp3"></audio>

## La presentaci&oacute;n de CASIO

<audio controls src="../audio/musica_casio.mp3"></audio>

## La partida empieza

<audio controls src="../audio/musica_partida.mp3"></audio>

## Cada escena empieza

<audio controls src="../audio/musica_escena.mp3"></audio>

## Las escenas 1, 3 y 5

<audio controls src="../audio/musica_escenas_135.mp3"></audio>

## La escena 2

<audio controls src="../audio/musica_escena_2.mp3"></audio>

## La escena 4

<audio controls src="../audio/musica_escena_4.mp3"></audio>

## La escena 6

<audio controls src="../audio/musica_escena_6.mp3"></audio>

## El guardi&aacute;n

<audio controls src="../audio/musica_guardian.mp3"></audio>

## La escena acabada

<audio controls src="../audio/musica_escena_acabada.mp3"></audio>

## El final

<audio controls src="../audio/musica_final.mp3"></audio>

## GAME OVER

<audio controls src="../audio/musica_game_over.mp3"></audio>

## La 5, que nadie pide

<audio controls src="../audio/musica_5_sin_uso.mp3"></audio>
