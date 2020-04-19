; NOT WORKING
; A boot sector that prints a string using our function.
;

	[org 0x7c00 ] 			; Tell the assembler where this code will be loaded

	mov dx, HEX_OUT 		; store the value to print in dx
	mov dx, 0x1234
	call print_hex 			; call the function
	
%include "../print_hex.asm" 	; Data

; global variables
HEX_OUT : db 9

						; Padding and magic number.	
	times 510 -($-$$) db 0
	dw 0xaa55