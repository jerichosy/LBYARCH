# Note: Comments may be incomplete and not reflect recent changes

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
	lw t2, Bc_size  # reassign t2 (to free up registers) bacause at this point t1=t2
	
	mul t3, t0, t2
	

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

determine_B_address_increment:
	li a6, 4
	mul a6, a6, t2  # based on no. of columns in B (Bc_size)
	
init_addresses:
	la a3, C
	la a4, A
	la a5, B

compute_element:  # Loop this by no. of multiplications per element  ( no of multiplications = t1 (Ac_size) or t2 (Br_size) )
	# load A and B element
	lw t4, 0(a4)
	lw t5, 0(a5)
	
	# multiply
	mul t5, t4, t5
	
	# sum
	add t6, t6, t5

	# increment A
	addi a4, a4, 4
	
	# increment B
	add a5, a5, a6
	
	# loop
	addi t1, t1, -1  # decrement t1 (Ac_size)  [NOTE: In-place decrement)
	bgtz t1, compute_element 
	
compute_element_loop_conclusion:
	# store word
	sw t6, 0(a3)
	addi a3, a3, 4
	
	# reset sum
	li t6, 0
	
	# reset its loop counter
	lw t1, Ac_size
			
next_element:
	# Check if there still more elements. If, not go to answer.
	addi t3, t3, -1 
	blez t3, answer_prefix

	# Prep next element loop
	# if B is not done with B, reset B but add 4 * where what col we are in B
	addi a2, a2, 1
	blt a2, t2, next_element_B_not_done
	
	# else, increment A to next row
	# reset a2
	li a2, 0
	
	j next_element_B_done
	
next_element_B_not_done:
	# reset A by substraction
	li a1, 4
	mul a1, a1, t1
	sub a4, a4, a1
	
	# reset B, but add 4 * where what col we are in B
	la a5, B
	li a1, 4
	mul a1, a1, a2
	add a5, a5, a1
	
	j compute_element
	
next_element_B_done:
	#addi a4, a4, 4
	la a5, B	
	
	j compute_element	
	
answer_prefix:
	# prefix the answer
	li a7, 4
	la a0, answer_msg
	ecall
	
	NEWLINE
	
answer_init:
	la a3, C
	li a1, 0
	
answer_line:
	# print
	li a7, 1
	lw a0, 0(a3)
	# before ecall check if done printing
	beqz a0, exit_program
	ecall
	
	# print space
	li a7, 11
	li a0, 32
	ecall
	
	# increment a3
	addi a3, a3, 4
	
	# If C max col reached, print newline. Address will remain the same
	addi a1, a1, 1
	blt a1, t2, answer_line
	
	li a1, 0
	NEWLINE
	
	j answer_line

exit_program:
	DONE
