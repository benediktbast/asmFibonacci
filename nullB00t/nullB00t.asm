[BITS 16]				; 16 bit code
[ORG 0x7C00]				; load  code to memory 0x7C00

_start:

	mov ax, 0x7C00			; 4K stack space after the bootloader
	add ax, 0x120			; 4096b + 512b (bl size) / 16b per frame
	mov ss, ax			; set stack space
	mov sp, 0x1000			; set stack pointer to offset 4096

	mov bp, sp			; set base pointer

	call _clearScreen		; redraw screen
	
	call _printNullMessage		; print welcome message

	jmp $

;---------------------------------------------------------------
; print ascii welcome message on screen
;---------------------------------------------------------------
_printNullMessage:

	push bp				; save base pointer
	mov bp, sp			; access arguments

	mov si, NullMsg1		; move string into SI
	push 0x8			; use row 0x8
	call _printCenteredString	; print centered string
	
	mov si, NullMsg2
	push 0x9
	call _printCenteredString
	
	mov si, NullMsg3
	push 0xa
	call _printCenteredString

	mov si, NullMsg4
	push 0xb
	call _printCenteredString

	mov si, NullMsg5
	push 0xc
	call _printCenteredString

	mov si, NullMsg6
	push 0xd
	call _printCenteredString

	leave				; restore BP and SP
	ret

;---------------------------------------------------------------
; procedure to move video outpout to a given poisition
; input : dl = x position
; input : dh = y poisition
;---------------------------------------------------------------
_setCursorPosition:
	mov ah, 0x2			; move cursor in video buffer
	int 0x10			; call video interrupt
	ret

;---------------------------------------------------------------
; procedure to move video output to position 0,0
;---------------------------------------------------------------
_resetCursorPosition:
	mov dl, 0x0			; set x = 0
	mov dh, 0x0			; set y = 0
	call _setCursorPosition		; set position
	ret

;---------------------------------------------------------------
; procedure to redraw screen in blue color
;---------------------------------------------------------------
_clearScreen:
	call _resetCursorPosition	; reset cursor to 0,0
	mov ah, 0x9			; subfunction write char and attr at cursor
	mov cx, 0x1000			; 4096 bytes
	mov al, 0x20			; white space
	mov bl, 0x17			; text attribute: grey font, blue bg
	int 0x10			; call video interrupt
	ret

;---------------------------------------------------------------
; procedure to get length of an null terminated string
; input: char pointer in SI
; output: length of string in AL
;---------------------------------------------------------------
_slen:
	push bx				; save BX
	mov bx, si			; save adress of first char to BX
	
.next:
	cmp byte [bx], 0 		; if char is null
	jz .done			; exit function
	inc bx				; increment adress
	jmp .next			; next char

.done:
	sub bx, si			; first adress - last adress
	mov al, bl			; use BL as return value
	pop bx				; restore BX
	ret

;---------------------------------------------------------------
; procedure to print one char to the string
; input: ascii value in AL
;---------------------------------------------------------------
_printchar:
	mov ah, 0x0E			; subfunction: write char in tty mode
	mov bh, 0x00			; page no
	mov bl, 0x07			; text attribute: grey font, black bg
	int 0x10			; call video interrupt
	ret				; exit

;---------------------------------------------------------------
; procedure to print a null terminated String on screen
; input: char pointer in SI
;---------------------------------------------------------------
_sprint:

.next:
	lodsb				; get char from si an inc
	or al, al			; if AL contains null
	jz .done	 		; exit
	call _printchar 		; print AL to screen
	jmp .next			; next char

.done:
	ret				; exit

;---------------------------------------------------------------
; procedure to print a horizontally aligned string
; input : string pointer in SI
; arg #1 : 1 byte - row number to print string
;---------------------------------------------------------------
_printCenteredString:

	push bp				; save base pointer
	mov bp, sp			; set base pointer

	push ax				; save AX
	push bx				; save BX
	push dx				; save DX
	
	call _slen			; get length of string in SI
	cmp al, 0x50			; check if str len > 80
	jg .errorTooLong		; handle error
	mov bl, al			; mov str len to BL

	xor dx, dx			; set remainder to 0
	mov ax, 0x50			; 80 columns per line
	sub ax, bx			; subtract line length - string length

	mov bx, 0x2			; divisor = 2
	div bx				; divide ax by 2

	mov dl, al			; move x offset to DL
	mov dh, BYTE [bp+4]		; move y offset to DH, arg #1

.success:
	call _setCursorPosition 	; set cursorpition
	call _sprint			; print string now
	call .done

.errorTooLong:				; print text at col 0
	mov dl, 0x0			; move x offset to DL
	mov dh, BYTE [bp+4]		; move y offset to DH, arg #1
	call .success			; exit normally

.done:
	pop dx				; restore DX
	pop bx				; restore AX
	pop ax				; restore BX
	leave				; restore BP and SP
	ret

; data
NullMsg1 db 219,219,219,187,219,219,219,187, 32, 32, 32,219,219,187,219,219,187, 32, 32, 32,219,219,187,219,219,187, 32, 32, 32, 32, 32,219,219,187, 32, 32, 32, 32, 32,219,219,219,187,0
NullMsg2 db 219,219,201,188,219,219,219,219,187, 32, 32,219,219,186,219,219,186, 32, 32, 32,219,219,186,219,219,186, 32, 32, 32, 32, 32,219,219,186, 32, 32, 32, 32, 32,200,219,219,186,0
NullMsg3 db 219,219,186, 32,219,219,201,219,219,187, 32,219,219,186,219,219,186, 32, 32, 32,219,219,186,219,219,186, 32, 32, 32, 32, 32,219,219,186, 32, 32, 32, 32, 32, 32,219,219,186,0
NullMsg4 db 219,219,186, 32,219,219,186,200,219,219,187,219,219,186,219,219,186, 32, 32, 32,219,219,186,219,219,186, 32, 32, 32, 32, 32,219,219,186, 32, 32, 32, 32, 32, 32,219,219,186,0
NullMsg5 db 219,219,219,187,219,219,186, 32,200,219,219,219,219,186,200,219,219,219,219,219,219,201,188,219,219,219,219,219,219,219,187,219,219,219,219,219,219,219,187,219,219,219,186,0
NullMsg6 db 200,205,205,188,200,205,188, 32, 32, 32,200,205,205,188, 32,200,205,205,205,205,205,188, 32,200,205,205,205,205,205,205,188,200,205,205,205,205,205,205,188,200,205,205,188,0

TIMES 510 - ($ - $$) db 0		; fill up with 0 to reach 512KB
DW 0xAA55				; boot signature at the
