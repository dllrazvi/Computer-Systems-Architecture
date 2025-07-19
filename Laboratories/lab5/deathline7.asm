bits 32 
global start
extern exit 
;extern exit,printf
import exit msvcrt.dll
;import printf msvcrt.dll
segment data use32 class=data
    s db 1,5,3,8,2,9 ; byte string
    l equ $-s ; the length of the initial string
    d1 times l/2 db 0 ;length of d1 and d2 are length(s)/2
    d2 times l/2 db 0 
segment code use32 class=code
start:
        ;A byte string S is given. Obtain the string D1 which contains the elements found on the even positions of S 
        ;and the string D2 which contains the elements found on the odd positions of S.
    mov ecx, l ;ecx is now the length of s
	mov esi, 0 
    mov edi, 0 ; we take edi as an index for d1 and d2 to have continous elements
	jecxz Sfarsit ; Jump short if ECX register is 0.
    Repeta:
		mov al, [s+esi] ; we put in al each elements of s
        test esi, 1 ; we mask all the bits but the lower one to see if esi is even or odd (ZF=0 ->esi odd)
        jnz et1 ;jump to et1 if esi is odd (Jump short if not zero (ZF=0))
        mov [d1+edi] ,al ;if esi is even, we put al in d1
        inc esi
    loop Repeta
        et1: ; al is on an odd position in s
        mov [d2+edi],al ; we put al in d2
        inc esi
        inc edi
	loop Repeta
	Sfarsit: 
    push dword 0 
    call [exit]