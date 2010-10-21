# 1 "myinth.c"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "myinth.c"
# 1 "clib.h" 1



void print(char *string, int length);
void printNewLine(void);
void printChar(char c);
void printString(char *string);


void printInt(int val);
void printLong(long val);
void printUInt(unsigned val);
void printULong(unsigned long val);


void printByte(char val);
void printWord(int val);
void printDWord(long val);


void exit(unsigned char code);


void signalEOI(void);
# 2 "myinth.c" 2
extern int KeyBuffer;
int tickCount = 0;

void reset(void) {
 exit(0x0);
}

void tick(void) {
 printNewLine();
 printString("TICK ");
 printInt(++tickCount);
 printNewLine();
 YKTickHandler();
}

void key(void) {
 int i;
 asm ("cli");
 switch(KeyBuffer) {
  case 'd' :
   asm("sti");
   printNewLine();
   printString("DELAY KEY PRESSED ");
   printNewLine();
   for(i=0;i<5000;i++);
   printString("DELAY COMPLETE ");
   printNewLine();
   break;
  default :
   printNewLine();
   printString("KEYPRESS (");
   printChar(KeyBuffer);
   printString(") IGNORED");
   printNewLine();
   break;
 }
 asm("sti");
}
