# The Seal of Hades - commented disassembly

*(También [en castellano](README.es.md).)*

The commented disassembly of **The Seal of Hades** (闇の竜王 ハデスの紋章, Yami no Ryuuou Hadesu no Monshou; Casio, 1986) for the MSX: a 32 KB cartridge with its header at 0x4000.

- **100%** of the binary explained: 9,874 bytes of code and 22,894 of named data, not one byte unassigned.
- **41.5%** of the listing commented, 612 routines and labels, none below 10% of comments.
- The listing reassembles into the original ROM **byte for byte**.
- The title comes from running the ROM, checked against openMSX point by point; the CASIO intro, the demo, the game, the guardian, the six scenes and the ending, played in GIF in openMSX; the twelve tunes that play, from its own sound engine, identical to openMSX frame by frame.
- On power-up it looks for The Stone of Wisdom in another slot: if it is there, the game starts stronger.

The site: <https://antxiko.github.io/SealOfHades-disassembly/>
(in Spanish: <https://antxiko.github.io/SealOfHades-disassembly/es/>).

## Reproducing it

The ROM image is not distributed. Put yours in the root as `hades.rom` (sha1 `fcc6b6b9...`) and run `make`. The details, in [UNDER THE HOOD](docs/UNDER-THE-HOOD.md).

## Legal

The game belongs to Casio and its rights holders. The licence in `LICENSE` covers only the tools, the comments, the analysis and the documentation here. See [LEGAL-NOTICE.md](LEGAL-NOTICE.md).
