;
; A simple boot sector program that demonstrates addressing.
;
	mov ah, 0x0e ; int 10/ ah = 0eh -> scrolling teletype BIOS routine

	; First attempt
	mov al, [the_secret]
	int 0x10 							; Does this print an X? No

	mov bx,	0x7c0
	mov ds, bx							; Can 't set ds directly , so set it through bx
	mov al, [the_secret]
	int 0x10 							; Does this print an X?

	mov al , [ds:the_secret]
	int 0x10 							; Does this print an X?

	mov bx , 0x7c0
	mov es , bx
	mov al , [es:the_secret]
	int 0x10 ; Does this print an X?

	jmp $ ; Jump forever.

the_secret:
db "X"

; Padding and magic BIOS number.
times 510 -($-$$) db 0
dw 0xaa55
