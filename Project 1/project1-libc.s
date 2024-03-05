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

# Argument: a0 = const char* s
puts:
    mv t0, a0         # Save the start address of the string

puts_loop:
    lb a1, 0(t0)      # Load the next byte of the string
    beqz a1, done_puts # If the byte is 0, end of string
    call putchar     
    addi t0, t0, 1    # Move to the next character
    j puts_loop       

done_puts:
    li a1, 10       # Output a newline at the end
    call putchar
    li a0, 0          # Return 0 on success
    ret

# Argument: a0 = char* s
gets:
    mv t1, a0         # Save the start address of the buffer

gets_loop:
    call getchar      # Read a character
    sb a0, 0(t1)      # Store the character in the buffer
    beq a0, 10, done_gets # If the character is newline, stop
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
    ret

# Argument: a1 = int c
putchar:
    li a7, __NR_WRITE 
    li a0, STDOUT    
    addi sp, sp, -4   # Allocate space on the stack
    sb a1, 0(sp)      # Store the character on the stack
    mv a1, sp         # Pointer to the character
    li a2, 1          # Write one character
    ecall             
    addi sp, sp, 4    # Deallocate stack space
    mv a0, a1         # Return the character written
    ret

.data
prompt: .asciz "Enter a message: "
buf:    .space 100