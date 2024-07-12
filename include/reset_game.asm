reset_game:
    mov word [ball_pos], CENTER_X
    mov word [ball_pos + 2], CENTER_Y
    
    ; disabled to save some memory
    ; mov word [pad_pos], PAD_INITIAL_Y
    ; mov word [pad_pos + 2], PAD_INITIAL_Y

    call clear_screen
    call draw_all

    times 5 call delay    
    ret
