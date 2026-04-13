.section .rodata
fmt_first:
	.asciz "%d"
fmt_next:
	.asciz " %d"

.text
.globl main
main:
	addi sp, sp, -96
	sd ra, 88(sp)
	sd s0, 80(sp)
	sd s1, 72(sp)
	sd s2, 64(sp)
	sd s3, 56(sp)
	sd s4, 48(sp)
	sd s5, 40(sp)
	sd s6, 32(sp)
	sd s7, 24(sp)
	sd s8, 16(sp)

	mv s0, a0
	mv s1, a1
	addi s2, s0, -1
	blez s2, .Lprint_empty_output_newline

	slli a0, s2, 2
	call malloc
	mv s3, a0
	beqz s3, .Lexit_with_failure

	slli a0, s2, 2
	call malloc
	mv s4, a0
	beqz s4, .Lexit_with_failure

	slli a0, s2, 2
	call malloc
	mv s5, a0
	beqz s5, .Lexit_with_failure

	li s6, 0
.Lparse_arguments_loop:
	bge s6, s2, .Lparsing_complete
	addi t0, s6, 1
	slli t0, t0, 3
	add t1, s1, t0
	ld a0, 0(t1)
	call atoi
	slli t2, s6, 2
	add t3, s3, t2
	sw a0, 0(t3)
	addi s6, s6, 1
	j .Lparse_arguments_loop

.Lparsing_complete:
	li s6, -1
	addi s7, s2, -1

.Lsolve_from_right_loop:
	bltz s7, .Lsolve_phase_complete
	slli t0, s7, 2
	add t1, s3, t0
	lw t2, 0(t1)

.Lpop_non_greater_candidates_loop:
	bltz s6, .Lstack_ready_for_answer
	slli t3, s6, 2
	add t4, s5, t3
	lw t5, 0(t4)
	slli t6, t5, 2
	add a2, s3, t6
	lw a3, 0(a2)
	ble a3, t2, .Lpop_top_candidate
	j .Lstack_ready_for_answer

.Lpop_top_candidate:
	addi s6, s6, -1
	j .Lpop_non_greater_candidates_loop

.Lstack_ready_for_answer:
	slli t0, s7, 2
	add t1, s4, t0
	bltz s6, .Lstore_no_answer
	slli t2, s6, 2
	add t3, s5, t2
	lw t4, 0(t3)
	sw t4, 0(t1)
	j .Lpush_current_index

.Lstore_no_answer:
	li t4, -1
	sw t4, 0(t1)

.Lpush_current_index:
	addi s6, s6, 1
	slli t5, s6, 2
	add t6, s5, t5
	sw s7, 0(t6)

	addi s7, s7, -1
	j .Lsolve_from_right_loop

.Lsolve_phase_complete:
	li s8, 0
.Lprint_answers_loop:
	bge s8, s2, .Lprint_trailing_newline_and_exit
	slli t0, s8, 2
	add t1, s4, t0
	lw a1, 0(t1)
	bnez s8, .Lprint_after_first_value
	la a0, fmt_first
	call printf
	j .Lprint_step_complete

.Lprint_after_first_value:
	la a0, fmt_next
	call printf

.Lprint_step_complete:
	addi s8, s8, 1
	j .Lprint_answers_loop

.Lprint_empty_output_newline:
.Lprint_trailing_newline_and_exit:
	li a0, 10
	call putchar
	li a0, 0
	j .Lrestore_and_return

.Lexit_with_failure:
	li a0, 1

.Lrestore_and_return:
	ld s8, 16(sp)
	ld s7, 24(sp)
	ld s6, 32(sp)
	ld s5, 40(sp)
	ld s4, 48(sp)
	ld s3, 56(sp)
	ld s2, 64(sp)
	ld s1, 72(sp)
	ld s0, 80(sp)
	ld ra, 88(sp)
	addi sp, sp, 96
	ret
