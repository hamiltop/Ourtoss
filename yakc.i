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


 int sp;
 int bp;
 int si;
 int di;

 int cs;
 int ds;
 int ss;
 int es;


} Context;

typedef struct {
 int id;
 Context context;
 int state;
 int first_time;
 int tickNum;
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
void YKScheduler();
void YKDispatcher(TCB * task_to_execute);
void saveContext(Context * context);
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
 YKNewTask(Idle, (void *)&IdleStk[256],100);
}

void Idle(void) {
 YKIdleCount++;
}

void YKNewTask(void (* task)(void),void *taskStack, unsigned char priority){
 TCB * newTCB = &(tasks[priority]);
 newTCB->id = id_counter++;
 newTCB->state = 1;
 newTCB->first_time = 1;

 tasks[priority] = *newTCB;
 if (running) YKScheduler();
}
void YKRun(){
 running = 1;
 YKScheduler();
}
void YKDelayTask(unsigned count){
 current_task->tickNum = YKTickNum +count;
}
void YKEnterMutex(){
 asm("cli");
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
  restoreContext(&current_task->context);
 }
}
void YKScheduler() {
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
  YKDispatcher(task_to_execute);
 }
}
void YKDispatcher(TCB * task_to_execute) {
 saveContext(&(current_task->context));
 current_task = task_to_execute;
 if(task_to_execute->first_time) {
  task_to_execute->first_time = 0;
  restoreContext(&(task_to_execute->context));
 }
 return;
}

void saveContext(Context * context) {
 int tempreg;
 asm("mov word [bp-2], ax");
 context->ax = tempreg;
 asm("mov word [bp-2], bx");
 context->bx = tempreg;
 asm("mov word [bp-2], cx");
 context->cx = tempreg;
 asm("mov word [bp-2], dx");
 context->dx = tempreg;

 asm("mov word [bp-2], sp");
 context->sp = tempreg;
 asm("mov word [bp-2], bp");
 context->bp = tempreg;
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
 tempreg = context->ax ;
 asm("mov word ax, [bp-2]");
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
 tempreg = context->bp ;
 asm("mov word bp, [bp-2]");
}

void YKTickHandler() {
 int i;
 YKTickNum++;
 for(i=0;i<100;i++) {
  if(tasks[i].tickNum == YKTickNum) {
   tasks[i].state = 1;
  }
 }
}
