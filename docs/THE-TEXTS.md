# The texts

Latin letters and digits are the cartridge's own (0x7D00), in the order of the MSX font from "0" on (tile = letter -
0x30: 0x11 is A, 0x10 the space). The ending text uses the BIOS font: `final_letras` (0x8F90) copies its letters
0x80-0xFF to the tiles with the same number, hiragana and katakana; the dakuten (゛) goes in a tile of its own, after
the letter. Here they are transcribed already joined.

## The title and the scoreboard

| address | text | |
|---|---|---|
| 0x8D8E | 闇の竜王 / ハデスの紋章 (8 + 8 and 16 + 16 + 16 tiles) | the name: "the dragon king of darkness / the seal of Hades" |
| 0x8DEB | CASIO (tiles 0x8A-0x8F) | |
| 0x8E18 | COPYRIGHT 1986 &copy; CASIO | |
| 0x8DE1 | GAME START | |
| 0x8E04 | PUSH TRIG:1 OR SPACE | |
| 0x8E2E | HISCORE | SCORE (0x8E30) is its end |
| 0x8DD4 | POWER, AIR | |
| 0x8E46 | LEON, SCENE | |
| 0x8E36 | GAME OVER | |

## The ending

| address | text | translation |
|---|---|---|
| 0x8E50 | わたしは ほしのめがみ エーメ | I am Eme, the goddess of the stars |
| | やみのりゅうおうは さりました | the dragon king of darkness has gone |
| | あなたの ゆうきを たたえて / ひかりのしょうごうを さずけます / イルシオン | in honour of your courage, I give you the title of light: イルシオン |
| | いつのひにか あなたは もういちど / そのゆうきを ためされるでしょう・・・ | some day your courage will be tested again... |

## Unused

Texts no instruction names: **ENERGY** (0x8DCE), " OVER" (0x8DDC), "T;POWER" (0x8E3F), the colon of HISCORE:, a
leftover of credits, **"ER    T;MORIYAMA"** (0x8FBD), and **THE STONE OF WISDOM** (0x8DF1), the name of Casio's
previous game, with the same codes. INIT does not read this text: it looks for the real one, in the other cartridge
(see [Curiosities](CURIOSITIES.html)).
