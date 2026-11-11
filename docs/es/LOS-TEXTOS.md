# Los textos

Las letras latinas y las cifras son las del propio cartucho (0x7D00), en el orden de la fuente del MSX desde el "0"
(la casilla = la letra - 0x30: 0x11 es la A, 0x10 el espacio). El texto del final usa la fuente de la BIOS: `final_letras`
(0x8F90) copia sus letras 0x80-0xFF a las casillas del mismo n&uacute;mero, hiragana y katakana; el dakuten (゛) va
en su propia casilla, detr&aacute;s de la letra. Aqu&iacute; se transcriben ya juntos.

## El t&iacute;tulo y el marcador

| direcci&oacute;n | texto | |
|---|---|---|
| 0x8D8E | 闇の竜王 / ハデスの紋章 (8 + 8 y 16 + 16 + 16 casillas) | el nombre: "el rey drag&oacute;n de las tinieblas / el sello de Hades" |
| 0x8DEB | CASIO (casillas 0x8A-0x8F) | |
| 0x8E18 | COPYRIGHT 1986 &copy; CASIO | |
| 0x8DE1 | GAME START | |
| 0x8E04 | PUSH TRIG:1 OR SPACE | |
| 0x8E2E | HISCORE | SCORE (0x8E30) es su final |
| 0x8DD4 | POWER, AIR | |
| 0x8E46 | LEON, SCENE | |
| 0x8E36 | GAME OVER | |

## El final

| direcci&oacute;n | texto | traducci&oacute;n |
|---|---|---|
| 0x8E50 | わたしは ほしのめがみ エーメ | soy Eme, la diosa de las estrellas |
| | やみのりゅうおうは さりました | el rey drag&oacute;n de las tinieblas se ha ido |
| | あなたの ゆうきを たたえて / ひかりのしょうごうを さずけます / イルシオン | en honor a tu valor, te doy el t&iacute;tulo de luz: イルシオン |
| | いつのひにか あなたは もういちど / そのゆうきを ためされるでしょう・・・ | alg&uacute;n d&iacute;a tu valor volver&aacute; a ponerse a prueba... |

## Sin usar

Textos que ninguna instrucci&oacute;n nombra: **ENERGY** (0x8DCE), " OVER" (0x8DDC), "T;POWER" (0x8E3F), los dos
puntos de HISCORE:, un resto de cr&eacute;ditos, **"ER    T;MORIYAMA"** (0x8FBD), y **THE STONE OF WISDOM** (0x8DF1), el
nombre del juego anterior de Casio, con sus mismos c&oacute;digos. INIT no lee este texto: busca el de verdad, en el
otro cartucho (ver [Curiosidades](CURIOSIDADES.html)).
