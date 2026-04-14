.text

.globl make_node
make_node:
	addi sp, sp, -16
	sd ra, 8(sp)
	sd s0, 0(sp)

	# keep the requested value safe while malloc uses a0
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
	beqz s1, .Linsert_empty_tree

	# s0 walks the tree one node at a time until a free child slot appears
	mv s0, s1
.Linsert_walk:
	lw t0, 0(s0)
	beq s2, t0, .Linsert_done
	blt s2, t0, .Linsert_left
	j .Linsert_right

.Linsert_left:
	ld t1, 8(s0)
	beqz t1, .Linsert_attach_left
	mv s0, t1
	j .Linsert_walk

.Linsert_attach_left:
	mv a0, s2
	call make_node
	sd a0, 8(s0)
	j .Linsert_done

.Linsert_right:
	ld t1, 16(s0)
	beqz t1, .Linsert_attach_right
	mv s0, t1
	j .Linsert_walk

.Linsert_attach_right:
	mv a0, s2
	call make_node
	sd a0, 16(s0)
	j .Linsert_done

.Linsert_empty_tree:
	mv a0, s2
	call make_node
	mv s1, a0

.Linsert_done:
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

.Lget_walk:
	beqz t0, .Lget_not_found
	lw t2, 0(t0)
	beq t1, t2, .Lget_found
	blt t1, t2, .Lget_left
	ld t0, 16(t0)
	j .Lget_walk

.Lget_left:
	ld t0, 8(t0)
	j .Lget_walk

.Lget_found:
	mv a0, t0
	ret

.Lget_not_found:
	li a0, 0
	ret

.globl getAtMost
getAtMost:
	mv t0, a1
	li t1, -1

	# t1 remembers the best floor candidate seen so far
.Lgetatmost_walk:
	beqz t0, .Lgetatmost_done
	lw t2, 0(t0)
	ble t2, a0, .Lgetatmost_take
	ld t0, 8(t0)
	j .Lgetatmost_walk

.Lgetatmost_take:
	mv t1, t2
	ld t0, 16(t0)
	j .Lgetatmost_walk

.Lgetatmost_done:
	mv a0, t1
	ret
