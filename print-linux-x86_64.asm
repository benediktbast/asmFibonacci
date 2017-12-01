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
	sub rax, rbx				; last position - first position 
	pop rbx					; restore RBX
	ret

;------------------------------------------------
; procedure to print a string
; input: string pointer in RAX
;------------------------------------------------
_sprint:
	push rdx
	push rcx
	push rbx
	push rax

	call _slen				; get string length

	mov rdx, rax				; length of string
	pop rsi					; pop string pointer so RSI
	mov rax, 1				; sys_write
	mov rdi, 1				; std out
	syscall

	pop rbx
	pop rcx
	pop rdx

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
	push rax
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
	mov rax, rsp				; stack pointer = beginning of string
	call _sprint
	pop rax					; remove char from stack
	cmp rcx, 0				; if counter = 0
	jnz .print				; if counter !=0 print next char
	
	pop rsi
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
; procedure to print an crlf on screen
;------------------------------------------------
_printcrlf:
	push rax
	mov rax, 10				; ascci = crlf
	
	push rax				; push rax to get a pointer to the char
	mov rax, rsp				; move adress of char to rax
	call _sprint				; call string print

	pop rax					; remove char
	pop rax					; restore original rax

	ret
