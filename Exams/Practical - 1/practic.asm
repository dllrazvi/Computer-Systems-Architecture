; The program will use:
; - the function fopen() to open/create the file
; - the function fclose() to close the created file.

bits 32

global start

; declare external functions needed by our program
extern exit, fopen, fclose, fprintf,scanf
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll  

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "numere2.txt", 0   ; filename to be created
    access_mode db "w", 0
    format_in db "%d", 0   ; Format pentru citirea numerelor
    format_out db "%d ", 0 ; Format pentru scrierea numerelor
    n dd 0                 ; Variabila pentru stocarea lui N
    num dd 0               ; Variabila pentru stocarea numerelor citite
    file_descriptor dd -1       ; variable to hold the file descriptor
    l dw 100d

; our code starts here
segment code use32 class=code
    start:
        ;Să se scrie un program în limbaj de asamblare care:

        ;citește de la tastatură un număr natural N (0 < N < 7);
        ;citește de la tastatură numere întregi până se introduce caracterul '$';
        ;creează un fișier text cu numele "numere2.txt";
        ;scrie în fișierul creat doar numerele întregi IMPARE și care au cifra zecilor egală cu N.
            ;Exemplu:

            ;Dacă se citește de la tastatură:

            ; N = 3

            ; Numere: 32 -231 343 4 5678 6 -37 878 38 939 $

            ;fișierul "numere2.txt" va conține:

            ; -231 -37 939
        
        ; call fopen() to create the file
        ; fopen() will return a file descriptor in the EAX or 0 in case of error
        ; eax = fopen(file_name, access_mode)
        ; Citire N
        push dword n
        push dword format_in
        call [scanf]
        add esp, 4*2
        push dword access_mode     
        push dword file_name
        call [fopen]
        add esp, 4*2                ; clean-up the stack

        mov [file_descriptor], eax  ; store the file descriptor returned by fopen
        cmp eax,0
        je close_file
        ; Start reading numbers and writing to the file
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
        mov eax, [num]
        cdq                          ; Sign-extend EAX into EDX
        mov ebx, l
        idiv ebx
        cmp edx, [n]                ; Compare tens digit with N
        jne read_loop
   
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
    push dword [file_descriptor]
    call [fclose]
    add esp, 4

    ; Cleanup and exit
    cleanup:
    push dword 0
    call [exit]
