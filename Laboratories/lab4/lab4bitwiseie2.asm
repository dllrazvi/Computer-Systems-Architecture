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
    M dd 11111100111010111101101100111111b ;1111 1[100 1110 1011 1101 101{1] 001}1 1111
;                                        BITS:             [8-26]          {5-8}
    MNew resd 1
segment code use32 class=code
start:
        ;Given the doubleword M, compute the doubleword MNew as follows:
    ;the bits 0-3 a of MNew are the same as the bits 5-8 a of M.
    ;the bits 4-7 a of MNew have the value 1
    ;the bits 27-31 a of MNew have the value 0
    ;the bits 8-26 of MNew are the same as the bits 8-26 a of M.
    mov eax, dword [MNew]
    and eax, 0FFFFFFFh      ; all the bits remain the same but bits 27-31 are forced to 0 (the 0)
    or eax, 000000F0h       ; all the bits remain the same but bits 4-7 forced to 1 (the f)
    mov ecx, dword [M]
    shr ecx, 5              ; swifting to the right in M so that bits 5-8 will be bits 0-3
    and ecx, 0fh            ; keeping only the lower 4 bits
    or eax,ecx              ; combining eax with ecx, only keeping the bits 0-3 from ecx and load it into eax | 0 or 0 =1 ^ 1 or 0 = 1 ^ 1 or 1 = 1
    mov ecx, dword [M]
    shl ecx,1               ; moving the bits one position to the left so that we work with bits 9-27
    and ecx, 0FFFFFE0h      ; keeping only the bits 9-27, the wanted ones
                            ;
    or eax,ecx
call [exit]
