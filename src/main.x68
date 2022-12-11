pt68k2_os_calls
    os_exit:            equ         $a01e
    os_get_char:        equ         $a02a
pt68k2_keycodes
    key_7:              equ         $37
pt68k2_symbols
    sym_trail:          equ         $16

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
