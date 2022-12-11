;---------------------------------------------------------------;
;   This is the global variables and constants file             ;
;   for main.x68                                                ;
;---------------------------------------------------------------;

painvi_bss
    bss_char_buff:
                        ds.b        512
    bss_current_mode:
                        ds.b        1
    bss_current_line:
                        ds.w        1
    bss_current_curpos:
                        ds.w        1
painvi_data
    dat_mode_name_normal:
                        dc.b        "--NORMAL--", $04
    dat_mode_name_insert:
                        dc.b        "--INSERT--", $04
    dat_mode_name_visual:
                        dc.b        "--VISUAL--", $04
;   trailing symbol
                        dc.b        sym_trail
