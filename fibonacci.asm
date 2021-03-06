; fibonacci.asm
%include './lib/print-linux-x86_64.asm'	; include sprint, iprint, etc ...
%include './lib/sysexit-macros.asm'	; inlude sysexit macros
%define sys_write  	1
%define std_out  	1
%define sys_read	0
%define std_in		0

section .data
	msg db 'How many numbers do you want to add? ',0
	ofErrorMsg db '<< Overflow Exit program >> ',0
	exitMsg db "- Done -",0
	fontRed db 0x1b,'[31m',0
	fontGreen db 0x1b,'[32m',0
	fontReset db 0x1b,'[0m',0
	defaultMax equ 24
	
section .bss
	inputBuffer resb 64		; user input for maximum number

section .text
	global _start


_start:
	mov rax, msg			; print welcome messagee
	call _sprint

	mov rax, defaultMax		; print default max
	call _iprintln

	call _fibonacci			; calculate fibonacci

	mov rax, fontGreen
	call _sprint

	mov rax, exitMsg
	call _sprintln

	mov rax, fontReset
	call _sprint

	exit 0				; call macro exit(0)

;------------------------------------------------
; output: calculating fibonacci numbers with a given limit
;------------------------------------------------
_fibonacci:
	mov rax,  1			; param 2
	mov rdx,  0			; param 1
	mov rcx, defaultMax		; set counter to max, decrement later

.fibonacciLoop:
	push rax			; save param 2 on stack
	adc rax, rdx			; param 2 = param 2 + param 1
	pop rdx				; save as new param 1
	jo _exitOF			; exit when overflow happens

	push rax			; save rax
	call _iprintln			; print result from rax
	pop rax				; restore rax

	sub rcx, 1			; decrement counter
	jnz .fibonacciLoop		; countinue loop if rbx > 0 

	ret				; else return

;------------------------------------------------
;read 100 bytes in put from std_in
;output: set maxmimum number of fibonacci numbers
;------------------------------------------------
_getMaxNum:
	mov rax, sys_read
	mov rdi, std_in
	mov rsi, inputBuffer
	mov rdx, 8
	syscall				; sys_read(std_in, inputBuffer, 8)
	ret

;------------------------------------------------
; exit with error message and exit code 1
;------------------------------------------------
_exitOF:
	mov rax, fontRed
	call _sprint

	mov rax, ofErrorMsg
	call _sprintln			; print error message

	mov rax, fontReset
	call _sprint

	exit 1				; call macro exit(1)
