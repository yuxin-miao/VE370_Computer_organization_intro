    .data 0x10001000
tempArrary: 
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
	.word	30
	.word	-19
	.word	33
	.text
	.align	2
	.globl	main 
main:      
    lui     $a0, 0x1000
    ori     $a0, $a0, 0x1000    # BA of tempArray in $a0
    addi    $a1, $zero, 32      # numElements in a1
    add     $s0, $zero, $zero   # $s0 = hotDay = 4
    add     $s1, $zero, $zero   # $s1 = coldDay = 9
    add     $s2, $zero, $zero   # $s2 = comfortDay = 19

    ## First call: hotDay = countArray (tempArray, size, 1); 
    addi    $a2, $zero, 1       # $a2 = cntType = 1
    addi    $sp, $sp, -24       # adjust stack for 6 items
    sw      $a1, 20($sp)        # save function arguments
    sw      $a0, 16($sp)        
    sw      $ra, 12($sp)        # save return address
    sw      $s2, 8($sp)         # save saved register 
    sw      $s1, 4($sp)
    sw      $s0, 0($sp)
    add     $t0, $t0, $0        # meaningless 
    jal     countArray
    lw      $s0, 0($sp)          # restore all the value
    lw      $s1, 4($sp)
    lw      $s2, 8($sp) 
    lw      $ra, 12($sp)         # $ra / $a0 / $a1 needed when calling countArray again
    lw      $a0, 16($sp)
    lw      $a1, 20($sp)
    add     $s0, $s0, $v0

    ## Second call: coldDay = countArray (tempArray, size, -1); 
    addi    $a2, $zero, -1      # $a2 = cntType = -1
    sw      $a1, 20($sp)
    sw      $a0, 16($sp)
    sw      $ra, 12($sp)
    sw      $s2, 8($sp)
    sw      $s1, 4($sp)
    sw      $s0, 0($sp)
    add     $t0, $t0, $0        # meaningless 
    jal     countArray
    lw      $s0, 0($sp)          
    lw      $s1, 4($sp)
    lw      $s2, 8($sp) 
    lw      $ra, 12($sp)
    lw      $a0, 16($sp)
    lw      $a1, 20($sp)
    add     $s1, $s1, $v0


    ## comfortDay = countArray (tempArray, size, 0);
    add     $a2, $zero, $zero   # $a2 = cntType = 0
    sw      $a1, 20($sp)
    sw      $a0, 16($sp)
    sw      $ra, 12($sp)
    sw      $s2, 8($sp)
    sw      $s1, 4($sp)
    sw      $s0, 0($sp)
    ## only $s1 has chanegd, store this only
    add     $t0, $t0, $0        # meaningless 
     add     $t0, $t0, $0        # meaningless 
    jal     countArray
    lw      $s0, 0($sp)          # no function call afterwards, restore all
    lw      $s1, 4($sp)
    lw      $s2, 8($sp)
    lw      $ra, 12($sp)
    lw      $a0, 16($sp)
    lw      $a1, 20($sp)
    add     $s2, $s2, $v0
    addi    $sp, $sp, 24
    addi    $v0, $zero, 10      # for exit
    syscall

### Function countArray ###
countArray:
    addi    $sp, $sp, -24       # adjust the stack for 6 items
    sw      $a0, 20($sp)        # save function arguments 
    sw      $a1, 16($sp)
    sw      $a3, 12($sp)
    sw      $ra, 8($sp)         # save return address 
    addi    $s0, $a1, -1        # $s0 for i = numElements - 1
    addi    $s1, $zero, 0       # $s1 for cnt = 0
cntLoop:
    sw      $s0, 4($sp)         # store $s0 as i, not address 
    sw      $s1, 0($sp)
    sll     $s0, $s0, 2         # $s0 = $s0 * 4
    add     $s0, $a0, $s0       # $s0 is the address of A[i]
    lw      $a0, 0($s0)         # $a0 = A[i]
    addi    $t0, $zero, 1       # $t0 = 1
    bne		$a2, $t0, sCase2    # if $a2 != 1, then not hot
    jal		hot			        # jump to hot and save position to $ra
    j		switchBreak			# jump to switchBreak
sCase2:
    addi    $t0, $zero, -1      # $t0 = -1
    bne     $a2, $t0, sDefault  # if $a2 != -1, then not cold
    jal		cold				# jump to cold and save position to $ra
    j       switchBreak
sDefault:
    add     $t0, $t0, $0        # meaningless 
    jal		comfort				# jump to comfort and save position to $ra
switchBreak:
    lw      $s1, 0($sp)
    lw      $s0, 4($sp)
    lw      $a3, 12($sp)
    lw      $a1, 16($sp)
    lw      $a0, 20($sp)
    add     $s1, $s1, $v0       # cnt += $v0
    addi    $s0, $s0, -1        # i--
    slti    $t0, $s0, 0         # if $s0 < 0, $t0 = 0
    beq		$t0, $zero, cntLoop	# if $t0 != 0 then continue the loop 
    lw      $ra, 8($sp)         # else, exit the loop, restore $ra
    add     $v0, $s1, $zero     # $v0 = cnt
    addi    $sp, $sp, 24        # destroy spaces on stack
    jr      $ra


### Function hot ###
hot: 
    slti    $v0, $a0, 30
    beq     $v0, $zero, hotTrue
    add     $v0, $zero, $zero   # A[i] < 30, $v0 = 0
    jr      $ra
hotTrue:
    addi    $v0, $zero, 1       # A[i] >= 30, $v0 = 1
    jr      $ra

### Function cold ###
cold:
    slti    $t0, $a0, 5         # A[i] < 5, $t0 = 1
    beq     $t0, $zero, coldFalse
coldTrue: 
    addi    $v0, $zero, 1       # $v0 = 1
    jr      $ra
coldFalse:
    addi    $t1, $zero, 5
    beq		$a0, $t1, coldTrue	# if $a0 == $t1 == 5 then coldTrue
    add		$v0, $zero, $zero	# $v0 = $zero + $zero = 0
    jr      $ra

### Function comfort ###
comfort:
    slti    $t0, $a0, 30
    addi    $t1, $zero, 1       
    beq		$t0, $t1, comfortTrue	# if $t0 == 1, $a0 < 30, then comfortTrue
comfortFalse:
    add     $v0, $zero, $zero
    jr      $ra
comfortTrue:
    slti    $t0, $a0, 5
    beq		$t0, $t1, comfortFalse	# if $t0 == 1, $a0 < 5 then comfortFalse
    addi    $t2, $zero, 5
    beq		$a0, $t2, comfortFalse	# if $a0 == 5 comfortFalse
    addi    $v0, $zero, 1
    jr      $ra
    


