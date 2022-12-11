pt68k2_os_calls
    os_exit:            equ         $a01e
;   get echoed char
    os_get_echar:       equ         $a029
    os_get_char:        equ         $a02a
    os_put_char:        equ         $a033

pt68k2_symbols
;   still cant belive this
    sym_EOL:            equ         $04
    sym_trail:          equ         $16

pt68k2_keycodes
    key_ESCAPE:         equ         $1b
    key_i:              equ
    key_a:              equ
    key_0:              equ
    key_$:              equ
    key_h:              equ
    key_j:              equ
    key_k:              equ
    key_l:              equ
    key_w:              equ
    key_b:              equ

painvi_equs
    pvi_NORMAL:         equ         $00
    pvi_INSERT:         equ         $01
    pvi_VISUAL:         equ         $02

;   the relocation in SK*DOS is absolutley fucked up, U'VE BEEN WARNED!
;   option #1 (for large files, with large offset):
;       $03 $rrrrrr $ssss -- your code --
;   requires GET -> SAVE procedure, !NOT BOOTABLE!
;
;   option #2 (for small files, with small offset):
;       $02 $rrrr $ss -- your code -- $tt
;   requires strange trailing constant 0x16 at the end of the file

;   option #3 (for small files, no reloc info):
;       -- your code -- $tt $aaaa
;   no reloc info, just code, trailing constant, and start address
rlc_header_struct
;   relocation identificator byte
    rlc_id:
                        dc.b        $02
;   code offset in bytes
    rlc_offset:
                        dc.w        $0000
;   program size in bytes
    rlc_size:
                        dc.b        $15

painvi_code
;   a little proof of conept. Load in SK*DOS, and
;   wait for user to pres "7" on keyboard
                        dc.w        os_get_char
                        andi.l      #$000000ff, d5
                        cmpi.b      #key_7, d5
                        bne.s       painvi_code
                        dc.w        os_exit
                        dc.b        sym_trail
                        end
