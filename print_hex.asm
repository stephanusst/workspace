; Masih salah!
;
; data written in dx
TABLE:
    db "0123456789ABCDEF", 0

print_hex:
    push ax
    push bx

    mov   dx,0x1234
    lea   bx, [TABLE]		;load effective address
    mov   ax, dx			;get the data such as: 0x1234 

    mov   ah, al            ;make al and ah equal so we can isolate each half of the byte, such as 0x3434
    shr   ah, 4             ;ah now has the high nibble, 0x03
    and   al, 0x0F          ;al now has the low  nibble, 0x04
    xlat                    ;lookup al's contents in our table, using al, get '4'
    xchg  ah, al            ;flip around the bytes so now we can get the higher nibble,  
    xlat                    ;look up what we just flipped, get '3'

    lea   bx, [STRING]		;load effective address
    
    xchg  ah, al
    mov   [bx], ax          ;append the new character to the string of bytes
	
	mov   bx, STRING		;give address of the STRING
	call print_string;
	
    pop bx
    pop ax
    ret

%include "../print_string.asm"
    ;section .bss

STRING:
	dw 0x0000
;    resb  50                ; reserve 50 bytes for the string