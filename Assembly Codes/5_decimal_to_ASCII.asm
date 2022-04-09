printstring     macro msg 
        mov ah, 09h
        mov dx, offset msg 
        int 21h 
        endm

_DATA segment 
    cr equ 0dh 
    lf equ 0ah 
    tab equ 09h 
    msg1 db 'ASCII table set display....$'
    msg2 db cr, lf, 'Decimal', tab, 'Character$'
    newline db cr, lf, '$'
    asc_char db 48
    result db 20 dup('$')
_DATA ends

_CODE segment
    assume cs: _CODE, ds: _DATA 

start:  mov ax, _DATA 
        mov ds, ax
        printstring msg1
        printstring msg2
        mov cx, 10 

nextchar:
        mov ah, 00
        mov al, asc_char
        mov si, offset result 

        call hex2asc
        printstring newline
        printstring result 
        mov ah, 02 
        mov dl, tab 
        int 21h 
        mov ah, 02 
        mov dl, asc_char 
        int 21h 
        
        inc asc_char 
        loop nextchar 
        mov ah, 4ch 
        mov al, 00h 
        int 21h 
        
hex2asc proc near
        push ax 
        push bx
        push cx
        push dx
        push si
        mov cx, 00h 
        mov bx, 0ah 
        
rpt1:   mov dx, 00
        div bx 
        add dl, '0' 
        push dx 
        inc cx 
        cmp ax, 0ah 
        jge rpt1 
        add al, '0' 
        mov [si], al 
        
rpt2:   pop ax 
        inc si 
        mov [si], al 
        loop rpt2 
        inc si
        mov al, '$'
        mov [si], al 
        pop si 
        pop dx
        pop cx
        pop bx
        pop ax
        ret
hex2asc endp
_CODE   ends 
        end start