readnum     macro num
            mov ah, 01h
            int 21h
            sub al, '0'
            mov bh, 0ah
            mul bh
            mov num, al
            mov ah, 01h
            int 21h
            sub al, '0'
            add num, al
            endm
printstring macro msg
    mov ah, 09h
    mov dx, offset msg
    int 21h
    endm   
    
    
_DATA   segment
    cr equ 0dh
    lf equ 0ah
    msg1 db 'Number of elements <XX>: ', '$'
    msg2 db cr, lf, 'Enter element <XX>: ', '$'
    msg3 db cr, lf, 'Elements in ascending order <XX>: ', '$'
    count db ?
    tabl db 20 dup(0)
    tnum db ?
    resdisp db 4 dup(0)
_DATA ends    
     
_CODE   segment
    assume cs:_CODE, ds:_DATA
    
start:  mov ax, _DATA
        mov ds, ax
        
        printstring    msg1
        readnum        count1
        
        mov ch, 00h
        mov cl, count
        mov bx, 01
        
rdnxt:  printstring    msg2
        readnum count
        mov al, tnum
        mov tabl[bx], al
        inc bx
        loop rdnxt
        
        mov ch, 00
        mov cl, count
        cmp cx, 01
        je done
        
nextpass:   mov dl, 00
            mov bx, 01
            
nextj:      mov al, tabl[bx]
            mov ah, tabl[bx+1]
            cmp al, ah
            jle skip
            mov tabl[bx], ah
            mov tabl[bx+1], al
            mov dl, 01
            
skip:   inc bx
        cmp bx, cx
        jl nextj
        dec cx
        jz done
        cmp dl, 01h
        je nextpass
        
done:   mov ch, 00h
        mov cl, count
        mov bx, 01
        mov si, offset resdisp
        printstring    msg3
        
prnxt:  mov ah, 00
        mov al, tabl[bx]
        call hex2asc
        printstring cr, lf, '$'
        printstring resdisp
        inc bx
        loop prnxt
        
        mov ah, 4ch
        mov al, 00h
        int 21h
        
hex2asc     proc near
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