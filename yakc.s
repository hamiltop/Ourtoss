; Generated by c86 (BYU-NASM) 5.1 (beta) from yakc.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
YKInitialize:
	; >>>>> Line:	15
	; >>>>> void YKInitialize(){ 
	jmp	L_yakc_1
L_yakc_2:
	; >>>>> Line:	16
	; >>>>> id_counter = 0; 
	mov	word [id_counter], 0
	; >>>>> Line:	17
	; >>>>> running = 0; 
	mov	word [running], 0
	; >>>>> Line:	18
	; >>>>> YKTickNum = 0; 
	mov	word [YKTickNum], 0
	; >>>>> Line:	19
	; >>>>> YKIdleCount = 0; 
	mov	word [YKIdleCount], 0
	; >>>>> Line:	20
	; >>>>> YKCtxSwCount = 0; 
	mov	word [YKCtxSwCount], 0
	; >>>>> Line:	21
	; >>>>> isrdepth = 0; 
	mov	word [isrdepth], 0
	; >>>>> Line:	22
	; >>>>> YKNewTask(Idle, (void *) &IdleStk[256], 99); 
	mov	al, 99
	push	ax
	mov	ax, (IdleStk+512)
	push	ax
	mov	ax, Idle
	push	ax
	call	YKNewTask
	add	sp, 6
	mov	sp, bp
	pop	bp
	ret
L_yakc_1:
	push	bp
	mov	bp, sp
	jmp	L_yakc_2
	ALIGN	2
Dummy:
	; >>>>> Line:	30
	; >>>>> void Dummy(){} 
	jmp	L_yakc_4
L_yakc_5:
	; >>>>> Line:	30
	; >>>>> void Dummy(){} 
	mov	sp, bp
	pop	bp
	ret
L_yakc_4:
	push	bp
	mov	bp, sp
	jmp	L_yakc_5
	ALIGN	2
YKNewTask:
	; >>>>> Line:	31
	; >>>>> void YKNewTask(void (* task)(void),void *taskStack, unsigned char priority){ 
	jmp	L_yakc_7
L_yakc_8:
	; >>>>> Line:	34
	; >>>>> newTCB->task = task; 
	mov	al, byte [bp+8]
	xor	ah, ah
	mov	cx, 40
	imul	cx
	add	ax, tasks
	mov	word [bp-2], ax
	; >>>>> Line:	34
	; >>>>> newTCB->task = task; 
	mov	si, word [bp-2]
	add	si, 38
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	35
	; >>>>> newTCB->id = id_counter++; 
	mov	ax, word [id_counter]
	inc	word [id_counter]
	mov	si, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	36
	; >>>>> newTCB->state = 1; 
	mov	si, word [bp-2]
	add	si, 32
	mov	word [si], 1
	; >>>>> Line:	37
	; >>>>> newTCB->first_time = 1; 
	mov	si, word [bp-2]
	add	si, 34
	mov	word [si], 1
	; >>>>> Line:	39
	; >>>>> newTCB->context.sp = (int)taskStack; 
	mov	si, word [bp-2]
	add	si, 12
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	40
	; >>>>> newTCB->context.bp = (int)taskStack; 
	mov	si, word [bp-2]
	add	si, 14
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	41
	; >>>>> newTCB->context 
	mov	si, word [bp-2]
	add	si, 16
	mov	word [si], 0
	; >>>>> Line:	42
	; >>>>> newTCB->context.di = 0; 
	mov	si, word [bp-2]
	add	si, 18
	mov	word [si], 0
	; >>>>> Line:	44
	; >>>>> newTCB->context.cs = 0; 
	mov	si, word [bp-2]
	add	si, 20
	mov	word [si], 0
	; >>>>> Line:	45
	; >>>>> newTCB->context.ds = 0; 
	mov	si, word [bp-2]
	add	si, 22
	mov	word [si], 0
	; >>>>> Line:	46
	; >>>>> newTCB->context.ss = 0; 
	mov	si, word [bp-2]
	add	si, 24
	mov	word [si], 0
	; >>>>> Line:	47
	; >>>>> newTCB->context.es = 0; 
	mov	si, word [bp-2]
	add	si, 26
	mov	word [si], 0
	; >>>>> Line:	49
	; >>>>> newTCB->tickNum = -1; 
	mov	si, word [bp-2]
	add	si, 36
	mov	word [si], -1
	; >>>>> Line:	50
	; >>>>> newTCB->context.tstamp = 0; 
	mov	si, word [bp-2]
	add	si, 30
	mov	word [si], 0
	; >>>>> Line:	53
	; >>>>> tasks[priority] = *newTCB; 
	mov	al, byte [bp+8]
	xor	ah, ah
	mov	cx, 40
	imul	cx
	add	ax, tasks
	mov	word [bp-4], ax
	mov	di, word [bp-4]
	mov	si, word [bp-2]
	mov	cx, 20
	rep
	movsw
	; >>>>> Line:	54
	; >>>>> if (running) YKScheduler(); 
	mov	ax, word [running]
	test	ax, ax
	je	L_yakc_9
	; >>>>> Line:	54
	; >>>>> if (running) YKScheduler(); 
	call	YKScheduler
L_yakc_9:
	mov	sp, bp
	pop	bp
	ret
L_yakc_7:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_8
	ALIGN	2
YKRun:
	; >>>>> Line:	56
	; >>>>> void YKRun(){ 
	jmp	L_yakc_11
L_yakc_12:
	; >>>>> Line:	57
	; >>>>> running = 1; 
	mov	word [running], 1
	; >>>>> Line:	58
	; >>>>> while(1) 
	jmp	L_yakc_14
L_yakc_13:
	; >>>>> Line:	59
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakc_14:
	jmp	L_yakc_13
L_yakc_15:
	mov	sp, bp
	pop	bp
	ret
L_yakc_11:
	push	bp
	mov	bp, sp
	jmp	L_yakc_12
	ALIGN	2
YKDelayTask:
	; >>>>> Line:	61
	; >>>>> void YKDelayTask(unsigned count){ 
	jmp	L_yakc_17
L_yakc_18:
	; >>>>> Line:	62
	; >>>>> current_task->tickNum = YKTickNum +count; 
	mov	ax, word [YKTickNum]
	add	ax, word [bp+4]
	mov	si, word [current_task]
	add	si, 36
	mov	word [si], ax
	; >>>>> Line:	63
	; >>>>> current_task->state = 0; 
	mov	si, word [current_task]
	add	si, 32
	mov	word [si], 0
	; >>>>> Line:	64
	; >>>>> YKScheduler(); 
	call	YKScheduler
	mov	sp, bp
	pop	bp
	ret
L_yakc_17:
	push	bp
	mov	bp, sp
	jmp	L_yakc_18
	ALIGN	2
YKEnterMutex:
	; >>>>> Line:	67
	; >>>>> void YKEnterMutex(){ 
	jmp	L_yakc_20
L_yakc_21:
	; >>>>> Line:	68
	; >>>>> asm("cli"); 
	cli
	mov	sp, bp
	pop	bp
	ret
L_yakc_20:
	push	bp
	mov	bp, sp
	jmp	L_yakc_21
	ALIGN	2
YKExitMutex:
	; >>>>> Line:	70
	; >>>>> void YKExitMutex(){ 
	jmp	L_yakc_23
L_yakc_24:
	; >>>>> Line:	71
	; >>>>> asm("sti"); 
	sti
	mov	sp, bp
	pop	bp
	ret
L_yakc_23:
	push	bp
	mov	bp, sp
	jmp	L_yakc_24
	ALIGN	2
YKEnterISR:
	; >>>>> Line:	73
	; >>>>> ); 
	jmp	L_yakc_26
L_yakc_27:
	; >>>>> Line:	74
	; >>>>> if (!isrdepth){ 
	mov	ax, word [isrdepth]
	test	ax, ax
	jne	L_yakc_28
	; >>>>> Line:	75
	; >>>>> saveContext(&current_task->context); 
	mov	ax, word [current_task]
	add	ax, 2
	push	ax
	call	saveContext
	add	sp, 2
L_yakc_28:
	; >>>>> Line:	77
	; >>>>> isrdepth++; 
	inc	word [isrdepth]
	mov	sp, bp
	pop	bp
	ret
L_yakc_26:
	push	bp
	mov	bp, sp
	jmp	L_yakc_27
	ALIGN	2
YKExitISR:
	; >>>>> Line:	79
	; >>>>> void YKExitISR(){ 
	jmp	L_yakc_30
L_yakc_31:
	; >>>>> Line:	80
	; >>>>> isrdepth--; 
	dec	word [isrdepth]
	; >>>>> Line:	81
	; >>>>> if (!isrdepth){ 
	mov	ax, word [isrdepth]
	test	ax, ax
	jne	L_yakc_32
	; >>>>> Line:	82
	; >>>>> restoreContext(&current_task->context); 
	mov	ax, word [current_task]
	add	ax, 2
	push	ax
	call	restoreContext
	add	sp, 2
L_yakc_32:
	mov	sp, bp
	pop	bp
	ret
L_yakc_30:
	push	bp
	mov	bp, sp
	jmp	L_yakc_31
	ALIGN	2
YKScheduler:
	; >>>>> Line:	85
	; >>>>> void YKScheduler() { 
	jmp	L_yakc_34
L_yakc_35:
	; >>>>> Line:	88
	; >>>>> for(i=0;i<100;i++) { 
	mov	word [bp-2], 0
	jmp	L_yakc_37
L_yakc_36:
	; >>>>> Line:	89
	; >>>>> if(tasks[i].state == 1) { 
	mov	ax, word [bp-2]
	mov	cx, 40
	imul	cx
	add	ax, tasks
	mov	si, ax
	add	si, 32
	cmp	word [si], 1
	jne	L_yakc_40
	; >>>>> Line:	90
	; >>>>> task_to_execute = &tasks[i]; 
	mov	ax, word [bp-2]
	mov	cx, 40
	imul	cx
	add	ax, tasks
	mov	word [bp-4], ax
	; >>>>> Line:	91
	; >>>>> break; 
	jmp	L_yakc_38
L_yakc_40:
L_yakc_39:
	inc	word [bp-2]
L_yakc_37:
	cmp	word [bp-2], 100
	jl	L_yakc_36
L_yakc_38:
	; >>>>> Line:	94
	; >>>>> if(task_to_execute != current_task) { 
	mov	ax, word [current_task]
	cmp	ax, word [bp-4]
	je	L_yakc_41
	; >>>>> Line:	95
	; >>>>> YKCtxSwCount++; 
	inc	word [YKCtxSwCount]
	; >>>>> Line:	96
	; >>>>> YKDispatcher(task_to_execute); 
	push	word [bp-4]
	call	YKDispatcher
	add	sp, 2
L_yakc_41:
	mov	sp, bp
	pop	bp
	ret
L_yakc_34:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_35
	ALIGN	2
YKDispatcher:
	; >>>>> Line:	100
	; >>>>> void YKDispatcher(TCB * task_to_execute) { 
	jmp	L_yakc_43
L_yakc_44:
	; >>>>> Line:	103
	; >>>>> if(current 
	mov	ax, word [current_task]
	test	ax, ax
	je	L_yakc_45
	; >>>>> Line:	104
	; >>>>> saveContext(&(current_task->context)); 
	mov	ax, word [current_task]
	add	ax, 2
	push	ax
	call	saveContext
	add	sp, 2
	; >>>>> Line:	105
	; >>>>> Dummy(); 
	call	Dummy
	; >>>>> Line:	106
	; >>>>> if (YKTickNum != current_task->context.tstamp) 
	mov	si, word [current_task]
	add	si, 30
	mov	ax, word [YKTickNum]
	cmp	ax, word [si]
	je	L_yakc_46
	; >>>>> Line:	107
	; >>>>> return; 
	jmp	L_yakc_47
L_yakc_46:
L_yakc_45:
	; >>>>> Line:	109
	; >>>>> current_task = task_to_execute; 
	mov	ax, word [bp+4]
	mov	word [current_task], ax
	; >>>>> Line:	110
	; >>>>> if(task_to_execute->first_time) { 
	mov	si, word [bp+4]
	add	si, 34
	mov	ax, word [si]
	test	ax, ax
	je	L_yakc_48
	; >>>>> Line:	111
	; >>>>> task_to_execute->first_time = 0; 
	mov	si, word [bp+4]
	add	si, 34
	mov	word [si], 0
	; >>>>> Line:	112
	; >>>>> tempreg = task_to_execute->context.bp; 
	mov	si, word [bp+4]
	add	si, 14
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	113
	; >>>>> tempreg2 = task_to_execute->task; 
	mov	si, word [bp+4]
	add	si, 38
	mov	ax, word [si]
	mov	word [bp-4], ax
	; >>>>> Line:	114
	; >>>>> Dummy(); 
	call	Dummy
	; >>>>> Line:	115
	; >>>>> asm("mov sp,word [bp-2]"); 
	mov sp,word [bp-2]
	; >>>>> Line:	116
	; >>>>> asm("mov si,word [bp-4]"); 
	mov si,word [bp-4]
	; >>>>> Line:	117
	; >>>>> asm("mov bp,word [bp-2]"); 
	mov bp,word [bp-2]
	; >>>>> Line:	118
	; >>>>> asm("call si"); 
	call si
	; >>>>> Line:	119
	; >>>>> Dummy(); 
	call	Dummy
	jmp	L_yakc_49
L_yakc_48:
	; >>>>> Line:	123
	; >>>>> restoreContext(&(task_to_execute->context)); 
	mov	ax, word [bp+4]
	add	ax, 2
	push	ax
	call	restoreContext
	add	sp, 2
L_yakc_49:
L_yakc_47:
	; >>>>> Line:	125
	; >>>>> return; 
	mov	sp, bp
	pop	bp
	ret
L_yakc_43:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_44
	ALIGN	2
saveContext:
	; >>>>> Line:	128
	; >>>>> >sp  
	jmp	L_yakc_51
L_yakc_52:
	; >>>>> Line:	131
	; >>>>> context->tstamp = YKTickNum; 
	mov	word [bp-2], 3
	; >>>>> Line:	131
	; >>>>> context->tstamp = YKTickNum; 
	mov	si, word [bp+4]
	add	si, 28
	mov	ax, word [YKTickNum]
	mov	word [si], ax
	; >>>>> Line:	133
	; >>>>> asm("mov word [bp-2], ax"); 
	mov word [bp-2], ax
	; >>>>> Line:	134
	; >>>>> context->ax = tempreg; 
	mov	si, word [bp+4]
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	136
	; >>>>> asm("pushf"); 
	pushf
	; >>>>> Line:	137
	; >>>>> asm("pop ax"); 
	pop ax
	; >>>>> Line:	139
	; >>>>> asm("mov word [bp-2], ax"); 
	mov word [bp-2], ax
	; >>>>> Line:	140
	; >>>>> context->flags = tempreg; 
	mov	si, word [bp+4]
	add	si, 26
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	142
	; >>>>> asm("mov word [bp-2], bx"); 
	mov word [bp-2], bx
	; >>>>> Line:	143
	; >>>>> context->bx = tempreg; 
	mov	si, word [bp+4]
	add	si, 2
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	144
	; >>>>> asm("mov word [bp-2], cx"); 
	mov word [bp-2], cx
	; >>>>> Line:	145
	; >>>>> context->cx = tempreg; 
	mov	si, word [bp+4]
	add	si, 4
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	146
	; >>>>> asm("mov word [bp-2], dx"); 
	mov word [bp-2], dx
	; >>>>> Line:	147
	; >>>>> context->dx = tempreg; 
	mov	si, word [bp+4]
	add	si, 6
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	149
	; >>>>> asm("mov word ax, word [bp+2]"); 
	mov word ax, word [bp+2]
	; >>>>> Line:	150
	; >>>>> asm("mov word [bp-2], ax"); 
	mov word [bp-2], ax
	; >>>>> Line:	151
	; >>>>> context->ip = tempreg; 
	mov	si, word [bp+4]
	add	si, 8
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	152
	; >>>>> asm("mov word [bp-2], sp"); 
	mov word [bp-2], sp
	; >>>>> Line:	153
	; >>>>> context->sp  
	mov	si, word [bp+4]
	add	si, 10
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	156
	; >>>>> asm("mov word [bp-2], si"); 
	mov word [bp-2], si
	; >>>>> Line:	157
	; >>>>> context->si = tempreg; 
	mov	si, word [bp+4]
	add	si, 14
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	158
	; >>>>> asm("mov word [bp-2], di"); 
	mov word [bp-2], di
	; >>>>> Line:	159
	; >>>>> context->di = tempreg; 
	mov	si, word [bp+4]
	add	si, 16
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	161
	; >>>>> asm("mov word [bp-2], cs"); 
	mov word [bp-2], cs
	; >>>>> Line:	162
	; >>>>> context->cs = tempreg; 
	mov	si, word [bp+4]
	add	si, 18
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	163
	; >>>>> asm("mov word [bp-2], ds"); 
	mov word [bp-2], ds
	; >>>>> Line:	164
	; >>>>> context->ds = tempreg; 
	mov	si, word [bp+4]
	add	si, 20
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	165
	; >>>>> asm("mov word [bp-2], ss"); 
	mov word [bp-2], ss
	; >>>>> Line:	166
	; >>>>> context->ss = tempreg; 
	mov	si, word [bp+4]
	add	si, 22
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	167
	; >>>>> asm("mov word [bp-2], es"); 
	mov word [bp-2], es
	; >>>>> Line:	168
	; >>>>> context->es = tempreg; 
	mov	si, word [bp+4]
	add	si, 24
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	169
	; >>>>> asm("push word [bp]"); 
	push word [bp]
	; >>>>> Line:	170
	; >>>>> asm("pop word [bp-2]"); 
	pop word [bp-2]
	; >>>>> Line:	171
	; >>>>> context->bp = tempreg; 
	mov	si, word [bp+4]
	add	si, 12
	mov	ax, word [bp-2]
	mov	word [si], ax
	mov	sp, bp
	pop	bp
	ret
L_yakc_51:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_52
	ALIGN	2
restoreContext:
	; >>>>> Line:	175
	; >>>>> void restoreContext(Context * context) { 
	jmp	L_yakc_54
L_yakc_55:
	; >>>>> Line:	179
	; >>>>> tempreg = context->bx ; 
	mov	si, word [bp+4]
	add	si, 2
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	180
	; >>>>> asm("mov word bx, [b 
	mov word bx, [bp-2]
	; >>>>> Line:	181
	; >>>>> tempreg = context->cx ; 
	mov	si, word [bp+4]
	add	si, 4
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	182
	; >>>>> asm("mov word cx, [bp-2]"); 
	mov word cx, [bp-2]
	; >>>>> Line:	183
	; >>>>> tempreg = context->dx ; 
	mov	si, word [bp+4]
	add	si, 6
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	184
	; >>>>> asm("mov word dx, [bp-2]"); 
	mov word dx, [bp-2]
	; >>>>> Line:	186
	; >>>>> tempreg = context->bp ; 
	mov	si, word [bp+4]
	add	si, 12
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	187
	; >>>>> asm("mov word sp, [bp-2]"); 
	mov word sp, [bp-2]
	; >>>>> Line:	188
	; >>>>> tempreg = context->si ; 
	mov	si, word [bp+4]
	add	si, 14
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	189
	; >>>>> asm("mov word si, [bp-2]"); 
	mov word si, [bp-2]
	; >>>>> Line:	190
	; >>>>> tempreg = context->di ; 
	mov	si, word [bp+4]
	add	si, 16
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	191
	; >>>>> asm("mov word di, [bp-2]"); 
	mov word di, [bp-2]
	; >>>>> Line:	193
	; >>>>> tempreg = context->cs ; 
	mov	si, word [bp+4]
	add	si, 18
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	194
	; >>>>> asm("mov word cs, [bp-2]"); 
	mov word cs, [bp-2]
	; >>>>> Line:	195
	; >>>>> tempreg = context->ds ; 
	mov	si, word [bp+4]
	add	si, 20
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	196
	; >>>>> asm("mov word ds, [bp-2]"); 
	mov word ds, [bp-2]
	; >>>>> Line:	197
	; >>>>> tempreg = context->ss ; 
	mov	si, word [bp+4]
	add	si, 22
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	198
	; >>>>> asm("mov word ss, [bp-2]"); 
	mov word ss, [bp-2]
	; >>>>> Line:	199
	; >>>>> tempreg = context->es ; 
	mov	si, word [bp+4]
	add	si, 24
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	200
	; >>>>> asm("mov word es, [bp-2]"); 
	mov word es, [bp-2]
	; >>>>> Line:	205
	; >>>>> tempreg = c 
	mov	si, word [bp+4]
	add	si, 26
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	206
	; >>>>> asm("push word [bp-2]"); 
	push word [bp-2]
	; >>>>> Line:	208
	; >>>>> tempreg = context->ax; 
	mov	si, word [bp+4]
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	209
	; >>>>> asm("push word [bp-2]"); 
	push word [bp-2]
	; >>>>> Line:	210
	; >>>>> tempreg = context->si; 
	mov	si, word [bp+4]
	add	si, 14
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	211
	; >>>>> asm("push word [bp-2]"); 
	push word [bp-2]
	; >>>>> Line:	213
	; >>>>> asm("pop si"); 
	pop si
	; >>>>> Line:	214
	; >>>>> asm("pop ax"); 
	pop ax
	; >>>>> Line:	215
	; >>>>> asm("popf"); 
	popf
	; >>>>> Line:	216
	; >>>>> asm("pop bp"); 
	pop bp
L_yakc_56:
	; >>>>> Line:	217
	; >>>>> return; 
	mov	sp, bp
	pop	bp
	ret
L_yakc_54:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_55
L_yakc_58:
	DB	".",0xA,0
	ALIGN	2
YKTickHandler:
	; >>>>> Line:	220
	; >>>>> void YKTickHandler() { 
	jmp	L_yakc_59
L_yakc_60:
	; >>>>> Line:	222
	; >>>>> YKTickNum++; 
	inc	word [YKTickNum]
	; >>>>> Line:	223
	; >>>>> for(i=0;i<100;i++) { 
	mov	word [bp-2], 0
	jmp	L_yakc_62
L_yakc_61:
	; >>>>> Line:	224
	; >>>>> if(tasks[i].tickNum == YKTickNum) { 
	mov	ax, word [bp-2]
	mov	cx, 40
	imul	cx
	add	ax, tasks
	mov	si, ax
	add	si, 36
	mov	ax, word [YKTickNum]
	cmp	ax, word [si]
	jne	L_yakc_65
	; >>>>> Line:	225
	; >>>>> tasks[i].state = 1; 
	mov	ax, word [bp-2]
	mov	cx, 40
	imul	cx
	add	ax, tasks
	mov	si, ax
	add	si, 32
	mov	word [si], 1
	; >>>>> Line:	226
	; >>>>> printUInt(YKTickNum); 
	push	word [YKTickNum]
	call	printUInt
	add	sp, 2
	; >>>>> Line:	227
	; >>>>> printString(".\n"); 
	mov	ax, L_yakc_58
	push	ax
	call	printString
	add	sp, 2
L_yakc_65:
L_yakc_64:
	inc	word [bp-2]
L_yakc_62:
	cmp	word [bp-2], 100
	jl	L_yakc_61
L_yakc_63:
	; >>>>> Line:	232
	; >>>>> YKScheduler(); 
	call	YKScheduler
	; >>>>> Line:	233
	; >>>>> asm("sti"); 
	sti
	mov	sp, bp
	pop	bp
	ret
L_yakc_59:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_60
	ALIGN	2
YKCtxSwCount:
	TIMES	2 db 0
YKIdleCount:
	TIMES	2 db 0
YKTickNum:
	TIMES	2 db 0
running:
	TIMES	2 db 0
current_task:
	TIMES	2 db 0
id_counter:
	TIMES	2 db 0
tasks:
	TIMES	4000 db 0
IdleStk:
	TIMES	512 db 0
isrdepth:
	TIMES	2 db 0
