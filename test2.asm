section .data
	buffer: times 256 db 0	; buffer of memory

section .text
	global _start

_start:
	mov rbx, 0	; mem pointer

	mov rsi, buffer
	add rsi, rbx
	add byte [rsi], 72
	call write_byte
	mov rsi, buffer
	add rsi, rbx
	add byte [rsi], 29
	call write_byte
	mov rsi, buffer
	add rsi, rbx
	add byte [rsi], 7
	call write_byte
	call write_byte
	mov rsi, buffer
	add rsi, rbx
	add byte [rsi], 3
	call write_byte
	mov rax, 60	; id syscall sys_exit
	mov rdi, 0	; arg 1 de sys_exit (exit code)
	syscall

read_byte:
	mov rax, 0	; sys_read
	mov rdi, 0	; fd STDIN

	mov rsi, buffer
	add rsi, rbx	; buffer + pointeur

	mov rdx, 1	; len
	syscall
	ret

write_byte:
	mov rax, 1	; sys_write
	mov rdi, 1	; fd STDOUT

	mov rsi, buffer
	add rsi, rbx	; buffer + pointeur

	mov rdx, 1	; len
	syscall
	ret

