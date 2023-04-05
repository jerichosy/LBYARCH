# Matthew Jericho Go Sy - S11

# Macro to exit program
.macro DONE
	li a7, 10
	ecall
.end_macro

# Macro to print newline
.macro NEWLINE
  	li a7, 11
  	li a0, 10
	ecall
.end_macro

.data
	# Given
	A: .float 2.0
	B: .float -5.0
	C: .float -3.0
	
	# Display
	display1: .asciz "X1: "
	display2: .asciz "X2: "

.text
init:
	# ABCs
	flw, f1, A, a1  # load address of A at a1 and its value in f1
	flw, f2, B, a2  # load address of B at a2 and its value in f2
	flw, f3, C, a3  # load address of C at a3 and its value in f3
	
	# constants
	li t0, 2  # assign t4 to 2
	fcvt.s.w f5, t0  # convert 2 at t4 to float in f4 
	li t0, 4  # assign t5 to 4
	fcvt.s.w f6, t0  # convert 4 at t5 to float in f5

bottom: 
	fmul.s f11, f5, f1  # 2a stored to f10

top_right:
	fmul.s f12, f2, f2  # b^2 stored to f11
	fmul.s f13, f6, f1  # 4a stored to f12
	fmul.s f13, f13, f3  # 4a (in f12) * c stored back to f12
	fsub.s f14, f12, f13  # b^2 - 4ac stored to f13
	fsqrt.s f15, f14  # sqrt(b^2 - 4ac) stored to f14
	
top_left:
	fneg.s f16, f2  # -b
	
top_plus:
	fadd.s f17, f16, f15  # -b + sqrt(b^2 - 4ac)
	
top_subtract:
	fsub.s f18, f16, f15  # -b - sqrt(b^2 - 4ac)
	
whole1:
	fdiv.s f19, f17, f11
	
whole2:
	fdiv.s f20, f18, f11
	
answer:
	li a7, 4
	la a0, display1
	ecall
	
	li a7, 2
	fmv.s f10, f19
	ecall
	
	NEWLINE
	
	li a7, 4
	la a0, display2
	ecall
	
	li a7, 2
	fmv.s f10, f20
	ecall
	
	DONE
