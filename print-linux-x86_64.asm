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

_sprintln:
	call _sprint
	
	push rax
	mov rax, 10
	push rax
	mov rax, rsp
	call _sprint
	
	ret
