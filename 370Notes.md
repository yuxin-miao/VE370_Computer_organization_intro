To run the .s file direclty through bash, use 

```bash
spim -bare
read ""
run
```

REMEMBER: 2’s complement

# Chapter 1

Performance 

- $$
  \begin{equation}
  \begin{aligned}
  \rm{\textbf{CPU Time}}&=\rm{CPU\ Clock\ Cycles\ per\ program \times Clock\ Cycle\ Time}\\[2ex]
   &=\frac{\rm{CPU\ Clock\ Cycles}}{\rm{Clock \ Rate}} \\[2ex]
   &= \frac{\rm{IC}\times \rm{CPI}}{\rm{Clock\ Rate}} \\[2ex]
   &= \frac{\rm{Instructions}}{\rm{Programs}} \times \frac{\rm{Clock\ Cycles}}{\rm{Instruction}} \times \frac{\rm{Seconds}}{\rm{Clock\ Cycles}}
  \end{aligned}
  \end{equation}
  $$

- **ISA**: Instruction Set Architecture 

- Instruction count: **IC** (由program, ISA, complier 决定)
- Clock Cycle per Instruction: **CPI**
- Clock Cycles = IC * CPI

> momorize the equation
>
> GHz = $10^9$

# Chapter 2

<p center> **Operation and Operands ** </p>

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200918202135979.png" alt="image-20200918202135979" style="zoom:50%;" />

```bash
# c language 
# need preprocessor 
gcc -E test.c > test.i

gcc -S test.s # obtain test.s
gcc -c test.c # obtain test.o, which is machine code to read $ hexdump text.o
/*or*/
hexdump -C test.c # to show ASCII 
gcc test.o -o test # obtain executable machine code test 
# so gcc could followed by test.c or test.o

```



- Instruction Set 
  - RISC: reduced instruction set computer
  - CISC: complex instruction set computer

MIPS Instruction Set

Design Principle 

1. Simplicity favors regularity. 
2. Smaller is faster 
3. Make the common case faster 

## Register Operands 

MIPS architecture has a 32*32-bit register file 

> \$zero: constant 0 (reg 0, also written as 0)
> \$at: Assembler Temporary (reg 1, or 1)
> \$v0, v1: result values (reg’s 2 and 3, or 2 and 3); use value for function result 
> \$a0 – a3: arguments (reg’s 4 – 7, or 4 - 7)
> \$t0 – t7: temporaries (reg’s 8 – 15, or 8 - 15); can be overwritten by callee
> \$s0 – s7: saved (reg’s 16 – 23, or 16 - 23); be saved/restored by callee
> \$t8, t9: temporaries (reg’s 24 and 25, or 24 and 25)
> \$k0, k1: reserved for OS kernel (reg’s 26 and 27, 26/27) 
>
> \$gp: global pointer for static data (reg 28, or 28)
> \$sp: stack pointer (reg 29, or 29)
> \$fp: frame pointer (reg 30, or 30)
> \$ra: return address (reg 31, or \$31)

```assembly
lw rt, offset(rs)# offset should be 4*(an integer) offset: a 16-bits 2's complement number


## Byte/Halfword Operations R[rt] = Mem[R[rs] + signExtensionOffest] 为32bits与16bits相加##
lb rt, offset(rs) # offset could be any integer (-2 is okey)
lh rt, offset(rs # repeat the sign bit

lbu rt, offset(rs) # for unsigned byte; 
lhu rt, offset(rs) # repeat zero

sb rt, offset(rs) 
sh rt, offset(rs)

```

## Memory Operands

- mainly for composite data (arrays, structures, dynamic data)

- steps 

  - `lw`: from memory into registers 
  - perfrom arithmetic operations with registers
  - `sw`: from register back to memory 

- Byte addressable - each address identifies a 8-bit byte

- organized in word  

-  Big/little Endian: MIPS is big Endian 

  <img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200918185859922.png" alt="image-20200918185859922" style="zoom:50%;" />

```c
g = h + A[8]
```

h in \$s2, base address of A in \$s3

### load word

from the content in register (\$s3), the content + offset (32), is the address of the content need to be loaded.

The content in the address ( Reg[$s3]) + offset (32)) is loaded in \$t0

`$t0 ` load in the content in this address. Content: A[8]

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200917162604239.png" alt="image-20200917162604239" style="zoom:50%;" />

### Store Word

```assembly
lw $t0, 32($s3)
add $t0, $s2, $t0
sw $t0, 48($s3) 
```

Store the content in \$t0, into the content of the address (content in \$s3 + 48)

![image-20200917162852822](/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200917162852822.png)

- difference between `lb` and `lbu`

  `lb`: load byte; R[rt] = SignExt(M[R[rs]+SignExtImm])

  `lbu`: load byte unsigned; R[rt] = {24b'0,M[R[rs]+SignExtImm] (7:0)}

## Immediate Operands (constant)

`sll` by i bits = multiply by $2^i$

`srl` by i bits = divides by $2^i$ (unsigned only)

### load 32-bits constant

- `lui rt, constant`
  - copies 16-bit constant to left 16 bits of rt
  - clear right 16-bits of rt to 0
- `ori $t0, $t0, 0x....` \$t1 = \$t2| ZeroExtImm

```assembly
# load 0x56781234 to register $s3
lui $s3, 0x5678
ori $s3, $s3, 0x1234
```

For the number stored in a byte if its value is larger than **(10000000) or(80)hex**. If we want to load its original value to a new register, we need to use `lbu`. If we use lb at this time, the value stored in the new register will be negative.

## If/For

no `blt`, `bge`, `ble`, `bgt`

`beq`, `bne` common; combined with `slt`, `slti`, `sltiu`

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200918204354042.png" alt="image-20200918204354042" style="zoom:33%;" />



<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200918204439309.png" alt="image-20200918204439309" style="zoom:33%;" />

## Byte/Halfword Operations 

```assembly
# i.e. load in byte 0xFA
/*Signed, with sign extension*/
	lb rt, offset(rs)		# offset could be any integer;in rt 0xFFFFFFFA
	lh rt, offset(rs)
/*Unsigned, with zero extension*/
	lbu rt, offset(rs)		# offset could be any integer; in rt 0x000000FA
	lhu rt, offset(rs)
```

<font color=#CD5C5C>有时候要注意offset是否要乘4，如果array是存储的bytes而不是words，则不需要乘4</font>

## Assembly Language

Example.c

```c
int add_a_and_b(int a, int b) {
   return a + b;
}

int main() {
   return add_a_and_b(2, 3);
}
```

转化为汇编语言

```
$ gcc -S example.c
```

**arm! but not mips **

example.s

```assembly
_add_a_and_b: # 并不是标准命令
   push   %ebx
   mov    %eax, [%esp+8] 
   mov    %ebx, [%esp+12]
   add    %eax, %ebx 
   pop    %ebx # pop会将ESP寄存器中地址加4
   ret  # 当前函数frame被回收

_main:
   push   3  # push: CPU指令，将运算子放入stack，即3写入main这个frame
   push   2 # push会将ESP寄存器中地址减4
   call   _add_a_and_b # call：调用函数
   add    %esp, 8
   ret
```

从`_main`开始执行，在stack上为main建立一个frame（帧）,stack所指向的地址写入ESP寄存器。数据若要写入main这个frame，则写在ESP寄存器所保存的地址。stack：从高位向地位发展。ESP中地址减去四个字节（int）后，新地址写入ESP

![bg2018012216](http://www.ruanyifeng.com/blogimg/asset/2018/bg2018012216.png)





# Chapter 3

**Function**

program stored in memory , instructions represented in binary, like data 

## **program counter**

(PC) (instruction address register)

- address of the instruction is sotred in PC 
- 32 bits register 
- a special register in CPU (not same as the registers in register file)

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200917145047483.png" alt="image-20200917145047483" style="zoom:30%;" />

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200917153557980.png" alt="image-20200917153557980" style="zoom:40%;" />

## function calling

> Similarly, in the execution of a procedure, the program must follow these six steps:
>
> 1. Put parameters in a place where the procedure can access them.
> 2. Transfer control to the procedure.
> 3. Acquire the storage resources needed for the procedure.
> 4. Perform the desired task.
> 5. Put the result value in a place where the calling program can access it.
> 6. Return control to the point of origin, since a procedure can be called from several points in a program.

### Function call instructions

- *Function call operation*:  jump-and-link instruction `jal FunctionLabel` (J-type)

  An instruction that jumps to an address and simultaneously saves the address of the following instruction in a register ($ra in MIPS).

  - \$ra = PC+4 (the address of following instruction)
  - PC = Addr(function label)

- *Function return operation*: jump register `jr $ra` (R-type)

  - PC = \$ra; Copies \$ra to program counter 

- return address

   A link to the calling site that allows a procedure to return to the proper address;

  in MIPS it is stored in register $ra.

- caller: The program that instigates a procedure and provides the necessary parameter values.

- Callee: A procedure that executes a series of stored instructions based on parameters provided by the caller and then returns control to the caller.

- **stack pointer** (\$sp)
  
- pointing to the **top of the stack** 
  
  - By mean top, not mean when adding more items, the address of \$sp would not become larger, but it should be subtracion.
  
- frame pointer (\$fp)

a frame pointer offers a stable base register within a procedure for local memory-references. as \$sp might change 

### leaf function

> Eg1: see swap

function that don’t call other functions 

```assembly
addi $sp, $sp, -12 # create spaces in stack
sw $t1, 8($sp) # store data on stack
sw $t0, 4($sp) # actually, no need to operate on $t0 and $t1
sw $s0, 0($sp)
....

lw $s0, 0($sp) # restore data from stack
lw $t0, 4($sp)
lw $t1, 8($sp)
addi $sp, $sp, 12 # destroy spaces on stack
jr $ra # return from function
```

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200917215149676.png" alt="image-20200917215149676" style="zoom:40%;" />

### Non-leaf funciton

> Eg2: see sort 

function that calls other functions 

For nested call, caller need to save on the stack 

1. its return address 

2. any arguments and temporaries needed after the call 

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200918091228677_副本.png" alt="image-20200918091228677" style="zoom:50%;" />

```c
int fact (int n) {
  if (n < 1) return f;
  else return n * fact(n - 1)
}
```

argument n in \$a0, result in \$v0

```assembly
fact: 
		addi $sp, $sp, -8
		sw $ra, 4($sp)
		sw $a0, 0($sp)
		slti $t0, $a0, 1
		beq $t0, $zero, L1 # the label tells where to go, such that L1 should have the address 
		addi $v0, $zero, 1
		addi $sp, $sp, 8
		jr $ra
L1: 
		addi $a0, $a0, -1
		jal fact
		lw $a0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		mul $v0, $a0, $v0 # how to implement it not using mul
		jr $ra

```



## Function Calling Convention

do not follow convention not mean syntax error, but highly likely to create error 

when to apply 

- immediatly before the function is called

  - pass arguments to \$a0 - \$a3 (more arguments on stack, addressable via \$fp)
  - save register that should be saved by caller ( i.e. \$a0 - \$a3  non-leaf function)
  - `jal`

- in function, but before it starts executing

  - allocate memory of frame’s size (moving \$sp downwards)
  - Save registers that should be saved by the function in the frame, before they are overwritten (\$s0-\$s7 (if to be used), \$fp (if used), ​\$ra (non- leaf function))
  - Establish \$fp (if desired), \$fp = \$sp + frame’s size - 4

- immediatly before the funtion finishes 

  - if necessary, place the function result to \$v0, \$v1
  - Restore registers saved by the function (pop from frame)
  - destroy stack frame (by moving \$sp upwards)
  - `jr $ra`

  <img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200920130607592.png" alt="image-20200920130607592" style="zoom:67%;" />

  

## Example

When translate from C to assembly language 

> 1. Allocate registers to program variables.
> 2. Produce code for the body of the procedure.
> 3. Preserve registers across the procedure invocation.

- `swap`

```c
void swap(int v[], int k) {
	int temp;
	temp = v[k]; 
  v[k] = v[k+1]; 
  v[k+1] = temp;
}
```

	1. program argument: `$a0, $a1 -> v, k` 		temporary variable: `$t0 -> temp`

2. ```assembly
   /*procedure body*/
   swap: sll $t1, $a1, 2 # $t1 = k * 4
         add $t1, $a0, $t1 # t1 = v + k * 4, the address of v[k]
         
         lw $t0, 0($t1) # $t1 (temp) = v[k]; load the content in address 0($t1) to the content oof $t0
         lw $t2, 4($t1) # $t2 = v[k+1];
         
         sw $t2, 0($t1) # v[k] = v[k+1]; store the content in $t2 to thr content in address 0($t1)
         sw $t0, 4($t1) # v[k+1] = temp;
   /*procedure return*/
         jr $ra
   ```

   

- `sort`

```c
void sort (int v[], int n) {
  int i, j;
  for (i = 0; i < n; i += 1) {
  	for (j = i – 1; j >= 0 && v[j] > v[j + 1]; j -= 1) { 
      swap(v,j);
  	} 
  }
}
```

Problem: `sort` needs the value in \$a0 and \$a1, `swap` need to have the parameters placed in those same registers. 

v in \$a0, n in \$a1, i in \$s0, j in \$s1 

```assembly
sort:
		addi $sp, $sp, -20
		sw $ra, 16($sp)
		sw $s3, 12($sp)
		sw $s2, 8($sp)
		sw $s1, 4($sp)
		sw $s0, 0($sp)
		add $s2, $a0, $zero	# $s2 = BA of v
		add $s3, $a1, $zero	# s3 = n
		add $s0, $zero, $zero	# i = 0
for1tst: 
		slt $t0, $s0, $s3
		beq $t0, $zer0, exit1 # when i >= n, exit the first loop
		addi $s1, $s0, -1 # j = i - 1
for2tst:
		slt $t0, $s1, 0
		bne $t0, $zero, exit2 # when j < 0 exit the second loop
		sll $t1, $s1, 2 # $t1 = j*4
		add $t2, $t1, $s2 # t2: the address of v[j]; v + j * 4
		lw $t3, 0($t2) # v[j]
		lw $t4, 4($t2) # v[j + 1]
		sll $t0, $t4, $t3
		beq $t0, $zero, exit2 # v[j] < v[j + 1]
		add $a0, $s2, $zero # prepare for the paramete needed for next function call swap
		add $a1, $s1, $zero
		jal swap
		addi $s1, $s1, -1
		j for2tst
exit2: 
		addi $s0, $s0, 1 #i+=1
		j for1tst
exit1: 
	 lw $s0, 0($sp)
	 lw $s1, 4($sp)
	 lw $s2, 8($sp)
	 lw $s3, 12($sp)
	 lw $ra, 16($sp)
	 addi $sp, $sp, 12
	 jr $ra 							# return to calling routine 
```

- `fib`

```c
int fib(int n) {
  if (n < 3)
    return 1;
  else 
    return fib(n-1) + fib(n-2); 
}
```

```assembly
fib:
	addi 	$sp, $sp, -12
	sw		$s0, 8($sp)
	sw 		$a0, 4($sp)
	sw		$ra, 0($sp)
	slti	$t0, $a0, 3
	beq		$t0, $zero, else
	# lw		$ra, 0($sp) unnecessary load here 
	# lw		$a0, 4($sp)
	addi	$sp, $sp, 12 
	addi	$v0, $zero, 1
	jr		$ra

else:
	lw		$ra, 0($sp)
	lw		$a0, 4($sp)
	addi 	$a0, $a0, -1
	jal	 	fib

	add	 	$s0, $v0, $zero	# we need $s0 to store the value so adjust the stack for 3 items 
	sw 		$a0, 4($sp)
	sw		$ra, 0($sp)
	addi 	$a0, $a0, -2
	jal 	fib
	addi 	$t1, $v0, 0
	lw		$ra, 0($sp)
	lw		$a0, 4($sp)
	addi	$sp, $sp, 8
	add		$v0, $t1, $t0
	jr 		$ra
```



```assembly
# VE370 2020FA RC Week 3
# Class exercise: fib
# Author: Li Shi

# Important note: 
#   This program is written in Linux, and executed by
#     1. spim -bare
#     2. (spim) read "fib.s"
#     3. (spim) run
#   You may need to modify this program to execute in PCSpim.

.text

main:
  addi  $a0,  $0,   8
  jal   fib                 # Call fib(8)
  add   $t0,  $t0,  $0      # Delay
  add   $t0,  $t0,  $0      # Delay
  addi  $a0,  $v0,  0       # Print fib(8)
  addi  $v0,  $0,   1       
  syscall
  addi  $v0,  $0,   10      # System call 10 (exit)
  syscall                   # Exit

fib:
  addi  $sp,  $sp,  -12     # Allocate the stack frame
  sw    $ra,  8($sp)
  sw    $a0,  4($sp)
  sw    $s0,  0($sp)        # We will use $s0 later
  slti  $t0,  $a0,  3       # Test for n < 3
  beq   $t0,  $0,   elseBlock
  addi  $v0,  $0,   1       # return 1 
  addi  $sp,  $sp,  12 
  jr    $ra
  add   $t0,  $t0,  $0      # Delay

elseBlock:
  addi  $a0,  $a0,  -1
  jal   fib                 # fib(n-1)
  add   $t0,  $t0,  $0      # Delay
  add   $t0,  $t0,  $0      # Delay
  addi  $s0,  $v0,  0       # Q: What is $s0 used for?
  addi  $a0,  $a0,  -1
  jal   fib                 # fib(n-2)
  add   $t0,  $t0,  $0      # Delay
  add   $t0,  $t0,  $0      # Delay
  add   $v0,  $v0,  $s0     # return fib(n-1)+fib(n-2)
  lw    $s0,  0($sp)
  add   $t0,  $t0,  $0      # Delay
  add   $t0,  $t0,  $0      # Delay
  lw    $a0,  4($sp)
  add   $t0,  $t0,  $0      # Delay
  add   $t0,  $t0,  $0      # Delay
  lw    $ra,  8($sp)    
  add   $t0,  $t0,  $0      # Delay
  add   $t0,  $t0,  $0      # Delay
  addi  $sp,  $sp,  12      # Pop the stack
  add   $t0,  $t0,  $0      # Delay
  add   $t0,  $t0,  $0      # Delay
  jr    $ra
  add   $t0,  $t0,  $0      # Delay

```



## Template

- if ($s0 < $s1) { ... } else { ... }

```assembly
      slt $t0, $s0, $s1
      beq $t0, $zero, else 
      ....
      j elseExit ## remember to jump out when finish if 
else: ....
elseExit: 
```

- for ($t0 = 0; $t0 < $a1; $t0++) { ... }

```assembly
Loop:
		add $t0, $zero, $zero
		slt $t1, $t0, $a1
		beq $t1, $zero, exit
		...
		addi $t0, $t0, 1
		j Loop
exit:
```



## Translation and Startup

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200919103108277.png" alt="image-20200919103108277" style="zoom:33%;" />

### Complier 

tansform the C program into an assembly language program (a symbolic form of waht the machine understands)

### assembler 

> To produce the binary version of each instruction in the assembly language program, the assembler must determine the addresses corresponding to all labels. Assemblers keep track of labels used in branches and data transfer instructions in a **symbol table**. As you might expect, the table contains pairs of symbols and addresses.

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200919104550827.png" alt="image-20200919104550827" style="zoom:33%;" />

**producing an object module**

Example 

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200919105156829.png" alt="image-20200919105156829" style="zoom:33%;" />

​			- In the object file: 

> the instructions in assembly language just to make the example understandable; in reality, the instructions would be numbers.

​		*Note that the address and symbols that must be updated in the link process is higlighted*: 

				1. the instructions that refer to the address of procedures $A$ and $B$
	
				2. the instructions that refers to the data word $X$ and $Y$

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200919105719045.png" alt="image-20200919105719045" style="zoom:50%;" />

### linker 

Also called link editor. A systems program that combines independently assembled machine language programs and resolves all undefined labels into an **executable file**. 

1. merge segments

 	2. resolve labels (determine their address)
 	3. patch location-dependent and external reference 

**example of linked objects**

Object is already machine language, but no memory has been traslated (the translator do not know about)

> the text segment starts at address 40 0000hex and the data segment at 1000 0000hex.

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200919111236159.png" alt="image-20200919111236159" style="zoom:50%;" />

> 1. The jals are easy because they use pseudodirect addressing. The jal at address 40 0004hex gets 40 0100hex (the address of procedure B) in its address field, and the jal at 40 0104hex gets 40 0000hex (the address of procedure A) in its address field.
> 2. The load and store addresses are harder because they are relative to a base register. This example uses the global pointer as the base register. Figure 2.13 shows that $gp is initialized to 1000 8000hex. To get the address 1000 0000hex (the address of word X), we place 8000hex in the address field of lw at address 40 0000hex (Because it is 2’s complement). Similarly, we place ­7980hex in the address field of sw at address 40 0100hex to get the address 1000 0020hex (the address of word Y).
> 3. also output an object file 

### Loader

> 1. Reads the executable file header to determine size of the text and data segments.
> 2. Creates an address space large enough for the text and data.
> 3. Copies the instructions and data from the executable file into memory.
> 4. Copies the parameters (if any) to the main program onto the stack.
> 5. Initializes the machine registers and sets the stack pointer to the first free location. (\$sp, \$gp, \$fp)
> 6. Jumps to a start-up routine.
>    - copies the parameters into the argument registers  (\$a0...) and calls the main routine
>    -  When the main routine returns, the start-up routine terminates the program with an exit system call

之前讲了static link， 即before the program is run *1. the library routines become part of the executable file 2. it loads all routines in the library that are called anywhere executable*

so -> **dynamically linked libraries (DLLs)**: Library routines that are linked to a program during execution.

###  Dynamic Linking

dll: dynamic linking library

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200919113501211.png" alt="image-20200919113501211" style="zoom:50%;" />



# Topic 4

Instructoin coding, how the **assembler and linker** transform into machine code. 

MIPS instruction -> 32 bits words, translated into binary information (machine code)

first 6 bits -> opcode always, for all three types. Based on this, CPU now what to do.

## R-format

 totally 32 bits, can see from the **reference card** ![image-20200928083358704](/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200928083358704.png)

### Instruction fields

Here is the meaning of each name of the fields in MIPS instructions:

- *op:* Basic operation of the instruction, traditionally called the **opcode**.
- *rs:* The first register source operand.
- *rt:* The second register source operand.
- *rd:* The register destination operand. It gets the result of the operation.
- *shamt:* Shift amount. (Section 2.6 explains shift instructions and this term; it will not be used until then, and hence the field contains zero in this section.) only use when shift, represents the number we want to shift (0-31)
- *funct:* Function. This field, often called the *function code,* selects the specific variant of the operation in the op field.

> add \$t0, \$s1, \$s2
>
> add: 0 (opcode)
>
> rs: \$s1 (5 -bits store the memory) 10001
>
> rt: \$s2 10010
>
> rd: \$t0 (becasue this is the register destination)01000

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200928084133611.png" alt="image-20200928084133611" style="zoom:33%;" />

`add` and `sub` have the same opcode, use the different `func` field to distinguish between these two. 



## I-format

i- immediate number 

![image-20200928084210292](/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200928084210292.png)

**rt: destination now** however it could also be source (determine by read / write operation)

rs: source or base address register 

constant / address: $-2^{15}$ to $2^{15}-1$ / offset added to base address in rs

Read: source register  			 Write: destination 

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200928084346097.png" alt="image-20200928084346097" style="zoom:33%;" />

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200928084559327.png" alt="image-20200928084559327" style="zoom:33%;" />

- 

```assembly
sw	$t0, 4($s0) 	# $s0->rs / $t0 -> rt
```

read from the register both \$s0->rs \$t0->rt. // no destination register needed 

relative address = (LOOP-PC-4)/4.  // because relative address should have a 32-bits address, so by calculation, we could use relative address (16 bits)

- 

```assembly
lui		$t0, 255 	# because $t0 is the destination register
```

| opcode | rs    | rt    | Immediate           |
| ------ | ----- | ----- | ------------------- |
| 001111 | 00000 | 01000 | 0000 0000 1111 1111 |

- 

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200928084836733.png" alt="image-20200928084836733" style="zoom:33%;" />







<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20201005110337077.png" alt="image-20201005110337077" style="zoom:50%;" />

## J-format

![image-20200928085339660](/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200928085339660.png)

encode full address in instruction, use 26 bits represent a 32 bits address 

leave the first 4 bits of PC untouched. 

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200928085659606.png" alt="image-20200928085659606" style="zoom:33%;" />

## Addressing in Branches and Jumps

- J-type: 6 bits for operation field and the rest of the bits for the address field. 

`j 10000` can be assembled into 

|   2    |  10000  |
| :----: | :-----: |
| 6 bits | 26 bits |

the value of the jump opcode is 2 and the jump address is 10000

- PC-relative addressing 

a branch instruction would calculate: Program counter = Register + Branch address

for conditional branches: loops and $if$ statements 

## Decoding Machine Code

1. converting hex to binary to find **op fields**, determine the operation
2. 

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200928140704517.png" alt="image-20200928140704517" style="zoom:50%;" />

-  How to get address

  - immediate addressing 
    - I-type `addi $s0, $s1, -1`
  - register addressing 
    - R-type / I-type : all or some operands provided by register IDs directly `add $t0, $s0, $s1`
  - base addressing 
    - I-type: operands provided by using base address of memory location `lw $t0, 32($s0)`
  - PC-relative addressing
    - Operands relative to PC, used for near branch *target address = PC + 4 + offest \* 4* , `beq $s0, $s1, LESS`
  - Pseudodirect addressing
    - encode full address in instruction J-type (`j` and `jal`) *target address = PC[31:28] : address \* 4*


  *instructions from memory & data from/into RF/memory*

  <img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200930114747486.png" alt="image-20200930114747486" style="zoom:33%;" />

  

# T05

Review of Digital Logic 

who to control reading  / writing? do not read / write at the same time -> control signal in RF 



- memory (access memory is slower than access RF, because of the big circuit of memory, need to decode the address)

  - SRAM (Static RAM)

  ![image-20200930130847535](file:///Users/yuxinmiao/Library/Application%20Support/typora-user-images/image-20200930130847535.png?lastModify=1601950411)

  - DRAM

  ![image-20200930131212504](file:///Users/yuxinmiao/Library/Application%20Support/typora-user-images/image-20200930131212504.png?lastModify=1601950411)

  memory in MIPS 

  insturction memory: only read afterwards 

  data memory: only one address for read / write 

  ![image-20200930131317240](file:///Users/yuxinmiao/Library/Application%20Support/typora-user-images/image-20200930131317240.png?lastModify=1601950411)

  If need write, write first 



# T06



Single Cycle Processor Chapter 4.1-4.4

■■ The **memory-reference** instructions load word (lw) and store word (sw) 

■■ The **arithmetic-logical** instructions add, sub, AND, OR, and slt

■■ The instructions **branch** equal (beq) and jump (j), which we add last

PC is controled by clock signal

every instruction, needs: send the PC to the memory that contains the code and fetch the instruction from that memory / read one or two registers, using fields of the instruction to select. 

*state element:* a memory element, such as a register or a memory 

- clocking methodology: edge-triggered clocking: a clocking scheme in which ass state changes occur on a clock edge. Only state elements can store data value, **any collection of combinational logic must have its inputs come from a set of state elements and its outputs written into a set of state elements**. The inputs are values that were written in a previous clock cycle, while the outputs  are values that can be used in a following clock cycle.
- ALUOp & funct -> ALU Control

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20201007102736810.png" alt="image-20201007102736810" style="zoom:33%;" />

​		Generate a 2-bit ALUOp (by CPI controller). With ALUOp and funct field -> ALU control

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20201007103211448.png" alt="image-20201007103211448" style="zoom:50%;" />

> ​		that is, using multiple levels of decoding -> reduce the size of the main control unit (opcode before)

The corresponding truth table is as follows, don’t care term all represented with X

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20201007103747839.png" alt="image-20201007103747839" style="zoom:50%;" />

- instruction format 

  `opcode` bits [31:26] as Op[5:0]

  Two register be read `rs` `rt` [25:21] and [20:16] (R-type, beq, store)

  base register for load and store `rs` [25:21] 

  offset [15:0] (beq, load, store)

  destination register - load: `rt` [20:16]

  ​									- R-type: `rd` [15:11] -> use a Mux to select 

- usage of seven control lines 

  <img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20201007105307315.png" alt="image-20201007105307315" style="zoom:50%;" />

For R-type, will not use data memory 

lw: read register from register file, ALU calculate the address, read data from data memory, store the data read back to register file 

![image-20201013152850305](/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20201013152850305.png)

### Clocking Methodology

`lw` load type instruction will need most time (becasuse of read from data)

`beq` only read from register and do some calculation, will not cost more time

*sigle-cycle processor* is not feasible to vary period for differerent instructions

![image-20201016131205087](/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20201016131205087.png)

​	clock cycle time for single-cycle processor will be 800ps, regardless of the instructions’ distribution

​	execution time is $100*800ps$



*multi-cycle CPU* - FSM: each instruction takes multiple cycles to execute 

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20201016132709964.png" alt="image-20201016132709964" style="zoom:50%;" />

​	still which operation will take the longest time - Instr Fetch: 200ps 

​	However, with different distribution, multi-cycle will have different total execution time, some may be worse than single-cycle some may be worse. 



# T07

Pipelined Processor 

divide the big combinational circuit into five small stages, one step per stage per cycle  

1. IF:  Instruction fetch
2. ID:  Instruction decode and register file read 
3. EX:  Execution or address calculation
4. MEM:  Data memory access
5. WB:  Write result back to register 

Single-clock-cycle diagram / multi-clock-cycle diagram

Instruction-level parallism: multiple instructions exectued at the same time

execution time for each instruction does not improve (all need to execute the five stages)

# T08 

Data Hazards 

- add stalls: nop instructions 
- forwarding (bypassing) : use data before it is stored into the register 