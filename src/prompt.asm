; prompt.asm

section .text
global should_delete
global print_fmt
global putnl

; Ask user for confirmation: prints "Delete <file>? [y/N] " and waits key
should_delete:
    push rdi                ; save filename in stack
    mov rsi, rdi            ; rsi = filename
    mov rdi, msg            ; rdi = prefix message
    call print_fmt          ; print prefix + filename
    mov rdi, ask            ; print suffix prompt
    call write_str
    call getchar
    cmp al, 'y'
    sete al
    pop rdi                 ; restore filename to rdi
    ret

; Print rdi (prefix) then rsi (filename), no newline
; rdi = cstr prefix, rsi = cstr filename
print_fmt:
    push rsi
    call write_str
    pop rdi
    jmp write_str

; Write a single newline to stdout
putnl:
    mov rdi, nl
    jmp write_str

; Write zero-terminated string at rdi to stdout
; Clobbers rax, rdi, rsi, rdx, rcx
write_str:
    push rdi
    ; find length in rdx
    xor rcx, rcx
.len_loop:
    cmp byte [rdi+rcx], 0
    je .len_done
    inc rcx
    jmp .len_loop
.len_done:
    mov rdx, rcx
    pop rsi                ; rsi = buf
    mov eax, 1             ; write
    mov edi, 1             ; fd = stdout
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
ask db "? [y/N] ", 0
nl db 10, 0
input db 0
