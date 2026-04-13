.section .rodata
fname:
	.asciz "input.txt"
fmode:
	.asciz "r"
yes_str:
	.asciz "Yes"
no_str:
	.asciz "No"

.text
.globl main
main:
	addi sp, sp, -64
	sd ra, 56(sp)
	sd s0, 48(sp)
	sd s1, 40(sp)
	sd s2, 32(sp)
	sd s3, 24(sp)
	sd s4, 16(sp)

	la a0, fname
	la a1, fmode
	call fopen
	mv s0, a0
	beqz s0, .Lprint_no_result

	mv a0, s0
	li a1, 0
	li a2, 2
	call fseek

	mv a0, s0
	call ftell
	mv s3, a0
	bltz s3, .Lclose_file_and_print_no

	li s1, 0
	addi s2, s3, -1

.Lpalindrome_check_loop:
	bge s1, s2, .Lclose_file_and_print_yes

	mv a0, s0
	mv a1, s1
	li a2, 0
	call fseek
	mv a0, s0
	call fgetc
	mv s4, a0

	mv a0, s0
	mv a1, s2
	li a2, 0
	call fseek
	mv a0, s0
	call fgetc

	bne s4, a0, .Lclose_file_and_print_no
	addi s1, s1, 1
	addi s2, s2, -1
	j .Lpalindrome_check_loop

.Lclose_file_and_print_yes:
	mv a0, s0
	call fclose
	la a0, yes_str
	call puts
	li a0, 0
	j .Lrestore_and_return

.Lclose_file_and_print_no:
	mv a0, s0
	call fclose

.Lprint_no_result:
	la a0, no_str
	call puts
	li a0, 0

.Lrestore_and_return:
	ld s4, 16(sp)
	ld s3, 24(sp)
	ld s2, 32(sp)
	ld s1, 40(sp)
	ld s0, 48(sp)
	ld ra, 56(sp)
	addi sp, sp, 64
	ret
