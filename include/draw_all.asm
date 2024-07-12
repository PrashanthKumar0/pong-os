draw_all:
        ;------------------------------------------
        ; draw mid line
            mov bx, CENTER_X * 2            ; since word = 2byte
            mov cx, (CENTER_Y + 1)          ; makes no sense but approx (ROWS / 2) times
            _draw_mid_line_loop:
                mov word [es:bx], FILL_GRAPHIC_CHAR
                add bx, ROW_STRIDE * 2
                loop _draw_mid_line_loop
        ;------------------------------------------

        ;------------------------------------------
        ; draw ball
            ; di = (ball_pos.x + ball_pos.y * ROW_STRIDE) * 2
            mov  di, [ball_pos + 2]
            imul di, COLS
            add  di, [ball_pos]    
            shl  di, 1             
            mov word [es:di], FILL_BALL_CHAR    ; move to vram
        ;------------------------------------------
        
        ; draw paddles
        ;------------------------------------------
        ; draw ai
            mov di, [pad_pos]    
            imul di, ROW_STRIDE
            call draw_paddle
        ;------------------------------------------
        ;
        ;------------------------------------------
        ; draw player
            mov di, [pad_pos + 2]
            imul di, ROW_STRIDE
            add di, ROW_STRIDE - 2
            call draw_paddle
        ;------------------------------------------


        ; draw scores
        ;------------------------------------------
        ; ENEMY SCORE
            mov cx, word [score]
            mov di, COLS - 10
            mov ax, -8              ; direction
            call draw_score
        ;------------------------------------------
        ;
        ;------------------------------------------
        ; PLAYER SCORE
            mov cx, word [score + 2]
            mov di, COLS + 10
            mov ax, +8          ; direction
            call draw_score 
        ;------------------------------------------            




        ; TODO : Win / LOSS?

    ret

