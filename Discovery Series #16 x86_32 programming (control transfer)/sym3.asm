; MATTHEW JERICHO GO SY - S11

%include "io.inc"

section .data
    message_kountc db "Count of cytosine: ",0
    message_kountg db "Count of guanine: ",0
    message_dnalen db "Length of DNA string: ",0

    STRVAR db "ACGTACGTCCCGGG",0
    KOUNTC db 0
    KOUNTG db 0
    DNALEN db 0

section .text
global main
main:
    ; Initialize registers
    mov ebx, 0  ; KOUNTC
    mov ecx, 0  ; KOUNTG
    mov edx, 0  ; DNALEN
    
    ; Load address of DNA string into esi
    lea esi, [STRVAR]
    
count_loop:
    ; Load current char
    mov al, [esi]
   
    ; Check if end of string
    ; If so, jump to store_result
    cmp al, 0
    je store_result
    
    ; Else, proceed with count
    
    ; Count C
    cmp al, 'C'
    je if_c  ; If C, increment C counter
    jmp continue   ; Else, just continue
    
if_c:
    inc ebx
 
continue:
    ; Count G
    cmp al, 'G'
    je if_g  ; If G, increment G counter
    jmp continue2  ; Else, just continue
    
if_g:
    inc ecx
    
continue2:
    inc edx  ; Increment DNA length counter
    inc esi  ; Increment DNA string address
    
    ; Loop
    jmp count_loop  
    
store_result:
    mov [KOUNTC], ebx
    mov [KOUNTG], ecx
    mov [DNALEN], edx
    
display_result:
    PRINT_STRING message_kountc
    PRINT_UDEC 1, KOUNTC
    NEWLINE
    PRINT_STRING message_kountg
    PRINT_UDEC 1, KOUNTG
    NEWLINE
    PRINT_STRING message_dnalen
    PRINT_UDEC 1, DNALEN
    NEWLINE
    
    xor eax, eax
    ret
