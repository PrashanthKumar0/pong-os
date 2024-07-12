;---- [Setup stack and segement regs] ------------
[org 0x7c00]
[bits 16]

mov sp, 0x8000
mov bp, sp

;------------------------------------------------


call game_loop


;--------------------------------------------
            ;
jmp $       ; Hold on buddy there's hazard down there.
            ;
            ;
;-[ INCLUDES ]-------------------------------

%include "CONSTANTS.asm"
%include "game_loop.asm"
%include "handle_input.asm"
%include "update_game_over.asm"
%include "draw_all.asm"
%include "draw_score.asm"
%include "draw_paddle.asm"
%include "update_all.asm"
%include "clear_screen.asm"
%include "reset_game.asm"
%include "delay.asm"
%include "data.asm"

;--------------------------------------------





times 510-($-$$) db 0
dw 0xaa55


