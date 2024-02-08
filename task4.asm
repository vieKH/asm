%include "io64.inc"
%include "io64_float.inc"

;f(x) = (ln(sin(x) + a)) ^3
section .data
    x dd 0.0
    y dd 0.0
    result dd 0.0
section .rodata
    a dd 5.0
    b dd 5.0
section .text
global main
main:
    
    
    mov rbp, rsp; for correct debugging
    ;READ_FLOAT x
    ;READ_FLOAT y
    ;PRINT_STRING " Point : "
    ;PRINT_FLOAT x
    ;PRINT_STRING ", "
    ;PRINT_FLOAT y
    ;NEWLINE
    ;write your code here
    fninit
    fld1
    fldl2e
    fdiv
    fld dword[a]
    fld dword[x]
    fsin
    fadd
    fyl2x
    fld st0
    fld st0
    fmul
    fmul
    fld dword[y]
    fcomip
    jnb false
    ;PRINT_STRING "This point satisfy the condition"
    jmp end
false:
    ;PRINT_STRING "This point did`t satisfy the condition"
end:    
    fstp st0
    ;fstp st0
    ;NEWLINE
    ;PRINT_STRING "Condition : y < (ln(sin(x) + a)) ^3"
    xor rax, rax
    ret
    
cal_fx:
    
ret
    