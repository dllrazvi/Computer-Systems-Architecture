; The code below will print message ”n=”, then will read from keyboard the value of perameter n.
bits 32
global start        
; declare extern functions used by the programme
extern exit, printf, scanf ; add printf and scanf as extern functions            
import exit msvcrt.dll    
import printf msvcrt.dll    ; tell the assembler that function printf is found in msvcrt.dll library
import scanf msvcrt.dll  
segment data use32 class=data
    a dd  0
    b dd 0
    result dd 0
    message  db "Enter a: ", 0
    message1  db "Enter b: ", 0
    format  db "%d", 0
    result_msg db "Result: %d", 0

segment code use32 class=code
    start:
        ; Read a
        push dword message
        call [printf]
        add esp, 4
        push dword a
        push dword format
        call [scanf]
        add esp, 8

        ; Read b
        push dword message1
        call [printf]
        add esp, 4
        push dword b
        push dword format
        call [scanf]
        add esp, 8

        ; Calculate (a+b)*(a-b)
        mov eax, [a]
        add eax, [b]
        mov ebx, eax
        mov eax, [a]
        sub eax, [b]
        imul ebx
        mov [result], eax

        ; Print result
        push eax
        push dword result_msg
        call [printf]
        add esp, 8

        push dword 0
        call [exit]
