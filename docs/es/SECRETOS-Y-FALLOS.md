# Secretos y fallos

Lo que se ha buscado en el c&oacute;digo y lo que se ha encontrado. Un fallo solo entra aqu&iacute; si est&aacute;
comprobado: ejecutando la propia rutina del juego (`tools/bios.py`) o contra las grabaciones de openMSX.

## Secretos

Contados en [Curiosidades](CURIOSIDADES.html):

- **El juego anterior de Casio en otro slot**: con su cartucho puesto, la partida empieza con POWER a 32 y la
  velocidad (INIT, 0x4010). Los tests lo comprueban con las dos ROM.
- **TAB** al acabar la presentaci&oacute;n de CASIO: Leon no muere (`muerte`, 0x8374). **CAPS**: LEON sin fin.
- **F1** derriba a Leon, aun con TAB.

Fuera de esas teclas, los mandos se leen en la interrupci&oacute;n: la palanca de los cursores y del mando 1, los
botones del mando 1, la barra y GRAPH.

## Fallo: pasados los 9.999.990 puntos, el r&eacute;cord a cero

Cuando los puntos pasan de 999.999 por dentro (9.999.990 en pantalla, con el 0 fijo), `puntos_suma` (0x8A30) copia al
r&eacute;cord los puntos **despu&eacute;s de dar la vuelta** (0x8A5A-0x8A69). Ejecutando aqu&iacute; la suma del
juego:

| puntos (en pantalla) | r&eacute;cord | + | despu&eacute;s: puntos | r&eacute;cord |
|---|---|---|---|---|
| 123.450 | 100.000 | 100 | 123.550 | 123.550 |
| 9.999.900 | 9.999.900 | 100 | **0** | **0** |
| 9.999.500 | 9.999.500 | 900 | **400** | **400** |

## Fallo: los cursores y el mando a la vez

`palanca` (0x8B88) junta los cursores y el mando 1 con un `or` (0x8B98) de sus n&uacute;meros de direcci&oacute;n.
Con los dos a la vez, ejecut&aacute;ndolo aqu&iacute;, derecha y abajo dan **izquierda** (7), y arriba-derecha y
abajo-derecha, **abajo-izquierda** (6).

## Comprobado y correcto

- **El LEON de m&aacute;s a los 30.000 puntos**: ejecutando la suma, de 29.900 a 30.000 en pantalla llama a
  `leon_suma` y apunta 0xE02D para no darlo dos veces; con 29.990 no. El comentario del listado dec&iacute;a que
  pon&iacute;a 0xE03A (la casilla de TAB, que har&iacute;a a Leon inmortal): estaba copiado de otro cartucho, y ya
  est&aacute; corregido.

## Lo que nadie cuenta, en [Curiosidades](CURIOSIDADES.html)

- **Las vueltas** (0xE004) se suman al acabar la escena 6 y nadie las lee.
- **La demostraci&oacute;n juega la cabecera**: sus mandos son los bytes de 0x4000 en adelante.
