.equ STDIN, 0
.equ STDOUT, 1
.equ __NR_READ, 63
.equ __NR_WRITE, 64

.text

.globl main

main:
    la a0, prompt     # Load address of prompt message

    call puts      

    la a0, buf        # Load address of buffer
    call gets      

    la a0, buf        # Load address of buffer
    call puts      

    ret

puts:
    mv t0, a0         # Save the start address of the string

puts_loop:
    lb a1, 0(t0)      # Load the next byte of the string
    beqz a1, done_puts # If the byte is 0, end of string
    call putchar     
    addi t0, t0, 1    # Move to the next character
    j puts_loop     

done_puts:
    li a1, 10         # Output a newline at the end
    call putchar
    li a0, 0          # return 0 on success
    ret


gets:
    mv t1, a0         # Save the start address of the buffer

gets_loop:
    call getchar      
    li t2, -1         # Load the EOF/error indicator into t2
    beq a0, t2, done_gets # If EOF/error, break out of the loop
    sb a0, 0(t1)      # Storecharacter in the buffer
    li t2, 10         # Load newline into t2
    beq a0, t2, done_gets # If the character newline, branch to done_gets
    addi t1, t1, 1    # Increment buffer pointer
    j gets_loop       

done_gets:
    sb zero, 0(t1)    # Null-terminate the string
    ret



getchar:
    li a7, __NR_READ  
    li a0, STDIN      
    addi sp, sp, -4   # Allocate space on the stack
    mv a1, sp         # Pointer to the stack space
    li a2, 1          # Read one character
    ecall             
    lb a0, 0(sp)      # Load the read character
    addi sp, sp, 4    # Deallocate stack space
    bltz a0, handle_eof_error  # Ifnegative value, handle as EOF/error
    beqz a0, handle_eof_error  # If zero value, handle as EOF/error

    # Otherwise, return the character as is
    ret

handle_eof_error:
    li a0, -1         # Use -1 to indicate EOF/error
    ret



putchar:
    li a7, __NR_WRITE 
    li a0, STDOUT    
    addi sp, sp, -4   # Allocate space on stack
    sb a1, 0(sp)      # Store the character stack
    mv a1, sp         # Pointer 
    li a2, 1          # Write one chara
    ecall             
    addi sp, sp, 4    # Deallocate 
    mv a0, a1         # Return the character
    ret

.data
prompt: .asciz "Enter a message: "
buf:    .space 100