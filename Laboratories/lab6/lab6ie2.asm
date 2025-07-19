bits 32 
global start
extern exit 
;extern exit,printf
import exit msvcrt.dll
;import printf msvcrt.dll
segment data use32 class=data
    s DD 12345607h, 1A2B3C15h, 13A33412h
    l equ ($-s)/4 ; the length of the initial string
    d times l db 0 ;length of d1 and d2 are length(s)
    sapte db 7
segment code use32 class=code
start:
    ;Given an array S of doublewords, build the array of bytes D formed from lower bytes of lower words, bytes multiple of 7.
    ;we have a doubleword with 4 bytes,
    mov ecx,l ;we move the length in ecx to have a loop with l iterations
    mov edi,0
    mov esi,s
    mov ebx, 0
    mov edi,d
    cld
    repeta:
       lodsb ;The byte from the address <DS:ESI> is loaded in AL
        ;If DF=0 then inc(ESI), else dec(ESI)
       mov bl,al ;make a copy of the byte in bl
       mov eax,0
       mov al,bl
       div byte [sapte] ; al/7, ah reminder
       cmp ah,0 ; see if al is div by 7
       jne do_not_add  ;jump short if not equal
       mov al,bl
       stosb ;Store al into the double word from the address <ES:EDI>
       do_not_add:
       
    loop repeta   
    push dword 0 
    call [exit]