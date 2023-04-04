; MATTHEW JERICHO GO SY - S11

%include "io.inc"

section .data
    message_input db "Please enter a string: ",0
    message_input_reprompt db "You did not enter a string. ",0

    string times 31 db 0

section .text
global main
main:
    ; Input name
    PRINT_STRING message_input
    GET_STRING string, 31
    
    ; If name is null, reprompt input again
    mov al, [string]
    cmp al, 10  ; 10 is LF (Line Feed) which is the char inputted on enter without inputted values
    je reprompt_input
    
    ; Else, continue
    jmp uppercaser
    
reprompt_input:
    PRINT_STRING message_input_reprompt
    NEWLINE
    jmp main
    
uppercaser:
    NEWLINE
    PRINT_STRING string
    
    xor eax, eax
    ret
