# The music

The tunes, in three voices. They are not hand-made recordings: `tools/musica.py` **runs the ROM's own sound engine**
with `tools/z80run.py` -the sound routine (`sonido`, 0xAD82), frame by frame, with the number the game writes- and
logs what it writes to the PSG through the BIOS (WRTPSG).

**Checked against openMSX**: the tone and volume registers of the three channels match the recorded ones, **0
different** in every frame looked at, in the twelve that play. Four recordings are checked (`tools/guiones/`): the
demo, the pilot's game, the TAB and CAPS one and the forced one with scenes 4-6 and the ending. Each recorded frame
is paired with the engine frame that has the same RAM in its channels (the backgrounds, only B and C: A carries the
shots).

## The engine

It is *The Stone of Wisdom*'s, byte for byte, 0x9FC bytes earlier (0xAD5E-0xB13B): it takes three **requests** -a
tune (0xE2BE), a channel A effect (0xE2C0) and a B and C one (0xE2C2)- and the lower number wins. The tables: nine
tunes at 0xAD00 (number 0, nothing), six channel A effects at 0xAD36, seven B and C ones at 0xAD42 and fourteen
durations at 0xB033.

During the game the background is an **effect** on channels B and C, which the loop asks for on every pass
(`sonido_fondo`, 0x8349): one per scene. The guardian asks for another one, number 2, every time it changes drawing
(0xAAE6); the loop would also ask for it with 0xE18D, but nobody sets that byte.

| | Who asks for it | Length |
|---|---|---:|
| the title | 0x80DA (the button cuts it) | 55.5 s |
| the CASIO intro | 0x8C85 | 1.1 s |
| the game starts | 0x820D | 6.4 s |
| each scene starts | 0x8212 | 3.2 s |
| scenes 1, 3 and 5 | the loop (effect 6) | 57.6 s, starts again |
| scene 2 | the loop (effect 5) | 51.2 s, starts again |
| scene 4 | the loop (effect 4) | 28.8 s, starts again |
| scene 6 | the loop (effect 3) | 29.9 s, starts again |
| the guardian | the guardian, every 64 frames (effect 2) | 1.1 s |
| the scene over | 0x8560 | 6.5 s |
| the ending | 0x8477, over and over | 8.6 s |
| GAME OVER | 0x842C | 4.4 s |

**Number 5** is asked for by nobody (there is no `ld a,5` before `musica_pide`): it comes from running the engine with
that number and cannot be checked.

## The title

<audio controls src="audio/musica_titulo.mp3"></audio>

## The CASIO intro

<audio controls src="audio/musica_casio.mp3"></audio>

## The game starts

<audio controls src="audio/musica_partida.mp3"></audio>

## Each scene starts

<audio controls src="audio/musica_escena.mp3"></audio>

## Scenes 1, 3 and 5

<audio controls src="audio/musica_escenas_135.mp3"></audio>

## Scene 2

<audio controls src="audio/musica_escena_2.mp3"></audio>

## Scene 4

<audio controls src="audio/musica_escena_4.mp3"></audio>

## Scene 6

<audio controls src="audio/musica_escena_6.mp3"></audio>

## The guardian

<audio controls src="audio/musica_guardian.mp3"></audio>

## The scene over

<audio controls src="audio/musica_escena_acabada.mp3"></audio>

## The ending

<audio controls src="audio/musica_final.mp3"></audio>

## GAME OVER

<audio controls src="audio/musica_game_over.mp3"></audio>

## Number 5, which nobody asks for

<audio controls src="audio/musica_5_sin_uso.mp3"></audio>
