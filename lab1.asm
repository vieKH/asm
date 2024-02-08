%include"io64.inc"

section .bss
 x: resb 1

section .text

global main
main:
    
    mov rbp, rsp; for correct debugging
    ;write your code here
    PRINT_DEC 4, x
    GET_UDEC 4, r8d
    mov r9d, r8d
    mov r10d, r8d
    mov r11d, r8d
    PRINT_STRING "Generation: "
    NEWLINE
    
    mov ecx, 100
    loop_generation:
        call xorshift128
        PRINT_UDEC 4, r8d
        PRINT_CHAR " "
        dec ecx
        jnz loop_generation
    
xorshift128:
    mov eax, r11d
    mov r11d, r10d
    mov r10d, r9d
    mov r9d, r8d
    
    mov ebx, eax
    shl ebx, 11
    xor eax, ebx
    
    mov ebx, eax
    shr ebx, 8
    xor eax, ebx
    
    mov ebx, r8d
    
    shr ebx, 19
    xor r8d, ebx
    xor r8d, eax   
    ret