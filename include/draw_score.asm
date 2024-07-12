draw_score:
        cmp cx, 0
        je end_draw_score
    draw_score_loop:
        mov word [es:di], FILL_HEALTH_CHAR
        add di, ax
        loop draw_score_loop

    end_draw_score:
    ret
