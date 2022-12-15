;   set current editor mode
;   @param: stack.w - pvi_NORMAL/pvi_INSERT/pvi_VISUAL
;   @returns: d0.b - s_ok/s_err

s_mode_set
    .s_ok:              set          0
    .s_err:             set          -1
    .s_passed_mode:     set          12

    .s_start:
;   save d0 and a0 before usege, then check passed arg against
;   three constants: pvi_NORMAL, pvi_INSERT, pvi_VISUAL
;   if arg equals to any of this constants - we got legit mode
                        movem.l     d0/a0, -(a7)
                        move.w      .s_passed_mode(a7), d0
                        andi.w      #$00ff, d0
                        beq.s       .s_write
                        cmpi.b      #pvi_INSERT, d0
                        beq.s       .s_write
                        cmpi.b      #pvi_VISUAL, d0
                        beq.s       .s_write
;   if arg is not equal to any of this constants save error code
;   to as computation result and exit
                        move.b      #.s_err, d0
                        bra.s       .s_exit
    .s_write:
                        lea.l       bss_current_mode(pc), a0
                        move.b      d0, (a0)
;   if arg was ok dont forget to return ok return code
                        move.b      #.s_ok, d0
    .s_exit:
                        movem.l     (a7)+, d0/a0
                        rts
