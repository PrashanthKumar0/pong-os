;---- [Setup stack and segement regs] ------------
[org 0x7c00]
[bits 16]

mov sp, 0x8000
mov bp, sp

;------------------------------------------------
call delay
call delay
call delay
call game_loop


;--------------------------------------------
            ;
jmp $       ; Hold on buddy there's hazard down there.
            ;
            ;
;-[ INCLUDES ]-------------------------------

%include "game_loop.asm"

;--------------------------------------------




;-[ DATA ]-----------------------------------

game_title: db "Jump-OS (pong)", 0x0


;--------------------------------------------

times 510-($-$$) db 0
dw 0xaa55

