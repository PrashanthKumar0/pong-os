game_loop:
    mov bx, VRAM_SEG
    mov es, bx

    __game_loop:
        ;------------------------------------------------------------
        cmp byte [gameOver], 0x01
        je exit


        call clear_screen
        call handle_input
        call update_all
        call draw_all
        
        ;------------------------------------
        ; check for game over
            mov cx, 2
            mov bx, word [score]
            check_score:
                call update_game_over
                add bx, 2
            loop check_score
        ;------------------------------------




        call delay
        ;------------------------------------------------------------
        jmp __game_loop
    exit: ret

