; test for s_mode_change subroutine

                        include     "../../equs.x68"

t_assertion_counter:    equ         11

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

t_code
    t_assert_mode:
                        clr.l       d0
                        moveq.l     #t_assertion_counter, d1
                        lea.l       dat_asserted(pc), a0
                        lea.l       dat_expected(pc), a1
                        lea.l       bss_current_mode(pc), a2
;   testing s_mode_change subroutine here. First, push next
;   tested item onto stack. Then call tested subroutine.
                        move.w      (a0), -(a7)
                        bsr         s_mode_change
;   check if returned result is correct, and if setted
;   mode is same as passed
                        cmpi.b      (a1)+, d0
                        beq.s       t_return_ok
;   TODO: report code
    .t_return_ok:
                        cmpi.b      (a0)+, (a2)
                        beq.s       t_setmode_ok
;   TODO: report code
;   if everything fine continue testing
    .t_setmode_ok:
                        dbra        d1, t_assert_mode

t_data
    dat_asserted:
                        dc.w        $0000, $0123, $0002,
                                    $abcd, $ffff, $0001,
                                    $7777, $ff00, $2202,
                                    $0101, $fef1, $3003
    dat_expected:
                        dc.b        $00, $ff, $00,
                                    $ff, $ff, $00,
                                    $ff, $00, $00,
                                    $00, $ff, $ff
    bss_current_mode:
                        ds.b        1
                        even

                        include     "./mode_change.x68"
                        end
