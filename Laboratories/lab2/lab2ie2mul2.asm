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
    b db 3
    c db 2
    d dw 6
    ;e equ 2
    ;r equ 5
; the program code will be part of a segment called code
segment code use32 class=code
start:
        ;((a+b-c)*2 + d-5)*d, a,b,c byte, d word
mov al,byte [a]
mov bl, byte [b]
mov cl, byte [c]
add al,bl; al=a+b
sub al, cl; al=a+b-c
mov bl, 2
mul bl ; ax=(a+b-c)*2
mov bx, word [d]
mov cl, 5
mov ch, 0 ;cx=cl
sub bx, cx ;bx=d-5
add ax, bx ;ax=(a+b-c)*2 + d-5
mul word [d] ; ax=((a+b-c)*2 + d-5)*d
        
call [exit]