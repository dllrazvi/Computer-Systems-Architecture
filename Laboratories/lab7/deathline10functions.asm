; The code below will print message ”n=”, then will read from keyboard the value of perameter n.
bits 32
global start        
; declare extern functions used by the programme
extern exit, printf, scanf ; add printf and scanf as extern functions            
import exit msvcrt.dll    
import printf msvcrt.dll    ; tell the assembler that function printf is found in msvcrt.dll library
import scanf msvcrt.dll     ; similar for scanf
segment data use32 class=data
	a dd  0       ; in this variable we'll store the value read from the keyboard
    b dd 0
    result dd 0
    ; char strings are of type byte
	message  db "a=", 0  ; char strings for C functions must terminate with 0(value, not char)
    message1  db "b=", 0  ; char strings for C functions must terminate with 0(value, not char)
	format  db "%d", 0  ; %d <=> a decimal number (base 10)
    message2 db "a=%d",0 
segment code use32 class=code
    start:
    ;Read two numbers a and b (base 10) from the keyboard and calculate: (a+b)*(a-b). 
    ;The result of multiplication will be stored in a variable called "result" (defined in the data segment).

    ; will call printf(message) => will print "a="
    ; place parameters on stack
    
    push dword message ; we push the message "a=" on the stack
    call [printf] ; we print the message on the console
    add esi, 4*1 ;we free the stack ;4 = size of dword; 1 = number of parameters
    ; will call scanf(format, a) => will read a number in variable a
    ; place parameters on stack from right to left
    push dword a 
    push dword format ; we push a on stack to store the input value in it
    call [scanf] ;call the input function
    add esi, 4*2 ; free the stack; 4= size of dword; 2= number of parameters
    ; analog for b
    push dword message1
    call [printf]
    add esi,4*1
    push dword b
    push dword format
    call [scanf]
    add esi,4*2
    mov eax,dword [a]
    add eax, dword [b]
    mov ebx,eax
    mov eax, dword [a]
    sub eax, dword [b]
    mul ebx
    push eax
    push dword message2
    call [printf] 
    add esi,4*2
    push dword 0      ; place on stack parameter for exit
    call [exit]       ; call exit to terminate the program
    