section .data
	msg db "How many numbers do you want to add? ",0
	defaultMax equ 90
	sys_exit equ 60
	sys_write equ 1
	sys_read equ 0
	std_out equ 1
	std_in equ 0

section .bss
	maxnum resb 100		; user input for maximum number
	strBuffer resb 100	; 100 bytes for integer conversion
	strBufferPos resb 8	; 8 bytes for array position

section .text
	global _start

_start:
	mov rax, msg		; print welcome messagee
	call _printString

	mov rax, defaultMax ; print default max
	call _printInt

	call _fibonacci		; calculate fibonacci

	mov rax, sys_exit	; exit(0)
	mov rdi, 0
	syscall

; output: calculating fibonacci numbers with a given limit
_fibonacci:
	mov r8, QWORD 0 
	mov r9, QWORD 1 	; start with numbers 0 and 1
	mov rbx, defaultMax ; set counter to 0

_fibonacciLoop:
	mov rax, QWORD r8	
	adc rax, r9			; add r8 + r9 and move result to rax for output
	mov r8, QWORD r9	; use r9 as first parameter next time
	mov r9, QWORD rax	; use result as second parameter next time

	push rbx			; safe counter in stack
	call _printInt		; print result from rax

	pop rbx				; get counter from stack
	sub rbx, 1			; decrement counter
	jnz _fibonacciLoop	; countinue loop if rbx > 0 

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
	xor rdx, rdx 		; set rdx (remainder) to zero before division
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
