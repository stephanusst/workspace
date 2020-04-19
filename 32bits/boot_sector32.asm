; A boot sector that enters 32- bit protected mode.
[org 0x7c00]
	mov bp, 0x9000 		; Set the stack.
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call print_string

	call switch_to_pm 		; Note that we never return from here.

	jmp $

	%include "../print_string.asm"
	%include "../kernel/gdt.asm"
	%include "print_string_pm.asm"
	%include "switch_to_pm.asm"
	
[bits 32]
; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:
	mov ebx, MSG_CLEAR
	call print_string_pm 	; Use our 32- bit print routine
	
	mov ebx, MSG_PROT_MODE
	call print_string_pm 	; Use our 32- bit print routine.
	
	jmp $ 					; Hang.

; Global variables
MSG_REAL_MODE db "Started in 16- bit Real Mode", 0
MSG_CLEAR db "                                                                                ",  ;1
          db "                                                                                ",  ;2
		  db "                                                                                ",0  ;8
MSG_PROT_MODE db 0x20,0x20,"@DR. Stephan Tan. 0160488. Successfully landed in 32- bit Protected Mode", 0

; Bootsector padding
	times 	510 -($-$$) db 0
	dw 		0xaa55