; atoi.asm
%include './lib/print-linux-x86_64.asm'	; include sprint, iprint, etc ...
%include './lib/sysexit-macros.asm'	; include sysexit macros
%include './lib/atoi-linux-x86_64.asm'  ; include atio function
%define sys_write  	1
%define std_out  	1
%define sys_read	0
%define std_in		0

section .data
	msg db '24 + 1 = ',0
	string db '24',0
	
section .bss
	inputBuffer resb 64		; user input for maximum number

section .text
	global _start


_start:

	mov rax, msg
	call _sprint

	mov rsi, string			; string pointer to rsi
	call _atoi

	add rax, 1			; add one rax to check the result
	call _iprintln

	exit 0
