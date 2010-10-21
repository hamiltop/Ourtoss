# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "yakc.c"
# 1 "yaku.h" 1
# 2 "yakc.c" 2
# 1 "yakk.h" 1



typedef struct {
 int ax;
 int bx;
 int cx;
 int dx;

 int ip;
 int sp;
 int bp;
 int si;
 int di;

 int cs;
 int ds;
 int ss;
 int es;

 int flags;
} Context;

typedef struct {
 int id;
 Context context;
 int state;
 int first_time;
 int tickNum;
 void (* task)();
} TCB;



void YKInitialize();
void Idle(void);
void YKNewTask(void (* task)(void),void *taskStack, unsigned char priority);
void YKRun();
void YKDelayTask(unsigned count);
void YKEnterMutex();
void YKExitMutex();
void YKEnterISR();
void YKExitISR();
void YKScheduler(int old_ip);
void YKDispatcher(TCB * task_to_execute,int old_ip);
void saveContext(Context * context,int old_ip);
void restoreContext(Context * context);
void YKTickHandler(void);

extern int YKCtxSwCount;
extern int YKIdleCount;
# 3 "yakc.c" 2


int running;
TCB * current_task;
int id_counter;
TCB tasks[100];
int YKCtxSwCount;
int YKIdleCount;
int YKTickNum;
int IdleStk[256];
int isrdepth;

void YKInitialize(){
 id_counter = 0;
 running = 0;
 YKTickNum = 0;
 YKIdleCount = 0;
 YKCtxSwCount = 0;
 isrdepth = 0;
 YKNewTask(Idle, (void *)&IdleStk[256],99);
 current_task = &tasks[99];
}

void Idle(void) {
 while (1)
  YKIdleCount++;
}
void Dummy(){}
void YKNewTask(void (* task)(void),void *taskStack, unsigned char priority){

 TCB * newTCB = &(tasks[priority]);
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


 tasks[priority] = *newTCB;
 if (running) YKScheduler(0);
}
void YKRun(){
 running = 1;
 while(1)
 YKScheduler(0);
}
void YKDelayTask(unsigned count){
 int old_ip;
 current_task->tickNum = YKTickNum +count;
 current_task->state = 0;
 asm("mov word ax, word [bp+2]");
 asm("mov word [bp-2], ax");
 YKScheduler(old_ip);

}
void YKEnterMutex(){
 asm("cli");
}
void YKExitMutex(){
 asm("sti");
}
void YKEnterISR(){
 if (!isrdepth){
  saveContext(&current_task->context,0);
 }
 isrdepth++;
}
void YKExitISR(){
 isrdepth--;
 if (!isrdepth){
  restoreContext(&current_task->context);
 }
}
void YKScheduler(int old_ip) {
 int i;
 TCB * task_to_execute;
 for(i=0;i<100;i++) {
  if(tasks[i].state == 1) {
   task_to_execute = &tasks[i];
   break;
  }
 }
 if(task_to_execute != current_task) {
  YKCtxSwCount++;
  YKDispatcher(task_to_execute,old_ip);

 }
}
void YKDispatcher(TCB * task_to_execute, int old_ip) {
 int tempreg;
 saveContext(&(current_task->context),old_ip);
 current_task = task_to_execute;
 if(task_to_execute->first_time) {
  task_to_execute->first_time = 0;
  tempreg = task_to_execute->context.sp;
  asm("mov sp,word [bp-2]");

  task_to_execute->task();
 } else {
  restoreContext(&(task_to_execute->context));
  printString("gay\n");
 }
 return;
}

void saveContext(Context * context,int old_ip) {
 int tempreg = 3;
 context->ip = old_ip;


 asm("mov word [bp-2], ax");
 context->ax = tempreg;

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




 asm("mov word [bp-2], sp");
 context->sp = tempreg;


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
}

void restoreContext(Context * context) {
 int tempreg;


 tempreg = context->bx ;
 asm("mov word bx, [bp-2]");
 tempreg = context->cx ;
 asm("mov word cx, [bp-2]");
 tempreg = context->dx ;
 asm("mov word dx, [bp-2]");

 tempreg = context->sp ;
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

 tempreg = context->flags;
 asm("push word [bp-2]");
 tempreg = context->cs;
 asm("push word [bp-2]");
 tempreg = context->ip;
 asm("push word [bp-2]");

 tempreg = context->ax;
 asm("push word [bp-2]");
 tempreg = context->si;
 asm("push word [bp-2]");

 asm("pop si");
 asm("pop ax");
 asm("iret");
}

void YKTickHandler() {
 int i;
 YKTickNum++;
 for(i=0;i<100;i++) {
  if(tasks[i].tickNum == YKTickNum) {
   tasks[i].state = 1;
  }
 }
 printUInt(YKIdleCount);
 asm("cli");
 YKScheduler();
 asm("sti");
}
