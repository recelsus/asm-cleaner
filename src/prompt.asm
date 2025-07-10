; prompt.asm

section .text
global should_delete

should_delete:
    push rdi
    mov rsi, rdi
    mov rdi, msg
    call print_fmt
    call getchar
    cmp al, 'y'
    sete al
    pop rdi
    ret

print_fmt:
    ; rdi=msg, rsi=filename
    mov rdx, 255
    syscall
    ret

getchar:
    mov eax, 0       ; syscall: read
    mov edi, 0       ; stdin
    mov rsi, input
    mov edx, 1
    syscall
    mov al, byte [input]
    ret

section .data
msg db "Delete ", 0
input db 0

