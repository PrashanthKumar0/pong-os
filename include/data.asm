; All are variables defined here


ball_pos:       dw  CENTER_X,  CENTER_Y
ball_vel:       db  1,  -1                              ; vx, vy
pad_pos:        dw  PAD_INITIAL_Y, PAD_INITIAL_Y        ; AI_y   Player_y 
score:          dw  0, 0                                ; AI Score, Player Score
gameOver:       db  0                                   ; TODO : Later

game_title: db "Pong-OS (pong)", 0x0    ; unused though



