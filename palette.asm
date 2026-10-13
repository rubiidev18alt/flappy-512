        bits 16
        org 0x7C00

        mov ax, 0x13
        int 0x10
        push 0xA000
        pop es
        xor di, di
        xor bx, bx
row:    mov cx, 320
        mov ax, bx
        shr ax, 3
        shl ax, 4
col:    push ax
        mov dx, 320
        sub dx, cx
        shr dx, 4
        add ax, dx
        stosb
        pop ax
        loop col
        inc bx
        cmp bx, 128
        jb row
        jmp $

        times 510 - ($ - $$) db 0
        dw 0xAA55
