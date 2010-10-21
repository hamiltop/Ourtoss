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
	call YKEnterISR
	sti
	call reset
	cli
	call YKExitISR
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
;	inc word [YKTickNum]
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds
	call YKEnterISR
	sti
	call YKTickHandler
	cli
	call YKExitISR
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
	call YKEnterISR
	sti
	call key
	cli
	call YKExitISR
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
