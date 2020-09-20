	.file	1 "p1.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	fp=xx
	.module	nooddspreg
	.abicalls
	.text
	.align	2
	.globl	hot
	.set	nomips16
	.set	nomicromips
	.ent	hot
	.type	hot, @function
hot:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-8
	sw	$fp,4($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	lw	$2,8($fp)
	slt	$2,$2,30
	bne	$2,$0,$L2
	nop

	li	$2,1			# 0x1
	.option	pic0
	b	$L3
	nop

	.option	pic2
$L2:
	move	$2,$0
$L3:
	move	$sp,$fp
	lw	$fp,4($sp)
	addiu	$sp,$sp,8
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	hot
	.size	hot, .-hot
	.align	2
	.globl	cold
	.set	nomips16
	.set	nomicromips
	.ent	cold
	.type	cold, @function
cold:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-8
	sw	$fp,4($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	lw	$2,8($fp)
	slt	$2,$2,6
	beq	$2,$0,$L5
	nop

	li	$2,1			# 0x1
	.option	pic0
	b	$L6
	nop

	.option	pic2
$L5:
	move	$2,$0
$L6:
	move	$sp,$fp
	lw	$fp,4($sp)
	addiu	$sp,$sp,8
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	cold
	.size	cold, .-cold
	.align	2
	.globl	comfort
	.set	nomips16
	.set	nomicromips
	.ent	comfort
	.type	comfort, @function
comfort:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-8
	sw	$fp,4($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	lw	$2,8($fp)
	slt	$2,$2,6
	bne	$2,$0,$L8
	nop

	lw	$2,8($fp)
	slt	$2,$2,30
	beq	$2,$0,$L8
	nop

	li	$2,1			# 0x1
	.option	pic0
	b	$L9
	nop

	.option	pic2
$L8:
	move	$2,$0
$L9:
	move	$sp,$fp
	lw	$fp,4($sp)
	addiu	$sp,$sp,8
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	comfort
	.size	comfort, .-comfort
	.align	2
	.globl	countArray
	.set	nomips16
	.set	nomicromips
	.ent	countArray
	.type	countArray, @function
countArray:
	.frame	$fp,40,$31		# vars= 8, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$fp,32($sp)
	move	$fp,$sp
	sw	$4,40($fp)
	sw	$5,44($fp)
	sw	$6,48($fp)
	sw	$0,28($fp)
	lw	$2,44($fp)
	addiu	$2,$2,-1
	sw	$2,24($fp)
	.option	pic0
	b	$L11
	nop

	.option	pic2
$L16:
	lw	$2,48($fp)
	li	$3,-1			# 0xffffffffffffffff
	beq	$2,$3,$L13
	nop

	li	$3,1			# 0x1
	bne	$2,$3,$L18
	nop

	lw	$2,24($fp)
	sll	$2,$2,2
	lw	$3,40($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	move	$4,$2
	.option	pic0
	jal	hot
	nop

	.option	pic2
	move	$3,$2
	lw	$2,28($fp)
	addu	$2,$2,$3
	sw	$2,28($fp)
	.option	pic0
	b	$L15
	nop

	.option	pic2
$L13:
	lw	$2,24($fp)
	sll	$2,$2,2
	lw	$3,40($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	move	$4,$2
	.option	pic0
	jal	cold
	nop

	.option	pic2
	move	$3,$2
	lw	$2,28($fp)
	addu	$2,$2,$3
	sw	$2,28($fp)
	.option	pic0
	b	$L15
	nop

	.option	pic2
$L18:
	lw	$2,24($fp)
	sll	$2,$2,2
	lw	$3,40($fp)
	addu	$2,$3,$2
	lw	$2,0($2)
	move	$4,$2
	.option	pic0
	jal	comfort
	nop

	.option	pic2
	move	$3,$2
	lw	$2,28($fp)
	addu	$2,$2,$3
	sw	$2,28($fp)
$L15:
	lw	$2,24($fp)
	addiu	$2,$2,-1
	sw	$2,24($fp)
$L11:
	lw	$2,24($fp)
	bgez	$2,$L16
	nop

	lw	$2,28($fp)
	move	$sp,$fp
	lw	$31,36($sp)
	lw	$fp,32($sp)
	addiu	$sp,$sp,40
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	countArray
	.size	countArray, .-countArray
	.rdata
	.align	2
$LC0:
	.word	36
	.word	9
	.word	-8
	.word	40
	.word	25
	.word	20
	.word	18
	.word	19
	.word	15
	.word	16
	.word	17
	.word	16
	.word	15
	.word	14
	.word	13
	.word	12
	.word	11
	.word	10
	.word	9
	.word	8
	.word	7
	.word	6
	.word	5
	.word	4
	.word	3
	.word	2
	.word	1
	.word	0
	.word	-3
	.word	-10
	.word	-19
	.word	-33
	.text
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,184,$31		# vars= 152, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-184
	sw	$31,180($sp)
	sw	$fp,176($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	lw	$2,%got(__stack_chk_guard)($28)
	lw	$2,0($2)
	sw	$2,172($fp)
	li	$2,32			# 0x20
	sw	$2,28($fp)
	lui	$2,%hi($LC0)
	addiu	$3,$fp,44
	addiu	$2,$2,%lo($LC0)
	li	$4,128			# 0x80
	move	$6,$4
	move	$5,$2
	move	$4,$3
	lw	$2,%call16(memcpy)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,memcpy
1:	jalr	$25
	nop

	lw	$28,16($fp)
	addiu	$2,$fp,44
	li	$6,1			# 0x1
	lw	$5,28($fp)
	move	$4,$2
	.option	pic0
	jal	countArray
	nop

	.option	pic2
	lw	$28,16($fp)
	sw	$2,32($fp)
	addiu	$2,$fp,44
	li	$6,-1			# 0xffffffffffffffff
	lw	$5,28($fp)
	move	$4,$2
	.option	pic0
	jal	countArray
	nop

	.option	pic2
	lw	$28,16($fp)
	sw	$2,36($fp)
	addiu	$2,$fp,44
	move	$6,$0
	lw	$5,28($fp)
	move	$4,$2
	.option	pic0
	jal	countArray
	nop

	.option	pic2
	lw	$28,16($fp)
	sw	$2,40($fp)
	move	$2,$0
	lw	$3,%got(__stack_chk_guard)($28)
	lw	$4,172($fp)
	lw	$3,0($3)
	beq	$4,$3,$L21
	nop

	lw	$2,%call16(__stack_chk_fail)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,__stack_chk_fail
1:	jalr	$25
	nop

$L21:
	move	$sp,$fp
	lw	$31,180($sp)
	lw	$fp,176($sp)
	addiu	$sp,$sp,184
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
