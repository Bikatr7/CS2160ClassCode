.globl main 
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

## part 2 input AAAAAAAAAAAAAAAAAAAA|2€€ (to test canary works)
## part 3 input (AAAAAAAAAAAAAAAAAAAAAAAA€€€C|2€€) (to break canary)

## AAAAAAAAAAAAAAAAAAAAAAAA (buffer)
## €€€C (canary)
## |2€€ (address string)

main:
    li t2,sekret_fn
	## Extend the stack to include canary space cause reasons
	addi sp, sp, -28
	sw ra, 28(sp)
	la t0, canary_value
	lw t1, 0(t0)
	sw t1, 24(sp)

	# main() body
	la a0, prompt
	call puts

	mv a0, sp
	call gets

	mv a0, sp
	call puts

	## Check the canary before returning 
	la t0, canary_value
	lw t1, 0(t0)
	lw t2, 24(sp)
	bne t1, t2, exit_failure

	lw ra, 28(sp)
	addi sp, sp, 29
	ret

exit_failure:
	li a7, __NR_EXIT
	li a0, 1
	ecall


.space 12288

sekret_fn:
	addi sp, sp, -4
	sw ra, 0(sp)
	la a0, sekret_data
	call puts
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

puts:
    addi sp, sp, -4   ## Make space on stack
    sw ra, 0(sp)      ## Save ra on stack

    mv t0, a0         # Savestart address of string

puts_loop:
    lbu a1, 0(t0)      ## Load the next byte of the string
    beqz a1, done_puts ## If byte is 0, end of string
    call putchar
    addi t0, t0, 1    ## Move to the next character
    j puts_loop

done_puts:
    li a1, 10         ## Output newline at end
    call putchar
    li a0, 0          ## return 0 on success

    lw ra, 0(sp)      ## Restore ra from stack
    addi sp, sp, 4    ## Return the stack pointer to its original position
    ret

gets:
    addi sp, sp, -8   ## Make space on stack
    sw ra, 0(sp)      ## Save ra on the stack
    sw s0, 4(sp)      ## Save s0 on the stack

    mv s0, a0         ## Save the start address of the buffer

gets_loop:
    call getchar
    li t3, -1       
    beq a0, t3, done_gets ## If EOF/error, break out of the loop
    sb a0, 0(s0)      ## Store character in the buffer
    li t3, 10         ## Load newline into t3
    beq a0, t3, done_gets ## If the character newline, branch to done_gets
    addi s0, s0, 1    ## Increment buffer pointer
    j gets_loop

done_gets:
    sb zero, 0(s0)    ## Null-terminate the string

    lw ra, 0(sp)      ## Restore ra from the stack
    lw s0, 4(sp)
    addi sp, sp, 8    ## Return the stack pointer to its original position
    ret

getchar:
    addi sp, sp, -4       ## Allocate space for the read syscall
    li a7, __NR_READ      
    li a0, STDIN         
    mv a1, sp             
    li a2, 1              
    ecall                 
    mv t1, a0             ## Save the return value of read syscall in t1
    lbu a0, 0(sp)          ## Load the read character into a0
    addi sp, sp, 4        ## Clean up  stack

    li t2, 1              
    bne t1, t2, handle_eof_error ## If read did not return 1, handle as EOF/error

    ## Otherwise, return the character as is
    ret

handle_eof_error:
    li a0, -1             ## Use -1 to indicate EOF/error
    ret

putchar:
    li a7, __NR_WRITE  
    li a0, STDOUT       
    addi sp, sp, -4      ## Allocate stack space
    sb a1, 0(sp)         ## Store character on the stack
    mv a1, sp            ## character pointer
    li a2, 1             ## Write one character
    ecall                ## sys ccall
    addi sp, sp, 4       ## Clean up the stack
    mv a0, a1            
    ret
    
.data
prompt:   .ascii  "Enter a message: "
prompt_end:

.word 0
sekret_data:
.word 0x73564753, 0x67384762, 0x79393256, 0x3D514762, 0x0000000A

.word 0
canary_value: 
.word 0x43000000
