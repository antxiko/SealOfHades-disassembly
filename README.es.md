# The Seal of Hades - desensamblado comentado

*(Also [in English](README.md).)*

El desensamblado comentado de **The Seal of Hades** (闇の竜王 ハデスの紋章, Yami no Ryuuou Hadesu no Monshou; Casio, 1986) para MSX: un cartucho de 32 KB con la cabecera en 0x4000.

- **100 %** del binario explicado: 9.874 bytes de código y 22.894 de datos con nombre, ni un byte sin asignar.
- **41,5 %** del listado comentado, 612 rutinas y etiquetas, ninguna por debajo del 10 % de comentarios.
- El listado se reensambla en la ROM original **byte a byte**.
- El título sale de ejecutar la ROM, cotejado con openMSX punto a punto; la presentación de CASIO, la demostración, la partida, el guardián, las seis escenas y el final, jugados en GIF en openMSX; las doce músicas que suenan, de su propio motor de sonido, idénticas a openMSX cuadro a cuadro.
- Al encender busca The Stone of Wisdom en otro slot: si está, la partida empieza más fuerte.

La web: <https://antxiko.github.io/SealOfHades-disassembly/es/>
(en inglés: <https://antxiko.github.io/SealOfHades-disassembly/>).

## Reproducirlo

La imagen de la ROM no se distribuye. Pon la tuya en la raíz como `hades.rom` (sha1 `fcc6b6b9...`) y ejecuta `make`. El detalle, en [POR DENTRO](docs/es/POR-DENTRO.md).

## Legal

El juego es de Casio y de sus titulares. La licencia de `LICENSE` cubre solo las herramientas, los comentarios, el análisis y la documentación de aquí. Mira [AVISO-LEGAL.md](AVISO-LEGAL.md).
