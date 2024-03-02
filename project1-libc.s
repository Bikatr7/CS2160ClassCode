.globl main 
.equ STDOUT, 1
.equ STDIN, 0
.equ __NR_READ, 63
.equ __NR_WRITE, 64
.equ __NR_EXIT, 93

.text
main:
    ## main() prolog
    addi sp, sp, -104
    sw ra, 100(sp)

    ## main() body

    ## Call write function to write the prompt to the terminal (stdout)
    la a1, prompt
    addi  a2, zero, prompt_end - prompt
    call write_to_terminal

    ## Call read function to read up to 100 characters from the terminal (stdin)
    call read_from_terminal

    ## Call write function to write the just read characters to the terminal (stdout)
    addi a2, a0, 0
    call write_to_terminal

    ## main() epilog
    lw ra, 100(sp)
    addi sp, sp, 104
    ret

read_from_terminal:
    li a7, __NR_READ
    li a0, STDIN
    mv a1, sp
    addi a2, zero, 100
    ecall
    ret

write_to_terminal:
    # Write to the terminal (stdout)
    li a7, __NR_WRITE
    li a0, STDOUT
    ecall
    ret

.data
prompt:   .ascii  "Enter a message: "
prompt_end:

