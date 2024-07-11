;-[ CONSTANTS ]---------------------------------------------------------
    TIMER       equ 0x046C    ; Memory location of bios timer (ticks since boot)
    COLS        equ 80
    ROWS        equ 25
    ROW_STRIDE  equ COLS * 2

    FILL_GRAPHIC_CHAR   equ 0xF020    ; BG = White    FG = BLACK  CHAR = space
    FILL_BALL_CHAR      equ 0xD020    ; BG = Magenta  FG = BLACK  CHAR = space
    FILL_HEALTH_CHAR    equ 0xC020    ; BG = Red      FG = BLACK  CHAR = space
    
    VRAM_SEG    equ 0xB800
    CENTER_X    equ 40
    CENTER_Y    equ 12
    PAD_HEIGHT  equ 6
    WIN_SCORE   equ 6

    ; https://stanislavs.org/helppc/scan_codes.html
    KBD_UP      equ 0x48
    KBD_DOWN    equ 0x50
;-----------------------------------------------------------------------


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
            mov bx, [score]
            check_score:
                call update_game_over
                add bx, 2
            loop check_score
        ;------------------------------------




        call delay
        ;------------------------------------------------------------
        jmp __game_loop
    exit: ret







update_game_over:
    cmp bx, WIN_SCORE
    jne check_game_over_ret
        mov byte [gameOver], 0x01
    check_game_over_ret:
    ret





handle_input:
    mov ah, 0x01
    int 16h             
    jz exit_handle_input0    ; if no key pressed
    
    cbw
    int 16h
    ; output scancode is written in ah

    ;------------------------------------------
    ; Up Arrow
        cmp ah, KBD_UP                      ;
        jne handle_down_arrow               ;
            dec word [pad_pos + 2]          ; move player up
            jmp exit_handle_input0          ;
    ;------------------------------------------

    ;------------------------------------------
    ; Down Arrow
        handle_down_arrow:                      ;
            cmp ah, KBD_DOWN                    ;
                jne exit_handle_input0          ;
                inc word [pad_pos + 2]          ; move player up
    ;------------------------------------------



    exit_handle_input0: 
    ; empty keyboard buffer
        mov ah, 0x01
        int 16h
        jz exit_handle_input
            xor ah, ah         
            int 16h
            jmp exit_handle_input0

    exit_handle_input: 
    ret




draw_all:
    pusha
        ;------------------------------------------
        ; draw mid line
            mov ax, FILL_GRAPHIC_CHAR
            mov di, CENTER_X * 2            ; since word = 2byte
            mov cx, (CENTER_Y + 1)          ; makes no sense but approx (ROWS / 2) times
            _draw_mid_line_loop:
                stosw
                add di, ROW_STRIDE * 2 - 2
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
        

        ;------------------------------------------
        ; draw ai
            mov di, [pad_pos]    
            imul di, ROW_STRIDE
            call draw_paddle
        ;------------------------------------------


        ;------------------------------------------
        ; draw player
            mov di, [pad_pos + 2]
            imul di, ROW_STRIDE
            add di, ROW_STRIDE - 2
            call draw_paddle
        ;------------------------------------------


        ;------------------------------------------
        ; draw score

            ; TODO :  MOVE THIS IN FUNCTION


            ;------------------------------------------
            ; ENEMY SCORE

                mov cx, word [score]
                mov di, COLS - 10
                mov ax, -8              ; direction
                call draw_score

            ;------------------------------------------

            
            ;------------------------------------------
            ; PLAYER SCORE
                mov cx, word [score + 2]
                mov di, COLS + 10
                mov ax, +8          ; direction
                call draw_score 
 
            ;------------------------------------------            
        ;------------------------------------------




        ; TODO : Win / LOSS?

    popa
    ret







draw_score:
    cmp cx, 0
    je end_draw_score
    draw_score_loop:
        mov word [es:di], FILL_HEALTH_CHAR
        add di, ax
        loop draw_score_loop

    end_draw_score:
    ret



draw_paddle:
    mov cx, PAD_HEIGHT
    _draw_player_loop:
        mov word [es:di], FILL_GRAPHIC_CHAR
        add di, ROW_STRIDE
        loop _draw_player_loop






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



clear_screen:
    xor ax, ax
    xor di, di
    mov cx, 80 * 25
    rep stosw

    ret


reset_game:
    mov word [ball_pos], CENTER_X
    mov word [ball_pos + 2], CENTER_Y
    
    mov word [pad_pos], PAD_INITIAL_Y
    mov word [pad_pos + 2], PAD_INITIAL_Y

    call clear_screen
    call draw_all

    times 5 call delay    
    ret

;----[ mannual delay ]-----------------
delay:
    mov bx, [TIMER]
    times 2 inc bx    ; 2 ticks delay
    _delay:
        cmp [TIMER], bx
        jl _delay

    ret









PAD_INITIAL_Y equ CENTER_Y - PAD_HEIGHT / 2

ball_pos:       dw  CENTER_X,  CENTER_Y
ball_vel:       db  1,  -1                              ; vx, vy
pad_pos:        dw  PAD_INITIAL_Y, PAD_INITIAL_Y        ; AI_y   Player_y 
score:          dw  0, 0                                ; AI Score, Player Score
gameOver:       db  0                                   ; TODO : Later



