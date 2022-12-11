;---------------------------------------------------------------;
;   This is the relocation info for whole project.              ;
;---------------------------------------------------------------;

;   the relocation in SK*DOS is absolutley fucked up, U'VE BEEN WARNED!
;   option #1 (for large files, with large offset):
;       $03 $rrrrrrrr $ssss -- your code --
;   requires GET -> SAVE procedure, !NOT BOOTABLE!
;
;   option #2 (for small files, with small offset):
;       $02 $rrrr $ss -- your code -- $tt
;   requires strange trailing constant 0x16 at the end of the file

;   option #3 (for small files, no reloc info):
;       -- your code -- $tt $aaaa
;   no reloc info, just code, trailing constant, and start address
;
;   below option #2 is used

                        org         $0
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
