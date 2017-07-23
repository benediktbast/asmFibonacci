section .data
	welcome db "How many numbers do you want to add?",0
	defaultMax db 20
	sys_exit equ 60
	sys_write equ 1
	sys_read equ 0
	std_out equ 1
	std_in equ 0

section .bss
	maxnum resb 8		; user input for maximum number

section .text
	global _start

_start:
	mov rax, welcome
	call _printString	; print welcom message
	call _getMaxNum
	call _quit

;read 8 bytes in put from std_in
;output: set maxmimum number of fibonacci numbers
_getMaxNum:
	mov rax, sys_read
	mov rdi, std_in
	mov rsi, maxnum
	mov rdx, 8
	syscall				;sys_read(std_in, maxnum, 8)
	ret

;input: rax as pointer to string
;output: print string at rax to std_out
_printString:
	push rax
	mov rbx, 0			; counter for print loop

_printLoop:
	inc rax				; inrecment string pointer
	inc rbx				; increment counter
	mov cl, [rax]		; mov current char to 8 bit equiv of rcx
	cmp cl, 0			; check for null terminator
	jne _printLoop		; continue loop

	mov rax, sys_write
	mov rdi, std_out
	pop rsi				; get string from stack
	mov rdx, rbx
	syscall				; sys_write(std_out, string, rbx)
	ret

_quit:
	mov rax, sys_exit	; system call
	mov rdi, 0			; errorcode
	syscall				; sys_exit(0)
