
[org 0x0100]
jmp start
graphics:
	mov ax, 0x0013	;for 320*200 pixels
	int 0x10				;switches to this mode
	mov ax, 0xA000	;seg address for video memory
	mov es, ax			;access to video buffer
	ret
upper_part:
	xor di, di				;points to start
	mov al, 11			;color
	mov cx, 320*60	;range
	rep stosb				;instruction to color this range
	ret

medium_part:
	mov di, 320*60		;points to specific point
	mov al, 9              ;color
	mov cx, 360*60    ;range
	rep stosb             ;instruction to color this range
	ret
	
lower_part:
	mov di, 320*120	;points to specific point
	mov al, 1              ;color
	mov cx, 320*80    ;range
	rep stosb             ;instruction to color this range
	ret
	
bird_body:
    mov bx,12            ;height of bird body
    mov si, 31180      ;points to the middle of screen
	body:
    mov di, si           	;Start at pixel 31180 
    mov al, 14			;Color index for yellow
    mov cx, 18			;width of body
    rep stosb
    sub bx,1				;decrement the length counter
    add si, 320           ;move to the next row since one line consists of 320 pixels
    cmp bx ,0 
    jnz body
    mov bx,2              ;height of bird's peak
    mov si, 32158       ;points to the top left corner of bird's peak
	ret	
	
bird_beak:
    mov di, si             ;Start at pixel 32158 
    mov al, 10            ;Color index for lightgreen
    mov cx, 4             ;width of beak
    rep stosb
    sub bx,1               ;decrement the length counter
    add si, 320            ;move to the nex row since one line consists of 320 pixels
    cmp bx ,0 
    jnz bird_beak
    mov si,0	
    mov bx,50             ;height of lower rectangle
    mov si, 48920       ;position of rectangle 
	ret	
green_rect_down:
    mov di, si              ;Start at pixel 38400 
    mov al, 2               ;Color index for Green
    mov cx, 28             ;width of body
    rep stosb
    sub bx,1                ;decrement the length counter
    add si, 320             ;move to uithe nex row since one line consists of 320 pixels
    cmp bx ,0 
    jnz green_rect_down
	
    mov si,0	
    mov bx,70             ;height of rectangle
    mov si, 00280        ;position of upper rectangle 
	ret
green_rect_up:
	mov di, si               ;Start at pixel 00920 
	mov al, 2                ;Color index for Green
	mov cx, 28             ;width of body
	rep stosb
	sub bx,1                 ;decrement the length counter
	add si, 320             ;move to the nex row since one line consists of 320 pixels
	cmp bx ,0 
	jnz green_rect_up

    mov dx,50				;width of triangle
    mov si,120            	;starting row
	ret
wave_loop:
	mov ax, si
	shl ax, 8					;multiply by 256
	mov bx, si
	shl bx, 6					;multiply by 64
	add ax, bx				;point on video memory where it will start making wave
	mov di, ax				;starting point copies to di				
	cmp dx, 0
	jle end_wave			;exit
	mov al, 9					;color
	mov cx, dx				;width
	rep stosb
	sub dx, 2					;width of triangle
	add si, 1					;loop to go to next row
	jmp wave_loop
	
	end_wave:
	mov dx, 50
	mov si, 120
	mov bp, 50
	ret
wave_loop_inverted:
	mov ax, si
	shl ax, 8					;multiply by 256
	mov bx, si
	shl bx, 6					;multiply by 64
	add ax, bx				;calculate video memory start point
	mov di, ax				;set DI for start
	add di, bp				;adjust DI by BP offset
	cmp dx, 0
	jle end_wave_inverted		;exit if DX is zero
	mov al, 9					;set color
	mov cx, dx				;set width
	rep stosb					;draw line
	sub dx, 2					;decrease width
	add bp, 2					;move start right
	add si, 1					;next row
	jmp wave_loop_inverted		;repeat loop
	
	end_wave_inverted:
	mov dx, 50				;reset DX
	mov si, 120				;reset SI
	ret
wave_loop1:	
	mov ax, si         		;copy si
	shl ax, 8            		;multiply
	mov bx, si         		
	shl bx, 6            		;multiply
	add ax, bx         		
	mov di, ax         		;set di
	add di, 100        		
	cmp dx, 0          		;check DX
	jle end_wave1    		;exit
	mov al, 9           		;color
	mov cx, dx        		;width
	rep stosb           		;draw
	sub dx, 2           		;decrease
	add si, 1            		;next row
	jmp wave_loop1        ;loop
	
	end_wave1:
	mov dx, 50          		;reset DX
	mov si, 120         		;reset SI
	mov bp, 150        		;set BP
	ret                 
wave_loop_inverted1:
	mov ax, si            	;copy SI
	shl ax, 8           		;multiply
	mov bx, si          		;copy SI
	shl bx, 6          			;multiply
	add ax, bx          		;calculate
	mov di, ax          		;set DI
	add di, bp          		;offset
	cmp dx, 0          		;check DX
	jle end_wave_inverted1 ; exit
	mov al, 9           		;color
	mov cx, dx          		;width
	rep stosb           		;draw
	sub dx, 2           		;decrease
	add bp, 2          		;increment BP
	add si, 1           		;increment to next row
	jmp wave_loop_inverted1 ; loop
	
	end_wave_inverted1:
	mov dx, 50          ; reset DX
	mov si, 120         ; reset SI
	ret 
wave_loop2:	
	mov ax, si          		;copy SI
	shl ax, 8            		;multiply
	mov bx, si          		;copy SI
	shl bx, 6            		;multiply
	add ax, bx          		;calculate
	mov di, ax          		;set DI
	add di, 200         		;offset
	cmp si, 200        		 ;check SI
	jge end_wave2    		 ;exit
	cmp dx, 0           		;check DX
	jle end_wave2     		 ;exit
	mov al, 9           		 ;color
	mov cx, dx         		 ;width
	rep stosb           		 ;draw
	sub dx, 2           		 ;decrease
	add si, 1           		 ;increment to next row
	jmp wave_loop2        ;loop
	
	end_wave2:
	mov dx, 50          		;reset DX
	mov si, 120         		;reset SI
	mov bp, 250        		;set BP
	ret              

	
wave_loop_inverted2:
	mov ax, si          	;copy SI
	shl ax, 8           	;multiply
	mov bx, si          	;copy SI
	shl bx, 6          		;multiply
	add ax, bx          	;calculate
	mov di, ax          	;set DI
	add di, bp          	;offset
	cmp si, 200         ;check SI
	jge end_wave_inverted2 ;exit
	cmp dx, 0           ;check DX
	jle end_wave_inverted2 ;exit
	mov al, 9           	;color
	mov cx, dx          	;width
	rep stosb           	;draw
	sub dx, 2           	;decrease
	add bp, 2           	;increment BP
	add si, 1           	;increment
	jmp wave_loop_inverted2 ;loop
	
	end_wave_inverted2:
	mov dx, 50          ;reset DX
	mov si, 120         ;reset SI
	ret                
wave_loop3:
	mov ax, si          	;copy SI
	shl ax, 8           	;multiply
	mov bx, si          	;copy SI
	shl bx, 6           	;multiply
	add ax, bx          	;calculate
	mov di, ax          	;set DI
	add di, 300         	;offset
	cmp si, 200         	;check SI
	jge end_wave3      ;exit
	cmp dx, 0           	;check DX
	jle end_wave3       ;exit
	mov al, 9          	;color
	mov cx, dx          	;width
	rep stosb           	;draw
	sub dx, 2           	;decrease
	add si, 1           	;increment
	jmp wave_loop3    ;loop
	
	end_wave3:
	sub dx, 2           	;decrease DX
	add si, 1          		;increment SI
	ret                 

ground:
	mov di,57600      ;position
	mov al,10            ;color green
	mov cx,320*10    ;width
	rep stosb            ;draw
	mov di,60800      ;position
	mov al,6              ;color brown
	mov cx,320*10     ;width
	rep stosb             ;draw
	ret 
          

iteration:
	mov cx,64000
delay1:

	loop delay1
	mov cx,64000
delay1:
	loop delay1
	mov ax,es
	mov ds,ax
	mov ax,200
	mov si,63998
	mov di,63918
	mov ax,0
iter:
	cmp ax,200
	je outer
	mov cx,40
	std
	rep movsw
	sub si,160
	sub di,160
	inc ax
	jmp iter
outer:
	mov cx,64000
delay:
	loop delay
	;call iteration
    ret 

start:
	call graphics
	call upper_part		
	call medium_part
	call lower_part
	call bird_body
	call bird_beak
	call green_rect_down
	call green_rect_up
	;call wave_loop
	;call wave_loop_inverted
	;call wave_loop1
	;call wave_loop_inverted1
	;call wave_loop2
	;call wave_loop_inverted2
	;call wave_loop3
labela:
	call iteration
jmp labela
	xor ax, ax
	int 0x16	
	mov ax, 0x0003
	int 0x10
	mov ax, 0x4C00
int 0x21
