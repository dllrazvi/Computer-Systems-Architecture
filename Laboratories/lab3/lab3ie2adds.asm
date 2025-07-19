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
cbw
adc ax,ax
adc ax, word [b]
adc ax,word [b]; ax=(a+b)+(a+b)
cwd  ; ax=eax 
mov ebx, dword [c]
adc eax,ebx
adc eax,ebx
cdq
sbb eax, dword [d]
sbb edx, dword [d+4]; edx:eax= ((a + b) + (a + c) + (b + c)) - d

call [exit]
