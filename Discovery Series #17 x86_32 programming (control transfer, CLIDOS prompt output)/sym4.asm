; MATTHEW JERICHO GO SY - S11

%include "io.inc"

section .data
    message_input db "Please enter a string: ",0
    message_input_reprompt db "You did not enter a string. ",0

    string times 31 db 0

section .text
global main
main:
    ; Input string
    PRINT_STRING message_input
    GET_STRING string, 31
    
    ; If string is null, reprompt input again
    mov al, [string]
    cmp al, 10  ; 10 is LF (Line Feed) which is the char inputted on enter without inputted values
    je reprompt_input
    
    ; Else, continue
    lea esi, [string]  ; Load address of string into esi
    jmp uppercaser
    
reprompt_input:
    PRINT_STRING message_input_reprompt
    NEWLINE
    jmp main
    
uppercaser:
    ; Load current char
    mov al, [esi]
    
    ; Check if end of string
    ; If so, jump to result
    cmp al, 0
    je result
    
    ; Else, continue
    
    ; If outside range of lowercase letters in ASCII, ignore and move on
    cmp al, 97
    jl next_letter
    cmp al, 122
    jg next_letter
    
    ; Else, must be within lowercase range
    ; Convert lowercase char to uppercase by subtracting 32
    sub al, 32
    
    ; Store back to string
    mov [esi], al
    
next_letter:
    ; Increment string address
    inc esi  

    ; Loop
    jmp uppercaser

result:
    NEWLINE
    PRINT_STRING string
    
    xor eax, eax
    ret
