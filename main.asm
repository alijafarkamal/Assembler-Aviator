org 0x0100                ; Origin point, standard for DOS .COM files
			jmp start
upper_part:
	    ; Fill the upper part with Light Blue (Index 11)
    xor di, di               ;Start at the top-left pixel
    mov al, 11               ;Color index for light blue
    mov cx, 320*60           ;Fill 60 rows of 320 pixels each
    rep stosb                ;Fill the area with light blue
	ret
	
    ; Fill the middle part with Medium Blue (Index 9)
    ; We need to adjust DI to start filling from the 61st row
	
medium_part:
    mov di, 320*60        ;Start at pixel 19200 (after first 60 rows)
    mov al, 9             ;Color index for medium blue
    mov cx, 360*60        ;Fill the next 60 rows (middle part)
    rep stosb             ;Fill the area with medium blue
	ret
	 ; Fill the lower part with Dark Blue (Index 1)
    ; Now adjust DI to start filling from the 121st row
lower_part:

	mov di, 320*120       ;Start at pixel 38400 (after first 120 rows)
    mov al, 1             ;Color index for dark blue
    mov cx, 320*80        ;Fill the remaining 80 rows (lower part)
    rep stosb             ;Fill the area with dark blue
	ret
bird_body:
    mov bx,12             ;height of bird body
    mov si, 31180         ;points to the middle of screen
	body:
    mov di, si            ;Start at pixel 31180 
    mov al, 14            ;Color index for yellow
    mov cx, 18            ;width of body
    rep stosb
    sub bx,1              ;decrement the length counter
    add si, 320           ;move to the nex row since one line consists of 320 pixels
    cmp bx ,0 
    jnz body
    mov bx,2              ;height of bird's peak
    mov si, 32158         ;points to the top left corner of bird's peak
	ret	
	
bird_beak:
    mov di, si            ;Start at pixel 32158 
    mov al, 10            ;Color index for lightgreen
    mov cx, 4             ;width of beak
    rep stosb
    sub bx,1              ;decrement the length counter
    add si, 320           ;move to the nex row since one line consists of 320 pixels
    cmp bx ,0 
    jnz bird_beak
    mov si,0	
    mov bx,50             ;height of lower rectangle
    mov si, 48920         ;position of rectangle 
	ret
	
green_rect_down:
    mov di, si             ;Start at pixel 38400 
    mov al, 2             ;Color index for Green
    mov cx, 28            ;width of body
    rep stosb
    sub bx,1              ;decrement the length counter
    add si, 320           ;move to uithe nex row since one line consists of 320 pixels
    cmp bx ,0 
    jnz green_rect_down
	
    mov si,0	
    mov bx,70             ;height of rectangle
    mov si, 00280         ;position of upper rectangle 
	ret
green_rect_up:

   mov di, si             ;Start at pixel 00920 
   mov al, 2             ;Color index for Green
   mov cx, 28             ;width of body
   rep stosb
   sub bx,1              ;decrement the length counter
   add si, 320           ;move to the nex row since one line consists of 320 pixels
   cmp bx ,0 
   jnz green_rect_up

    mov dx,50            ;Initialize DX (loop counter or row size modifier)
    mov si,120            ;Initialize SI (starting row)
	ret
wave_loop:
    ; Now draw the triangle wave pattern starting from column 370
    ;mov dx, 50           ; Initialize DX (width of the wave at start)
    ;mov si, 120          ; Start at the 120th row (beginning of dark blue section)
	
    ; Calculate di = 320 * si (for the next row)
    mov ax, si
    shl ax, 8            ; Multiply by 256 (shift left by 8 bits)
    mov bx, si
    shl bx, 6            ; Multiply by 64 (shift left by 6 bits)
    add ax, bx           ; Add the two results together (320 * si)
    mov di, ax           ; Now di = 320 * si (where to draw the wave)
    ; Add column offset to start the wave from column 370
    add di, 0            ; Offset by 50 to start the wave at column 370
    cmp si, 200          ; Stop once we've processed all 200 rows
    jge end_wave         ; Exit loop if we've reached the end of the screen
    ; Draw the triangle wave (decreasing dx in each iteration)
    cmp dx, 0
    jle end_wave         ; Exit the loop if DX reaches 0
    ; Now fill the wave in medium blue
    mov al, 9            ; Medium blue for the wave
    mov cx, dx           ; Set CX for the number of pixels in the wave
    rep stosb            ; Draw the wave part in medium blue
    sub dx, 2            ; Decrease DX to make the wave narrower in each row
    add si, 1            ; Move to the next row
    jmp wave_loop        ; Repeat the loop
end_wave:

    mov dx, 50           ; Initialize DX (width of the wave at start, determines wave width)
    mov si, 120          ; Start at the 120th row (beginning of dark blue section)
    mov bp, 50           ; Starting column offset for the inverted wave
	ret
wave_loop_inverted:
    ; Calculate di = 320 * si (for the next row)
    mov ax, si
    shl ax, 8            ; Multiply by 256 (shift left by 8 bits)
    mov bx, si
    shl bx, 6            ; Multiply by 64 (shift left by 6 bits)
    add ax, bx           ; Add the two results together (320 * si)
    mov di, ax           ; Now di = 320 * si (where to draw the wave)
    ; Add column offset to start the wave from column (e.g., 370 initially)
    add di, bp           ; Offset to start the wave from right of first wave
    cmp si, 200          ; Stop once we've processed all 200 rows
    jge end_wave_inverted
    ; Draw the triangle wave (increasing dx in each iteration to create inverted effect)
    cmp dx, 0
    jle end_wave_inverted  ; Exit the loop if DX reaches 0
    mov al, 9              ; Medium blue for the wave
    mov cx, dx             ; Set CX for the number of pixels in the wave
    rep stosb              ; Draw the wave part in medium blue
    sub dx, 2              ; Decrease DX to make the wave narrower in each row
    add bp, 2              ; Move the start point leftward to create an inverted effect
    add si, 1              ; Move to the next row
    jmp wave_loop_inverted 
end_wave_inverted:
    mov dx, 50             ; Initialize DX (width of the wave at start)
    mov si, 120            ; Start at the 120th row (beginning of dark blue section)
	ret
wave_loop1:
    ; Calculate di = 320 * si (for the next row)
    mov ax, si
    shl ax, 8              ; Multiply by 256 (shift left by 8 bits)
    mov bx, si
    shl bx, 6              ; Multiply by 64 (shift left by 6 bits)
    add ax, bx             ; Add the two results together (320 * si)
    mov di, ax             ; Now di = 320 * si (where to draw the wave)
	
    ; Add column offset to start the wave from column 370
    add di, 100            ; Offset by 50 to start the wave at column 370
    cmp si, 200            ; Stop once we've processed all 200 rows
    jge end_wave1          
	
    ; Draw the triangle wave (decreasing dx in each iteration)
    cmp dx, 0
    jle end_wave1           
	
    ; Now fill the wave in medium blue
    mov al, 9               ; Medium blue for the wave
    mov cx, dx              ; Set CX for the number of pixels in the wave
    rep stosb               ; Draw the wave part in medium blue
    sub dx, 2               ; Decrease DX to make the wave narrower in each row
    add si, 1               ; Move to the next row
    jmp wave_loop1          ; Repeat the loop
	end_wave1:
	
    mov dx, 50              ; Initialize DX (width of the wave at start, determines wave width)
    mov si, 120             ; Start at the 120th row (beginning of dark blue section)
    mov bp, 150             ; Starting column offset for the inverted wave
	ret
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
    jle end_wave_inverted1   
    mov al, 9                ; Medium blue for the wave
    mov cx, dx               ; Set CX for the number of pixels in the wave
    rep stosb                ; Draw the wave part in medium blue
    sub dx, 2                ; Decrease DX to make the wave narrower in each row
    add bp, 2                ; Move the start point leftward to create an inverted effect
    add si, 1                ; Move to the next row
    jmp wave_loop_inverted1  
	end_wave_inverted1:
	mov dx, 50                ; Initialize DX (width of the wave at start)
    mov si, 120               ; Start at the 120th row (beginning of dark blue section)
	ret
	
wave_loop2:
    ; Calculate di = 320 * si (for the next row)
    mov ax, si
    shl ax, 8                 ; Multiply by 256 (shift left by 8 bits)
    mov bx, si
    shl bx, 6                 ; Multiply by 64 (shift left by 6 bits)
    add ax, bx                ; Add the two results together (320 * si)
    mov di, ax                ; Now di = 320 * si (where to draw the wave)
	
    ; Add column offset to start the wave from column 370
    add di, 200               ; Offset by 50 to start the wave at column 370
    cmp si, 200               ; Stop once we've processed all 200 rows
    jge end_wave2             ; Exit loop if we've reached the end of the screen
	
    ; Draw the triangle wave (decreasing dx in each iteration)
    cmp dx, 0
    jle end_wave2             ; Exit the loop if DX reaches 0
	
    ; Now fill the wave in medium blue
    mov al, 9                 ; Medium blue for the wave
    mov cx, dx                ; Set CX for the number of pixels in the wave
    rep stosb                 ; Draw the wave part in medium blue
    sub dx, 2                 ; Decrease DX to make the wave narrower in each row
    add si, 1                 ; Move to the next row
    jmp wave_loop2         
	end_wave2:
	mov dx, 50                    ; Initialize DX (width of the wave at start, determines wave width)
	mov si, 120                   ; Start at the 120th row (beginning of dark blue section)
	mov bp, 250                   ; Starting column offset for the inverted wave
	ret
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
	ret
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
    jmp wave_loop3      ; Repeat the loop
	end_wave3:
    sub dx, 2          ; Decrease dx for the next row (creating the wave effect)
    add si, 1          ; Move to the next row
	ret
ground:
	mov di,57600
	mov al,10 ;green
	mov cx,320*10
	rep stosb
	mov di,60800
	mov al,6 ;brown
	mov cx,320*10
	rep stosb
	ret
start:
    mov ax, 0x0013 ;Set video mode to 320x200 with 256 colors
    int 0x10
    mov ax, 0xA000  ;Set segment to video memory
    mov es, ax
	call upper_part
	call medium_part
	call lower_part
	call bird_body
	call bird_beak
	call green_rect_down
	call green_rect_up
	call wave_loop
	call wave_loop_inverted
	call wave_loop1
	call wave_loop_inverted1
	call wave_loop2
	call wave_loop_inverted2
	call wave_loop3
	call ground
	
    xor ax, ax					 ;Wait for key press (simple method for demonstration purposes)
    int 0x16                  ; Wait for a key press									
    mov ax, 0x0003        ;Function to set text mode			;Set video mode to text mode 80x25 (Mode 03h)
    int 0x10                  ; Video BIOS interrupt

    mov ax, 0x4C00            ; Terminate process DOS interrupt function
    int 0x21                  ; DOS interrupt this is code which outputs this
