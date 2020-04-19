; READ SECTORS
;
; Read some sectors from the boot disk using our disk_read function

	[org 0x7c00]
	
	mov [BOOT_DRIVE], dl 	; BIOS stores our boot drive in DL , so it 's
							; best to remember this for later.
	mov bp, 0x8000 			; Here we set our stack safely out of the
	mov sp, bp 				; way, at 0x8000
	
	mov bx, 0x9000 			; Load 5 sectors to 0x0000 (ES ):0x9000 (BX)
	mov dh, 5 				; from the boot disk.
	mov dl, [BOOT_DRIVE]	;
	call disk_load			; Loading 
	
; Keypressed				
	mov bx, Keypressed
	call 	print_string	; Asking a "key pressed to continue"
	
;Pause, tunggo ENTER key.
ReadLoop: 
	mov ah, 0 				; Read Key opcode
	int 16h					; 
	cmp al, 0 				; Special function?
	jz ReadLoop 			; If so, don’t echo this keystroke
	cmp al, 0dh 			; Carriage return (ENTER)?
	jne ReadLoop			;

; Clear Page	
	call ClearPage			;

; 80 huruf x 25 baris text berwarna	
	mov ah, 0				; Function Number
	mov al, 3				; Page 0
	int 0x10				;
	
; The first	
	mov bx, First
	call print_string

	mov bx,LINE_FEED
	call print_string	
	
	mov bx, [0x9000] 		; Print out the first loaded word, which
	mov [NUMBER], bx
	mov bx, NUMBER
	call print_hex_1 		; we expect to be 0xdade, stored
							; at address 0x9000			
	mov bx,LINE_FEED
	call print_string		;line feed

; The second
	mov bx, Second
	call print_string

	mov bx,LINE_FEED	
	call print_string
	
	mov bx, [0x9000+512]  	; offset 512 bytes (256 words),  print the second group of loaded word
	mov [NUMBER], bx
	mov bx, NUMBER
	call print_hex_1 		; we expect to be 0xface, stored

	mov bx,LINE_FEED
	call print_string		; line feed

	
; Realtime Clock	
JAM:	
	mov ah, 0;				; Real Time Clock
	int 1ah

;Posisi cursor	1
	mov dh, 20				; Row number
	mov dl, 30				; Column number
	call PosKursor			;
; timer	
	mov [NUMBER], ax		
	mov bx, NUMBER
	call print_hex_1		;ax ah 1 writing, ah 0 reading. al = 0 or 1

;Posisi cursor 2		
	mov dh, 20				; Row number
	mov dl, 30				; Column number
	call PosKursor			;
; timer 
	mov [NUMBER], cx
	mov bx, NUMBER
	call print_hex_1		;cx high

;Posisi cursor 3
	mov dh, 20				; Row number
	mov dl, 40				; Column number
	call PosKursor			;
; timer 
	mov [NUMBER], dx		
	mov bx, NUMBER
	call print_hex_1		;dx low

	;jmp JAM
	
	jmp $

%include "../print_string.asm" ; Re - use our print_string function
%include "../print_hex_1.asm" 	; Re - use our print_hex function
%include "../disk_load.asm"

PosKursor:
	mov bh,	0h
	mov ah, 02h
	int 10h
	ret

ClearPage:
	mov ah, 06				; Function Number 6
	mov al, 00				;
	mov bh, 07				;
	mov ch, 00				; Row start
	mov cl, 0				; Column start
	mov dh, 24				; Row end
	mov dl, 79				; Column end
	int 0x10				;
	ret

; Include our new disk_load function
; Global variables
BOOT_DRIVE: 
	db 0
NUMBER:
	dw 0x0000    			; Padding and magic number.	
LINE_FEED:
	db 13,10,0;
First:
	db 'The first 256 word', 0;
Second:
	db 'The second 256 word', 0;
Keypressed:
	db 'Press any key to continue',0;
	
; Bootsector padding
	times 510-($-$$) db 0
	dw 0xaa55

; We know that BIOS will load only the first 512 - byte sector from the disk ,
; so if we purposely add a few more sectors to our code by repeating some
; familiar numbers , we can prove to ourselfs that we actually loaded those
; additional two sectors from the disk we booted from.
DADE:
	times 256 dw 0xdade
FACE:
	times 256 dw 0xface
HALAMAN:
	db 'Timer', 13,10,0;
