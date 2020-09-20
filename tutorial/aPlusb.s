        .data
aNum:   .word 3
bNum:   .word 4

        .text
        .globl main
main:
        lw $a0, aNum
        lw $a1, bNum
        add $v0, $a0, $a1
        syscall 