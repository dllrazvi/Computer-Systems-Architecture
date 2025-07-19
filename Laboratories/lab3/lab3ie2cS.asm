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
    imul byte [d] ;AX=AL*d=c*d
    mov bx,ax
    mov al, [a] ;al= byte a
    cbw ; signed conversion from byte to word, ax=al=a
    adc ax, bx ; ax=ax+bx=a+c*d ; add
    ; we need to convert word ax to doubleword to add b-doubleword
    cwd; ax=dx:ax
    mov cx, word [b]
    mov dx, word [b+2];cx:dx=b
    adc cx,ax ;add
    adc dx,bx ; dx:cx=a+b+c*d,cx
    push dx
    push cx
    pop edx ;edx=dx:cx=a+b+c*d
    mov eax,edx ;eax=edx
    cdq; edx:eax=a+b+c*d
    mov ecx,eax 
    mov ebx,edx ; ecx:ebx=edx:eax
    mov al,9
    sbb al, byte [a];al=9-a sub
    cbw; signed conversion from byte al to word ax
    cwd ;ax=dx:ax conversion from word to doubleword
    push dx
    push ax
    pop eax ;eax=dx:ax=9-a
    mov edx,ebx ; edx=ebx=a+b+c*d
    mov ebx, eax ; ebx=9-a
    mov eax,ecx
    idiv ebx ;eax=edx:eax/ebx, edx=edx:eax%ebx edx:eax=(a+b+c*d)/(9-a)
    mov ecx, dword [x]
    mov ebx, dword [x+4] ;ecx:ebx=x
    sbb ecx, eax
    sbb ebx, edx ;ebx:ecx=ebx:ecx-edx:eax=x-(a+b+c*d)/(9-a)
    push dword 0 
    call [exit]