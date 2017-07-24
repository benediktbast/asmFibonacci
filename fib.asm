section .data
	welcome db "How many numbers do you want to add? ",0
	defaultMax equ 1337
	sys_exit equ 60
	sys_write equ 1
	sys_read equ 0
	std_out equ 1
	std_in equ 0

section .bss
	maxnum resb 100		; user input for maximum number
	intSpace resb 100	; 100 bytes for integer conversion
	intSpacePos resb 8	; 8 bytes for array position

section .text
	global _start

_start:
	mov rax, welcome	; print welcome messagee
	call _printString
	mov rax, defaultMax
	call _printInt
	;call _getMaxNum
	call _quit

;read 100 bytes in put from std_in
;output: set maxmimum number of fibonacci numbers
_getMaxNum:
	mov rax, sys_read
	mov rdi, std_in
	mov rsi, maxnum
	mov rdx, 100
	syscall				; sys_read(std_in, maxnum, 8)
	ret

;input: rax = pointer to string
;output: print null terminated string at rax to std_out
_printString:
	push rax
	mov rbx, 0			; counter for print loop

_printStringLoop:
	inc rax				; inrecment string pointer
	inc rbx				; increment counter
	mov cl, [rax]		; mov current char (8 bit) to rcx
	cmp cl, 0			; check for null terminator
	jne _printStringLoop; continue loop

	mov rax, sys_write
	mov rdi, std_out
	pop rsi				; get string from stack
	mov rdx, rbx		; length of string = counter
	syscall				; sys_write(std_out, string, rbx)
	ret

; input: rax = integer to print
; output: print integers as string to std_out
_printInt:
	mov rcx, intSpace		; move adress of integer buffer to rcx
	mov rbx, 10				; new line character
	mov [rcx], rbx			; add new line character first position of array
	inc rcx					; increment adress after adding cr
	mov [intSpacePos], rcx	; update array position

_printIntLoop:
	mov rdx, 0 			; set rdx to zero before division
	mov rbx, 10			; move divisor to rbx
	div rbx				; divide rax by 10
	push rax			; push result to stack
	add rdx, 48			; remainder + 48 = ascii code for one integer
	
	mov rcx, [intSpacePos] 	; current position in array
	mov [rcx], dl			; move char (lower 8 bytes of rdx) to array
	inc rcx					; increment position
	mov [intSpacePos], rcx	; update pointer to array Position

	pop rax				; pop division result from stack
	cmp rax, 0			; if division result !=0
	jne _printIntLoop	; continue loop

; string is now in reversed order
; print in correct order
_printIntLoop2: 
	mov rcx, [intSpacePos]	; move last char to rcx

	mov rax, sys_write
	mov rdi, std_out
	mov rsi, rcx			; pointer to last char
	mov rdx, 1				; 1 byte
	syscall

	mov rcx, [intSpacePos]
	dec rcx					; decrement array pointer
	mov [intSpacePos], rcx	; update array pointer

	cmp rcx, intSpace		; if array position >= start of int bffer
	jge _printIntLoop2		; continue printing

	ret

_quit:
	mov rax, sys_exit	; system call
	mov rdi, 0			; errorcode
	syscall				; sys_exit(0)
