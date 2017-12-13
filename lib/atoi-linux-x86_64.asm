;------------------------------------------------
; procedure to convert a string to integer
; input: string pointer in RAX
; output; integer value in RAX
;------------------------------------------------
_atoi:
	push rsi			; save registers
	push rdx
	xor rax, rax			; set RAX to zero

.next:
	mov dl, byte [rsi]		; mov char RDX
	cmp dl, 0			; detect end of string
	jz .done

	imul rax, 10			; multiply result by 10 in every step
	sub rdx, 48			; convert ascii to integer
	add rax, rdx			; add to result
	inc rsi				; next char
	jmp .next

.done:
	pop rdx				; restore registers
	pop rsi
	ret
