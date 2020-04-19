; Filename: print_string.asm
; Argument: bx is the address of string to be printed

print_string:
	push	ax			; register that we use
	mov		ah, 0x0e	; int=10/ah=0xe -> BIOS tele-type output
again:
	mov		al, [bx]	; comparison
	cmp 	al, 0		; if the data is already at the end
	je  	exit		; done, exit
	int		0x10		; print 
	
	inc 	bx			; get the next data
	jmp 	again
exit:
	pop 	ax
	ret
