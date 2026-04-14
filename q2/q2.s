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
	blez s2, .Lprint_only_newline

	# three int arrays of size n: values, answers, and stack-of-indices
	slli a0, s2, 2
	call malloc
	mv s3, a0
	beqz s3, .Lfail

	slli a0, s2, 2
	call malloc
	mv s4, a0
	beqz s4, .Lfail

	slli a0, s2, 2
	call malloc
	mv s5, a0
	beqz s5, .Lfail

	li s6, 0
.Lparse_args:
	bge s6, s2, .Lparse_done
	addi t0, s6, 1
	slli t0, t0, 3
	add t1, s1, t0
	ld a0, 0(t1)
	call atoi
	slli t2, s6, 2
	add t3, s3, t2
	sw a0, 0(t3)
	addi s6, s6, 1
	j .Lparse_args

	# stack top index (s6) starts at -1 meaning empty stack
.Lparse_done:
	li s6, -1
	addi s7, s2, -1

	# process from right to left to reuse future candidates
.Lsolve_right_to_left:
	bltz s7, .Lsolve_done
	slli t0, s7, 2
	add t1, s3, t0
	lw t2, 0(t1)

	# pop every index whose value is <= current value
.Lpop_until_strictly_greater:
	bltz s6, .Lanswer_ready
	slli t3, s6, 2
	add t4, s5, t3
	lw t5, 0(t4)
	slli t6, t5, 2
	add a2, s3, t6
	lw a3, 0(a2)
	ble a3, t2, .Lpop_one
	j .Lanswer_ready

.Lpop_one:
	addi s6, s6, -1
	j .Lpop_until_strictly_greater

.Lanswer_ready:
	slli t0, s7, 2
	add t1, s4, t0
	bltz s6, .Lstore_minus_one
	slli t2, s6, 2
	add t3, s5, t2
	lw t4, 0(t3)
	sw t4, 0(t1)
	j .Lpush_current

.Lstore_minus_one:
	li t4, -1
	sw t4, 0(t1)

.Lpush_current:
	addi s6, s6, 1
	slli t5, s6, 2
	add t6, s5, t5
	sw s7, 0(t6)

	addi s7, s7, -1
	j .Lsolve_right_to_left

.Lsolve_done:
	li s8, 0
.Lprint_answers:
	bge s8, s2, .Lprint_newline_and_exit
	slli t0, s8, 2
	add t1, s4, t0
	lw a1, 0(t1)
	bnez s8, .Lprint_with_space
	la a0, fmt_first
	call printf
	j .Lprint_next

.Lprint_with_space:
	la a0, fmt_next
	call printf

.Lprint_next:
	addi s8, s8, 1
	j .Lprint_answers

.Lprint_only_newline:
.Lprint_newline_and_exit:
	li a0, 10
	call putchar
	li a0, 0
	j .Ldone

.Lfail:
	li a0, 1

.Ldone:
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
