Idle:
	push bp
I_l_s:	inc word [YKIdleCount]
	jmp I_l_s
	pop bp
	ret
