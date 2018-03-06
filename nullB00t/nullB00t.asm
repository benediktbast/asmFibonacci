[BITS 16]				; 16 bit code
[MAP SYMBOLS nullB00t.map]
[ORG 0x7C00]				; load  code to memory 0x7C00

_start:

	mov ax, 0x7C00			; 4K stack space after the bootloader
	add ax, 0x120			; 4096b + 512b (bl size) / 16b per frame
	mov ss, ax			; set stack space
	mov sp, 0x1000			; set stack pointer to offset 4096

	mov bp, sp			; set base pointer

	call _clearScreen		; redraw screen
	
	call _printWelcomeMsg		; print welcome message

	jmp $

;---------------------------------------------------------------
; print ascii welcome message on screen
;---------------------------------------------------------------
_printWelcomeMsg:

	push bp				; save base pointer
	mov bp, sp			; access arguments

	push 0x8			
	call _moveCursorToLine		; write message to line 8
	mov si, Msg1			; move string into SI
	call _printCenteredString	; print centered string
	
	call _nextLine
	mov si, Msg2
	call _printCenteredString

	leave				; restore BP and SP
	ret

;---------------------------------------------------------------
; procedure to move video outpout to a given poisition
; input : dl = x position
; input : dh = y poisition
;---------------------------------------------------------------
_setCursorPosition:
	call _updateCursorPosition	; update position
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
; position to save save current Cursor Position
; input : dl = x position
; input : dh = y position
;---------------------------------------------------------------
_updateCursorPosition
	mov [cursorX], dl
	mov [cursorY], dh
	ret

;---------------------------------------------------------------
; procedure to move cursor to the next line
;---------------------------------------------------------------
_nextLine:
	push dx

	mov dl, [cursorX]		; use current X position
	mov dh, [cursorY]		; load current Y position
	inc dh	
	; TODO: use generic function !
	;call _moveCursorToLine
	call _setCursorPosition		; set and update cursor

	pop dx
	ret

;---------------------------------------------------------------
; procedure to move cursor to a certain line
; arg #1 : 1 byte - row number to print string
;---------------------------------------------------------------
_moveCursorToLine:
	push bp				; save base pointer
	mov bp, sp			; set base pointer

	push ax				; save AX
	push bx				; save BX
	push dx				; save DX

	mov dl, [cursorX]		; use current X position
	mov dh, BYTE [bp+4]		; get new Y position from arg #1
	call _setCursorPosition		; set and update cursor

	pop dx				; restore DX
	pop bx				; restore AX
	pop ax				; restore BX
	leave				; restore BP and SP
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
	mov dh, [cursorY]		; get current cursor y position 

.success:
	call _setCursorPosition 	; set cursor postion
	call _sprint			; print string now
	call .done

.errorTooLong:				; print text at col 0
	mov dl, 0x0			; move x offset to DL
	mov dh, [cursorY]		; move y offset to DH,
	call .success			; exit normally

.done:
	pop dx				; restore DX
	pop bx				; restore AX
	pop ax				; restore BX
	leave				; restore BP and SP
	ret

; data
cursorX resb 1				; cursor X Pposition
cursorY resb 1				; cursor Y position
cursorP resb 1				; current page

Msg1 db "NullB00t",0
Msg2 db "Bootloader Example",0


;NullMsg1 db 219,219,219,187,219,219,219,187, 32, 32, 32,219,219,187,219,219,187, 32, 32, 32,219,219,187,219,219,187, 32, 32, 32, 32, 32,219,219,187, 32, 32, 32, 32, 32,219,219,219,187,0
;NullMsg2 db 219,219,201,188,219,219,219,219,187, 32, 32,219,219,186,219,219,186, 32, 32, 32,219,219,186,219,219,186, 32, 32, 32, 32, 32,219,219,186, 32, 32, 32, 32, 32,200,219,219,186,0
;NullMsg3 db 219,219,186, 32,219,219,201,219,219,187, 32,219,219,186,219,219,186, 32, 32, 32,219,219,186,219,219,186, 32, 32, 32, 32, 32,219,219,186, 32, 32, 32, 32, 32, 32,219,219,186,0
;NullMsg4 db 219,219,186, 32,219,219,186,200,219,219,187,219,219,186,219,219,186, 32, 32, 32,219,219,186,219,219,186, 32, 32, 32, 32, 32,219,219,186, 32, 32, 32, 32, 32, 32,219,219,186,0
;NullMsg5 db 219,219,219,187,219,219,186, 32,200,219,219,219,219,186,200,219,219,219,219,219,219,201,188,219,219,219,219,219,219,219,187,219,219,219,219,219,219,219,187,219,219,219,186,0
;NullMsg6 db 200,205,205,188,200,205,188, 32, 32, 32,200,205,205,188, 32,200,205,205,205,205,205,188, 32,200,205,205,205,205,205,205,188,200,205,205,205,205,205,205,188,200,205,205,188,0


TIMES 510 - ($ - $$) db 0		; fill up with 0 to reach 512KB
DW 0xAA55				; boot signature at the
