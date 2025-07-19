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
    b db 5
    c db 3
    d db 4
; the program code will be part of a segment called code
segment code use32 class=code
start:
        ;(c+b+a)-(d+d), a,b,c,d word
mov ax, word [c];
mov dx, word [b];
mov bx, word [a];
add ax,dx;
add ax,bx; ; ax=(c+b+a)
mov bx, word [d];
add bx, bx; bx=d+d
sub ax, bx; ax=(c+b+a)-(d+d)
call [exit]