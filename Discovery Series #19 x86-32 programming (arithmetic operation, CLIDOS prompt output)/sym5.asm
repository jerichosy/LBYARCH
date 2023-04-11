; MATTHEW JERICHO GO SY - S11

%include "io.inc"

section .data
    message_inputA db "Input A: ",0
    message_inputB db "Input B: ",0
    message_outputA db "A^4 = ",0
    message_outputB db "B^4 = ",0
    message_outputY db "A^4 + B^4 = ",0
    
    A dd 0x00000000
    B dd 0x00000000
    Y dd 0x00000000

section .text
global main
main:
    ;write your code here
    PRINT_STRING message_inputA
    GET_DEC 4, A
    PRINT_STRING message_inputB
    GET_DEC 4, B
    
    mov eax, [A]
    imul eax, [A]
    imul eax, [A]
    imul eax, [A]
    mov [A], eax
    
    mov ebx, eax
    
    mov eax, [B]
    imul eax, [B]
    imul eax, [B]
    imul eax, [B]
    mov [B], eax
    
    add ebx, eax
    mov [Y], ebx
    
    PRINT_STRING message_outputA
    PRINT_DEC 4, A
    NEWLINE

    PRINT_STRING message_outputB
    PRINT_DEC 4, B
    NEWLINE
    
    PRINT_STRING message_outputY
    PRINT_DEC 4, Y
    NEWLINE
    
    xor eax, eax
    ret
    