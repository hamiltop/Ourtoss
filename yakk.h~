#define TASK_ARRAY_SIZE 100
#define IDLESTACKSIZE 256

typedef struct {
	int ax;
	int bx;
	int cx;
	int dx;
	
//	int ip;
	int sp;
	int bp;
	int si;
	int di;
	
	int cs;
	int ds;
	int ss;
	int es;
	
//	int flags;	
} Context;

typedef struct {
	int id;
	Context context;
	int state;//ready = 1, not ready = 0
	int first_time; //=1 if it hasn't run yet. = 0 if it has.
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
void YKScheduler();
void YKDispatcher(TCB * task_to_execute);
void saveContext(Context * context);
void restoreContext(Context * context);
void YKTickHandler(void);

extern int YKCtxSwCount;
extern int YKIdleCount;
