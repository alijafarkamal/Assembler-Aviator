;Below commented code(starts after this non-commented code ) contains music code embedded with game logic
;Below commented code(starts after this non-commented code ) contains music code embedded with game logic
;Below commented code(starts after this non-commented code ) contains music code embedded with game logic
[org 0x0100]
 mov ax, 0x0013 
 int 0x10 
 mov ax, 0xA000 
 mov es, ax 
     jmp start
exit_msg: db 'Exit? (y/n)', 0  ;
game_ended_msg: db 'Game Ended. Press Key', 0
a_keeper: dw 0
rect_mov_count: dw 0
green_shades db 2, 10, 12, 28, 34 
upperPillarHeight dw 0 
lowerPillarHeight dw 0 
bird_bottom_corner: dw 0
bird_bottom_corner_end: dw 0
bird_top_corner: dw 0
bird_pos: dw 31180
pipesX: dw 319, 459
pipesY: dw 20 , 20
leftOverPipeWidth: dw 0
leftOverPipeY: dw 0
boolDrawBottomPipe: dw 0
intBottomPipeStart: dw 0
intPipeEndX: dw 0
collision_detected: dw 0
boolAdjusted: dw 0
boolFirstPipe: dw 0
rect_pos1: dw 0
rect_pos2: dw 0
rect_pos_down: dw 0
rect_pos_down1: dw 0
rect_pos_down2: dw 0
isAnimating: dw 0
BirdDirection: db 'D'
bird_position_holder: dw 0
score :dw 0
tickcount: dw 0
old_timer:dw 0,0
delay_threshold dw 1600   
timer_hooked db 0    
is_flapping :db 0  
upper_pillar_helper: dw 0
GameTitle: db 'Assembler Aviator', 0
RollNumbers: db 'Roll Numbers: 23L-0815, 23L-0576', 0
Names: db 'Developed by: Ali Jafar,Tayyab Khalil', 0
Semester: db 'Semester: Fall 2024', 0
Instructions: db 'Press UP ARROW to move up,ESC to quit', 0
Instructions1: db 'If ESC is pressed, game stops', 0
Instructions2: db 'If y is pressed, it exits', 0
Instructions3: db 'else it continues from where it stops', 0
StartMessage: db 'Press any key to start...', 0
Instru: db 'INSTRUCTIONS.', 0
StartMessage1: db 'Press any key to continue...', 0
cscore: db 'Score: ' ,0
background:
    xor di, di
    mov cx, 320 * 200
    mov al, 2
    rep stosb
    ret
DisplayIntroduction1:
    call background
    mov dl, 12
	MOV dh,9
	mov si,Instru
	call PrintStringAtPosition
	mov dl, 3
    mov dh, 12
    mov si, Instructions
    call PrintStringAtPosition
    mov dh, 15
    mov si, StartMessage1
    call PrintStringAtPosition
	ret
DisplayIntroduction:
    call background
    mov dh, 7
    mov dl, 3
    mov si, GameTitle
    call PrintStringAtPosition
    mov dh, 9
    mov si, RollNumbers
    call PrintStringAtPosition

    mov dh, 11
    mov si, Names
    call PrintStringAtPosition

    mov dh, 13
    mov si, Semester
    call PrintStringAtPosition

    mov dh, 17
    mov si, StartMessage
    call PrintStringAtPosition
    ret



PrintStringAtPosition:
    pusha
    mov ah, 02h
    int 10h
    mov ah, 0Eh
    mov bh, 0
    mov bl, 15

print_position_loop:
    lodsb
    cmp al, 0
    je done_position_print
    int 10h
    jmp print_position_loop

done_position_print:
    popa
    ret




collision:
pusha
 cmp word[bird_pos],150
 ja next_check
 mov word[collision_detected],1
 jmp get_out
next_check:
mov di, word[bird_bottom_corner_end]
add di,320
 cmp di,57600
 jb get_out
 mov word[collision_detected],1
get_out: 
popa
ret


ShowExitConfirmation:
    mov ah, 02h                
    mov bh, 0                   
    mov dh, 24                  ; Row (adjust as needed)
    mov dl, 15                  ; Column (adjust as needed)
    int 10h

    mov ah, 0Eh                 ; BIOS teletype function
    mov bh, 0                   ; Page number
    mov bl, 2                  ; White text
    mov si, exit_msg            ; Pointer to message

print_message_text:
    lodsb                      
    cmp al, 0
    je wait_for_key1
    int 10h                   
    jmp print_message_text

wait_for_key1:
    mov ah, 0
    int 16h                     ; Get key in AL
    cmp al, 'y'                 ; Check if 'y' or 'Y'
    je exit_game
    cmp al, 'Y'
    je exit_game
end_erase:
	mov bx,10
	mov di,60920
exit_loop:
	mov cx,88
	mov al,6
	rep stosb
	dec bx
	add di,232
	cmp bx,0
jne exit_loop
    ret

exit_game:
    ; mov ax, 0x0003
    ; int 0x10
    mov ah, 02h
    mov bh, 0
    mov dh, 12
    mov dl, 15
    int 10h

    mov ah, 0Eh
    mov si, game_ended_msg

print_loop:
    lodsb
    cmp al, 0
    je wait_for_key
    int 10h
    jmp print_loop
wait_for_key:
    mov ah, 0
    int 16h

    mov ax, 0x0003
    int 0x10

    mov ax, 0x4C00
    int 0x21

upper_part:
    xor di, di
    mov al, 35h
    mov cx, 320 * 60
    rep stosb
    ret

medium_part:
    mov di, 320 * 60
    mov al, 35h
    mov cx, 360 * 60
    rep stosb
    ret

lower_part:
    mov di, 320 * 120
    mov al, 35h
    mov cx, 320 * 80
    rep stosb
    ret

sscore:
    pusha
    mov si, cscore
    mov ah, 02h
    mov bh, 0
    mov dh, 24
    mov dl, 1
    int 10h
    mov ah, 0Eh
    mov bh, 0
    mov bl, 15

print_scoer:
    lodsb
    cmp al, 0
    je done_
    int 10h
    jmp print_scoer

done_:
    popa
    ret

cal_dig:
    call sscore
    mov ax, [score]
    xor cx, cx
    mov bx, 10
store_digits:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jnz store_digits

draw_score:
    mov ah, 02h
    mov bh, 0
    mov dh, 24
    mov dl, 8
    int 10h

print_digits:
    pop dx
    add dl, 0x30
    mov al, dl
    mov ah, 0Eh
    mov bh, 0
    int 10h
    inc dl
    loop print_digits
    ret    


bird_body:
    pusha
    mov bx,12 
    mov si, [bird_pos] 
    add si,18
    mov word[bird_top_corner],si
    sub si,18
body:
    mov di, si
    mov al, 14 
    mov cx, 18 
    rep stosb
    sub bx,1
    add si, 320
    cmp bx, 0 
    jnz body
	push di
	mov di,[bird_pos]
	add di,1608
	mov al,  0xCC
	stosb
	inc di
	stosb
	inc di
	stosb
	pop di
    sub si,320
    mov word[bird_bottom_corner],si
    add si,18
    mov word[bird_bottom_corner_end],si
    sub si,18
    mov [bird_position_holder],si
    popa 
    ret 

defDrawPipe:
    push bp
    mov bp, sp
    pusha
    mov cx, [bp+4]
    mov dx, 0
    mov ah, 0ch
    mov bx, [bp+6]
    mov word [intBottomPipeStart], bx
    add word [intBottomPipeStart], 55
    mov word [boolDrawBottomPipe], 0
    mov word [intPipeEndX], cx
    add word [intPipeEndX], 40
    cmp word [bp+8], 1
    je drawTopPipe
    cmp word [leftOverPipeWidth], 0
    jbe endDrawPipe
    mov cx, [leftOverPipeWidth]
    mov word [intPipeEndX], cx
    mov cx, 40
    sub cx, [leftOverPipeWidth]
    add bx, cx
    mov cx, 0
    dec word [leftOverPipeWidth]
drawTopPipe:
    mov al,2
colorSelected:
    cmp cx, 320
    jae endDrawPipe
    cmp cx, 0
    jb endDrawPipe
    int 10h
skipPipe:
    inc dx
    cmp dx, [bp+6]
    jbe drawTopPipe
    cmp dx, [intBottomPipeStart]
    ja notSkip
    add dx, 54
notSkip:
    cmp dx, 180
    jb drawTopPipe
    inc cx
    mov dx, 0
    inc bx
    cmp cx, [intPipeEndX]
    jb drawTopPipe
endDrawPipe:
    popa 
    pop bp
    ret 6
movePipe:
    push bp
    mov bp, sp
    pusha
    inc word[rect_mov_count]
    cmp word[rect_mov_count],360
    je incc
    jne noincc
incc:
    mov word[rect_mov_count],0
    inc word[score]
    call cal_dig
noincc:
    mov bx, [bp+4]
    dec word [bx]
    mov cx, [bx]
    add cx,41
    mov word [boolAdjusted], 0
    cmp cx, 320
    jge adjustX
    jmp continueDrawing
adjustX:
    sub word cx, 320
    mov word [boolAdjusted], 1
continueDrawing:
    mov dx,0
    mov al,35h
    mov ah,0ch
    mov si,[bp+6]
drawLastColumnSky:
    int 10h
    cmp dx, [si]
    jne continueDrawingSky
    cmp word [boolAdjusted], 0
    je notCheckForadjusted
    cmp cx,41
    ja skipSkyColumn
notCheckForadjusted:
    cmp cx,41
    jb continueDrawingSky
    add dx, 55
    jmp drawLastColumnSky
continueDrawingSky:
    inc dx
    cmp dx,180
    jb drawLastColumnSky
skipSkyColumn:
    sub cx,41
    cmp cx,0
    jne endMovePipe
    cmp word [pipesX], 0
    jne endMovePipeContinue
    mov word [boolFirstPipe], 1
endMovePipeContinue:
    mov word [leftOverPipeWidth], 40
    mov cx, [si]
    mov word [leftOverPipeY], cx
    mov word [bx], 320
    push word [bp+6]
    call generateRandomNumber
endMovePipe:
    popa
    pop bp
    ret 2
generateRandomNumber:
    push bp
    mov bp, sp
    pusha
    mov ah,0
    int 1ah
    mov ax,dx
    mov bx,60
    mov dx,0
    div bx
    mov bx, [bp+4]
    mov word [bx], dx
    add word [bx], 20
    popa
    pop bp
    ret 2

ground:
    mov di, 57600
    mov cx, 320 * 10
    mov bx, 1
.draw_gradient:
    mov al, [green_shades+bx]
    stosb
    inc bx
    cmp bx, 4
    jne .continue_gradient
    mov bx, 1
.continue_gradient:
    loop .draw_gradient
    mov di, 60800
    mov al, 6
    mov cx, 320 * 10
    rep stosb
    ret


delay:
 pusha
 mov cx,64000
delay1:
 loop delay1
 popa
 ret



remover_bird:
 pusha
 mov di,si
 mov al,35h
 mov cx,18
 rep stosb
 popa
 ret



bird_falling:
pusha
mov ax,0xA000
mov es,ax
push di
mov di,[bird_top_corner]
cmp byte[es:di],2
je exit_game_1
mov di,[bird_bottom_corner]
cmp byte[es:di+320],2
je exit_game_1
mov di,[bird_bottom_corner_end]
cmp byte[es:di+320],2
je exit_game_1
pop di
 mov si,word[bird_pos]
 call remover_bird
 add word[bird_pos],320
 call bird_body
jmp outr
exit_game_1:
mov word[collision_detected],1
pop di
outr:
 popa
 ret

moving_up:
 pusha
mov ax,0xA000
mov es,ax
push di
mov di,[bird_top_corner]
cmp byte[es:di-320],2
je exit_game_2
mov di,[bird_bottom_corner_end]
cmp byte[es:di],2
je exit_game_2
mov di,[bird_pos]
cmp byte[es:di-320],2
je exit_game_2
pop di

 sub word[bird_pos],320
 mov si,[bird_position_holder]
 call remover_bird
 call bird_body
jmp outrr
exit_game_2:
mov word[collision_detected],1
pop di
outrr:
 popa
 ret

bird_falling_collide:
pusha
 mov si,word[bird_pos]
 call remover_bird
 add word[bird_pos],320
 call bird_body
 popa
 ret

remover_extra:
pusha
 mov di,[bird_pos]
mov cx,12
 mov al,35h
l2:
 stosb
 add di,319
loop l2
 popa
 ret


collide_extra:
pusha
l1:
call remover_extra
add word[bird_pos],1
call delay
call delay
call bird_body
mov di,[bird_bottom_corner]
cmp byte[es:di+320],2
je l1
popa
ret

Collider:
iteration:
pusha
mov ax,0xA000
mov es,ax
mov di,[bird_bottom_corner_end]
cmp byte[es:di+318],2
je outrrr
mov di,[bird_bottom_corner]
cmp byte[es:di+320],2
je outrrr
popa
call delay
call bird_falling_collide
cmp word[bird_bottom_corner_end],57600
jb iteration
jmp labela
outrrr:
call collide_extra
popa
call Collider
labela:
call delay
call delay
call exit_game
ret

HandleKeyPress:
    push ax
    push bx
    push cx
    push dx
    mov ah, 1          
    int 0x16
    jz no_key_pressed  
    mov ah, 0          
    int 0x16
    cmp ah, 0x01          
    je exit_game_press

    cmp ah, 0x48          
    je handle_up

    cmp ah, 0xC8          
    je handle_release

    jmp no_key_pressed    

exit_game_press:
    call ShowExitConfirmation
    jmp out_of
handle_up:
    mov word [is_flapping], 1  
    mov word [tickcount], 0    
    call moving_up  
	call moving_up
    jmp out_of
handle_release:
    cmp byte [timer_hooked], 1 
    je out_of                  
    mov byte [timer_hooked], 1 
    call hook_timer            
    mov word [is_flapping], 0  
    jmp out_of
no_key_pressed:
    call bird_falling
out_of:
    pop dx
    pop cx
    pop bx
    pop ax
    ret


hook_timer:
    cli                        
    push ds
    xor ax, ax
    mov es, ax
    mov ax, word [es:8*4]
    mov word [old_timer], ax
    mov ax, word [es:8*4+2]
    mov word [old_timer+2], ax
    mov ax, [delay_threshold]
    mov word [es:8*4], timr
    mov word [es:8*4+2], cs
    pop ds
    sti
    ret

timr:
    push ax
    push bx
    push cx
    push dx
    inc word [tickcount]
    cmp word [tickcount], ax
    jne end_timer
    mov word [tickcount], 0
    call bird_falling
    mov byte [timer_hooked], 0
    call unhook_timer
end_timer:
    mov al, 0x20
    out 0x20, al
    pop dx
    pop cx
    pop bx
    pop ax
    iret

unhook_timer:
    cli
    push ds
    xor ax, ax
    mov es, ax
    mov ax, word [old_timer]
    mov word [es:8*4], ax
    mov ax, word [old_timer+2]
    mov word [es:8*4+2], ax
    pop ds
    sti
    ret

ground_mover:
 pusha
 push ds
 mov ax,0xA000
 mov ds,ax
 mov di,57600
 mov si,57602
 mov cx,3198
 rep movsb
 pop ds
 popa
 ret

PrintStartScreen:
 call upper_part  
 call medium_part
 call lower_part
 call bird_body
 call ground
 ret

anime:
	
	call sscore
main_loop:
	call delay
	call delay
    call HandleKeyPress 
	call collision
	cmp word[collision_detected],1
	je Collider
	mov word[collision_detected],0
continue_loop:
    push pipesY ; y-coordinate address of pipe
    push pipesX ; x-coordinate address of pipe    
    call movePipe

    push pipesY+2 ; y-coordinate address of pipe
    push pipesX+2 ; x-coordinate address of pipe
    call movePipe
    push 1
    push word [pipesY] ; x-coordinate of pipe
    push word [pipesX] ; y-coordinate of pipe
    call defDrawPipe
    push 1
    push word [pipesY+2] ; x-coordinate of pipe
    push word [pipesX+2] ; y-coordinate of pipe
    call defDrawPipe
    push 0
    push word [leftOverPipeY]
    push 0
    call defDrawPipe
	call ground_mover
	jmp main_loop
	ret

start:
    call DisplayIntroduction
    mov ah, 0
    int 16h
    cmp ah, 0x01
    je exit_game
	call background
	call DisplayIntroduction1
    mov ah, 0
    int 16h
    cmp ah, 0x01
    je exit_game
    call PrintStartScreen
    mov ah, 0
    int 16h
    cmp ah, 0x01
	call anime
	mov ax,0x4c00
	int 0x21

; [org 0x0100]
 ; mov ax, 0x0013 
 ; int 0x10 
 ; mov ax, 0xA000 
 ; mov es, ax 
     ; jmp start
; exit_msg: db 'Exit? (y/n)', 0  ;
; game_ended_msg: db 'Game Ended. Press Key', 0
; a_keeper: dw 0
; rect_mov_count: dw 0
; green_shades db 2, 10, 12, 28, 34 
; upperPillarHeight dw 0 
; lowerPillarHeight dw 0 
; bird_bottom_corner: dw 0
; bird_bottom_corner_end: dw 0
; bird_top_corner: dw 0
; bird_pos: dw 31180
; pipesX: dw 319, 459
; pipesY: dw 20 , 20
; leftOverPipeWidth: dw 0
; leftOverPipeY: dw 0
; boolDrawBottomPipe: dw 0
; intBottomPipeStart: dw 0
; intPipeEndX: dw 0
; collision_detected: dw 0
; boolAdjusted: dw 0
; boolFirstPipe: dw 0
; rect_pos1: dw 0
; rect_pos2: dw 0
; rect_pos_down: dw 0
; rect_pos_down1: dw 0
; rect_pos_down2: dw 0
; isAnimating: dw 0
; BirdDirection: db 'D'
; bird_position_holder: dw 0
; score :dw 0
; game_end: dw 0
; tickcount: dw 0
; old_timer:dw 0,0
; oldtimer : dw 0, 0
; delay_threshold dw 1600   
; timer_hooked db 0    
; is_flapping :db 0  
; upper_pillar_helper: dw 0
; GameTitle: db 'Assembler Aviator', 0
; RollNumbers: db 'Roll Numbers: 23L-0815, 23L-0576', 0
; Names: db 'Developed by: Ali Jafar,Tayyab Khalil', 0
; Semester: db 'Semester: Fall 2024', 0
; Instructions: db 'Press UP ARROW to move up,ESC to quit', 0
; Instructions1: db 'If ESC is pressed, game stops', 0
; Instructions2: db 'If y is pressed, it exits', 0
; Instructions3: db 'else it continues from where it stops', 0
; StartMessage: db 'Press any key to start...', 0
; cscore: db 'Score: ' ,0
; ; notes: dw 440, 494, 523, 587, 659, 698, 784  ; Frequencies for A4, B4, C5, etc.
; ; durations: dw 300, 300, 400, 300, 500, 300, 600 ; Durations in milliseconds
; ; note_count: dw 7                              ; Number of notes
; notes: dw 0x1FB4, 0x152F, 0x0A97  ; Frequencies for D3, A3, and A4
; durations: dw 500, 500, 500         ; Durations in milliseconds
; note_count: dw 3                    ; Number of notes
; current_note: dw 0                  ; Index of the current note
; ; pcb: times *2 dw 0 ; Allocate space for 2 tasks (game + music)

; pcb: dw 0, 0, 0, 0, 0 ; task0 regs[cs:pcb + 0]
; dw 0, 0, 0, 0, 0 ;
; current: db 0
; background:
; push cs 
; pop ds
; push es
    ; xor di, di
    ; mov cx, 320 * 200
    ; mov al, 2
    ; rep stosb
	; pop es
    ; ret
; DisplayIntroduction:

; push cs 
; pop ds
; push es
    ; call background
    ; mov dh, 7
    ; mov dl, 3
    ; mov si, GameTitle
    ; call PrintStringAtPosition
    ; mov dh, 9
    ; mov si, RollNumbers
    ; call PrintStringAtPosition

    ; mov dh, 11
    ; mov si, Names
    ; call PrintStringAtPosition

    ; mov dh, 13
    ; mov si, Semester
    ; call PrintStringAtPosition

    ; mov dh, 15
    ; mov si, Instructions
    ; call PrintStringAtPosition

    ; mov dh, 17
    ; mov si, StartMessage
    ; call PrintStringAtPosition
	; pop es
    ; ret

; PrintStringAtPosition:

; push cs 
; pop ds
; push es
    ; pusha
    ; mov ah, 02h
    ; int 10h
    ; mov ah, 0Eh
    ; mov bh, 0
    ; mov bl, 15

; print_position_loop:
    ; lodsb
    ; cmp al, 0
    ; je done_position_print
    ; int 10h
    ; jmp print_position_loop

; done_position_print:
    ; popa
	; pop es
    ; ret

; collision:
; cli
; push cs 
; pop ds
; ;push es
; pusha
 ; cmp word[bird_pos],150
 ; ja next_check
 ; mov word[collision_detected],1
 ; jmp get_out
; next_check:
; mov di, word[bird_bottom_corner_end]
; add di,320
 ; cmp di,57600
 ; jb get_out
 ; mov word[collision_detected],1
; get_out: 
; popa
; ;pop es
; ret


; ShowExitConfirmation:
; push cs 
; pop ds
    ; mov ah, 02h                
    ; mov bh, 0                   
    ; mov dh, 24                  ; Row (adjust as needed)
    ; mov dl, 15                  ; Column (adjust as needed)
    ; int 10h

    ; mov ah, 0Eh                 ; BIOS teletype function
    ; mov bh, 0                   ; Page number
    ; mov bl, 2                  ; White text
    ; mov si, exit_msg            ; Pointer to message

; print_message_text:
    ; lodsb                      
    ; cmp al, 0
    ; je wait_for_key1
    ; int 10h                   
    ; jmp print_message_text

; wait_for_key1:
; push cs 
; pop ds
    ; mov ah, 0
    ; int 16h                     ; Get key in AL
    ; cmp al, 'y'                 ; Check if 'y' or 'Y'
    ; je exit_game
    ; cmp al, 'Y'
    ; je exit_game
; end_erase:
	; mov bx,10
	; mov di,60920
; exit_loop:
	; mov cx,88
	; mov al,6
	; rep stosb
	; dec bx
	; add di,232
	; cmp bx,0
; jne exit_loop
    ; ret
; exit_game:  
; mov word[game_end],1

    ; mov al, 11111101b    
    ; in  al, 61h          
    ; and al, 11111100b    
    ; out 61h, al          
    ; mov al, 10110110b    
    ; out 43h, al          
    ; mov al, 0            
    ; out 42h, al          
	 ; mov al, 0           
    ; out 42h, al          
    ; ; Wait for a keypress
; wait_for_key:
    ; mov ah, 0                      ; BIOS keyboard function
    ; int 16h                        ; Wait for key

    ; ; Clear the stack and prepare for a clean exit
; reset_stack:
    ; cli                            ; Disable interrupts
    ; xor ax, ax                     ; AX = 0
    ; mov ss, ax                     ; Reset stack segment to 0
    ; mov sp, 0xFFFE                 ; Set stack pointer to a safe high value
    ; sti                            ; Re-enable interrupts

    ; ; Restore video mode to text mode 03h (80x25 color text)
    ; mov ax, 0x0003                 ; Set video mode 03h
    ; int 0x10                       ; Call BIOS to restore text mode

    ; ; Forcefully restore all critical interrupt vectors
    ; xor ax, ax                     ; AX = 0
    ; mov es, ax                     ; ES = 0 (interrupt vector table segment)

    ; ; Restore default INT 9h (keyboard interrupt) to BIOS
    ; ;mov word [es:9*4], 0x1C        ; Default offset for keyboard handler
    ; ;mov word [es:9*4+2], 0xF000    ; Default segment for keyboard handler
; mov ax,[oldtimer]
; mov bx,[oldtimer+2]
     ; mov word [es:8*4],ax 
     ; mov [es:8*4+2], bx
; ; mov byte [cs:dead], 1  ; Stop the sound
    ; ; Stop the sound by disabling the speaker
    ; mov ah, 0                      ; BIOS keyboard function
    ; int 16h                        ; Clear buffer with wait
    ; mov ah, 1
    ; int 16h                        ; Test for a keypress
    ; jz no_more_keys
; clear_keys:
    ; mov ah, 0
    ; int 16h                        ; Read and discard key
    ; jmp no_more_keys
; no_more_keys:

    ; mov al, 20h                    ; End-of-Interrupt command
    ; out 20h, al                    ; Send to PIC
    ; mov cx, 0FFFFh                 ; Arbitrary delay
; delay_loop:
    ; loop delay_loop
; jmp ll2
    ; ; Terminate program and return to DOS
    ; mov ax, 0x4C00                 ; DOS terminate program function
    ; int 0x21                       ; Exit program and return to DOS



; upper_part:
; push cs 
; pop ds
; push es
    ; xor di, di
    ; mov al, 35h
    ; mov cx, 320 * 60
    ; rep stosb
	; pop es
    ; ret

; medium_part:
; push cs 
; pop ds
; push es
    ; mov di, 320 * 60
    ; mov al, 35h
    ; mov cx, 360 * 60
    ; rep stosb
	; pop es
    ; ret

; lower_part:
; push cs 
; pop ds
; push es
    ; mov di, 320 * 120
    ; mov al, 35h
    ; mov cx, 320 * 80
    ; rep stosb
	; pop es
    ; ret

; sscore:
; push cs 
; pop ds
; push es
    ; pusha
    ; mov si, cscore
    ; mov ah, 02h
    ; mov bh, 0
    ; mov dh, 24
    ; mov dl, 1
    ; int 10h
    ; mov ah, 0Eh
    ; mov bh, 0
    ; mov bl, 15

; print_scoer:
    ; lodsb
    ; cmp al, 0
    ; je done_
    ; int 10h
    ; jmp print_scoer

; done_:
    ; popa
	; pop es
    ; ret

; cal_dig:

    ; call sscore
	; push cs 
; pop ds
; push es
    ; mov ax, [score]
	; cmp ax,1000
	; je movv
	; jne movv1
	; movv:
	; mov ax,0
	; movv1:
    ; xor cx, cx
    ; mov bx, 10
; store_digits:
; push cs 
; pop ds
    ; xor dx, dx
    ; div bx
    ; push dx
    ; inc cx
    ; cmp ax, 0
    ; jnz store_digits

; draw_score:
; push cs 
; pop ds
    ; mov ah, 02h
    ; mov bh, 0
    ; mov dh, 24
    ; mov dl, 8
    ; int 10h

; print_digits:

    ; pop dx
    ; add dl, 0x30
    ; mov al, dl
    ; mov ah, 0Eh
    ; mov bh, 0
    ; int 10h
    ; inc dl
    ; loop print_digits
	; pop es
    ; ret    


; bird_body:
; push cs 
; pop ds
; push es
    ; pusha
    ; mov bx,12 
    ; mov si, [bird_pos] 
    ; add si,18
    ; mov word[bird_top_corner],si
    ; sub si,18
; body:
    ; mov di, si
    ; mov al, 14 
    ; mov cx, 18 
    ; rep stosb
    ; sub bx,1
    ; add si, 320
    ; cmp bx, 0 
    ; jnz body
	; push di
	; mov di,[bird_pos]
	; add di,1608
	; mov al,  0xCC
	; stosb
	; inc di
	; stosb
	; inc di
	; stosb
	; pop di
    ; sub si,320
    ; mov word[bird_bottom_corner],si
    ; add si,18
    ; mov word[bird_bottom_corner_end],si
    ; sub si,18
    ; mov [bird_position_holder],si
    ; popa
; pop es	
    ; ret 

; defDrawPipe:
    ; push bp
    ; mov bp, sp
    ; pusha
    ; mov cx, [bp+4]
    ; mov dx, 0
    ; mov ah, 0ch
    ; mov bx, [bp+6]
    ; mov word [intBottomPipeStart], bx
    ; add word [intBottomPipeStart], 55
    ; mov word [boolDrawBottomPipe], 0
    ; mov word [intPipeEndX], cx
    ; add word [intPipeEndX], 40
    ; cmp word [bp+8], 1
    ; je drawTopPipe
    ; cmp word [leftOverPipeWidth], 0
    ; jbe endDrawPipe
    ; mov cx, [leftOverPipeWidth]
    ; mov word [intPipeEndX], cx
    ; mov cx, 40
    ; sub cx, [leftOverPipeWidth]
    ; add bx, cx
    ; mov cx, 0
    ; dec word [leftOverPipeWidth]
; drawTopPipe:
    ; mov al,2
; colorSelected:
    ; cmp cx, 320
    ; jae endDrawPipe
    ; cmp cx, 0
    ; jb endDrawPipe
    ; int 10h
; skipPipe:
    ; inc dx
    ; cmp dx, [bp+6]
    ; jbe drawTopPipe
    ; cmp dx, [intBottomPipeStart]
    ; ja notSkip
    ; add dx, 54
; notSkip:
    ; cmp dx, 180
    ; jb drawTopPipe
    ; inc cx
    ; mov dx, 0
    ; inc bx
    ; cmp cx, [intPipeEndX]
    ; jb drawTopPipe
; endDrawPipe:
    ; popa 
    ; pop bp
	; ;pop es
    ; ret 6
; movePipe:
; push cs 
; pop ds
    ; push bp
    ; mov bp, sp
    ; pusha
    ; inc word[rect_mov_count]
    ; cmp word[rect_mov_count],325
    ; je incc
    ; jne noincc
; incc:
    ; mov word[rect_mov_count],0
    ; inc word[score]
    ; call cal_dig
; noincc:
    ; mov bx, [bp+4]
    ; dec word [bx]
    ; mov cx, [bx]
    ; add cx,41
    ; mov word [boolAdjusted], 0
    ; cmp cx, 320
    ; jge adjustX
    ; jmp continueDrawing
; adjustX:
    ; sub word cx, 320
    ; mov word [boolAdjusted], 1
; continueDrawing:
    ; mov dx,0
    ; mov al,35h
    ; mov ah,0ch
    ; mov si,[bp+6]
; drawLastColumnSky:
    ; int 10h
    ; cmp dx, [ds:si]
    ; jne continueDrawingSky
    ; cmp word [boolAdjusted], 0
    ; je notCheckForadjusted
    ; cmp cx,41
    ; ja skipSkyColumn
; notCheckForadjusted:
    ; cmp cx,41
    ; jb continueDrawingSky
    ; add dx, 55
    ; jmp drawLastColumnSky
; continueDrawingSky:
    ; inc dx
    ; cmp dx,180
    ; jb drawLastColumnSky
; skipSkyColumn:
    ; sub cx,41
    ; cmp cx,0
    ; jne endMovePipe
    ; cmp word [pipesX], 0
    ; jne endMovePipeContinue
    ; mov word [boolFirstPipe], 1
; endMovePipeContinue:
    ; mov word [leftOverPipeWidth], 40
    ; mov cx, [ds:si]
    ; mov word [leftOverPipeY], cx
    ; mov word [bx], 320
    ; push word [bp+6]
    ; call generateRandomNumber
; endMovePipe:
    ; popa
    ; pop bp
    ; ret 2
; generateRandomNumber:
; push cs 
; pop ds
    ; push bp
    ; mov bp, sp
    ; pusha
    ; mov ah,0
    ; int 1ah
    ; mov ax,dx
    ; mov bx,60
    ; mov dx,0
    ; div bx
    ; mov bx, [bp+4]
    ; mov word [bx], dx
    ; add word [bx], 20
    ; popa
    ; pop bp
    ; ret 2

; ground:
; push cs 
; pop ds
; push es
    ; mov di, 57600
    ; mov cx, 320 * 10
    ; mov bx, 1
; .draw_gradient:
    ; mov al, [green_shades+bx]
    ; stosb
    ; inc bx
    ; cmp bx, 4
    ; jne .continue_gradient
    ; mov bx, 1
; .continue_gradient:
    ; loop .draw_gradient
    ; mov di, 60800
    ; mov al, 6
    ; mov cx, 320 * 10
    ; rep stosb
	; pop es
    ; ret


; delay:
; push cs 
; pop ds
 ; pusha
 ; mov cx,64000
; delay1:
 ; loop delay1
 ; popa
 ; ret



; remover_bird:
; push cs 
; pop ds
 ; pusha
 ; mov di,si
 ; mov al,35h
 ; mov cx,18
 ; rep stosb
 ; popa
 ; ret



; bird_falling:
; push cs 
; pop ds
; pusha
; mov ax,0xA000
; mov es,ax
; push di
; mov di,[bird_top_corner]
; cmp byte[es:di],2
; je exit_game_1
; mov di,[bird_bottom_corner]
; cmp byte[es:di+320],2
; je exit_game_1
; mov di,[bird_bottom_corner_end]
; cmp byte[es:di+320],2
; je exit_game_1
; pop di
 ; mov si,word[bird_pos]
 ; call remover_bird
 ; add word[bird_pos],320
 ; call bird_body
; jmp outr
; exit_game_1:
; mov word[collision_detected],1
; pop di
; outr:
 ; popa
 ; ret

; moving_up:
; push cs 
; pop ds
 ; pusha
; mov ax,0xA000
; mov es,ax
; push di
; mov di,[bird_top_corner]
; cmp byte[es:di-320],2
; je exit_game_2
; mov di,[bird_bottom_corner_end]
; cmp byte[es:di],2
; je exit_game_2
; mov di,[bird_pos]
; cmp byte[es:di-320],2
; je exit_game_2
; pop di

 ; sub word[bird_pos],320
 ; mov si,[bird_position_holder]
 ; call remover_bird
 ; call bird_body
; jmp outrr
; exit_game_2:
; mov word[collision_detected],1
; pop di
; outrr:
 ; popa
 ; ret

; bird_falling_collide:
; push cs 
; pop ds
; pusha
 ; mov si,word[bird_pos]
 ; call remover_bird
 ; add word[bird_pos],320
 ; call bird_body
 ; popa
 ; ret

; remover_extra:
; push cs 
; pop ds
; pusha
 ; mov di,[bird_pos]
; mov cx,12
 ; mov al,35h
; l2:
 ; stosb
 ; add di,319
; loop l2
 ; popa
 ; ret


; collide_extra:
; push cs 
; pop ds
; pusha
; l1:
; call remover_extra
; add word[bird_pos],1
; call delay
; call delay
; call bird_body
; mov di,[bird_bottom_corner]
; cmp byte[es:di+320],2
; je l1
; popa
; ret

; Collider:
    ; mov al, 11111101b    ; Clear bit 1 (Speaker Gate)
    ; in  al, 61h          ; Read current state of port 61h
    ; and al, 11111100b    ; Clear speaker bits
    ; out 61h, al          ; Write back to port 61h
    ; mov al, 10110110b    ; Control word: Select Channel 2, Latch Command
    ; out 43h, al          ; Send control word to PIT command register
    ; mov al, 0            ; Send initial count low byte
    ; out 42h, al          ; Write to Channel 2 data port
    ; mov al, 0            ; Send initial count high byte
    ; out 42h, al
; push cs 
; pop ds
; iteration:
; pusha
; mov ax,0xA000
; mov es,ax
; mov di,[bird_bottom_corner_end]
; cmp byte[es:di+318],2
; je outrrr
; mov di,[bird_bottom_corner]
; cmp byte[es:di+320],2
; je outrrr
; popa
; call delay
; call bird_falling_collide
; cmp word[bird_bottom_corner_end],57600
; jb iteration
; jmp labela
; outrrr:
; call collide_extra
; popa
; call Collider
; labela:
; call delay
; call delay
; call exit_game
; ret

; HandleKeyPress:
; push cs 
; pop ds
    ; push ax
    ; push bx
    ; push cx
    ; push dx
    ; mov ah, 1          
    ; int 0x16
    ; jz no_key_pressed  
    ; mov ah, 0          
    ; int 0x16
    ; cmp ah, 0x01          
    ; je exit_game_press

    ; cmp ah, 0x48          
    ; je handle_up

    ; cmp ah, 0xC8          
    ; je handle_release

    ; jmp no_key_pressed    

; exit_game_press:
    ; call ShowExitConfirmation
    ; jmp out_of

; handle_up:
    ; mov word [is_flapping], 1  
    ; mov word [tickcount], 0    
    ; call moving_up             
    ; jmp out_of
; handle_release:
    ; cmp byte [timer_hooked], 1 
    ; je out_of                  
    ; mov byte [timer_hooked], 1 
    ; call hook_timer            
    ; mov word [is_flapping], 0  
    ; jmp out_of
; no_key_pressed:
    ; call bird_falling
; out_of:
    ; pop dx
    ; pop cx
    ; pop bx
    ; pop ax
    ; ret


; hook_timer:
; push cs 
; pop ds
    ; cli                        
    ; push ds
    ; xor ax, ax
    ; mov es, ax
    ; mov ax, word [es:8*4]
    ; mov word [old_timer], ax
    ; mov ax, word [es:8*4+2]
    ; mov word [old_timer+2], ax
    ; mov ax, [delay_threshold]
    ; mov word [es:8*4], timr
    ; mov word [es:8*4+2], cs
    ; pop ds
    ; sti
    ; ret

; timr:
; push cs 
; pop ds
    ; push ax
    ; push bx
    ; push cx
    ; push dx
    ; inc word [tickcount]
    ; cmp word [tickcount], ax
    ; jne end_timer
    ; mov word [tickcount], 0
    ; call bird_falling
    ; mov byte [timer_hooked], 0
    ; call unhook_timer
; end_timer:
    ; mov al, 0x20
    ; out 0x20, al
    ; pop dx
    ; pop cx
    ; pop bx
    ; pop ax
    ; iret

; unhook_timer:
; push cs 
; pop ds
    ; cli
    ; push ds
    ; xor ax, ax
    ; mov es, ax
    ; mov ax, word [old_timer]
    ; mov word [es:8*4], ax
    ; mov ax, word [old_timer+2]
    ; mov word [es:8*4+2], ax
    ; pop ds
    ; sti
    ; ret

; ground_mover:
; push cs 
; pop ds
 ; pusha
 ; push ds
 ; push es
 ; mov ax,0xA000
 ; mov ds,ax
 ; mov di,57600
 ; mov si,57602
 ; mov cx,3198
 ; rep movsb
 ; pop es
 ; pop ds
 ; popa
 ; ret

; PrintStartScreen:
 ; call upper_part  
 ; call medium_part
 ; call lower_part
 ; call bird_body
 ; call ground
 ; ret

; anime:
	; call sscore

; main_loop:
	; call delay
	; call delay
    ; call HandleKeyPress 
	; call collision
	; cmp word[collision_detected],1
	; je Collider
	; mov word[collision_detected],0
; continue_loop:
; mov ax,0xA000
; mov ds,ax
    ; push pipesY ; y-coordinate address of pipe
    ; push pipesX ; x-coordinate address of pipe    
    ; call movePipe

    ; push pipesY+2 ; y-coordinate address of pipe
    ; push pipesX+2 ; x-coordinate address of pipe
    ; call movePipe
    ; push 1
    ; push word [pipesY] ; x-coordinate of pipe
    ; push word [pipesX] ; y-coordinate of pipe
    ; call defDrawPipe
    ; push 1
    ; push word [pipesY+2] ; x-coordinate of pipe
    ; push word [pipesX+2] ; y-coordinate of pipe
    ; call defDrawPipe
    ; push 0
    ; push word [leftOverPipeY]
    ; push 0
    ; call defDrawPipe
	; call ground_mover
		; ;call music
; jmp main_loop ; Repeat the main loop
	; ret
; sound:
    ; pusha                       ; Save all general-purpose registers
    ; push ds                     ; Save DS
    ; push es                     ; Save ES
    ; push ss                     ; Save SS
    ; mov ax, 0xA000              ; Video memory segment
    ; mov es, ax                  ; Use ES for potential screen updates (if needed)

; infinite_sound_loop:
    ; mov al, 182                 ; Command to set frequency mode
    ; out 43h, al
    ; mov bx, 1193180             ; Base frequency of 1.19318 MHz
    ; div bx                      ; Calculate divisor for desired frequency
    ; out 42h, al                 ; Low byte of divisor to timer
    ; mov al, ah
    ; out 42h, al                 ; High byte of divisor to timer

    ; ; Enable the speaker
    ; in al, 61h                  ; Read speaker control register
    ; or al, 00000011b            ; Enable speaker
    ; out 61h, al

    ; ; Optional delay or loop (minimal)
    ; nop                         ; Use NOP or a small delay instead of an infinite loop
    ; nop

    ; ; Disable the speaker
    ; in al, 61h
    ; and al, 11111100b           ; Disable speaker
    ; out 61h, al
    ; jmp infinite_sound_loop

; sound_exit:
    ; pop ss                      ; Restore SS
    ; pop es                      ; Restore ES
    ; pop ds                      ; Restore DS
    ; popa                        ; Restore all general-purpose registers
    ; ret                         ; Return to caller
; prrint:
; inc word [score]
; call sound
; jmp prrint
; start:

 ; call DisplayIntroduction 
 ; mov ah,0
 ; int 16h
 ; cmp ah,0x01
 ; je exit_game
 ; call PrintStartScreen 
     ; xor ax, ax
     ; mov es, ax
     ; cli
	 ; mov ax, word[es:8*4]
	 ; mov word [oldtimer],ax
	 ; mov ax,word[es:8*4+2]
	 ; mov word[oldtimer+2],ax
     ; mov word [es:8*4], timer
     ; mov [es:8*4+2], cs
     ; sti

; ll1:
     ; mov word [pcb+10+4], sound         ; Game logic thread
     ; mov [pcb+10+6], cs
     ; mov word [pcb+10+8], 0x0200    
     ; mov word [pcb+20+4], anime  ; Music thread
     ; mov [pcb+20+6], cs
     ; mov word [pcb+20+8], 0x0200         ; Flags
     ; mov word [current], 0               ; Start with the first task
	 ; jmp ll1
	 ; ll2:
	 ; cmp word[game_end] ,1
	 ; je exxxxit
	 ; exxxxit:
 ; mov ax, 0x4C00
; int 0x21
; timer:
	; push cs 
; pop ds
  ; push ax
 ; push bx
 ; mov bl, [cs:current] ; read index of current task ... bl
 ; mov ax, 10 ; space used by
 ; mul bl ; multiply to get
 ; mov bx, ax ; load start of
 ; pop ax ; read origina

 ; mov [cs:pcb+bx+2], ax ; space for current task's BX
 ; pop ax ; read original
 ; mov [cs:pcb+bx+0], ax ; space for current task's AX
 ; pop ax ; read original
 ; mov [cs:pcb+bx+4], ax ; space for current task
 ; pop ax ; read original
 ; mov [cs:pcb+bx+6], ax ; space for current task
 ; pop ax ; read original
 ; mov [cs:pcb+bx+8], ax ; space for current task
 ; inc byte [cs:current] ; update current task index...1
 ; cmp byte [cs:current], 3; is task index out of range
 ; jne skipreset ; no, proceed
 ; mov byte [cs:current], 0 ; yes, reset to task 0
 ; skipreset: 
 ; mov bl, [cs:current] ; read index of current task
 ; mov ax, 10 ; space used by
 ; mul bl ; multiply to get
 ; mov bx, ax ; load start of
 ; mov al, 0x20
 ; out 0x20, al ; send EOI to PIC
 ; push word [cs:pcb+bx+8] ; flags of new task...
 ; push word [cs:pcb+bx+6] ; cs of new task ...
 ; push word [cs:pcb+bx+4] ; ip of new task...
 ; mov ax, [cs:pcb+bx+0] ; ax of new task...pcb+10+0
 ; mov bx, [cs:pcb+bx+2] ; bx of new task...pcb+10+2
 ; iret ; return to new