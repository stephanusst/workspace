; Read some sectors from the boot disk using our disk_read function
	[org 0x7c00]
	
; Clear Page	
	mov ah, 06
	mov al, 00
	mov bh, 07
	mov ch, 00
	mov cl, 0
	mov dh, 24
	mov dl, 79
	int 0x10 
	
; Posisi cursor	
	mov ah, 2
	mov bh, 0
	mov dh, 0
	mov dl, 0
	int 0x10

	mov bx, Name_MSG
	call print_string
	
	mov bx , NAME_MSG_2
	call print_string
	
	mov bx, NAME_MSG_3
	call print_string    

	mov bx, batas
	call print_string
	
	mov bx, mul_3		; assume VLL x A x PF
	call print_hex_1

	mov bx, MSG_CON
	call print_string

	mov bx, NUMBER_TOT  ; assume total 3 fasa
	call print_string
	
	JAM:	
	mov ah, 0;				; Real Time Clock
	int 1ah

	mov dh, 3
	mov dl, 8
	call PosKursor			; position cursor
	
	mov dh, 4
	mov dl,8
	call PosKursor
	
	mov dh,5
	mov dl, 8
	call PosKursor
	
	mov [NUMBER_3], cx  ; assume as PF
	mov bx, NUMBER_3
	call print_hex_1

	jmp $

%include "print_string.asm" ; Re - use our print_string function
%include "print_hex_1.asm" 	; Re - use our print_hex function
%include "disk_load.asm"
%include "print_decimal.asm"
%include "cobafloat1.asm"


PosKursor:
	mov bh,	0h
	mov ah, 02h
	int 10h
	ret
; Include our new disk_load function
; Global variables

NUMBER:
	dw 0x0000    ; Padding and magic number.

Name_MSG:
		;db 13,10
		db 'DATA LOGGER KWh meter elevator ',13, 10
		db 'Average   Yehezkiel V.E-19340006',13,10
		db 13, 10 , 9
		db 'VLL =',0
					
NAME_MSG_2:
		db 13,10,9, 'A =',0

NAME_MSG_3:
		db 13,10,9,'PF = ',0
		
NUMBER_3:
		dw 0x0000
		
batas:
		;db 13,10
		db 13,10,"VLL*A*PF= ",0
		
mul_3:
		;mov bx, NUMBER_1

MSG_CON:
		db 13,10,'BIAYA/KWh =', 13,10
		db 'Total 3 fasa = ',0
		
NUMBER_TOT:
		db 13,10
		
BOOT_DRIVE: db 0

; Bootsector padding
	times 510-($-$$) db 0
	dw 0xaa55

; We know that BIOS will load only the first 512 - byte sector from the disk ,
; so if we purposely add a few more sectors to our code by repeating some
; familiar numbers , we can prove to ourselfs that we actually loaded those
; additional two sectors from the disk we booted from.
