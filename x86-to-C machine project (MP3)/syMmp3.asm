; MATTHEW JERICHO GO SY - S11

global main
extern gets, printf

section .data
    prompt_dna db "DNA string: ",0
    error_dna db "Error: Invalid DNA string",13,10,0
    error_terminator db "Error: No terminator",13,10,0
    error_length db "Error: Beyond maximum length",13,10,0
    message_dna_reverse_complement db "Reverse complement: %s",13,10,0
    message_dna_reverse_palindrome db "Reverse palindrome: %s",13,10,0
    message_yes db "Yes ",0
    message_no db "No ",0
    
    string_dna times 32 db 0  ; 30 DNA + terminator + null byte
    string_dna_reverse_complement times 32 db 0
    
    length db 0x00

section .text
main:
    push prompt_dna
    call printf
    add esp, 4
    ; get DNA string at most 30 alphabets (all caps) + '.' terminator
    push string_dna
    call gets
    add esp, 4
    
    ;push string_dna
    ;call printf
    ;add esp, 4
    
    ; loop thru string to check if terminator
    lea esi, [string_dna]
    
check_terminator_and_length:
    mov al, [esi]
    
    cmp al, 46
    je terminator_present
    cmp al, 0
    je no_terminator
    cmp byte [length], 30
    je beyond_max_length
    
    inc byte [length]
    inc esi
    
    jmp check_terminator_and_length
    
beyond_max_length:
    push error_length
    call printf
    add esp, 4

    jmp exit
    
no_terminator:    
    push error_terminator
    call printf
    add esp, 4
    
    jmp exit
    
terminator_present:    
    ; reverse the string
    lea esi, [string_dna]
    
reverse_string:
    ; Load current char
    mov al, [esi]
    
    ; Check if terminator
    ; If so, jump
    cmp al, 46  ; 46 '.'
    je continue
    
    ; push
    push eax
    
    inc esi
    
    jmp reverse_string
    
continue:
    mov dl, [length]
    lea esi, [string_dna_reverse_complement]
    
store_digits:
    cmp dl, 0
    je continue2
    
    pop eax
    mov [esi], al
    inc esi
    dec dl
    jmp store_digits
    
continue2:
    lea esi, [string_dna_reverse_complement]
    
complement_string:
    mov al, [esi]
    cmp al, 0
    je print_reverse_complement
    
    ; if   A, change to T
    ; elif T, change to A
    ; elif C, change to G
    ; elif G, change to C
    ; ASCII:
    ;   A = 65
    ;   T = 84
    ;   C = 67
    ;   G = 71
    cmp al, 65
    je if_a
    cmp al, 84
    je if_t
    cmp al, 67
    je if_c
    cmp al, 71
    je if_g
    
    ; if we reach here, that means our string is not a valid DNA string
invalid_dna:
    push error_dna
    call printf
    add esp, 4
    
    jmp exit
    
if_a:
    mov byte [esi], 84
    inc esi
    jmp complement_string

if_t:
    mov byte [esi], 65
    inc esi
    jmp complement_string

if_c:
    mov byte [esi], 71
    inc esi
    jmp complement_string

if_g:
    mov byte [esi], 67
    inc esi
    jmp complement_string
    
print_reverse_complement:
    push string_dna_reverse_complement
    push message_dna_reverse_complement
    call printf
    add esp, 8
    
continue3:
    lea esi, [string_dna]
    lea edi, [string_dna_reverse_complement]
    
check_reverse_palindrome:
    ; A DNA string is a reverse palindrome if it is equal to its reverse complement.
    mov ah, [esi]
    mov al, [edi]
    
    ; both string will be of equal length always
    ; so just check if one of them is already the null
    cmp ah, 46
    je reverse_palindrome_yes
    
    ;if not equal, break and print no
    cmp ah, al
    jne reverse_palindrome_no
    
    ;else, continue iterating
    inc esi
    inc edi
    
reverse_palindrome_yes:
    push message_yes
    push message_dna_reverse_palindrome
    call printf
    add esp, 8
    
    jmp exit
    
reverse_palindrome_no:
    push message_no
    push message_dna_reverse_palindrome
    call printf
    add esp, 8
    
exit:
    xor eax, eax
    ret
