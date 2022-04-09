printstring	    macro	msg	
	            mov	ah, 09h		
            	mov	dx, offset msg	
            	int	21h			
            	endm

_DATA	segment
	cr	equ	0dh		
	lf	equ	0ah		
	msg1	db	'Enter the 8-bit binary number: ', '$'
	msg2	db	cr, lf, 'Hexadecimal code of the binary number: ', '$'
	msg3	db	cr, lf, 'Illegal input.', '$'
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
	shl	bh, 1			
	or	bh, al			
	loop	input

done:
	mov	cx, 00h		
	printstring	msg2
	mov	ah, 02h		

output:
	cmp	cx, 2			
	je	finish
	inc	cx
	mov	dl, bh
	push	cx			
	mov	cx, 4
	
shift1:
	shr	dl, 1
	loop	shift1
	pop	cx
	cmp	dl, 0ah		
	jl	digit
	add	dl, '7'
	jmp	next

digit:
	add	dl, '0'

next:
	int	21h			
	push cx			
	mov	cx, 4

shift2:
	rol	bx, 1
	loop shift2
	pop	cx
	jmp	output

errormsg:
	printstring	msg3

finish:
	mov	ah, 4ch		
	mov	al, 00h		
	int	21h			

_CODE	ends			
	end	start
