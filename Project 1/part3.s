.equ STDIN, 0
.equ STDOUT, 1
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ BUF_SIZE, 100

.text

.globl main

main:
    addi sp, sp, -4   ## Make space on stack
    sw ra, 0(sp)      ## Save ra on stack

    la a0, prompt    
    call puts

    la a0, buf       
    call gets

    la a0, buf     
    call puts

    lw ra, 0(sp)      ## Restore ra from stack
    addi sp, sp, 4    ## Return the stack pointer to its original position
    ret

puts:
    addi sp, sp, -4   ## Make space on stack
    sw ra, 0(sp)      ## Save ra on stack

    mv t0, a0         # Savestart address of string

puts_loop:
    lb a1, 0(t0)      ## Load the next byte of the string
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
    li t3, -1         ##Load the EOF/error indicator into t3
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
    addi sp, sp, -4
    li a7, __NR_READ  
    li a0, STDIN      
    mv a1, sp         ## Pointer to the stack space
    li a2, 1          ## Read one character
    ecall             
    lb a0, 0(sp)      ## Load the read character
    addi sp, sp, 4    ## Deallocate stack space
    
    blez a0, handle_eof_error  ## If <= 0 , handle as EOF/error

    ## Otherwise, return the character as is
    ret

handle_eof_error:
    li a1, -1         ## Use -1 to indicate EOF/error
    ret



putchar:
    li a7, __NR_WRITE 
    li a0, STDOUT    
    addi sp, sp, -4   ## Allocate space on stack
    sb a1, 0(sp)      ## Store the character stack
    mv a1, sp         ## Pointer 
    li a2, 1          ## Write one chara
    ecall             
    addi sp, sp, 4    ## Deallocate 
    mv a0, a1         ## Return the character
    ret

.data
prompt: .asciz "Enter a message: "
buf:    .space 100