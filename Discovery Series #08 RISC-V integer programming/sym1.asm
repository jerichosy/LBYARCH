# Macro to exit program. 
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
	prompt_dna: .asciz "Please input DNA string here: "
	dna_string: .space 101  # 1 ASCII char = 1 byte (8 bits)
	rna_string: .space 101
	msg_dna_length: .asciz "Length of DNA string: "
	msg_rna_converted: .asciz "Converted RNA string: "

.text
start:
	# -- INPUT --
	# Prompt
	li a7, 4
	la a0, prompt_dna
	ecall
	# Read string
	li a7, 8
	la a0, dna_string
	li a1, 101
	ecall
	  
	# -- PROCESS --
	la t1, dna_string
	  
	# Find length of string
	li t2, 0  # init length counter
loop:
	lb t3, (t1)  # load byte at beginning of string
	# if end of string, exit loop
	beq t3, zero, continue  
	# else, continue
	# increment
	addi t2, t2, 1  # increment the counter
	addi t1, t1, 1  # increment the address
	j loop
  
continue:
	# Replace all occurences of T in DNA string to U to form an RNA string
	la t1, dna_string
	la t4, rna_string
  
loop2:
  	lb t3, (t1) # load byte at beginning of string
	# if end of string, exit loop
	beq t3, zero, end  
	# else, continue
	# if byte is is 'T', replace with 'U'
	li t5, 'T'
	beq t3, t5, replace_T_with_U
	# else, copy as-is
	sb t3, (t4)
	# increment
	j increment
  
replace_T_with_U:
	li t3, 'U'
	sb t3, (t4)
  
increment:
	addi t1, t1, 1  # increment the address of DNA string
	addi t4, t4, 1  # increment the address of RNA string
	j loop2
  
end:  
	# -- OUTPUT --
	# Print length of string
	li a7, 4
	la a0, msg_dna_length
	ecall
	  
	li a7, 1
	addi t2, t2, -1  # Assuming length of string should not include the null byte
	mv a0, t2
	ecall 
	
	NEWLINE
	
	# Print RNA string to console
	li a7, 4
	la a0, msg_rna_converted
	ecall
	
	li a7, 4
	la a0, rna_string
	ecall
	
	# -- EXIT -- 
	# Call/exec macro to exit program
	DONE
