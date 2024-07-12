update_game_over:
    cmp bx, WIN_SCORE
    jne check_game_over_ret
        mov byte [gameOver], 0x01
    check_game_over_ret:
    ret
