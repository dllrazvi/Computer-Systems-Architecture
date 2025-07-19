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
    b db 2
    c db 3
    d db 4
; the program code will be part of a segment called code
segment code use32 class=code
start:
        ;(b+b)+(c-a)+d, a,b,c,d byte
mov dl, byte [b];
add dl,dl; ; dl=dl+dl=b+b 
mov bl, byte [c];
mov al, byte [a];
sub bl, al; ; bl=bl-al=c-a
add bl, dl; ; bl=bl+dl=(c-a)+2*b
mov al, byte [d];
add al, bl ; al=al+bl=(b+b)+(c-a)+d
call [exit]