section .data
	buffer: times 256 db 0	; buffer of memory

section .text
	global _start

_start:
	mov rbx, 0	; mem pointer

	mov rsi, buffer
	add rsi, rbx
	add byte [rsi], 0x41; Add 0x41 to buffer[mem pointer]

	call write_byte

	add bl, 1	; increment mem pointer mod 256

	mov rsi, buffer
	add rsi, rbx
	add byte [rsi], 0x43; Add 0x43 to buffer[mem pointer]

	call write_byte

;	call read_byte
;	call write_byte

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
