printstring     macro msg
        mov ah,09h
        mov dx,offset msg
        int 21h
        endm
    

DATA    segment
        cr equ 0dh
        lf equ 0ah
        msg1 db 'Enter string: $'
        msg2 db cr,lf,'String length= $'
        strlen dw 0 
        result dw 20 dup(0)
DATA ends


CODE segment 
    assume cs:CODE,ds:DATA

start:
        mov ax,DATA
        mov ds,ax
        printstring msg1 
        mov ah,01h

string:
        int 21h
        cmp al,cr
        je finish
        inc strlen
        loop string

finish:
        printstring msg2
        mov si,offset result
        mov ax,00
        mov ax,strlen
        call hex2asc
        printstring result
        mov ah,4ch
        mov ah,00h
        int 21h

hex2asc proc near
        push ax
        push bx
        push cx
        push dx
        push si
        
        mov cx,00
        mov bx,0ah        
    
rpt:
        mov dx,00
        div bx
        add dl,'0'
        push dx
        inc cx
        cmp ax,0ah
        jge rpt
        add al,'0'
        mov [si],al
   
rpt2:
        pop ax
        inc si
        mov [si],al
        loop rpt2
        
        inc si
        mov al,'$'
        mov [si],al
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
        
hex2asc endp
CODE    ends
        end start
         
            