[BITS 16]				; 16 bit code
[ORG 0x7C00]				; load  code to memory 0x7C00

_nullBootMain:
	call _clearScreen		; redraw screen

	mov cl, WelcomeMsgLen		; move length of string to CL 
	call _hAlign			; find horzontal offset
	mov dh, 0x8			; set vertical offset
	call _setOuputPosition		; set video position to offset

	mov si, WelcomeMsg 		; store string pointer to SI
	call _printString		; call print string procedure

	jmp $				; just an infinite loop

;---------------------------------------------------------------
; procedure to move video outpout to a given poisition
; input : dl = x position
; input : dh = y poisition
;---------------------------------------------------------------
_setOuputPosition:
	mov ah, 0x2			; move position in video buffer
	int 0x10			; call video interrupt
	ret

;---------------------------------------------------------------
; procedure to move video output to position 0,0
;---------------------------------------------------------------
_resetOuputPosition:
	mov dl, 0x0			; set x = 0
	mov dh, 0x0			; set y = 0
	call _setOuputPosition		; set position
	ret

;---------------------------------------------------------------
; procedure to redraw screen in blue color
;---------------------------------------------------------------
_clearScreen:
	call _resetOuputPosition	; reset cursor to 0,0
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
	mov ax, 0x50		; 80 columns per line
	sub ax, cx		; subtract line length - string length

	mov bx, 0x2		; divisor = 2
	div bx			; divide al by 2

	mov dl, al		; move x offset to dl, do not change y offset

	ret

; data
WelcomeMsg db 'Hello World', 0
WelcomeMsgLen equ $-WelcomeMsg

TIMES 510 - ($ - $$) db 0	; fill up with 0 to reach 512KB
DW 0xAA55			; boot signature at the
