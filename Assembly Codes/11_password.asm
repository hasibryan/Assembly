printstring     macro msg
        mov ah,09h
        mov dx,offset msg
        int 21h
        endm


DATA    segment
    cr equ 0dh
    lf equ 0ah
    msg1 db 'Enter password(XXXXXXX): $'
    msg2 db cr,lf,'Incorrect!$'
    msg3 db cr,lf,'Correct$'
    pass dw 'emu8086$'
    count db 7
    given dw 100 dup(0)
DATA ends

CODE segment
    assume cs:CODE,ds:DATA
start:  mov ax,DATA
        mov ds,ax
        mov ch,00
        mov cl,count
        printstring msg1
        mov si,offset given
        mov ah,01h
        
read:
        int 21h 
        mov [si],al
        inc si
        loop read

        mov al,'$'
        mov [si],al
        mov ch,00
        mov cl,count
        mov si,offset pass
        mov di,offset given

compare:
        mov al,[si]
        mov bl,[di]
        cmp al,bl
        jne inco
        inc si
        inc di 
        loop compare
        jmp cor

inco:
        printstring msg2
        jmp finish

cor:
        printstring msg3

finish:
        mov ah,4ch
        mov ah,00h
        int 21h

CODE    ends
        end start