bits 32 
global start
extern exit 
import exit msvcrt.dll
segment data use32 class=data
    a db 5              ; Define variable a as a byte (8 bits)
    b dw 10             ; Define variable b as a word (16 bits)
    c dd 15             ; Define variable c as a double word (32 bits)
    d dq 3              ; Define variable d as a qword (64 bits)
    result dd 0         ; Variable to store the result (32 bits)
segment code use32 class=code
start:
            ;c-(a+d)+(b+d)
            ;a - byte, b - word, c - double word, d - qword - Unsigned representation
    mov al, [a]
    mov ah,0 ; conversion from al to ax
    mov bx,0; ax=bx:ax conversion from word to dword
    ;we need to convert the doubleword to quadword so that we add it
    push bx
    push ax
    pop eax
    
    mov AL,[c] ;AL=c
    mul byte [d] ;AX=AL*d=c*d
    mov bl, [a] ;bl= byte a
    mov bh,0; unsigned conversion from byte si to word, bx=bl=a
    add ax, bx ; ax=ax+bx=a+c*d
    ; we need to convert word ax to doubleword to add b-doubleword
    mov bx,0 ; ax=bx:ax
    mov cx, word [b]
    mov dx, word [b+2];cx:dx=b
    add cx,ax
    adc dx,bx ; dx:cx=a+b+c*d,cx
    push dx
    push cx
    pop edx ;edx=dx:cx=a+b+c*d
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
    sbb ebx, edx ;ebx:ecx=ebx:ecx-edx:eax=x-(a+b+c*d)/(9-a)
    push dword 0 
    call [exit]