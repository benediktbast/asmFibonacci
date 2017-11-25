[BITS 16]			; 16 bit code
[ORG 0x7C00]			; load  code to memory 0x7C00

MOV SI, WelcomeMsg 		; store string pointer to SI
CALL PrintString		; call print string procedure
JMP $				; infinite loop;


; procedure to print one char to the string
; input: Ascii value in SI
PrintCharacter:
	MOV AH, 0x0E		; print char
	MOV BH, 0x00		; page no
	MOV BL, 0x07		; text attribute lightgrey font on black
	INT 0x10		; call video interrupt
	RET			; exit

;Procedure to Print a null terminated String on screen
;input: char pointer in SI
PrintString:
next_char:	
	MOV AL, [SI]		; store ascii value from SI to AL
	INC SI			; increment pointer
	OR AL, AL		; if AL contains null
	JZ exit_function 	; exit
	CALL PrintCharacter 	; print AL to screen
	JMP next_char	; next char
exit_function:
	RET			; exit


;Data
WelcomeMsg db 'Hello World', 0

TIMES 510 - ($ - $$) db 0	; fill up with 0 to reach 512KB
DW 0xAA55			; boot signature at the
