;   set current editor mode
;   @param: stack.w - pvi_NORMAL/pvi_INSERT/pvi_VISUAL
;   @returns: d0.b - s_mode_change_ok/s_mode_change_err

s_mode_change_ok:      equ          0
s_mode_change_err:     equ          -1
s_mode_change_arg:     equ          8

    s_mode_change:
;   save a0 before usege, then check passed arg against
;   three constants: pvi_NORMAL, pvi_INSERT, pvi_VISUAL
;   if arg equals to any of this constants - we got legit mode
                        move.l      a0, -(a7)
                        tst.b       s_mode_change_arg(a7)
                        beq.s       .s_write
                        cmpi.b      #pvi_INSERT, s_mode_change_arg(a7)
                        beq.s       .s_write
                        cmpi.b      #pvi_VISUAL, s_mode_change_arg(a7)
                        beq.s       .s_write
;   if arg is not equal to any of this constants save error code
;   to as computation result and exit
                        move.b      #s_mode_change_err, d0
                        bra.s       .s_exit
    .s_write:
                        lea.l       bss_current_mode(pc), a0
                        move.b      s_mode_change_arg(a7), (a0)
;   if arg was ok dont forget to return ok return code
                        clr.b       d0
    .s_exit:
                        move.l      (a7)+, a0
                        rts
