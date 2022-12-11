## Installation

### Option a:
1. Just load disk image `painvi.imd` from `/output` directory to **MAME** (u may also write it with you trusty 5.25fd if you older than a dinosaur 🤡)
2. Load SK\*DOS
3. Type `X.painvi` (where X is your drive number with painvi image)
4. Have ~~pain~~ fun
### Option b:
1. Start **MAME** with `-debug` option
2. Load `pt68k2` machine
3. Open memory edit window
4. Copy contents of `painvi.txt` from `/output` directory right into `0xE9000`
5. Load SK\*DOS
6. Type `SAVE X.painvi.com e9000 eyyyy e9000` (where X is drive number where you want to save binary, and yyyy is size of binary. You can find size of binary in `/src/main.x68`, `rlc_size`)
7. Type `X.painvi` (where X is a drive number where you saved binary)
8. Have ~~pain~~ fun
