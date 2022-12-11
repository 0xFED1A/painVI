                        include     "./equs.x68"
                        include     "./relocation.x68"

                ;  oh boy this code is ridiculous
                    ;   and i'm da fucking clown
                        ;  enjoy

;---------------------------------------------------------------;
;   rlc_xxxx            SK*DOS relocation data                  ;
;   os_xxxx             SK*DOS system calls equations           ;
;   sym_xxxx            symbol equations                        ;
;   key_xxxx            keyboard scancode equations             ;
;   pvi_xxxx            painvi equations                        ;
;   c_xxxx              code labels                             ;
;   .c_xxxx             local code labels                       ;
;   s_xxxx              subroutine labels                       ;
;   .s_xxxx             local subroutine labels                 ;
;   bss_xxxx            global var locations                    ;
;   dat_xxxx            global const locations                  ;
;                                                               ;
;   no scratch except d0, all regs saved                        ;
;   arg pass via stack only, return in d0 only (C style)        ;
;                                                               ;
;   stack chores by caller                                      ;
;                                                               ;
;   for best results build this abomination with VASM           ;
;   using this options: -spaces -Fbin                           ;
;---------------------------------------------------------------;

painvi_code
;   save registers before usage, clear them
;   and prepare CCR
                        movem.l     d0-d7/a0-a6, -(a7)
                        clr.l       d0
                        movea.l     #0, a0
                        clr.l       d1
                        movea.l     #0, a1
                        clr.l       d2
                        movea.l     #0, a2
                        clr.l       d3
                        movea.l     #0, a3
                        clr.l       d4
                        movea.l     #0, a4
                        clr.l       d5
                        movea.l     #0, a5
                        clr.l       d6
                        movea.l     #0, a6
                        clr.l       d7
                        move.w      #0, ccr
;   init global editor variables, and set editor to
;   normal mode
    c_init:
                        move.w      #pvi_NORMAL, -(a7)
                        bsr         s_mode_change
                        adda.w      #4, a7
;   first, get current mode by calling s_mode_get(), if result
;   is !pvi_NORMAL (0x00) then branch to c_insertmode, else
;   keep moving down to c_normalmode
    c_busyloop:
                        bsr         s_mode_get
                        tst.b       d0
                        bne.s       c_insertmode
;   looks like we are in normal mode. Get character from keyboard
;   without echo, then send received char to s_check_is_to_input()
;   as arg. If result is zero, we are still in normal mode, otherwise
;   change current mode to normal via s_mode_change() call and
;   proceed to c_insertmode
    c_normalmode:
                        dc.w        os_get_char
                        move.w      d5, -(a7)
                        bsr         s_check_is_to_input
                        adda.l      #4, a7
                        tst.b       d0
                        beq.s       c_normalmode
                        move.w      #pvi_INSERT, -(a7)
                        bsr         s_mode_change
                        adda.l      #4, a7
;   seems we are in insert mode. Get char from keyboard with echo this
;   time, then try (at least) to save it as is, by sending it to
;   s_save_char_to_buff() and passing char as arg. Then, check
    c_insertmode:
                        dc.w        os_get_echar
                        move.w      d5, -(a7)
                        bsr         s_save_char_to_buff
                        bsr         s_check_is_to_normal
                        adda.l      #4, a7
                        tst.b       d0
                        beq.s       c_insertmode
                        move.w      #pvi_NORMAL, -(a7)
                        bsr         s_mode_change
                        adda.l      #4, a7
                        bra.s       c_normalmode

;   pop unaltered registers, and run for your life
                        movem.l     (a7)+, d0-d7/a0-a6
                        dc.w        os_exit

                        include     "./data.x68"
                        incdir      "./subroutines/"
                        include     "./check_init_args/check_init_args.x68"
                        include     "./check_is_to_input/check_is_to_input.x68"
                        include     "./check_is_to_normal/check_is_to_normal.x68"
                        include     "./file_read/file_read.x68"
                        include     "./file_write/file_write.x68"
                        include     "./mode_change/mode_change.x68"
                        include     "./mode_get/mode_get.x68"
                        include     "./save_char_to_buff/save_char_to_buff.x68"
                        end
