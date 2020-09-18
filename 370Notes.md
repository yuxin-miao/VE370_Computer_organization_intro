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
- 

> GHz = $10^9$

# Chapter 2

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

## load word

from the content in register (\$s3), the content + offset (32), is the address of the content need to be loaded.

The content in the address ( content in register (\$s3) + offset (32)) is loaded in \$t0

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200917162604239.png" alt="image-20200917162604239" style="zoom:50%;" />

## Store Word

Store the content in \$t0, into the content of the address (content in \$s3 + 48)

![image-20200917162852822](/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200917162852822.png)

## Meaning of each name

Here is the meaning of each name of the fields in MIPS instructions:

- *op:* Basic operation of the instruction, traditionally called the **opcode**.
- *rs:* The first register source operand.
- *rt:* The second register source operand.
- *rd:* The register destination operand. It gets the result of the operation.
- *shamt:* Shift amount. (Section 2.6 explains shift instructions and this term; it will not be used until then, and hence the field contains zero in this section.)
- *funct:* Function. This field, often called the *function code,* selects the specific variant of the operation in the op field.

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

## Register Convention

>  \$zero: constant 0 (reg 0, also written as 0)
>  \$at: Assembler Temporary (reg 1, or 1)
>  \$v0, v1: result values (reg’s 2 and 3, or 2 and 3)
> \$a0 – a3: arguments (reg’s 4 – 7, or 4 - 7)
> \$t0 – t7: temporaries (reg’s 8 – 15, or 8 - 15); can be overwritten by callee
> \$ s0 – s7: saved (reg’s 16 – 23, or 16 - 23); be saved/restored by callee
>  \$t8, t9: temporaries (reg’s 24 and 25, or 24 and 25)
>  \$k0, k1: reserved for OS kernel (reg’s 26 and 27, 26/27) 
>
> \$gp: global pointer for static data (reg 28, or 28)
>  \$sp: stack pointer (reg 29, or 29)
>  \$fp: frame pointer (reg 30, or 30)
>  \$ra: return address (reg 31, or \$31)



# Chapter 3

program stored in memory 

> Similarly, in the execution of a procedure, the program must follow these six steps:
>
> 1. Put parameters in a place where the procedure can access them.
> 2. Transfer control to the procedure.
> 3. Acquire the storage resources needed for the procedure.
> 4. Perform the desired task.
> 5. Put the result value in a place where the calling program can access it.
> 6. Return control to the point of origin, since a procedure can be called from several points in a program.

- jump-and-link instruction 

  An instruction that jumps to an address and simultaneously saves the address of the following instruction in a register ($ra in MIPS).

- return address

   A link to the calling site that allows a procedure to return to the proper address;

  in MIPS it is stored in register $ra.

- caller: The program that instigates a procedure and provides the necessary parameter values.

- Callee: A procedure that executes a series of stored instructions based on parameters provided by the caller and then returns control to the caller.

- **program counter** (PC) (instruction address register)

  - address of the instruction is sotred in PC 
  - 32 bits register 
  - a special register in CPU (not same as the registers in register file)

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200917145047483.png" alt="image-20200917145047483" style="zoom:30%;" />

- **stack pointer** (\$sp)
  - pointing to the bottom of the stack 

<img src="/Users/yuxinmiao/Library/Application Support/typora-user-images/image-20200917153557980.png" alt="image-20200917153557980" style="zoom:40%;" />

- frame pointer (\$fp)

a frame pointer offers a stable base register within a procedure for local memory-references. as \$sp might change 

- Function calling

```assembly
jal Functionlabel1 # J-type function call operations jump and link
									# $ra = PC +4; address of following instruction Pc = target address
jr $ra # R-type PC = $ra jump register
```

- leaf function

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

- Non-leaf funciton

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
  	for (j = i – 1; j >= 0 && v[j] > v[j + 1]; j += 1) { 
      swap(v,j);
  	} 
  }
}
```

Problem: `sort` needs the value in \$a0 and \$a1, `swap` need to have the parameters placed in those same registers. 