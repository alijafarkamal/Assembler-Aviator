org 0x0100                ; Origin point, standard for DOS .COM files

start:
    ; Set video mode to 320x200 with 256 colors
    mov ax, 0x0013
    int 0x10

    ; Set segment to video memory
    mov ax, 0xA000
    mov es, ax

    ; Fill the upper part with Light Blue (Index 11)
    xor di, di                ; Start at the top-left pixel
    mov al, 11                ; Color index for light blue
    mov cx, 320*60            ; Fill 60 rows of 320 pixels each
    rep stosb                 ; Fill the area with light blue

    ; Fill the middle part with Medium Blue (Index 9)
    ; We need to adjust DI to start filling from the 61st row
    mov di, 320*60           ; Start at pixel 19200 (after first 60 rows)
    mov di, 320*60            ; Start at pixel 19200 (after first 60 rows)
    mov al, 9                 ; Color index for medium blue
    mov cx, 360*60           ; Fill the next 60 rows (middle part)
    mov cx, 320*60            ; Fill the next 60 rows (middle part)
    rep stosb                 ; Fill the area with medium blue

    ; Fill the lower part with Dark Blue (Index 1)
    ; Now adjust DI to start filling from the 121st row
    mov di, 320*120           ; Start at pixel 38400 (after first 120 rows)
    mov al, 1                 ; Color index for dark blue
    mov cx, 320*80            ; Fill the remaining 80 rows (lower part)
    rep stosb                 ; Fill the area with dark blue
	 
 mov bx,12     ;height of bird body
 mov si, 31180;points to the middle of screen
 
bird_body:
mov di, si        ; Start at pixel 31180 
 
    mov al, 14               ; Color index for yellow
   mov cx, 18              ;width of body
    rep stosb
	sub bx,1              ; decrement the length counter
	add si, 320           ;move to the nex row since one line consists of 320 pixels
	cmp bx ,0 
	jnz bird_body
		mov si,0	
 mov bx,50           ;height of rectangle
 mov si, 48920        ;position of rectangle 
green_rect_down:
   mov di, si        ; Start at pixel 38400 
 
    mov al, 2             ; Color index for Green
   mov cx, 28             ;width of body
    rep stosb
	sub bx,1              ; decrement the length counter
	add si, 320           ;move to the nex row since one line consists of 320 pixels
	cmp bx ,0 
	jnz green_rect_down
		mov si,0	
 mov bx,70           ;height of rectangle
 mov si, 00920        ;position of rectangle 
green_rect_up:
   mov di, si        ; Start at pixel 00920 
 
    mov al, 2             ; Color index for Green
   mov cx, 28             ;width of body
    rep stosb
	sub bx,1              ; decrement the length counter
	add si, 320           ;move to the nex row since one line consists of 320 pixels
	cmp bx ,0 
	jnz green_rect_up
	 mov dx,50          ; Initialize DX (loop counter or row size modifier)
    mov si,120         ; Initialize SI (starting row)
loop:

    ; Calculate di = 320 * si using shifts and adds
    mov ax, si         ; Move si into ax to preserve si
    shl ax, 8          ; Multiply by 256 (shift left by 8 bits)
    mov bx, si         ; Copy si to bx
    shl bx, 6          ; Multiply by 64 (shift left by 6 bits)
    add ax, bx         ; Add the two results together (320 * si)
    mov di, ax         ; Now di = 320 * si

    mov al, 9          ; Color index for medium blue

    cmp dx, 0          ; Check if the loop counter is 0
    jz out             ; Exit if dx is 0
    ; Now draw the triangle wave pattern starting from column 370
    mov dx, 50                ; Initialize DX (width of the wave at start)
    mov si, 120               ; Start at the 120th row (beginning of dark blue section)
wave_loop:
    ; Calculate di = 320 * si (for the next row)
    mov ax, si
    shl ax, 8                 ; Multiply by 256 (shift left by 8 bits)
    mov bx, si
    shl bx, 6                 ; Multiply by 64 (shift left by 6 bits)
    add ax, bx                ; Add the two results together (320 * si)
    mov di, ax                ; Now di = 320 * si (where to draw the wave)
    ; Add column offset to start the wave from column 370
    add di, 0               ; Offset by 50 to start the wave at column 370
    cmp si, 200               ; Stop once we've processed all 200 rows
    jge end_wave              ; Exit loop if we've reached the end of the screen
    ; Draw the triangle wave (decreasing dx in each iteration)
    cmp dx, 0
    jle end_wave              ; Exit the loop if DX reaches 0
    ; Now fill the wave in medium blue
    mov al, 9                 ; Medium blue for the wave
    mov cx, dx                ; Set CX for the number of pixels in the wave
    rep stosb                 ; Draw the wave part in medium blue
    sub dx, 2                 ; Decrease DX to make the wave narrower in each row
    add si, 1                 ; Move to the next row
    jmp wave_loop             ; Repeat the loop
end_wave:
mov dx, 50                ; Initialize DX (width of the wave at start, determines wave width)
mov si, 120               ; Start at the 120th row (beginning of dark blue section)
mov bp, 50                ; Starting column offset for the inverted wave
wave_loop_inverted:
    ; Calculate di = 320 * si (for the next row)
    mov ax, si
    shl ax, 8                ; Multiply by 256 (shift left by 8 bits)
    mov bx, si
    shl bx, 6                ; Multiply by 64 (shift left by 6 bits)
    add ax, bx               ; Add the two results together (320 * si)
    mov di, ax               ; Now di = 320 * si (where to draw the wave)
    ; Add column offset to start the wave from column (e.g., 370 initially)
    add di, bp               ; Offset to start the wave from right of first wave
    cmp si, 200              ; Stop once we've processed all 200 rows
    jge end_wave_inverted    ; Exit loop if we've reached the end of the screen
    ; Draw the triangle wave (increasing dx in each iteration to create inverted effect)
    cmp dx, 0
    jle end_wave_inverted    ; Exit the loop if DX reaches 0
    mov al, 9                ; Medium blue for the wave
    mov cx, dx               ; Set CX for the number of pixels in the wave
    rep stosb                ; Draw the wave part in medium blue
    sub dx, 2                ; Decrease DX to make the wave narrower in each row
    add bp, 2               ; Move the start point leftward to create an inverted effect
    add si, 1                ; Move to the next row
    jmp wave_loop_inverted   ; Repeat the loop
end_wave_inverted:
		mov dx, 50                ; Initialize DX (width of the wave at start)
    mov si, 120               ; Start at the 120th row (beginning of dark blue section)
	
	wave_loop1:
    ; Calculate di = 320 * si (for the next row)
    mov ax, si
    shl ax, 8                 ; Multiply by 256 (shift left by 8 bits)
    mov bx, si
    shl bx, 6                 ; Multiply by 64 (shift left by 6 bits)
    add ax, bx                ; Add the two results together (320 * si)
    mov di, ax                ; Now di = 320 * si (where to draw the wave)
	
    ; Add column offset to start the wave from column 370
    add di, 100              ; Offset by 50 to start the wave at column 370
    cmp si, 200               ; Stop once we've processed all 200 rows
    jge end_wave1              ; Exit loop if we've reached the end of the screen
	
    ; Draw the triangle wave (decreasing dx in each iteration)
    cmp dx, 0
    jle end_wave1              ; Exit the loop if DX reaches 0
	
    ; Now fill the wave in medium blue
    mov al, 9                 ; Medium blue for the wave
    mov cx, dx                ; Set CX for the number of pixels in the wave
    rep stosb                 ; Draw the wave part in medium blue
    sub dx, 2                 ; Decrease DX to make the wave narrower in each row
    add si, 1                 ; Move to the next row
    jmp wave_loop1         ; Repeat the loop
	end_wave1:
	
	
mov dx, 50                ; Initialize DX (width of the wave at start, determines wave width)
mov si, 120               ; Start at the 120th row (beginning of dark blue section)
mov bp, 150                ; Starting column offset for the inverted wave
wave_loop_inverted1:
    ; Calculate di = 320 * si (for the next row)
    mov ax, si
    shl ax, 8                ; Multiply by 256 (shift left by 8 bits)
    mov bx, si
    shl bx, 6                ; Multiply by 64 (shift left by 6 bits)
    add ax, bx               ; Add the two results together (320 * si)
    mov di, ax               ; Now di = 320 * si (where to draw the wave)
    ; Add column offset to start the wave from column (e.g., 370 initially)
    add di, bp               ; Offset to start the wave from right of first wave
    cmp si, 200              ; Stop once we've processed all 200 rows
    jge end_wave_inverted1    ; Exit loop if we've reached the end of the screen
    ; Draw the triangle wave (increasing dx in each iteration to create inverted effect)
    cmp dx, 0
    jle end_wave_inverted1    ; Exit the loop if DX reaches 0
    mov al, 9                ; Medium blue for the wave
    mov cx, dx               ; Set CX for the number of pixels in the wave
    rep stosb                ; Draw the wave part in medium blue
    sub dx, 2                ; Decrease DX to make the wave narrower in each row
    add bp, 2               ; Move the start point leftward to create an inverted effect
    add si, 1                ; Move to the next row
    jmp wave_loop_inverted1   ; Repeat the loop
end_wave_inverted1:
	
	mov dx, 50                ; Initialize DX (width of the wave at start)
    mov si, 120               ; Start at the 120th row (beginning of dark blue section)
	
	wave_loop2:
    ; Calculate di = 320 * si (for the next row)
    mov ax, si
    shl ax, 8                 ; Multiply by 256 (shift left by 8 bits)
    mov bx, si
    shl bx, 6                 ; Multiply by 64 (shift left by 6 bits)
    add ax, bx                ; Add the two results together (320 * si)
    mov di, ax                ; Now di = 320 * si (where to draw the wave)
	
    ; Add column offset to start the wave from column 370
    add di, 200              ; Offset by 50 to start the wave at column 370
    cmp si, 200               ; Stop once we've processed all 200 rows
    jge end_wave2              ; Exit loop if we've reached the end of the screen
	
    ; Draw the triangle wave (decreasing dx in each iteration)
    cmp dx, 0
    jle end_wave2             ; Exit the loop if DX reaches 0
	
    ; Now fill the wave in medium blue
    mov al, 9                 ; Medium blue for the wave
    mov cx, dx                ; Set CX for the number of pixels in the wave
    rep stosb                 ; Draw the wave part in medium blue
    sub dx, 2                 ; Decrease DX to make the wave narrower in each row
    add si, 1                 ; Move to the next row
    jmp wave_loop2         ; Repeat the loop
	end_wave2:
mov dx, 50                ; Initialize DX (width of the wave at start, determines wave width)
mov si, 120               ; Start at the 120th row (beginning of dark blue section)
mov bp, 250                ; Starting column offset for the inverted wave
wave_loop_inverted2:
    ; Calculate di = 320 * si (for the next row)
    mov ax, si
    shl ax, 8                ; Multiply by 256 (shift left by 8 bits)
    mov bx, si
    shl bx, 6                ; Multiply by 64 (shift left by 6 bits)
    add ax, bx               ; Add the two results together (320 * si)
    mov di, ax               ; Now di = 320 * si (where to draw the wave)
    ; Add column offset to start the wave from column (e.g., 370 initially)
    add di, bp               ; Offset to start the wave from right of first wave
    cmp si, 200              ; Stop once we've processed all 200 rows
    jge end_wave_inverted2    ; Exit loop if we've reached the end of the screen
    ; Draw the triangle wave (increasing dx in each iteration to create inverted effect)
    cmp dx, 0
    jle end_wave_inverted2    ; Exit the loop if DX reaches 0
    mov al, 9                ; Medium blue for the wave
    mov cx, dx               ; Set CX for the number of pixels in the wave
    rep stosb                ; Draw the wave part in medium blue
    sub dx, 2                ; Decrease DX to make the wave narrower in each row
    add bp, 2               ; Move the start point leftward to create an inverted effect
    add si, 1                ; Move to the next row
    jmp wave_loop_inverted2   ; Repeat the loop

    mov cx, dx         ; Set CX for the number of pixels to fill
    rep stosb          ; Fill the row with color
end_wave_inverted2:
	mov dx, 50                ; Initialize DX (width of the wave at start)
    mov si, 120               ; Start at the 120th row (beginning of dark blue section)
	
	wave_loop3:
    ; Calculate di = 320 * si (for the next row)
    mov ax, si
    shl ax, 8                 ; Multiply by 256 (shift left by 8 bits)
    mov bx, si
    shl bx, 6                 ; Multiply by 64 (shift left by 6 bits)
    add ax, bx                ; Add the two results together (320 * si)
    mov di, ax                ; Now di = 320 * si (where to draw the wave)
	
    ; Add column offset to start the wave from column 370
    add di, 300              ; Offset by 50 to start the wave at column 370
    cmp si, 200               ; Stop once we've processed all 200 rows
    jge end_wave3             ; Exit loop if we've reached the end of the screen
	
    ; Draw the triangle wave (decreasing dx in each iteration)
    cmp dx, 0
    jle end_wave3             ; Exit the loop if DX reaches 0
	
    ; Now fill the wave in medium blue
    mov al, 9                 ; Medium blue for the wave
    mov cx, dx                ; Set CX for the number of pixels in the wave
    rep stosb                 ; Draw the wave part in medium blue
    sub dx, 2                 ; Decrease DX to make the wave narrower in each row
    add si, 1                 ; Move to the next row
    jmp wave_loop3         ; Repeat the loop
	end_wave3

    sub dx, 2          ; Decrease dx for the next row (creating the wave effect)
    add si, 1          ; Move to the next row
    jmp loop           ; Repeat the loop

out:
    ; Exit loop
    ; Continue the program

    ; Wait for key press (simple method for demonstration purposes)
    xor ax, ax
    int 0x16                  ; Wait for a key press

    ; Set video mode to text mode 80x25 (Mode 03h)
    mov ax, 0x0003            ; Function to set text mode
    int 0x10                  ; Video BIOS interrupt

    ; Terminate program and return to DOS
    mov ax, 0x4C00            ; Terminate process DOS interrupt function
    int 0x21                  ; DOS interrupt this is code which outputs this
    int 0x21                  ; DOS interrupt
