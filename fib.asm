section .data
	msg db "How many numbers do you want to add? ",0
	defaultMax equ 75
	sys_exit equ 60
	sys_write equ 1
	sys_read equ 0
	std_out equ 1
	std_in equ 0

section .bss
	maxnum resb 100		; user input for maximum number
	strBuffer resb 100	; 100 bytes for integer conversion
	strBufferPos resb 8	; 8 bytes for array position
	r1 resb 8;
	r2 resb 8

section .text
	global _start

_start:
	mov rax, msg	; print welcome messagee
	call _printString
	mov rax, defaultMax
	call _printInt
	;call _getMaxNum
	call _fibonacci
	call _quit

_fibonacci:
	mov [r1], DWORD 0 
	mov [r2], DWORD 1 	; start with numbers 0 and 1
	mov rbx, 0 		; set counter to 0

_fibonacciLoop:
	mov rax, [r1]	; mov r1 value to rax
	add rax, [r2]	; add r1 + r2

	mov rdx, [r2]	; mov r2 to rdx
	mov [r1], rdx	; then mov value to r1

	push rbx		; push counter to stack
	mov [r2], rax	; mov result to r2
	call _printInt	; print result from rax

	pop rbx			; get counter from stack
	inc rbx			; increment counter
	cmp rbx, defaultMax ; if counter == max
	jl _fibonacciLoop	; countinue Loop

	ret					; else return

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
	mov rcx, strBuffer		; move adress of buffer to rcx
	mov rbx, 10				; new line character
	mov [rcx], rbx			; add new line character first position of array
	inc rcx					; increment adress after adding cr
	mov [strBufferPos], rcx	; set array position to second element in strBuffer

; convert ints to char
; store to strBuffer in reversed order
_printIntLoop:
	mov rdx, 0 			; set rdx to zero before division
	mov rbx, 10			; move divisor to rbx
	div rbx				; divide rax by 10
	push rax			; push result to stack
	add rdx, 48			; remainder + 48 = ascii code for one integer
	
	mov rcx, [strBufferPos] 	; current position in array
	mov [rcx], dl			; move char (lower 8 bytes of rdx) to array
	inc rcx					; increment position
	mov [strBufferPos], rcx	; update pointer to array Position

	pop rax				; pop division result from stack
	cmp rax, 0			; if division result !=0
	jne _printIntLoop	; continue loop

; print chars in strBuffer in corret order to std
_printIntLoop2: 
	mov rcx, [strBufferPos]	; move last char to rcx

	mov rax, sys_write
	mov rdi, std_out
	mov rsi, rcx			; pointer to last char
	mov rdx, 1				; 1 byte
	syscall

	mov rcx, [strBufferPos]
	dec rcx					; decrement array pointer
	mov [strBufferPos], rcx	; update array pointer

	cmp rcx, strBuffer		; if array position >= start of int bffer
	jge _printIntLoop2		; continue printing

	ret

_quit:
	mov rax, sys_exit	; system call
	mov rdi, 0			; errorcode
	syscall				; sys_exit(0)
