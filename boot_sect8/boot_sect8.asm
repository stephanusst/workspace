
;
; A boot sector that prints a string using our function.
;
	[org 0x7c00] 		; Tell the assembler where this code will be loaded

	mov bx, HELLO_MSG	; Use BX as a parameter to our function , so
	call print_string 	; we can specify the address of a string.

	mov bx, GOODBYE_MSG
	call print_string
	
	mov bx, NUMBER_MSG
	call print_hex_1

	mov bx, NUMBER_MSG2
	call print_hex_1

	jmp $ 				; Hang

%include "../print_string.asm" ; Data
%include "../print_hex.asm"	;
%include "../print_hex_1.asm"	;

	; Data
		
NUMBER_MSG:
	dw 0xABCD     ; Padding and magic number.	

NUMBER_MSG2:
	dw 0x1234     ; Padding and magic number.	
	
HELLO_MSG:
	db 'Hello, World !', 13, 10, 0 		; <-- The zero on the end tells our routine
					; when to stop printing characters.
GOODBYE_MSG:
	db 'Goodbye !', 13, 10, 0

	
	times 510 -($-$$) db 0
	dw 0xaa55