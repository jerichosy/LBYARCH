.macro DONE
  li a7, 10
  ecall
.end_macro 

.macro NEWLINE
  li a7, 11
  li a0, 10
  ecall
.end_macro

.data
	A: .word 10, 6, 12, 7, 5, 11, 10, 7
	Ar_size: .word  2  # row length in A
	Ac_size: .word  4  # column length in A
	B: .word 15, 9, 21, 14, 12, 8, 17, 5, 2, 10, 9, 6
	Br_size: .word  4  # row length in B
	Bc_size: .word  3  # column length in B
	C: .space 200  # 200 bytes or 50 integer elements (4 bytes each)
	
	error_msg: .asciz "Error: Input matrices have sizes that are invalid for multiplication."
	answer_msg: .asciz "C ="
	
.text
check:
	# check if valid matmul operation (Ac_size and Br_size must be equal)
	lw t1, Ac_size
	lw t2, Br_size
	beq t1, t2, determine_element_cnt_in_final
	
	# if reached this point, then invalid matmul so print error and call exit 
	li a7, 55
	la a0, error_msg
	li a1, 0
	ecall
	
	DONE
	
determine_element_cnt_in_final:
	# calculate number of elements in final matrix for use as loop counter
	lw t0, Ar_size
	lw t3, Bc_size
	
	mul t4, t0, t3
	

# SUBELEMENT
# When accessing next column, increment A address counter by 4
# When accessing next row (same column), increment B address counter by 4 * Bc_size

# ELEMENT 
# Assume C is a 2x2 matrix
# At 1st element, A and B address counters should be at first A row and B column respectively.
# At 2nd element, A address counter should stay the same, but B address counter should move to next column. 
# At 3rd element, A address counter should move to next row, but B address counter should go back to prev. column.
# At 4th element, A address counter should stay the same, but B address counter should move to next column. 
# For A address counter, reset back to 
# For B address counter, 

subcompute_element:  # Loop this by no. of multiplications per element  ( no of multiplications = t1 (Ac_size) or t2 (Br_size) )
	
	# loop
	addi t1, t1, -1  # decrement t1 (Ac_size)  [NOTE: In-place decrement)
	bgtz t1, 
	
init:
	
			
compute_element:

	# store to C
	
	# prep next loop (reset address counters)
	
	# loop upwards
	addi t4, t4, 1  # decrement t4 (element count)
	
	bgtz t4, sub_elements  # branch to loop if t4 (element count) still greater than zero
	
	
answer_prefix:
	# prefix the answer
	li a7, 4
	la a0, answer_msg
	ecall
	
	NEWLINE

answer:	 # print answer by use of a loop depending on no. of rows (Ar_size), then append newline at end of loop
	
	NEWLINE
	
		
	
	# call exit
	DONE
