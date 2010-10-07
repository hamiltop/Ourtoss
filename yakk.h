#define TASK_ARRAY_SIZE 100

struct TCB {
	int id;
	Context * context;
	int state;//ready = 1, not ready = 0
	int first_time; //=1 if it hasn't run yet. = 0 if it has.
	int tickNum;
}

struct Context {
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
}