bits 32

global start

; declare external functions needed by our program
extern exit, fopen, fclose, fprintf, scanf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "numere3.txt", 0   ; filename to be created
    access_mode db "w", 0
    format_in db "%d", 0   ; Format pentru citirea numerelor
    format_out db "%d ", 0 ; Format pentru scrierea numerelor
    n dd 0                 ; Variabila pentru stocarea lui N
    num dd 0               ; Variabila pentru stocarea numerelor citite
    file_descriptor dd -1  ; variable to hold the file descriptor
    l dw 100d

segment code use32 class=code
    start:
        ; Citire N
        push dword n
        push dword format_in
        call [scanf]
        add esp, 4*2

        ; Open the file
        push dword access_mode     
        push dword file_name
        call [fopen]
        add esp, 4*2
        mov [file_descriptor], eax
        cmp eax, 0
        je cleanup

    read_loop:
        ; Read an integer
        push dword num
        push dword format_in
        call [scanf]
        add esp, 8

        ; Check for end of input (character '$')
        mov eax, [num]
        cmp eax, 36 ; ASCII code for '$'
        je close_file

        ; Check if the number is odd and tens digit is N
        mov eax, [num]
        test eax, eax
        js negative_number
        mov ebx, eax
        shr ebx, 4    ; Shift right by 4 bits to get the tens digit
        and ebx, 0xF  ; Isolate the tens digit
        cmp ebx, [n]
        jne read_loop
        test eax, 1   ; Check if the number is odd
        jz read_loop

        ; Write the number to the file
        jmp write_number

    negative_number:
        neg eax        ; Make the number positive to check the tens digit
        mov ebx, eax
        shr ebx, 4
        and ebx, 0xF
        cmp ebx, [n]
        jne read_loop
        mov eax, [num]
        test eax, 1   ; Check if the original number is odd
        jz read_loop

    write_number:
        push dword [num]
        push dword format_out
        push dword [file_descriptor]
        call [fprintf]
        add esp, 12
        jmp read_loop

    close_file:
        ; Close the file
        push dword [file_descriptor]
        call [fclose]
        add esp, 4

    cleanup:
        ; Exit program
        push dword 0
        call [exit]
