positive:
addi $sp, $sp, -12 # adjust stack to make room for 3 items
sw $ra, 8($sp)
sw $a1, 4($sp)
sw $a0, 0($sp)
jal addit
bgt $v0, $zero, greater
lw $v0, $zero
j exit
greater: 
lw $v0, $zero
addi $v0, $v0, 1 
exit: 
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $re, 8($sp)
addi $sp, $sp, 12
jr $ra

addit: 
addi $sp, $sp, -4		# 1 item 
sw $s0, 0($sp)
add $s0, $a0, $a1		# parameter variable a, b correspond to the argument register
add $v0, $s0, $zero # copy into a return register
lw $s0, 0($sp)			# restore 
addi $sp, $sp, 4		# adjust stack to delete 1 item
jr $ra

