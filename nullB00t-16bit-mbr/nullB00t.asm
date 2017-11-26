[BITS 16]				; 16 bit code
[ORG 0x7C00]				; load  code to memory 0x7C00

_nullBootMain:
	call _clearScreen		; redraw screeni
	
	call _printNullMessage		; print welcome message

	hlt				; halt cpu

_printNullMessage:
	mov cl, NullMsgLen
	call _hAlign
	mov dh, 0x9
	call _setCursorPosition

	mov si, NullMsg1
	call _printString
	
	mov cl, NullMsgLen
	call _hAlign
	mov dh, 0xa
	call _setCursorPosition

	mov si, NullMsg2
	call _printString
	
	mov cl, NullMsgLen
	call _hAlign
	mov dh, 0xb
	call _setCursorPosition

	mov si, NullMsg3
	call _printString

	mov cl, NullMsgLen
	call _hAlign
	mov dh, 0xc
	call _setCursorPosition

	mov si, NullMsg4
	call _printString

	mov cl, NullMsgLen
	call _hAlign
	mov dh, 0xd
	call _setCursorPosition

	mov si, NullMsg5
	call _printString

	mov cl, NullMsgLen
	call _hAlign
	mov dh, 0xe
	call _setCursorPosition

	mov si, NullMsg6
	call _printString
	
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
	mov ah, 0x9			; number of bytes defined in cx
	mov cx, 0x1000			; 4096 bytes
	mov al, 0x20			; white space
	mov bl, 0x17			; text attribute blue
	int 0x10			; call video interrupt
	ret

;---------------------------------------------------------------
; procedure to print one char to the string
; input: Ascii value in AL
;---------------------------------------------------------------
_printCharacter:
	mov ah, 0x0E		; print one char 
	mov bh, 0x00		; page no
	mov bl, 0x07		; text attribute lightgrey font on black
	int 0x10		; call video interrupt
	ret			; exit

;---------------------------------------------------------------
; procedure to Print a null terminated String on screen
; input: char pointer in SI
;---------------------------------------------------------------
_printString:

.nextChar:
	mov al, [si]		; store ascii value from SI to AL
	inc si			; increment pointer
	or al, al		; if AL contains null
	jz .exitPrintString 	; exit
	call _printCharacter 	; print AL to screen
	jmp .nextChar		; next char

.exitPrintString:
	ret			; exit

;---------------------------------------------------------------
; procedure to print a horizontally aligned string
; input : length of string in CL
; output: horizontal offset in DL
;---------------------------------------------------------------
_hAlign:
	xor dx, dx		; set remainder to 0
	mov ax, 0x50		; 80 columns per line
	sub ax, cx		; subtract line length - string length

	mov bx, 0x2		; divisor = 2
	div bx			; divide ax by 2

	mov dl, al		; move x offset to dl, do not change y offset
	
	ret

; data
WelcomeMsg db 'Hello World', 0
WelcomeMsgLen equ $-WelcomeMsg

NullMsg1 db 219,219,219,187,219,219,219,187, 32, 32, 32,219,219,187,219,219,187, 32, 32, 32,219,219,187,219,219,187, 32, 32, 32, 32, 32,219,219,187, 32, 32, 32, 32, 32,219,219,219,187,0
NullMsg2 db 219,219,201,188,219,219,219,219,187, 32, 32,219,219,186,219,219,186, 32, 32, 32,219,219,186,219,219,186, 32, 32, 32, 32, 32,219,219,186, 32, 32, 32, 32, 32,200,219,219,186,0
NullMsg3 db 219,219,186, 32,219,219,201,219,219,187, 32,219,219,186,219,219,186, 32, 32, 32,219,219,186,219,219,186, 32, 32, 32, 32, 32,219,219,186, 32, 32, 32, 32, 32, 32,219,219,186,0
NullMsg4 db 219,219,186, 32,219,219,186,200,219,219,187,219,219,186,219,219,186, 32, 32, 32,219,219,186,219,219,186, 32, 32, 32, 32, 32,219,219,186, 32, 32, 32, 32, 32, 32,219,219,186,0
NullMsg5 db 219,219,219,187,219,219,186, 32,200,219,219,219,219,186,200,219,219,219,219,219,219,201,188,219,219,219,219,219,219,219,187,219,219,219,219,219,219,219,187,219,219,219,186,0
NullMsg6 db 200,205,205,188,200,205,188, 32, 32, 32,200,205,205,188, 32,200,205,205,205,205,205,188, 32,200,205,205,205,205,205,205,188,200,205,205,205,205,205,205,188,200,205,205,188,0
NullMsgLen equ $-NullMsg6

TIMES 510 - ($ - $$) db 0	; fill up with 0 to reach 512KB
DW 0xAA55			; boot signature at the
