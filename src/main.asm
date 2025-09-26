%include "config.asm"
%include "prompt.asm"

section .text
global _start

_start:
    mov rsi, [rsp+16] ; argv[1]
    mov rdi, [rsp+24] ; argv[2]
    call parse_flags

    mov rbx, target_files
.next_file:
    mov rdi, [rbx]
    test rdi, rdi
    jz .done

    call file_exists
    test eax, eax
    jz .skip

    cmp byte [dry_run], 1
    je .report

    cmp byte [auto_yes], 1
    je .delete

    call should_delete
    test al, al
    jz .skip

.delete:
    ; syscall unlink
    mov rax, 87
    mov rdi, [rbx]
    syscall
    jmp .skip

.report:
    mov rdi, [rbx]
    call print_name

.skip:
    add rbx, 8
    jmp .next_file

.done:
    mov rax, 60
    xor edi, edi
    syscall

parse_flags:
    mov byte [auto_yes], 0
    mov byte [dry_run], 0
    cmp rsi, 0
    je .ret
    mov rdi, rsi
    call cmp_flag_yes
    cmp eax, 1
    sete byte [auto_yes]
    call cmp_flag_dry
    cmp eax, 1
    sete byte [dry_run]
.ret:
    ret

cmp_flag_yes:
    mov rsi, flag_yes
    call strcmp
    ret
cmp_flag_dry:
    mov rsi, flag_dry
    call strcmp
    ret

strcmp:
.loop:
    mov al, byte [rdi]
    mov bl, byte [rsi]
    cmp al, bl
    jne .diff
    test al, al
    je .eq
    inc rdi
    inc rsi
    jmp .loop
.eq:
    mov eax, 1
    ret
.diff:
    xor eax, eax
    ret

file_exists:
    ; rdi = filename
    mov rax, 21 ; access
    mov rsi, 0  ; F_OK
    syscall

    cmp eax, 0
    sete al
    movzx eax, al
    ret

print_name:
    mov rsi, rdi
    mov rdi, prefix
    call print_fmt
    call putnl
    ret

section .data
flag_yes db "--yes", 0
flag_dry db "--dry-run", 0
prefix db "[found] ", 0

auto_yes db 0
dry_run db 0
