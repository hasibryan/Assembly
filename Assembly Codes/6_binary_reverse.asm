printstring	    macro	msg	
    	mov	ah, 09h		
    	mov	dx, offset msg	
    	int	21h			
    	endm

_DATA	segment
	cr	equ	0dh		
	lf	equ	0ah		
	msg1	db	'Enter the 8-bit binary number: ', '$'
	msg2	db	cr, lf, 'Binary number in reverse order: ', '$'
	msg3	db	cr, lf, 'Illegal input.' , '$'
_DATA	ends

_CODE	segment
	assume	cs:_CODE, ds:_DATA

start:
	mov	ax, _DATA
	mov	ds, ax			
	printstring	msg1
	xor	bx, bx			
	mov	cx, 8			
	mov	ah, 01h		

input:
	int	21h			
	cmp	al, '0'			
	je	continue
	cmp	al, '1'			
	jne	errormsg

continue:
	sub	al, '0'			
	shl	bx, 1		
	or	bl, al			
	loop	input
    printstring	msg2
	mov	cx, 8			
	mov	ah, 02h		

output:
	sar	bx, 1
	jnc	zero
	mov	dl, 31h			
	jmp	display

zero:
	mov	dl, 30h		

display:
	int	21h			
	loop	output
	jmp	finish
	
errormsg:
	printstring	msg3

finish:
	mov	ah, 4ch		
	mov	al, 00h		
	int	21h			
_CODE	ends		
	end	start
