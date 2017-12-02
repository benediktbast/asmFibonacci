%define crlf 		0xa			; ascii code crlf
%define std_out 	1			; std_out for linux syscall
%define sys_write	1			; sys_wirte for linux syscall

;------------------------------------------------
; procedure to calculate the length of a string
; input: string pointer in RAX
; output: length of string to RAX
;------------------------------------------------
_slen:
	push rbx				; save RBX
	mov rbx, rax				; rbx points to the string too
.next:
	cmp byte [rax], 0			; if char on current poisition is null
	jz .done				; exit function
	inc rax					; increment pointer
	jmp .next				; continue 

.done:
	sub rax, rbx				; len = last position - first position 
	pop rbx					; restore RBX
	ret


;------------------------------------------------
; procedure to print a string
; input: string pointer in RAX
;------------------------------------------------
_sprint:
	push rax				; save registers
	push rbx 
	push rcx
	push rdx

	push rax				; push again, to last position of stack
	
	call _slen				; get string length

	mov rdx, rax				; length of string
	pop rsi					; pop string pointer so RSI
	mov rax, 1				; sys_write
	mov rdi, 1				; std out
	syscall

	pop rdx					; restore registers
	pop rcx
	pop rbx
	pop rax

	ret


;------------------------------------------------
; procedure to print an string 
; and a crlf
; input: string pointer in RAX
;------------------------------------------------
_sprintln:
	call _sprint				; print integer
	call _printcrlf				; print crlf

	ret


;------------------------------------------------
; procedure to print an integer on screen
; input: integer value in RAX
;------------------------------------------------
_iprint:
	push rax				; save registers
	push rcx
	push rdx
	push rsi

	xor rcx, rcx				; set counter to zero

.itao:
	inc rcx					; increment counter
	xor rdx, rdx				; set remainder to zero
	mov rsi, 10				; divisor
	idiv rsi				; rax / 10
	add rdx, 48				; remainder + 48 = asii representation
	push rdx				; push char to stack
	cmp rax, 0				; test if division result = 0
	jnz .itao				; if !=0 continue

.print:
	dec rcx					; decrement counter
	mov QWORD rax, [rsp]			; mov char on current stack position to RAX
	call _cprint				; print that char
	pop rax					; remove char from stack
	cmp rcx, 0				; check counter for 0
	jnz .print				; if counter !=0 print next char
	
	pop rsi					; restore registers
	pop rdx
	pop rcx
	pop rax

	ret


;------------------------------------------------
; procedure to print an integer 
; and a crlf
; input: integer value in RAX
;------------------------------------------------
_iprintln:
	call _iprint				; print integer
	call _printcrlf				; print crlf

	ret


;------------------------------------------------
; procedure to print a crlf on screen
;------------------------------------------------
_printcrlf:
	push rax
	
	mov rax, 0xa				; ascii code crlf
	call _cprint				; print char

	pop rax					; restore original RAX
	
	ret


;------------------------------------------------
; procedure to print one singe char to screen
; input: char in RAX
;------------------------------------------------
_cprint:
	push rbx				; save registers
	push rcx
	push rdx
	
	push rax				; push RAX to get a pointer to the char

	mov rdx, 1				; print one byte
	mov rsi, rsp				; pop adress of char to  RSI
	mov rax, 1				; sys_write
	mov rdi, 1				; std out
	syscall
	
	pop rax					; restore RAX

	pop rdx					; restore registers
	pop rcx
	pop rbx

	ret
