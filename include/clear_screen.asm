clear_screen:
    xor ax, ax
    xor di, di
    mov cx, 80 * 25
    rep stosw

    ret
