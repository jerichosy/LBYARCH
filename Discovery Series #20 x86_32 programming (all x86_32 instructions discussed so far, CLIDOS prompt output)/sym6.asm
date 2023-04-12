; MATTHEW JERICHO GO SY - S11

%include "io.inc"

section .data
    message_input1 db "Input (1st address): ",0
    message_input2 db "Input (2nd address): ",0
    
    first dd 0x00000000
    second dd 0x00000000
    
    message_error db "Error: Invalid input, please try again. ",0
    message_output db "Offset: ",0
    
section .text
global main
main:
    ;write your code here
    PRINT_STRING message_input1
    GET_HEX 2, first
    PRINT_STRING message_input2
    GET_HEX 2, second
    
    ; If both inputs not divisible by 4
    
    ; check first
    mov eax, [first]
    cdq
    mov ecx, 4
    idiv ecx
    cmp edx, 0
    jne error
    
    ; check second
    mov eax, [second]
    cdq
    mov ecx, 4
    idiv ecx
    cmp edx, 0
    jne error
    
    ; Else
    
    mov ebx, [first]
    mov eax, [second]
    
    SUB eax, ebx
    
    cdq  ; Sign extend dword in eax to edx. cdq = convert from doubleword to quadword
    idiv ecx  ; Divide EDX:EAX by ECX
    
    ; eax contains quotient
    ; edx contains remainder
    
    PRINT_STRING message_output
    PRINT_DEC 2, eax
    
    jmp exit

error:
    PRINT_STRING message_error 

exit:
    xor eax, eax
    ret
    