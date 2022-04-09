printstring	    macro	msg	
    	mov	ah, 09h		
    	mov	dx, offset msg	
    	int	21h			
    	endm

_DATA	segment
	cr	equ	0dh		
	lf	equ	0ah
	msg1	db  cr, lf, 'Addition= ', '$'		
	msg2	db  cr, lf, 'Subtraction= ', '$'
	msg3	db  cr, lf, 'Multiplication= ', '$'
	num1	dw  4269h
	num2	dw  168dh
_DATA	ends 

_EXTRA	segment
	sum	    dw  0000h
	subt	dw  0000h
	multl	dw  0000h
	multh	dw  0000h
_EXTRA	ends

_CODE	segment
	assume	cs:_CODE, ds:_DATA, es:_EXTRA	

start:
	mov	ax, _DATA
	mov	ds, ax			
	mov	ax, _EXTRA
	mov	es, ax
	mov	ax, num1		
    add	ax, num2		
    mov	sum, ax		
    
    mov	ax, num1		
    mov	bx, num2		
    sub	ax, bx			
    mov	subt, ax		
    
    mov	ax, num1		
    mul	num2			
    mov	multl, ax		
    mov	multh, dx		

_CODE	ends			
	end	start
