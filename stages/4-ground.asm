        bits 16
        cpu 386
        org 0x7C00

WORLD   equ 0x1000
SKY     equ 77
CLOUD   equ 100
LIGHT   equ 10
PIPE    equ 2
GROUND  equ 67
GAPH    equ 56
BIRDX   equ 80
GRAV    equ 14
FLAP    equ 427

start:
        xor ax, ax
        mov ds, ax
        mov al, 0x13
        int 0x10
        cld
        mov ax, 9943
        out 0x40, al
        mov al, ah
        out 0x40, al

        push WORLD
        pop es
        xor di, di
        mov al, SKY
        mov cx, 64000
        rep stosb

        mov word [y], 90*256
        xor ax, ax
        mov [vy], ax
        mov word [col], 0

frame:
        mov ax, [0x046C]
.tick:  cmp ax, [0x046C]
        je .tick

        mov ah, 1
        int 0x16
        jz .fall
        xor ax, ax
        int 0x16
        mov word [vy], -FLAP
.fall:
        add word [vy], GRAV
        mov ax, [vy]
        add [y], ax

        push ds
        push es
        pop ds
        mov si, 1
        xor di, di
        mov cx, 64000-1
        rep movsb
        pop ds

        mov cx, [col]
        test cl, 127
        jnz .same
        in al, 0x40
        and al, 63
        add al, 40
        mov [gap], al
.same:
        mov dl, [gap]
        mov ch, cl
        and ch, 127
        mov bx, 199
.column:
        mov al, GROUND
        cmp bl, 187
        jae .put
        cmp bl, 180
        jb .air
        mov al, bl
        add al, cl
        and al, 4
        add al, al
        add al, PIPE
        jmp .put
.air:   mov al, SKY
        cmp ch, 32
        jae .put
        mov ah, bl
        sub ah, dl
        sub ah, GAPH/2
        jns .abs
        neg ah
.abs:   cmp ah, GAPH/2
        jb .put
        cmp ah, GAPH/2+6
        jb .cap
        mov ah, ch
        sub ah, 3
        cmp ah, 26
        jae .put
.cap:   mov al, LIGHT
        cmp ch, 8
        jb .put
        mov al, PIPE
.put:   mov [es:di], al
        sub di, 320
        dec bx
        jns .column
        inc word [col]

        movzx ax, byte [y+1]
        cmp al, 169
        ja dead
        imul di, ax, 320
        add di, BIRDX
        push di
        mov dx, 11
.check: mov cx, 12
.cc:    cmp byte [es:di], SKY
        jb dead
        inc di
        loop .cc
        add di, 320-12
        dec dx
        jnz .check

        push es
        pop ds
        push 0xA000
        pop es
        xor si, si
        xor di, di
        mov cx, 32000
        rep movsw
        xor ax, ax
        mov ds, ax

        pop di
        mov si, bird
        mov dx, 11
.brow:  mov cx, 6
.bbyte: lodsb
        aam 16
        xchg al, ah
        call px
        mov al, ah
        call px
        loop .bbyte
        add di, 320-12
        dec dx
        jnz .brow
        push WORLD
        pop es

        mov ah, 2
        xor bx, bx
        mov dx, 0x0113
        int 0x10
        mov ax, [col]
        sub ax, 143
        jns .score
        xor ax, ax
.score: shr ax, 7
        mov si, 10
        xor cx, cx
.digit: xor dx, dx
        div si
        push dx
        inc cx
        test ax, ax
        jnz .digit
.print: pop ax
        add al, '0'
        mov ah, 0x0E
        mov bx, 15
        int 0x10
        loop .print

        jmp frame

dead:
        xor ax, ax
        int 0x16
        jmp start

px:     test al, al
        jz .skip
        mov [es:di], al
.skip:  inc di
        ret

bird:
        db 0x00, 0x00, 0x88, 0x88, 0x88, 0x00
        db 0x00, 0x88, 0xEE, 0xE8, 0xFF, 0x80
        db 0x08, 0xEE, 0xEE, 0x8F, 0xFF, 0xF8
        db 0x08, 0xEE, 0xEE, 0x8F, 0xF8, 0xF8
        db 0x88, 0x88, 0xEE, 0xE8, 0xFF, 0xF8
        db 0x8F, 0xFF, 0x8E, 0xEE, 0x88, 0x88
        db 0x8F, 0xFF, 0x8E, 0xE8, 0xCC, 0xCC
        db 0x08, 0x88, 0xEE, 0xE8, 0xC8, 0x88
        db 0x00, 0x8E, 0xEE, 0xEE, 0x8C, 0xC8
        db 0x00, 0x08, 0x8E, 0xEE, 0xE8, 0x80
        db 0x00, 0x00, 0x08, 0x88, 0x80, 0x00

y:      dw 0
vy:     dw 0
col:    dw 0
gap:    dw 0

        times 510 - ($ - $$) db 0
        dw 0xAA55
