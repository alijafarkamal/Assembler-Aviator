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
    mov al, 9                 ; Color index for medium blue
    mov cx, 360*60           ; Fill the next 60 rows (middle part)
    rep stosb                 ; Fill the area with medium blue


    ; Fill the lower part with Dark Blue (Index 1)
    ; Now adjust DI to start filling from the 121st row
    mov di, 320*120           ; Start at pixel 38400 (after first 120 rows)
    mov al, 1                 ; Color index for dark blue
    mov cx, 320*80            ; Fill the remaining 80 rows (lower part)
    rep stosb                 ; Fill the area with dark blue
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

    mov cx, dx         ; Set CX for the number of pixels to fill
    rep stosb          ; Fill the row with color

    sub dx, 2          ; Decrease dx for the next row (creating the wave effect)
    add si, 1          ; Move to the next row
    jmp loop           ; Repeat the loop

out:
    ; Exit loop

    ; Wait for key press (simple method for demonstration purposes)
    xor ax, ax
    int 0x16                  ; Wait for a key press

    ; Set video mode to text mode 80x25 (Mode 03h)
    mov ax, 0x0003            ; Function to set text mode
    int 0x10                  ; Video BIOS interrupt

    ; Terminate program and return to DOS
    mov ax, 0x4C00            ; Terminate process DOS interrupt function
    int 0x21                  ; DOS interrupt this is code which outputs this
