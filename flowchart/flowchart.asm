; ASM-flowchart.nasm
; A more complex A-FCL interpreter in NASM assembly language for a 64-bit Linux system.
; This example demonstrates how to implement the 'SET' and 'PRINT' commands
; and how to manage a variable in memory.
;
; It interprets the following hard-coded A-FCL program:
; START
;   SET myvar = "Hello, A-FCL!"
;   PRINT myvar
; END
;
; To compile and run:
; nasm -f elf64 ASM-flowchart.nasm -o ASM-flowchart.o
; ld ASM-flowchart.o -o ASM-flowchart
; ./ASM-flowchart

section .data
    ; The A-FCL program string. For this example, we'll "parse" it by
    ; hard-coding the execution flow.
    a_fcl_program db "START SET myvar = \"Hello, A-FCL!\" PRINT myvar END", 0
    
    ; The string literal value to be assigned to the variable.
    string_value db "Hello, A-FCL!", 0
    string_len equ $ - string_value
    
    ; Memory location to hold the value of the variable "myvar".
    ; We allocate enough space for our string and a null terminator.
    myvar_storage resb 20

section .text
    global _start

_start:
    ; --- Execution Flow Simulation ---
    ; In a real interpreter, we would read the program line by line and
    ; jump to the appropriate command's code. Here, we'll simulate that
    ; by jumping directly to the 'SET' command, then 'PRINT', then 'END'.
    jmp set_command

set_command:
    ; The 'SET' command logic: copy the string literal into the variable storage.
    ; For simplicity, we assume the variable name is 'myvar' and the value is
    ; 'string_value'.

    mov rsi, string_value   ; Source address (the string literal)
    mov rdi, myvar_storage  ; Destination address (the variable's storage)
    mov rcx, string_len     ; Count of bytes to copy
    
    ; We use the REP MOVSB instruction to copy a block of bytes.
    ; This is a fast way to copy memory in assembly.
    cld                     ; Clear direction flag for forward copy
    rep movsb               ; Repeat MOVSB (Move String Byte) RCX times

    ; The variable 'myvar' now holds the value "Hello, A-FCL!".
    jmp print_command

print_command:
    ; The 'PRINT' command logic: print the contents of the variable 'myvar'.

    ; sys_write syscall
    ; RAX: syscall number 1 (for write)
    ; RDI: file descriptor 1 (for stdout)
    ; RSI: pointer to the string to be written (the variable's value)
    ; RDX: length of the string
    
    mov rax, 1              ; syscall number for sys_write
    mov rdi, 1              ; file descriptor 1 (stdout)
    mov rsi, myvar_storage  ; address of our variable's value
    mov rdx, string_len     ; length of the string to print
    syscall                 ; Execute the system call

    ; Add a newline character to make the output clean.
    mov rsi, newline_char
    mov rdx, 1
    mov rax, 1
    mov rdi, 1
    syscall

    jmp end_command

end_command:
    ; The 'END' command logic: exit the program.
    ; sys_exit syscall
    ; RAX: syscall number 60 (for exit)
    ; RDI: exit status 0 (for success)

    mov rax, 60             ; syscall number for sys_exit
    mov rdi, 0              ; exit status 0 (success)
    syscall                 ; Execute the system call

    section .data
    newline_char db 10

