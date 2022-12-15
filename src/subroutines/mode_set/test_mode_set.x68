; test for s_mode_set subroutine

                        include     "../../equs.x68"

t_assertion_counter:    set         23

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
                        dc.b        0

t_code
    .t_start:
;   d0 - place where subroutine returs code
;   d1 - counter
;   a0 - next asserted argument
;   a1 - next expected return code
;   a2 - place where subroutine saves result
;   a3 - next expected mode chagne
;   a4 - pointer to messages
;   a5 - pointer to error counter
;   d3 - error occured flag
;   d4 - numbers to print
;   d5 = 0 - no leading zeroes
                        clr.l       d0
                        moveq.l     #t_assertion_counter, d1
                        lea.l       dat_arg_asserted(pc), a0
                        lea.l       dat_ret_expected(pc), a1
                        lea.l       dat_mode_expected(pc), a3
                        lea.l       bss_current_mode(pc), a2
                        lea.l       bss_error_count(pc), a5
                        clr.l       d4
                        clr.l       d5
    .t_loop:
;   testing s_mode_set subroutine here. First, push next
;   tested item onto stack. Then call tested subroutine.
                        clr.l       d3
                        move.w      (a0), -(a7)
                        bsr         s_mode_set
                        adda.l      #2, a7
;   report assertion begins like this:
;   "\nNow asserting: 00ff"
                        lea.l       dat_msg_asserting(pc), a4
                        dc.w        os_write_ln
                        move.w      (a0)+, d4
                        dc.w        os_put_4hex
;   check if returned result is correct. If so, branch to
;   testing setted value. If no, mark error flag in d3
;   and continue with report error
                        cmp.b       (a1), d0
                        beq.s       .t_return_ok
                        sne.b       d3
;   if assertion of return code failed, report it like this:
;   "\nNow asserting: 00ff Fail!"
;   "\n\tReturn code expected: 00 but ff obtained."
                        addi.b      #1, (a5)
                        lea.l       dat_msg_fail(pc), a4
                        dc.w        os_write
                        lea.l       dat_msg_expected_ret(pc), a4
                        dc.w        os_write_ln
                        move.b      (a1)+, d4
                        dc.w        os_put_2hex
                        lea.l       dat_msg_but(pc), a4
                        dc.w        os_write
                        move.b      d0, d4
                        dc.w        os_put_2hex
                        lea.l       dat_msg_obtained(pc), a4
                        dc.w        os_write
    .t_return_ok:
;   its time to check what value was actually setted by routine
;   first we reuse d3 which stores error flag as a temporary place
;   to store current mode. We swap d3 to keep error flag safe
;   then we check if current mode equals to expected mode, and if
;   so, we print success, and branch to next tested value
;   otherwise
                        swap.w      d3
                        move.b      (a2), d3
                        cmp.b       (a3), d3
                        beq.s       .t_setmode_ok
                        swap.w      d3
                        tst.b       d3
                        bne.s       .t_skip_failed
                        lea.l       dat_msg_fail(pc), a4
                        dc.w        os_write
    .t_skip_failed:
                        addi.b      #1, (a5)
                        lea.l       dat_msg_expected_mode(pc), a4
                        dc.w        os_write_ln
                        move.b      (a3)+, d4
                        dc.w        os_put_2hex
                        lea.l       dat_msg_but(pc), a4
                        dc.w        os_write
                        move.b      (a2), d4
                        dc.w        os_put_2hex
                        lea.l       dat_msg_obtained(pc), a4
                        dc.w        os_write
                        bra.s       .t_skip_success
;   assure than both test passed flawlessly, by swapping d3, and testing
;   its LSB.
;   if LSB is clean both tests passed, and we tell user about it
;   "\nNow asserting: 00ff Success."
    .t_setmode_ok:
                        adda.l      #1, a3
                        swap.w      d3
                        tst.b       d3
                        bne.s       .t_skip_success
    .t_put_success:
                        lea.l       dat_msg_success(pc), a4
                        dc.w        os_write
    .t_skip_success:
                        dbra        d1, .t_loop
                        lea.l       dat_msg_errors(pc), a4
                        dc.w        os_write_ln
                        move.b      bss_error_count(pc), d4
                        andi.w      #$00ff, d4
                        dc.w        os_put_2hex
                        dc.w        os_exit

t_data
    dat_arg_asserted:
                        dc.w        $0000, $0123, $0002
                        dc.w        $abcd, $ffff, $0001
                        dc.w        $7777, $ff00, $2202
                        dc.w        $0101, $fef1, $3003
                        dc.w        $0505, $BBB3, $4500
                        dc.w        $8080, $7312, $0402
                        dc.w        $5210, $5200, $0202
                        dc.w        $1234, $5678, $9001
    dat_ret_expected:
                        dc.b        $00, $ff, $00
                        dc.b        $ff, $ff, $00
                        dc.b        $ff, $00, $00
                        dc.b        $00, $ff, $ff
                        dc.b        $ff, $ff, $00
                        dc.b        $ff, $ff, $00
                        dc.b        $ff, $00, $00
                        dc.b        $ff, $ff, 00
    dat_mode_expected:
                        dc.b        pvi_NORMAL, pvi_NORMAL, pvi_VISUAL
                        dc.b        pvi_VISUAL, pvi_VISUAL, pvi_INSERT
                        dc.b        pvi_INSERT, pvi_NORMAL, pvi_VISUAL
                        dc.b        pvi_INSERT, pvi_INSERT, pvi_INSERT
                        dc.b        pvi_INSERT, pvi_INSERT, pvi_NORMAL
                        dc.b        pvi_NORMAL, pvi_NORMAL, pvi_VISUAL
                        dc.b        pvi_VISUAL, pvi_NORMAL, pvi_VISUAL
                        dc.b        pvi_VISUAL, pvi_VISUAL, pvi_INSERT
    dat_msg_asserting:
                        dc.b        "Now asserting: ", sym_EOL
    dat_msg_success:
                        dc.b        " Success.", sym_EOL
    dat_msg_fail:
                        dc.b        " Fail!", sym_EOL
    dat_msg_expected_ret:
                        dc.b        "    Return code expected ", sym_EOL
    dat_msg_expected_mode:
                        dc.b        "    Mode change expected ", sym_EOL
    dat_msg_obtained:
                        dc.b        " obtained.", sym_EOL
    dat_msg_but:
                        dc.b        " but ", sym_EOL
    dat_msg_errors:
                        dc.b        "Errors: ", sym_EOL
    bss_current_mode:
                        ds.b        1
    bss_error_count:
                        ds.b        1
                        even

                        include     "./mode_set.x68"
                        dc.b        sym_trail
                        end
