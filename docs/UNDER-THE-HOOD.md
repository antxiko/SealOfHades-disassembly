# Under the hood

## Rebuilding the ROM

`make verify` assembles `src/hades.asm` with pasmo and out comes the 32 KB ROM **byte for byte**. `make sanity`
checks what reassembly does not cover: that no byte declared as data is read as code, that no entry point falls in
data and that all 32,768 bytes are explained. `make test` runs the tests. The ROM is not in the repository: put it in
the root as `hades.rom` (the GoodMSX dump, `[!]`, sha1 `fcc6b6b9...`).

| | bytes |
|---|---|
| traced code | 9,874 |
| named data | 22,894 |
| unexplained | 0 |

The listing has 1,854 comments in 4,464 instructions (41.5%), 612 routines and labels, none under 10% commented, and
no called routine without a name.

## The cartridge

32 KB at 0x4000-0xBFFF, with the header at 0x4000. INIT (0x4010) looks for *The Stone of Wisdom* in another slot,
also puts the cartridge in page 2 and jumps to 0x8010. The data comes first: the tables of the scenes (0x4068) and of
their screens (0x4074), the screen descriptions (0x40F8-0x49B5), the borders and drawings (0x49B6-0x4EAB), the title
and game tiles with their colours (0x5000-0x5F7F) and four more tile sets (0x6000-0x7FFF), with the letters inside
(0x7D00). The code goes from 0x8000 to 0xACB5, with the texts in between (0x8D74-0x8EBA) and the sprite drawings
(0x9000-0x97FF); after it, the sound (0xAD00-0xBFFF).

## The BIOS it uses

RDSLT, RSLREG and ENASLT for the slots; SETGRP, CHGCLR, WRTVDP, DISSCR and ENASCR; FILVRM, LDIRVM and WRTVRM; GTSTCK
and GTTRIG for the controls and SNSMAT for the space bar, GRAPH, STOP, F1, TAB and CAPS; WRTPSG for the sound. From the
BIOS it reads the font for the ending text (0x1FBF: its letters 0x80-0xFF).

## The interrupt and the loop

INIT puts a jump to 0x8B09 in the H.TIMI hook. The interrupt does the requested silence, runs the sound, counts
frames (eight counters, 0xE010-0xE017) and reads F1, STOP, the buttons, the space bar, GRAPH and the joystick; in the
demo, a byte of its list every 16 frames (`interrupcion`, 0x8B09). The game runs in the **loop** (`bucle`, 0x823A):
once per frame, the blinking sprites (`sprites_rota`) and, if there is no pause, the background sound, the screen
flash, what was picked up, Leon, the sprites, the shot, the points, the enemies, the objects, the air and the enemies
that come out on their own.

**Moving on.** The current screen and the next one are in RAM (0xE840 and 0xEA80, 24 x 24 tiles); a window (0xE190)
goes down them one row every 16 frames and is copied to VRAM from the bottom up (`ventana_pon`, 0x9E40). After 24
rows the next screen is built (`pantalla_monta`, 0x9B89) and the objects of the old one are shifted 0x240 bytes. Leon
and the enemies look at two tiles on the side they are going to: below 0xC0 they pass (`pasa_fila`, 0x9AC2).

**The sprites.** With more than four sprites on a line the VDP does not draw the fifth; every frame the game copies
those of 0xE340-0xE47F starting with a different one (0xE185), so they blink instead of vanishing (`sprites_rota`,
0x8EBB).

## How it was done

The trace follows the code from INIT, the interrupt and the three jump tables (the objects, 0x9E9D; the enemies,
0x9EF3; the bullet steps, 0xA49B), declared in `src/hades.entries`. The rest was **measured in openMSX**
(`tools/omsx_cobertura.tcl`) on a Philips VG 8020, waiting for the demo and playing: nothing that ran was left out of
the trace. The comments of the sound engine come from *The Stone of Wisdom*, where it is the same code 0x9FC bytes
later, and other shared routines from other Casio games (`comun/casio/porta.py`, only on identical stretches),
checked one by one.

The recordings for the site (`tools/guiones/*.tcl`, recorded with `tools/lanza_graba.ps1` on C-BIOS) log, on every
frame, the VDP registers, the RAM from 0xE000, the PSG and the VRAM that changed. `tools/pantallas.py` runs the title
with `tools/bios.py` and checks it against the recording (**0 different points**), `tools/gifs.py` makes the GIFs and
`tools/musica.py` runs the sound engine.

## The RAM

| | |
|---|---|
| 0xE000 / 0xE060 | playing / The Stone of Wisdom in another slot |
| 0xE001 | LEON (BCD) |
| 0xE003 | the scene (0-5) |
| 0xE004 | the rounds (nobody reads them) |
| 0xE006-0xE00B | the score digits |
| 0xE00C-0xE00E | the score (BCD) |
| 0xE010-0xE017 | the frame counters |
| 0xE020-0xE02D | the buttons: just pressed and held |
| 0xE027 / 0xE037 | the demo / its list of controls |
| 0xE02E-0xE033 / 0xE034-0xE036 | the high score: digits / BCD |
| 0xE039 / 0xE03A | CAPS / TAB in the intro |
| 0xE053 | the screen (0-10) |
| 0xE054 / 0xE055 | the hearts: BCD / binary |
| 0xE057 / 0xE058 | AIR / POWER |
| 0xE059 / 0xE05A | the weapon / the speed |
| 0xE180 | the joystick |
| 0xE183 / 0xE184 | death / the scene over |
| 0xE190 / 0xE192 | the window / its row in the screen |
| 0xE1B0 / 0xE1B2 / 0xE1B4 | F1 / STOP / the pause |
| 0xE1BE | the screen's tile set |
| 0xE1C0 | the screen flash |
| 0xE280-0xE2D5 | the sound: the three channels and the requests |
| 0xE300 | the sprites: 28 of 16 bytes |
| 0xE320 / 0xE340 | Leon / his four shots |
| 0xE380 | the enemies and the bullets |
| 0xE500 | the sixteen objects of the screen |
| 0xE840 / 0xEA80 | the current screen / the next one |
