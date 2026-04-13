.text

.globl make_node
make_node:
	addi sp, sp, -16
	sd ra, 8(sp)
	sd s0, 0(sp)

	mv s0, a0
	li a0, 24
	call malloc
	beqz a0, .Lmake_node_done

	sw s0, 0(a0)
	sd zero, 8(a0)
	sd zero, 16(a0)

.Lmake_node_done:
	ld s0, 0(sp)
	ld ra, 8(sp)
	addi sp, sp, 16
	ret

.globl insert
insert:
	addi sp, sp, -40
	sd ra, 32(sp)
	sd s0, 24(sp)
	sd s1, 16(sp)
	sd s2, 8(sp)

	mv s1, a0
	mv s2, a1
	beqz s1, .Linsert_when_tree_empty

	mv s0, s1
.Linsert_search_position_loop:
	lw t0, 0(s0)
	blt s2, t0, .Linsert_move_left
	bgt s2, t0, .Linsert_move_right
	j .Linsert_finish

.Linsert_move_left:
	ld t1, 8(s0)
	beqz t1, .Linsert_attach_new_left_child
	mv s0, t1
	j .Linsert_search_position_loop

.Linsert_attach_new_left_child:
	mv a0, s2
	call make_node
	sd a0, 8(s0)
	j .Linsert_finish

.Linsert_move_right:
	ld t1, 16(s0)
	beqz t1, .Linsert_attach_new_right_child
	mv s0, t1
	j .Linsert_search_position_loop

.Linsert_attach_new_right_child:
	mv a0, s2
	call make_node
	sd a0, 16(s0)
	j .Linsert_finish

.Linsert_when_tree_empty:
	mv a0, s2
	call make_node
	mv s1, a0

.Linsert_finish:
	mv a0, s1
	ld s2, 8(sp)
	ld s1, 16(sp)
	ld s0, 24(sp)
	ld ra, 32(sp)
	addi sp, sp, 40
	ret

.globl get
get:
	mv t0, a0
	mv t1, a1

.Lget_search_loop:
	beqz t0, .Lget_value_not_found
	lw t2, 0(t0)
	beq t2, t1, .Lget_value_found
	blt t1, t2, .Lget_move_left
	ld t0, 16(t0)
	j .Lget_search_loop

.Lget_move_left:
	ld t0, 8(t0)
	j .Lget_search_loop

.Lget_value_found:
	mv a0, t0
	ret

.Lget_value_not_found:
	li a0, 0
	ret

.globl getAtMost
getAtMost:
	mv t0, a1
	li t1, -1

.Lget_at_most_loop:
	beqz t0, .Lget_at_most_done
	lw t2, 0(t0)
	ble t2, a0, .Lget_at_most_take_candidate
	ld t0, 8(t0)
	j .Lget_at_most_loop

.Lget_at_most_take_candidate:
	mv t1, t2
	ld t0, 16(t0)
	j .Lget_at_most_loop

.Lget_at_most_done:
	mv a0, t1
	ret
