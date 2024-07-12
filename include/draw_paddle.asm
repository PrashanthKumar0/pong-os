draw_paddle:
    mov cx, PAD_HEIGHT
    _draw_player_loop:
        mov word [es:di], FILL_GRAPHIC_CHAR
        add di, ROW_STRIDE
        loop _draw_player_loop

