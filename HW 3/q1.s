f:

    call g

    addi sp, sp, -4   

    add a1, a2, a3      # c + d, result in a1

    lw a0, 0(sp)        # Load the saved result into a0
    addi sp, sp, 4      # Deallocate stack space

    call g
    
    # Result of g is already in a0
    ret
