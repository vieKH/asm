%include "io64.inc"
%include "io64_float.inc"

;i used formul maclaurin for cos: cos(x) = 1 - x^2/2 + x^4/4! + ... +(-1)^m * x^2m/(2m)!

section .data
    loop_count dd 10
    
section .rodata
    _one dd -1.0
    one dd 1.0
    two dd 2.0
    three dd 3.0
    
section .text
global main
main:
    mov rbp, rsp; for correct debugging
    READ_FLOAT xmm0
    
    call cal_cos
    
    PRINT_FLOAT xmm1
    ;write your code here
    xor rax, rax
    ret
    
cal_cos:
    movss xmm1, [one]   ;1
    movss xmm2, xmm0    ;x
    mulss xmm2, xmm2    ;x^2
    divss xmm2, [two]   ;x^2/2
    mulss xmm2, [_one]  ;-x^2/2
    addss xmm1, xmm2    ;1 - x^2/2
    movss xmm3, [two]
    mov ecx, [loop_count]
    loop:
        mulss xmm2, xmm0    ;-x^3/2!
        mulss xmm2, xmm0    ;-x^4/2!
        addss xmm3, [one]   ; + 1 = 3
        divss xmm2, xmm3    ;-x^4/(3!)
        addss xmm3, [one]   ; + 1 = 3
        divss xmm2, xmm3    ;-x^4/(4!)
        mulss xmm2, [_one]
        addss xmm1, xmm2
        sub ecx, 1
        jnz loop
    ret
   
