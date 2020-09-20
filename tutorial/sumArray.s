.data
array:  .word 5, 10, 20, 25
length: .word 4
sum:    .word 0
.word 5, 10, 20, 25, 30, 40, 60 .word 7
.word 0
# Algorithm being implemented to sum an array
# sum =
# for i #
# end for
main:
for:
.text .globl main
li    $8, 0
la    $11, array
lw $10, length addi $10, $10, -1 li $9,0
# (use $8 for sum)
# (use $9 for i)
# (use $10 for length-1)
# (use $11 for base addr. of array)
# immediate 0 in reg. $8 (sum) base addr. of array into $11
# load
# $10 = length - 1 #initializeiin$9to0
# drop out of loop when i > (length-1)
# mult. i by 4 to get offset within array
# add base addr. of array to $12 to get addr. of array[i] # load value of array[i] from memory into $12
# update sum
# increment i
# system code for exit
0
:= 0 to length-1 do sum := sum + array[i]
for_compare:
bgt $9, $10, end_for
mul $12, $9, 4 add $12, $11, $12 lw $12, 0($12) add $8, $8, $12 addi $9, $9, 1
j for_compare
end_for:
sw $8, sum
      li    $v0, 10
      syscall