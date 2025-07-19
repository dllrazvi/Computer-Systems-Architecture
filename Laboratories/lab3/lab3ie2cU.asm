bits 32 
global start
extern exit 
import exit msvcrt.dll
segment data use32 class=data
    a db 7
    b dd 2
    c db 3
    d db 1
    x dq 10
segment code use32 class=code
start:
            ;x-(a+b+c*d)/(9-a); 
            ;a,c,d-byte; b-doubleword; x-qword 
    mov AL,[c] ;AL=c
    mul byte [d] ;AX=AL*d=c*d
    mov bl, [a] ;bl= byte a
    mov bh,0; unsigned conversion from byte si to word, bx=bl=a
    add ax, bx ; ax=ax+bx=a+c*d
    ; we need to convert word ax to doubleword to add b-doubleword
    mov bx,0 ; ax=bx:ax
    mov cx, word [b]   ;breaking b in 2 words and load them in cx:dx
    mov dx, word [b+2];cx:dx=b
    add cx,ax
    add dx,bx ; cx:dx=a+b+c*d,cx
    push cx
    push dx
    pop edx ;edx=cx:dx=a+b+c*d
    mov eax,edx ;eax=edx
    mov edx,0; edx:eax=a+b+c*d
    mov cl,9
    sub cl, byte [a];cl=9-a
    mov ch,0 ;unsigned conversion from byte cl to word cx
    mov bx,0 ;cx=bx:cx conversion from word to doubleword
    push bx
    push cx
    pop ecx ;ecx=bx:cx=9-a
    div ecx ;eax=edx:eax/ecx, edx=edx:eax%ecx
    mov ecx, dword [x]
    mov ebx, dword [x+4] ;ecx:ebx=x
    sub ecx, eax
    sub ebx, edx ;ebx:ecx=ebx:ecx-edx:eax=x-(a+b+c*d)/(9-a) ; sbb
    push dword 0 
    call [exit]