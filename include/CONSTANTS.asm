;-[ CONSTANTS ]---------------------------------------------------------
    TIMER       equ 0x046C    ; Memory location of bios timer (ticks since boot)
    COLS        equ 80
    ROWS        equ 25
    ROW_STRIDE  equ COLS * 2

    FILL_GRAPHIC_CHAR   equ 0xF020    ; BG = White    FG = BLACK  CHAR = space
    FILL_BALL_CHAR      equ 0xD020    ; BG = Magenta  FG = BLACK  CHAR = space
    FILL_HEALTH_CHAR    equ 0xC020    ; BG = Red      FG = BLACK  CHAR = space
    
    VRAM_SEG        equ 0xB800
    CENTER_X        equ 40
    CENTER_Y        equ 12
    PAD_HEIGHT      equ 6
    WIN_SCORE       equ 6
    PAD_INITIAL_Y   equ CENTER_Y - PAD_HEIGHT / 2

    ; https://stanislavs.org/helppc/scan_codes.html
    KBD_UP      equ 0x48
    KBD_DOWN    equ 0x50
;-----------------------------------------------------------------------
