.globl main
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text
main:
    # Main prolog
    addi sp, sp, -104
    sw ra, 100(sp)

    # Call puts to write the prompt
    la a0, str
    call puts

    # Call gets to read input
    la a0, buf
    call gets

    # Call puts to echo the input
    la a0, buf
    call puts

    # Main epilog
    lw ra, 100(sp)
    addi sp, sp, 104
    ret

putchar:
    li a7, __NR_WRITE
    li a0, STDOUT
    addi a1, sp, 12 
    sw a0, 0(a1)
    li a2, 1
    ecall
    lw a0, 0(a1)
    ret

getchar:
    li a7, __NR_READ
    li a0, STDIN
    addi a1, sp, 12 
    li a2, 1
    ecall
    lb a0, 0(a1) 
    ret

gets:
    addi t0, a0, 0 

getchar_loop:
    call getchar
    sb a0, 0(t0) ## Store read character
    addi t0, t0, 1 ## Increment buff point
    li t1, 10
    beq a0, t1, finish_gets ## Break if newline
    j getchar_loop

finish_gets:
    sb zero, -1(t0) ## Null-term string
    ret

puts:
    addi t0, a0, 0 ## Copy string address to t0

puts_loop:
    lb a0, 0(t0) ## Load character
    beq a0, zero, finish_puts ## Break if its null-terminator
    call putchar
    addi t0, t0, 1 ## Increments string pointer
    j puts_loop
finish_puts:

    li a0, 10
    call putchar ## Write newline
    ret

.data
str: .asciz "Enter a message: "
buf: .space 100
