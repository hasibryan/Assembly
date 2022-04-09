printstring	    macro	msg	
    	mov	ah, 09h		
    	mov	dx, offset msg	
    	int	21h			
    	endm

_DATA	segment		
	dos	equ	21h		
	cr	equ	0dh		
	lf	equ	0ah		
	buff	db   80   dup(0)
	revbuff   db   80   dup(0)
	strlen	dw  ?
	msg1	db   'Enter the string: ', '$'
	msg2	db   cr, lf, 'Reverse of string: ', '$'
	msg3	db   cr, lf, 'Input string is a Palindrome.$'
	msg4	db   cr, lf, 'Input string is NOT a Palindrome.$'
_DATA	ends

_CODE	segment
	assume   cs:_CODE, ds:_DATA	
start:	
	mov	ax, _DATA
	mov	ds, ax			
	printstring	msg1
	mov	si, offset buff

rdchar1:
	mov	ah, 01h		
	int	dos		
	mov	[si], al
	inc	si
	cmp	al, cr
	jne	rdchar1
	mov	si, offset buff
	mov	bx, 00			

nxtchar2:
	mov	al, [si]
	cmp	al, cr
	je	skip1			
	mov	[si], al
	inc	si
	inc	bx			
	jmp	nxtchar2

skip1:
	mov	strlen, bx
	mov	si, offset  buff
	add	si, bx
	mov	di, offset  revbuff
	mov	cx, bx

nxtchar3:
	dec	si
	mov	al, [si]
	mov	[di], al
	inc	di
	loop	nxtchar3
	mov	al, '$'
	mov	[di], al			
	printstring	msg2
	printstring	revbuff 
	mov	si, offset buff
	mov	di, offset revbuff
	mov	cx, strlen

nxtchar4:
	mov	al, [si]
	cmp	al, [di]
	jne	notpali
	inc	si			
	inc	di
	loop	nxtchar4

palindrome:
	printstring	msg3
	jmp	skip2

notpali:
	printstring	msg4

skip2:
	mov	ah, 4ch		
	mov	al, 00h		
	int	dos			
_CODE	ends			
	end	start