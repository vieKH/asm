    %include "io64.inc"
%include "io64_float.inc"

;cos(ln(x+a)) = b
; x = exp(arccos(b)) - a = exp(2 * acrtag(sqrt(1-b)/sqrt(1+b)) - a

; ПОЛИЗ
section .bss
    x: resd 1
section .rodata
    a dd 5.0
    b dd 0.5
    e dd 2.718282
    two dd 2.0
    
    
section .text
global main
main:
    mov rbp, rsp; for correct debugging
    ;write your code here
    PRINT_STRING "With value a, b = "
    PRINT_FLOAT a
    PRINT_STRING ", "
    PRINT_FLOAT b
    NEWLINE
    PRINT_STRING "cos(ln(x+a)) = b"
    NEWLINE
    PRINT_STRING "Solution x = "
    call cal_e_arc
    fld dword[x]
    fld dword[a]
    fsub
  
    fstp dword[x]
    PRINT_FLOAT x
    xor rax, rax
    ret

cal_e_arc:
    fld1
    fld dword[b]
    fsub
    fsqrt
    fld1
    fld dword[b]
    fadd
    fsqrt
    fpatan 
    fld dword[two]
    fmul
    
    fld dword[e]    
    
    FYL2X    ;вычисляем показатель
    FLD1     ;загружаем +1.0 в стек
    FLD ST1  ;дублируем показатель в стек
    FPREM    ;получаем дробную часть
    F2XM1    ;возводим в дробную часть показателя
    FADD     ;прибавляем 1 из стека
    FSCALE   ;возводим в целую часть и умножаем
    FSTP ST1 ; выталкиваем лишнее из вершины
   
    fstp dword[x]
    ret