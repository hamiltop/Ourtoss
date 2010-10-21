resetRoutine:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds
	sti
	call reset
	cli
	mov	al, 0x20
	out	0x20, al
	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	iret
	
tickRoutine:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds
	sti
	call tick
	cli
	call YKScheduler
	mov	al, 0x20
	out	0x20, al
	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	iret

			
	keyRoutine:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds
	sti
	call key
	cli
	mov	al, 0x20
	out	0x20, al
	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	iret