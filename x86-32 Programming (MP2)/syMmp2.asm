; MATTHEW JERICHO GO SY - S11

%include "io.inc"

section .data
    message_input db "Input Number: ",0
    message_digits db "Digits: ",0
    message_sum_of_digits db "Sum of digits: ",0
    message_quotient db "Quotient: ",0
    message_remainder db "Remainder: ",0
    message_harshad db "Harshad Number: ",0
    message_yes db "Yes ",0
    message_no db "No ",0
    message_reprompt db "Do you want to continue (Y/N) ",0
    comma db ", ",0
    input dd 0x00000000
    reprompt db "",0
    
    length db 0x00

section .text
global main
main:
    PRINT_STRING message_input
    GET_UDEC 4, input
    
    mov eax, [input]
    
    xor ebx, ebx  ; This will be the sum
    mov byte [length], 0x00  ; Reset length
    
iterate:
    cmp eax, 0
    je continue
   
    mov ecx, 10
    xor edx, edx  ; No need to sign extend since we're working with positive integers. Make sure edx is 0 instead.
    div ecx  ; This will remove last digit from eax, and give it through mod in dl 
    
    push edx  ; Store to stack for printing in order later
    
    add ebx, edx
    
    inc byte [length]
    
    jmp iterate
    
continue:
    PRINT_STRING message_digits
    
    mov al, [length]
    
print_digits:
    cmp al, 0
    je process
    
    pop ecx
    PRINT_UDEC 4, ecx
    
check_if_comma:
    cmp al, 1
    jne need_comma
    dec al
    jmp print_digits

need_comma:
    PRINT_STRING comma
    dec al
    jmp print_digits
    
process:
    NEWLINE
    PRINT_STRING message_sum_of_digits
    PRINT_UDEC 4, ebx
    mov eax, [input]
    xor edx, edx
    div ebx
    NEWLINE
    PRINT_STRING message_quotient
    PRINT_UDEC 4, eax
    NEWLINE
    PRINT_STRING message_remainder
    PRINT_UDEC 4, edx
    NEWLINE
    PRINT_STRING message_harshad
    cmp edx, 0
    jne not_harshad
    PRINT_STRING message_yes
    jmp ask_reprompt
    
not_harshad:
    PRINT_STRING message_no
    
ask_reprompt:
    NEWLINE
    NEWLINE
    PRINT_STRING message_reprompt
    GET_CHAR reprompt  ; This is to catch the \n entered when the first input is made
    GET_CHAR reprompt
    mov al, [reprompt]
    cmp al, 89  ; 'Y'
    je main
    
exit:
    xor eax, eax
    ret
    