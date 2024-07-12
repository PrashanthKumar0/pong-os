;----[ mannual delay ]-----------------
delay:
    mov bx, [TIMER]
    times 2 inc bx    ; 2 ticks delay
    _delay:
        cmp [TIMER], bx
        jl _delay

    ret



