;---------------------------------------------------------------;
;   This is the main equis table for main.x68 source            ;
;   equs for subroutines in subroutines folders                 ;
;---------------------------------------------------------------;

pt68k2_os_calls
    os_exit:            equ         $a01e
;   get echoed char
    os_get_echar:       equ         $a029
    os_get_char:        equ         $a02a
    os_put_char:        equ         $a033
    os_put_2hex:        equ         $a03a
    os_put_4hex:        equ         $a03b
    os_put_5dec:        equ         $a038
;   os_write, os_write_ln require pointer to
;   text at register 'a4', text must be terminated
;   with sym_EOL
    os_crlf:            equ         $a034
    os_write:           equ         $a036
    os_write_ln:        equ         $a035

pt68k2_symbols
;   still cant belive this
    sym_EOL:            equ         $04
    sym_trail:          equ         $16

pt68k2_keycodes
    key_ESCAPE:         equ         $1b
    key_i:              equ         $69
    key_a:              equ         $61
    key_0:              equ         $30
    key_$:              equ         $24
    key_h:              equ         $68
    key_j:              equ         $6a
    key_k:              equ         $6b
    key_l:              equ         $6c
    key_w:              equ         $77
    key_b:              equ         $62

painvi_equs
    pvi_NORMAL:         equ         $00
    pvi_INSERT:         equ         $01
    pvi_VISUAL:         equ         $02
