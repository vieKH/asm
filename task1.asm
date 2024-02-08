%include "io64.inc"
%include "io64_float.inc"
section .bss
    value_fpu_up: resd 1
    value_fpu_down: resd 1
    tmp: resd 1
    
section .text
global main
main:
    mov rbp, rsp; for correct debugging   
    
    PRINT_STRING "Method by round down sse: "
    ;PRINT_STRING "Method by round up sse: "
    READ_FLOAT xmm0
    call round_down_sse
    ;call round_up_sse
    PRINT_DEC 4, eax
    
    NEWLINE
    PRINT_STRING "Method by fpu, round up: "
    READ_FLOAT value_fpu_up
    
    call round_up_fpu
    PRINT_DEC 4, value_fpu_up
    NEWLINE
    
    PRINT_STRING "Method by fpu, round down: "
    READ_FLOAT value_fpu_down
    call round_down_fpu
    PRINT_DEC 4, value_fpu_down
    
    ;write your code here
    xor rax, rax
    ret
    
round_up_fpu:
    sub rsp,8 ; allocate space on stack
    fstcw [rsp] ; save the control word
    mov al, [rsp+1] ; get the higher 8 bits
    and al, 0xF3 ; reset the RC field to 0
    or al, 8 ; set the RC field to 0x10
    mov [rsp+1], al
    fldcw [rsp] ; load the control word
    add rsp, 8 ; 'free' the allocated stack space
    fld dword[value_fpu_up]
    fistp dword[value_fpu_up]
    ret
    
round_down_fpu:
    sub rsp,8
    fstcw [rsp]
    mov al, [rsp+1]
    and al, 0xF3
    or al, 4
    mov [rsp+1], al
    fldcw [rsp]
    add rsp, 8
    fld dword[value_fpu_down]
    fistp dword[value_fpu_down]  
    ret    
    
round_down_sse:
    stmxcsr [tmp]
    or dword [tmp], 0x00002000
    ldmxcsr [tmp]
    cvtss2si eax, xmm0 
    ret
    
round_up_sse:
    stmxcsr [tmp]
    or dword [tmp], 0x00004000
    ldmxcsr [tmp]
    cvtss2si eax, xmm0 
    ret
    