# Por dentro

## Rehacer la ROM

`make verify` ensambla `src/hades.asm` con pasmo y sale la ROM de 32 KB **byte a byte**. `make sanity` comprueba lo
que el reensamblado no cubre: que ning&uacute;n byte declarado como datos se lea como c&oacute;digo, que ning&uacute;n
punto de entrada caiga en datos y que los 32.768 bytes est&eacute;n explicados. `make test` pasa los tests. La ROM no
est&aacute; en el repositorio: hay que ponerla en la ra&iacute;z como `hades.rom` (el volcado de GoodMSX, `[!]`, sha1
`fcc6b6b9...`).

| | bytes |
|---|---|
| c&oacute;digo trazado | 9.874 |
| datos con nombre | 22.894 |
| sin explicar | 0 |

El listado tiene 1.854 comentarios en 4.464 instrucciones (41,5 %), 612 rutinas y etiquetas, ninguna por debajo del
10 % comentado, y ninguna rutina llamada sin nombre.

## El cartucho

32 KB en 0x4000-0xBFFF, con la cabecera en 0x4000. INIT (0x4010) busca *The Stone of Wisdom* en otro slot, pone el
cartucho tambi&eacute;n en la p&aacute;gina 2 y salta a 0x8010. Primero van los datos: las tablas de las escenas
(0x4068) y de sus pantallas (0x4074), las descripciones de las pantallas (0x40F8-0x49B5), los bordes y los dibujos
(0x49B6-0x4EAB), las casillas del t&iacute;tulo y del juego con sus colores (0x5000-0x5F7F) y cuatro juegos de
casillas m&aacute;s (0x6000-0x7FFF), con las letras dentro (0x7D00). El c&oacute;digo va de 0x8000 a 0xACB5, con los
textos en medio (0x8D74-0x8EBA) y los dibujos de los sprites (0x9000-0x97FF); detr&aacute;s, el sonido (0xAD00-0xBFFF).

## La BIOS que usa

RDSLT, RSLREG y ENASLT para los slots; SETGRP, CHGCLR, WRTVDP, DISSCR y ENASCR; FILVRM, LDIRVM y WRTVRM; GTSTCK y
GTTRIG para los mandos y SNSMAT para la barra, GRAPH, STOP, F1, TAB y CAPS; WRTPSG para el sonido. De la BIOS lee la
fuente para el texto del final (0x1FBF: sus letras 0x80-0xFF).

## La interrupci&oacute;n y el bucle

INIT pone un salto a 0x8B09 en el gancho H.TIMI. La interrupci&oacute;n hace el silencio pedido, corre el sonido,
cuenta cuadros (ocho cuentas, 0xE010-0xE017) y lee F1, STOP, los botones, la barra, GRAPH y la palanca; en la
demostraci&oacute;n, un byte de su lista cada 16 cuadros (`interrupcion`, 0x8B09). La partida corre en el **bucle**
(`bucle`, 0x823A): una vez por cuadro, los sprites que parpadean (`sprites_rota`), y si no hay pausa, el sonido de
fondo, el parpadeo de la pantalla, lo cogido, Leon, los sprites, el disparo, los puntos, los enemigos, los objetos,
el aire y los enemigos que salen solos.

**El avance.** La pantalla de ahora y la siguiente est&aacute;n en la RAM (0xE840 y 0xEA80, 24 x 24 casillas); una
ventana (0xE190) baja por ellas una fila cada 16 cuadros y se copia a la VRAM de abajo arriba (`ventana_pon`,
0x9E40). A las 24 filas se monta la pantalla siguiente (`pantalla_monta`, 0x9B89) y los objetos de la anterior se
corren 0x240 bytes. Leon y los enemigos miran dos casillas del lado al que van: por debajo de 0xC0 se pasa
(`pasa_fila`, 0x9AC2).

**Los sprites.** Con m&aacute;s de cuatro sprites en una l&iacute;nea el VDP no pinta el quinto; el juego copia
cada cuadro los de 0xE340-0xE47F empezando por otro (0xE185), as&iacute; que parpadean en vez de desaparecer
(`sprites_rota`, 0x8EBB).

## C&oacute;mo se ha hecho

El trazado sigue el c&oacute;digo desde INIT, la interrupci&oacute;n y las tres tablas de saltos (los objetos,
0x9E9D; los enemigos, 0x9EF3; los pasos de las balas, 0xA49B), declaradas en `src/hades.entries`. Lo dem&aacute;s se
**midi&oacute; en openMSX** (`tools/omsx_cobertura.tcl`) en un Philips VG 8020, esperando la demostraci&oacute;n y
jugando: no qued&oacute; fuera del trazado nada de lo que se ejecut&oacute;. Los comentarios del motor de sonido vienen
de *The Stone of Wisdom*, donde es el mismo c&oacute;digo 0x9FC bytes despu&eacute;s, y otras rutinas comunes de otros
Casio (`comun/casio/porta.py`, solo en los tramos id&eacute;nticos), revisados uno a uno.

Las grabaciones de la web (`tools/guiones/*.tcl`, grabadas con `tools/lanza_graba.ps1` en C-BIOS) apuntan, en cada
cuadro, los registros del VDP, la RAM desde 0xE000, el PSG y la VRAM que cambi&oacute;. `tools/pantallas.py` ejecuta
el t&iacute;tulo con `tools/bios.py` y lo coteja con la grabaci&oacute;n (**0 puntos distintos**), `tools/gifs.py` hace
los GIF y `tools/musica.py` ejecuta el motor de sonido.

## La RAM

| | |
|---|---|
| 0xE000 / 0xE060 | jugando / The Stone of Wisdom en otro slot |
| 0xE001 | LEON (BCD) |
| 0xE003 | la escena (0-5) |
| 0xE004 | las vueltas (nadie las lee) |
| 0xE006-0xE00B | las cifras de los puntos |
| 0xE00C-0xE00E | los puntos (BCD) |
| 0xE010-0xE017 | las cuentas de cuadros |
| 0xE020-0xE02D | los botones: reci&eacute;n pulsados y sostenidos |
| 0xE027 / 0xE037 | la demostraci&oacute;n / su lista de mandos |
| 0xE02E-0xE033 / 0xE034-0xE036 | el r&eacute;cord: cifras / BCD |
| 0xE039 / 0xE03A | CAPS / TAB en la presentaci&oacute;n |
| 0xE053 | la pantalla (0-10) |
| 0xE054 / 0xE055 | los corazones: BCD / binario |
| 0xE057 / 0xE058 | AIR / POWER |
| 0xE059 / 0xE05A | el arma / la velocidad |
| 0xE180 | la palanca |
| 0xE183 / 0xE184 | la muerte / la escena acabada |
| 0xE190 / 0xE192 | la ventana / su fila en la pantalla |
| 0xE1B0 / 0xE1B2 / 0xE1B4 | F1 / STOP / la pausa |
| 0xE1BE | el juego de casillas de la pantalla |
| 0xE1C0 | el parpadeo de la pantalla |
| 0xE280-0xE2D5 | el sonido: los tres canales y los pedidos |
| 0xE300 | los sprites: 28 de 16 bytes |
| 0xE320 / 0xE340 | Leon / sus cuatro disparos |
| 0xE380 | los enemigos y las balas |
| 0xE500 | los diecis&eacute;is objetos de la pantalla |
| 0xE840 / 0xEA80 | la pantalla de ahora / la siguiente |
