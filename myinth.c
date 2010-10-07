#include "clib.h"
extern int KeyBuffer;
int tickCount = 0;

void reset(void) {
	exit(0x0);
}

void tick(void) {
	printNewLine();
	printString("TICK ");       // Print string
	printInt(tickCount++);
	printNewLine();
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