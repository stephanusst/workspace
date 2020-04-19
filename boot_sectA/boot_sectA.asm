
;
; A boot sector that prints a string using our function.
;
	[org 0x7c00] 				; Tell the assembler where this code will be loaded

	call ClearPage              ; Clear the page

    mov  dh, 0
    mov  dl, 0
    call PosKursor              ; Posisi Cursor

	mov bx, HELLO_MSG			; Use BX as a parameter to our function , so
	call print_string 			; we can specify the address of a string.

    mov bx, VARIABLE
    call print_hex_1

	mov bx,LINE_FEED
    call print_string

    mov dx, [VARIABLE]          ; dx is the value
    call hex2dec

	jmp $ 						; Hang

%include "../print_string.asm" 	
%include "../print_hex_1.asm"	
%include "../fungsi_layar.asm"
%include "../hex2dec.inc"       
		
HELLO_MSG:
	db 'Hex2Dec', 13, 10, 0 		; <-- The zero on the end tells our routine
					                ; when to stop printing characters.
PREVIOUS4:
    db 0x00
PREVIOUS3:
    db 0x00
PREVIOUS2:
    db 0x00
PREVIOUS1:
    db 0x00
DECIMAL:
    db 0x00
VARIABLE:
    dw 0xFFFF

	times 510 -($-$$) db 0
	dw 0xaa55

