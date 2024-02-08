section .text
global main
extern access3
main:
    mov rbp, rsp; 
    mov rcx, 1
    mov r9, 15
    mov dx, -10
    mov r8w, -1
  
    call access3
    xor rax, rax
   
    
    ret
;void acces3(long long rcx, long long r9, short dx, short r8w){
;   rax = [r9/dx]
;;  rcx += rax
;   r8 = r8w
;   rcx += r8
;   if rcx == -1: print("access granted")}
