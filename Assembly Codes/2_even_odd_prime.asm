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

_DATA segment
        cr equ 0dh
        lf equ 0ah
        msg1 db 'Enter number <XX>: ', '$'
        msg2 db cr, lf, 'Even number.', '$'
        msg3 db cr, lf, 'Odd number.', '$'
        msg4 db cr, lf, 'Prime number.', '$'
        msg5 db cr, lf, 'Not prime number.', '$'
        num db ?
_DATA ends

_CODE segment
        assume cs: _CODE, ds: _DATA

start:  mov ax, _DATA
        mov ds, ax
        printstring msg1
        readnum num
        mov ah, 00
        mov al, num
        mov bl, 02
        div bl
        mov bh, 00
        mov bl, al
        cmp ah, 00
        je evennum
        printstring msg3
        jmp checkprime

evennum:printstring msg2 

checkprime:
        and dx, 00
        mov ah, 00
        mov al, num
        cmp al, 01
        jle notprime
        cmp al, 02
        je isprime
        mov ch, 00
        mov cl, 02
        
chkprm2:div cx
        cmp dx, 00
        je notprime
        and dx, 00
        mov ah, 00
        mov al, num
        inc cx
        cmp bx, cx
        jge chkprm2  
        
isprime:printstring msg4
        jmp skip
        notprime: printstring msg5
        skip: mov ah, 4ch
        mov al, 00h
        int 21h  
        
_CODE   ends
        end start