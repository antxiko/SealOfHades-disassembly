# Secrets and bugs

What was searched for in the code and what was found. A bug only goes here if it has been checked: by running the
game's own routine (`tools/bios.py`) or against the openMSX recordings.

## Secrets

Told in [Curiosities](CURIOSITIES.html):

- **Casio's previous game in another slot**: with its cartridge inserted, the game starts with POWER at 32 and the
  speed (INIT, 0x4010). The tests check it with both ROMs.
- **TAB** when the CASIO intro ends: Leon does not die (`muerte`, 0x8374). **CAPS**: endless LEON.
- **F1** knocks Leon down, even with TAB.

Apart from those keys, the controls are read in the interrupt: the stick from the cursor keys and joystick 1, the
joystick 1 buttons, the space bar and GRAPH.

## Bug: past 9,999,990 points, the high score to zero

When the score goes past 999,999 inside (9,999,990 on screen, with the fixed 0), `puntos_suma` (0x8A30) copies into the
high score the score **after it has wrapped** (0x8A5A-0x8A69). Running the game's addition here:

| score (on screen) | high score | + | after: score | high score |
|---|---|---|---|---|
| 123,450 | 100,000 | 100 | 123,550 | 123,550 |
| 9,999,900 | 9,999,900 | 100 | **0** | **0** |
| 9,999,500 | 9,999,500 | 900 | **400** | **400** |

## Bug: the cursor keys and the joystick at once

`palanca` (0x8B88) joins the cursor keys and joystick 1 with an `or` (0x8B98) of their direction numbers. With both at
once, running it here, right and down give **left** (7), and up-right and down-right give **down-left** (6).

## Checked and correct

- **The extra LEON at 30,000 points**: running the addition, going from 29,900 to 30,000 on screen calls `leon_suma`
  and sets 0xE02D so as not to give it twice; with 29,990 it does not. The listing's comment said it set 0xE03A (the
  TAB flag, which would make Leon immortal): it had been copied from another cartridge, and it is now fixed.

## What nobody counts, in [Curiosities](CURIOSITIES.html)

- **The laps** (0xE004) are added when scene 6 ends and nobody reads them.
- **The demo plays the header**: its controls are the bytes from 0x4000 on.
