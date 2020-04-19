hex2dec:   
    mov bx, DECIMAL
hex2decloop:
    mov ax, dx
    mov dx, 0
;
    mov cx, 10
    div cx                      ; isi dx:ax dibagi dengan cx,  hasil bagi berada di ax, sisa di dx
    xchg dx, ax                 ; ditukar posisinya , dx hasil bagi, ax sisa 
;
    or al, 30h                  ; sisa dijadikan angka ASCII
    mov byte [bx], al           ; save
    dec bx                      ; reduce the address
; 
    cmp dx, 0                   ; jika is dx belum 0, konversi dilanjutkan
    jnz hex2decloop
  

    mov bh, 0;
    mov cx, 1;
    mov ax, [PREVIOUS4]            ; the highest
    or al, 30h
    mov ah, 0x0e
    int 0x10


    mov ax, [PREVIOUS3]            ; the next
    or al, 30h
    mov ah, 0x0e
    int 0x10

    mov ax, [PREVIOUS2]           ; the third
    or al, 30h
    mov ah, 0x0e
    int 0x10

    mov ax, [PREVIOUS1]
    or al, 30h
    mov ah, 0x0e
    int 0x10

    mov ax, [DECIMAL]
    or al, 30h
    mov ah, 0x0e
    int 0x10

    ret