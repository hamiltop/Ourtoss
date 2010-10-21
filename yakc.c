#include "yaku.h"
#include "yakk.h"


int running;
TCB * current_task;
int id_counter;
TCB tasks[100];
int YKCtxSwCount;
int YKIdleCount;
int YKTickNum;
int IdleStk[IDLESTACKSIZE];           /* Space for each task's stack */
int isrdepth;
int NumTasks;

void YKInitialize(){
	id_counter = 1;
	running = 0;
	YKTickNum = 0;
	YKIdleCount = 0;
	YKCtxSwCount = 0;
	isrdepth = 0;
	NumTasks = 0;
	YKNewTask(Idle, (void *) &IdleStk[IDLESTACKSIZE], 100);
//	current_task = &tasks[99];
}

//void Idle(void) {
	//while (1)
	//	YKIdleCount++;
//}
void Dummy(){}
void YKNewTask(void (* task)(void),void *taskStack, unsigned char priority){
	int i;
	int j;
	TCB tmpTCB;
	TCB * newTCB = &tmpTCB;
	newTCB->task = task;
	newTCB->id = id_counter++;
	newTCB->state = 1;
	newTCB->first_time = 1;
	
	newTCB->context.sp = (int)taskStack;
	newTCB->context.bp = (int)taskStack;
	newTCB->context.si = 0;
	newTCB->context.di = 0;
	
	newTCB->context.cs = 0;
	newTCB->context.ds = 0;
	newTCB->context.ss = 0;
	newTCB->context.es = 0;
	
	newTCB->tickNum = -1;
	newTCB->context.tstamp = 0;
	newTCB->priority = priority;
	for ( i = 0; i < NumTasks + 1; i++){
		if (tasks[i].task == 0){
			
			tasks[i] = *newTCB;
			break;
		}
		if (tasks[i].priority > priority){
			for ( j = NumTasks; j > i; j--){
				tasks[j] = tasks[j-1];
				
			}
			tasks[i]= *newTCB;
			break;
		} 
	}
	
	// initialize variables in TCB
	//tasks[priority] = *newTCB;
	NumTasks++;
	if (running) YKScheduler();
}
void YKRun(){
	running = 1;
	while(1)
		YKScheduler();
}
void YKDelayTask(unsigned count){
	current_task->tickNum = YKTickNum +count;
	current_task->state = 0;
	YKScheduler();

}
int YKEnterMutex(){
	int ireg;
	asm("pushf");
	asm("pop word [bp-2]");
	asm("cli");
	ireg = ireg & (1 << 9);
	return ireg;
}
void YKExitMutex(){
	asm("sti");
}
void YKEnterISR(){
	if (!isrdepth){
		saveContext(&current_task->context);
	}
	isrdepth++;
}
void YKExitISR(){
	isrdepth--;
	if (!isrdepth){
		YKScheduler();
	}
}
void YKScheduler() {
	int i;
	TCB * task_to_execute;
	int ireg;
	ireg = YKEnterMutex();
	for(i=0;i<NumTasks;i++) {
		if(tasks[i].state == 1) {
			task_to_execute = &tasks[i];
			break;
		}
	}
	if(task_to_execute != current_task) {
		YKCtxSwCount++;
		YKDispatcher(task_to_execute);
		
	}
	if(ireg)
		YKExitMutex();
}
void YKDispatcher(TCB * task_to_execute) {
	int tempreg;
	void (*tempreg2)();
	if(current_task){
		saveContext(&(current_task->context));
		Dummy();
		if (YKTickNum != current_task->context.tstamp)
			return;
	}
	current_task = task_to_execute;
	if(task_to_execute->first_time) {
		task_to_execute->first_time = 0;
		tempreg = task_to_execute->context.bp;
		tempreg2 = task_to_execute->task;
		Dummy();
		asm("mov sp,word [bp-2]");
		asm("mov si,word [bp-4]");
		asm("mov bp,word [bp-2]");
		asm("sti");
		asm("call si");
		Dummy();
		//restoreContext(&(task_to_execute->context));
		//task_to_execute->task();
	} else {
		restoreContext(&(task_to_execute->context));
	}
	return;
}

void saveContext(Context * context) {
	int tempreg = 3;
	//asm("cli");
	
	context->tstamp = YKTickNum;
	// take care of ax first so we can use it
	asm("mov word [bp-2], ax");
	context->ax = tempreg;
	// push flags onto stack,
	asm("pushf");
	asm("pop ax");
	
	asm("mov word [bp-2], ax");
	context->flags = tempreg;
	
	asm("mov word [bp-2], bx");
	context->bx = tempreg;
	asm("mov word [bp-2], cx");
	context->cx = tempreg;
	asm("mov word [bp-2], dx");
	context->dx = tempreg;

	asm("mov word ax, word [bp+2]");
	asm("mov word [bp-2], ax");
	context->ip = tempreg;
	asm("mov word [bp-2], sp");
	context->sp = tempreg;
	//asm("mov word [bp-2], bp");
	//context->bp = tempreg;
	asm("mov word [bp-2], si");
	context->si = tempreg;
	asm("mov word [bp-2], di");
	context->di = tempreg;
	
	asm("mov word [bp-2], cs");
	context->cs = tempreg;
	asm("mov word [bp-2], ds");
	context->ds = tempreg;
	asm("mov word [bp-2], ss");
	context->ss = tempreg;
	asm("mov word [bp-2], es");
	context->es = tempreg;
	asm("push word [bp]");
	asm("pop word [bp-2]");
	context->bp = tempreg;
	//YKExitMutex();
	
}

void restoreContext(Context * context) {
	int tempreg;
	//YKEnterMutex();
//	tempreg = context->ax ;
//	asm("mov word ax, [bp-2]");
	tempreg = context->bx ;
	asm("mov word bx, [bp-2]");
	tempreg = context->cx ;
	asm("mov word cx, [bp-2]");
	tempreg = context->dx ;
	asm("mov word dx, [bp-2]");

	tempreg = context->bp ;
	asm("mov word sp, [bp-2]");
	tempreg = context->si ;
	asm("mov word si, [bp-2]");
	tempreg = context->di ;
	asm("mov word di, [bp-2]");
	
	tempreg = context->cs ;
	asm("mov word cs, [bp-2]");
	tempreg = context->ds ;
	asm("mov word ds, [bp-2]");
	tempreg = context->ss ;
	asm("mov word ss, [bp-2]");
	tempreg = context->es ;
	asm("mov word es, [bp-2]");
	
//	tempreg = context->bp ;
//	asm("push word  [bp-2]");
	
	tempreg = context->flags;
	asm("push word [bp-2]");
	// ax and si are used in the above operations
	tempreg = context->ax;
	asm("push word [bp-2]");
	tempreg = context->si;
	asm("push word [bp-2]");
	
	asm("pop si");
	asm("pop ax");
	asm("popf");
	asm("pop bp");
	//asm("sti");
	return;
}

void YKTickHandler() {
	int i;
	printNewLine();
	printString("TICK ");       // Print string
	printUInt(++YKTickNum);
	printNewLine();
	for(i=0;i<NumTasks;i++) {
		if(tasks[i].tickNum == YKTickNum) {
			tasks[i].state = 1;
		}
	}
	//printUInt(YKIdleCount);
	//asm("cli");
	//asm("sti");
}
