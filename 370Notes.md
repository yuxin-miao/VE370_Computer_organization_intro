# Chapter 1

Performance 

- $$
  \begin{equation}
  \begin{aligned}
  \rm{\textbf{CPU Time}}&=\rm{CPU\ Clock\ Cycles\ per\ program \times Clock\ Cycle\ Time}\\
   &=\frac{\rm{CPU\ Clock\ Cycles}}{\rm{Clock \ Rate}} \\
   &= \frac{\rm{IC}\times \rm{CPI}}{\rm{Clock\ Rate}} \\
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

<p center> **Operation and Operands ** <p>

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

The content in the address ( content in register (\$s3) + offset (32)) is loaded in \$t0

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
- `ori $t0, $t0, 0x....` \\$t1 = \$t2| ZeroExtImm

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

- *Function return operation*: jump register `jr $ra` (R-type)

  - PC = \$ra; Copies \$ra to program counter 

- return address

   A link to the calling site that allows a procedure to return to the proper address;

  in MIPS it is stored in register $ra.

- caller: The program that instigates a procedure and provides the necessary parameter values.

- Callee: A procedure that executes a series of stored instructions based on parameters provided by the caller and then returns control to the caller.

- **stack pointer** (\$sp)
  - pointing to the bottom of the stack 

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
		beq $t0, $zero, L1
		addi $v0, $zero, 1
		addi $sp, $sp, 8
		jr $ra
L1: 
		addi $a0, $a0, 1
		jal fact
		lw $a0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		mul $v0, $a0, $v0 # how to implement it not using mul
		jr $ra

```



## Function Calling Convention

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

				2. ​	the instructions that refers to the data word $X$ and $Y$

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200919105719045.png" alt="image-20200919105719045" style="zoom:50%;" />

### linker 

Also called link editor. A systems program that combines independently assembled machine language programs and resolves all undefined labels into an **executable file**.

	1. merge segments
 	2. resolve labels (determine their address)
 	3. patch location-dependent and external reference 

**example of linked objects**

> the text segment starts at address 40 0000hex and the data segment at 1000 0000hex.

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200919111236159.png" alt="image-20200919111236159" style="zoom:50%;" />

> 1. The jals are easy because they use pseudodirect addressing. The jal at address 40 0004hex gets 40 0100hex (the address of procedure B) in its address field, and the jal at 40 0104hex gets 40 0000hex (the address of procedure A) in its address field.
> 2. The load and store addresses are harder because they are relative to a base register. This example uses the global pointer as the base register. Figure 2.13 shows that $gp is initialized to 1000 8000hex. To get the address 1000 0000hex (the address of word X), we place -­8000hex in the address field of lw at address 40 0000hex. Similarly, we place ­7980hex in the address field of sw at address 40 0100hex to get the address 1000 0020hex (the address of word Y).

**从哪里看出来是-8000hex？？？**

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

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200919113501211.png" alt="image-20200919113501211" style="zoom:50%;" />

## Meaning of each name

Here is the meaning of each name of the fields in MIPS instructions:

- *op:* Basic operation of the instruction, traditionally called the **opcode**.
- *rs:* The first register source operand.
- *rt:* The second register source operand.
- *rd:* The register destination operand. It gets the result of the operation.
- *shamt:* Shift amount. (Section 2.6 explains shift instructions and this term; it will not be used until then, and hence the field contains zero in this section.)
- *funct:* Function. This field, often called the *function code,* selects the specific variant of the operation in the op field.



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

