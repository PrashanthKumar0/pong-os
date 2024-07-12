handle_input:
    mov ah, 0x01
    int 16h             
    jz exit_handle_input0    ; if no key pressed


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
