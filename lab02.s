
.data

array: .word 1, 0, 1, 12, 0, 1, 4

.text

    la a0, array
    li a1, 7    # unsigned
    li a2, 1
 #   j  findLast_forwards_withIndex
 #   j  findLast_forwards_withPointers

# -------------------------------
# Prefered solution: start from last element of the array and scan it backwards
#  using pointer, the first match is returned.
# Some extra work is done ouside the loop, so that the loop body is 
#  just a few instructions
# Algorithm:
# if a1 == 0
#   goto ret0
# s0 = a0 + a1 *4
# do {
#   s0--;
#   if *s0 == a2
#     goto done
# } while s0 != a0
# ret0:
#   s0 = 0  // not found
# done:
#   return
findLast_backwards_withPointers:
    beq  a1, zero, ret0
    slli s0, a1, 2  # offset of 1 word past the end of the array
    add  s0, s0, a0 # full address of the above
loop:
    addi s0, s0, -4   # s0--
    lw   t1, 0(s0)
    beq  t1, a2, done
    bne  s0, a0, loop
ret0:
    add  s0, zero, zero  # return address - not found
done:
    addi a7, zero, 10 
    ecall

# -------------------------------
# Solution 1: scan the array forwards using a0 as a pointer
#  Cannot end loop if element matches. It may not be the last match!
#  So record the matching address (in s0) and continue to the end of the array
findLast_forwards_withPointers:
    add  s0, zero, zero   # default return address : 0 - not found
loop1:
    beq  a1, zero, done1  # finished?
    lw   t1, 0(a0)
    bne  t1, a2, next1
    add  s0, a0, zero  # keep matching element's address in s0
next1:  # prepare for next iteration
    addi a0, a0, 4
    addi a1, a1, -1
    j    loop1
done1:
    addi a7, zero, 10 
    ecall


# -------------------------------
# Solution 2: scan the array forwards, calculating each element's
#  address from its index (register t2)
#  Cannot end loop if element matches. It may not be the last match!
findLast_forwards_withIndex:
    add  s0, zero, zero  # return address
    add  t2, zero, zero  # index
loop2:
    beq  a1, t2, done2
    slli t1, t2, 2
    add  t1, t1, a0
    lw   t3, 0(t1)
    bne  t3, a2, next2
    add  s0, t1, zero  # keep matching element's address in s0
next2:
    addi t2, t2, 1
    j    loop2
done2:
    addi a7, zero, 10 
    ecall
    
