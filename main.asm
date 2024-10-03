[org 0x0100]
jmp start

Clear:
nextchar:    
    mov word [es:di], 0x1020       ;Dark Blue Background
    add di, 2                      ;point to next box
    cmp di, 4000                   ;compare with window size
    jne nextchar 
ret	
start:
    mov ax, 0xb800             ;point base of video
    mov es, ax                   ;move pointer the base in ax
    mov di, 0                 ;offset of esegement
call Clear	
    mov ax, 0x4c00             
    int 0x21
