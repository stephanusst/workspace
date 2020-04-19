;
; PRINT_HEX_1.ASM
;Put 2 bytes data on address bx

print_hex_1:
	mov	ah, 0x0e	; int=10/ah=0xe -> BIOS tele-type output
again_hex:
	inc bx			; get the high byte
	mov	al, [bx]	; get the content
	
	;cmp al, 0		; conditional if the data is zero, then exit.
	;je  exit_hex	;

;0x1---	
	and	al,0xf0		; extract the high nible.
	shr al,4		; shift to right
	cmp al,9		;                        *
	jg besar1		; jump if greater than 9 *
	add al,48		; 48 untuk 0 or 65       *
	jmp print1      ;                        *
besar1:             ;                        *  
	add al, 55		; offset=48+7            *
print1:             ;                        *
	int	0x10		; printing high nible

;0x-2--	
	mov al, [bx]	; 
	and al, 0x0f
	cmp al,9  		;*
	jg besar2		;*jump if greater than 9
	add al,48		;*48 untuk 0 or 65
	jmp print2		;*
besar2:				;*
	add al, 55		; offset=48+7
print2:				;*
	int 0x10		; print low nible

	dec bx			; get the low byte
	mov	al, [bx]	; get the content
	
	and	al,0xf0		; extract the high nible
	shr al,4		; shift to right
	cmp al,9  		;*
	jg besar3		;*jump if greater than 9
	add al,48		;*48 untuk 0 or 65
	jmp print3		;*
besar3:				;*
	add al, 55		; offset=48+7
print3:				;*
	int	0x10		; printing high nible
	
	mov al, [bx]	
	and al, 0x0f
	cmp al,9  		;*
	jg besar4		;*jump if greater than 9
	add al,48		;*48 untuk 0 or 65
	jmp print4		;*
besar4:				;*
	add al, 55		; offset=48+7
print4:				;*
	int 0x10		; print low nible

	
	
	;jmp again_hex
	
exit_hex:	
	ret
