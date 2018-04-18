%include './lib/print-linux-x86_64.asm'	; include sprint, iprint, etc ...
%include './lib/sysexit-macros.asm'	; include sysexit macros

%define whitespace	32		; ascii code whitespace

section .data

	i	equ 8			; integer to test with

section .text
	global _start


_start:
	mov eax, i
	call _iprintln

	mov eax, i
	call _binaryprint32

	exit 0				; call macro exit(0)

;------------------------------------------------
; procedure to binary print an integer on screen
; currently the bits get printed in reversed order
; input: integer value in EAX
;------------------------------------------------

_binaryprint32:
	mov rcx, 0x20			; counter for 32 bits
.loop:
	push rax			; save value

	and eax, 0x1			; mask lowest bit
	add eax, 0x30			; add 48 to get ascii for 0 or 1
	call _cprint			; print 0 or 1

	pop rax				; restore value
	shr eax, 0x1			; rightshift value by 1

	dec rcx				; decerment counter
	jnz .loop			; if not zero loop again

	call _printcrlf
	ret
