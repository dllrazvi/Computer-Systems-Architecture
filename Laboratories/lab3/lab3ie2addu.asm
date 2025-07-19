bits 32 ;assembling for the 32 bits architecture
global start

; we ask the assembler to give global visibility to the symbol called start 
;(the start label will be the entry point in the program) 
extern exit ; we inform the assembler that the exit symbol is foreign; it exists even if we won't be defining it
import exit msvcrt.dll  ; we specify the external library that defines the symbol
        ; msvcrt.dll contains exit, printf and all the other important C-runtime functions
import printf msvcrt.dll
; our variables are declared here (the segment is called data) 6
segment data use32 class=data
    a db 1
    b dw 2 
    c dd 3
    d dq 4
; the program code will be part of a segment called code
segment code use32 class=code
start:
        ;((a + b) + (a + c) + (b + c)) - d
        ;a - byte, b - word, c - double word, d - qword - Unsigned representation
mov al, byte [a]
mov ah,0;
add ax,ax
add ax, word [b]
add ax,word [b]; ax=(a+b)+(a+b)
mov dx,0; ax=dx:ax | higher part:lower part
mov cx, word [c] ;lower part
mov bx, word [c+2];bx:cx=c
add ax,cx ; dx:ax=(dx+bx):(ax+cx)=((a + b) + (a + c) + (b + c))
add dx,bx
add ax,cx ; 
add dx,bx
push dx
push ax
pop eax; eax=dx:ax=((a + b) + (a + c) + (b + c))
mov edx,0; eax= edx:eax
sub eax, dword [d]
sub edx, dword [d+4]; edx:eax= ((a + b) + (a + c) + (b + c)) - d

call [exit]
