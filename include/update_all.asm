update_all:
    ;------------------------------------------
    ; update ball (pos += velocity)
        mov bl, [ball_vel]
        add [ball_pos], bl
        mov bl, [ball_vel + 1]
        add [ball_pos + 2], bl
    ;------------------------------------------

    ;------------------------------------------
    ; AI game play
        cmp word [ball_pos], COLS / 20   ; move only if ball is in our area?
        jg end_ai_move
        cmp byte [ball_vel], 0          ; move only if ball is comming to us
        jg end_ai_move
            mov ax, [pad_pos]
            add ax, PAD_HEIGHT / 2
            cmp ax, word [ball_pos + 2]
            je end_ai_move
            jl move_ai_down
                dec word [pad_pos] 
                jmp end_ai_move
            move_ai_down:
                inc word [pad_pos]
    ;------------------------------------------
 
    end_ai_move:




    ;----------------------------------------
    ; pad hit?
        ; ai pad hit
        ; ax = pad top      bx = pad bottom
            mov ax, [pad_pos]
            mov bx, ax
            add bx, PAD_HEIGHT
            cmp word [ball_pos], 1              ; check hit in x direction
            jg check_player_pad_hit 
                cmp ax, word [ball_pos + 2]     ; check hit in y dir
                jg check_player_pad_hit
                cmp bx, word [ball_pos + 2]     ; check hit in y dir
                jl check_player_pad_hit
                    neg byte [ball_vel]         ; flip velocity
        
        ; player 
        check_player_pad_hit:
        ; ax = pad top      bx = pad bottom
            mov ax, [pad_pos + 2]
            mov bx, ax
            add bx, PAD_HEIGHT
            cmp word [ball_pos], (COLS - 1)              ; check hit in x direction
            jl end_pad_hit_check 
                cmp ax, word [ball_pos + 2]     ; check hit in y dir
                jg end_pad_hit_check
                cmp bx, word [ball_pos + 2]     ; check hit in y dir
                jl end_pad_hit_check
                    neg byte [ball_vel]         ; flip velocity
        end_pad_hit_check:
    ;------------------------------------------
 



    ;------------------------------------------
    ; bound check
    ; if(ball_pos.x < 0)
        left_bound:
            cmp word [ball_pos], 0
            jg right_bound
                ; mov word [ball_pos], 1
                call reset_game
                neg byte [ball_vel]
                inc word [score + 2]    ; increase player score
                jmp top_bound
                

        ; else if(ball_pos.x > COLS)
        right_bound:
            cmp word [ball_pos], COLS
            jle top_bound
                ; mov word [ball_pos], COLS
                call reset_game
                inc word [score]    ; increase ai score
                neg byte [ball_vel]

        top_bound:
            cmp word [ball_pos + 2], 0
            jg bottom_bound
                mov word [ball_pos + 2], 1
                neg byte [ball_vel + 1]
                jmp end_bound_check

        bottom_bound:
            cmp word [ball_pos + 2], ROWS
            jle end_bound_check
                mov word [ball_pos + 2], ROWS
                neg byte [ball_vel + 1]                 
    ;------------------------------------------
    end_bound_check:
    



    ret

