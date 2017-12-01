; fibonacci.asm
%include 'print-linux-x86_64.asm'	; include sprint, iprint, etc ...

section .data
	msg db "How many numbers do you want to add? ",0
	ofErrorMsg db "<< Overflow Exit program >>",10,0
	exitMsg db "- Done -",10,0
	defaultMax equ 20
	sys_exit equ 60
	sys_write equ 1
	sys_read equ 0
	std_out equ 1
	std_in equ 0
	
section .bss
	inputBuffer resb 64		; user input for maximum number
	strBuffer resb 64		; 100 bytes for integer conversion
	strBufferPos resb 8		; 8 bytes for array position

section .text
	global _start

%macro exit 1
	mov rax, sys_exit
	mov rdi, %1
	syscall
%endmacro

_start:
	mov rax, msg			; print welcome messagee
	call _sprint

	mov rax, defaultMax		; print default max
	call _printInt

	call _fibonacci			; calculate fibonacci

	mov rax, exitMsg
	call _sprint

	exit 0				; call macro exit(0)

; output: calculating fibonacci numbers with a given limit
_fibonacci:
	mov r8, QWORD 0 
	mov r9, QWORD 1			; start with numbers 0 and 1
	mov rbx, defaultMax		; set counter to max, decrement later

.fibonacciLoop:
	mov rax, QWORD r8	
	adc rax, r9			; add r8 + r9 and move result to rax for output
	mov r8, QWORD r9		; use r9 as first parameter next time
	mov r9, QWORD rax		; use result as second parameter next time

	jo _exitOF			; exit when overflow happens

	push rbx			; safe counter in stack
	call _printInt			; print result from rax

	pop rbx				; get counter from stack
	sub rbx, 1			; decrement counter
	jnz .fibonacciLoop		; countinue loop if rbx > 0 

	ret				; else return

;read 100 bytes in put from std_in
;output: set maxmimum number of fibonacci numbers
_getMaxNum:
	mov rax, sys_read
	mov rdi, std_in
	mov rsi, inputBuffer
	mov rdx, 8
	syscall				; sys_read(std_in, inputBuffer, 8)
	ret

; input: rax = integer to print
; output: print integers as string to std_out
_printInt:
	mov rcx, strBuffer		; move adress of buffer to rcx
	mov rbx, 10			; new line character
	mov [rcx], rbx			; add new line character first position of array
	inc rcx				; increment adress after adding cr
	mov [strBufferPos], rcx		; set array position to second element in strBuffer

; convert ints to char
; store to strBuffer in reversed order
.printIntLoop:
	xor rdx, rdx			; set rdx (remainder) to zero before division
	mov rbx, 10			; move divisor to rbx
	div rbx				; divide rax by 10
	push rax			; push result to stack
	add rdx, 48			; remainder + 48 = ascii code for one integer
	
	mov rcx, [strBufferPos]		; current position in array
	mov [rcx], dl			; move char (lower 8 bytes of rdx) to array
	inc rcx				; increment position
	mov [strBufferPos], rcx		; update pointer to array Position

	pop rax				; pop division result from stack
	or rax, rax			; if division result !=0
	jnz .printIntLoop		; continue loop

; print chars in strBuffer in corret order to std
.printIntLoop2: 
	mov rcx, [strBufferPos]		; move last char to rcx

	mov rax, sys_write
	mov rdi, std_out
	mov rsi, rcx			; pointer to last char
	mov rdx, 1			; 1 byte
	syscall

	mov rcx, [strBufferPos]
	dec rcx				; decrement array pointer
	mov [strBufferPos], rcx		; update array pointer

	cmp rcx, strBuffer		; if array position >= start of int bffer
	jge .printIntLoop2		; continue printing

	ret

_exitOF:
	mov rax, ofErrorMsg
	call _sprint		; print error message
	exit 1				; call macro exit(1)
