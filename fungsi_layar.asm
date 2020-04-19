; fungsi_layar.asm
; 
; PosKursor
; ---------
; dh= row number
; dl= column number 
PosKursor:
	push ax
	push bx
	mov bh,	0h				; display page number
	mov ah, 02h				; int function number
	int 10h
	pop bx
	pop ax
	ret

; Clear Screen
; ------------
; Membersihkan layar
ClearPage:
	push ax
	push bx
	push cx
	push dx
	mov ah, 06				; Function Number 6
	mov al, 00				; Agar layar dibersihkan
	mov bh, 07				;
	mov ch, 00				; Row start
	mov cl, 0				; Column start
	mov dh, 24				; Row end
	mov dl, 79				; Column end
	int 0x10				;
	pop dx
	pop cx
	pop bx
	pop ax
	ret

;data

LINE_FEED:
	db 13,10,0;
