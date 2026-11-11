# Curiosities

## The Stone of Wisdom in another slot

On power-up, INIT (0x4010) reads with RDSLT byte 0x92E1 of every slot -the four primary ones and the sixteen expanded
ones- looking for a 0x23. In *The Stone of Wisdom*, Casio's previous game, 0x92E1 is the "S" of THE STONE OF WISDOM
(its text starts at 0x92DD and 0x23 is S in the encoding of both); in *The Seal of Hades* that byte is a 0. If it
finds it, it notes it at 0xE000, which the start-up does not clear (it starts clearing at 0xE001), and it goes to
0xE060: the game starts with **POWER at 32** instead of 16 and with **speed** (Leon walks two at a time and the screen
moves on faster; `partida_nueva`, 0x810F). The tests check it with both ROMs.

## TAB and CAPS

Held when the CASIO intro ends, by the title:

- **TAB** (0xE03A): Leon **does not die**. The death routine (`muerte`, 0x8374) returns doing nothing, whether from an
  enemy, a bullet, the air or a hole. Only F1 brings him down.
- **CAPS** (0xE039): **endless** LEON: when the last one falls, there are three again (`game_over_mira`, 0x840B).

The GIFs of the guardian and of scenes 2 and 3 are recorded with both.

## The demo plays the header

The demo's controls are read from a list, one byte every 16 frames (the joystick in the low half, the buttons in the
high one), that starts at **0x4000**: the cartridge header ("AB", INIT...) and INIT's code. There is no list made for
it. In the recorded one it reads up to 0x407F.

## The rounds nobody counts

When scene 6 is over, the ending adds a round at 0xE004 and sets the scene to 0, but nobody reads 0xE004 again: the
button on the ending goes back to the title. And the guardian's background sound has a byte of its own (0xE18D) that
nobody sets to 1.

## Leftovers

- **Texts**: THE STONE OF WISDOM, ENERGY, " OVER", "T;POWER" and a leftover of credits, "ER    T;MORIYAMA" (see [The
  texts](THE-TEXTS.html)).
- **Tune 5**, which nobody asks for (see [The music](THE-MUSIC.html)).
- **Dead code**: five loose pieces behind a jump or a `ret` (0x880F, 0x885E, 0x8890, 0x8948 and 0x8F41) and a `ret` at
  0x9800; no jump reaches them and the coverage measured in openMSX does not go through them.
- **Data**: the end of an 8 x 8 font at 0x4EAC (340 bytes), 128 bytes at 0x5780 and another 128 at 0x5F80, and the
  EPROM's FB 00 filler at the end.
- **The letters inside the colours**: the game's letters (0x7D00, 0x180 bytes) are inside the colour table of a tile
  set (0x7C00-0x7FFF): the same bytes serve both.
