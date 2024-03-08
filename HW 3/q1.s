f:
    addi sp, sp, -8    ## Adjust stack pointer to allocate space for 2 items
    sw ra, 4(sp)       ## Store return address  stack
    sw a0, 0(sp)       ## Store the first argument of f (a) on the stack, could be used to store the result of first g call
    
    call g             ## Call g(a, b), result will be in a0
    
    sw a0, 0(sp)       ## Store result of first g call on the stack
    
    lw a0, 0(sp)       ## Load result of first g call into a0, preparing for second g call
    add a1, a2, a3     ## Compute c+d and store in a1 for the second g call
    
    call g             ## Call g(result of first g call, c+d)
    
    lw ra, 4(sp)       ## Restore return address stack
    addi sp, sp, 8     ## Deallocate stack
    
    ret                ## Return, result of second g call is already in a0, I think
