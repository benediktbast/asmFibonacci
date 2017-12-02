%define sys_exit	60

;------------------------------------------------
; macro for sys exit with return code
; e.g. exit 0 for
;------------------------------------------------
%macro exit 1
	mov rax, sys_exit
	mov rdi, %1
	syscall
%endmacro

