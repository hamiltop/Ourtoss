#####################################################################
# ECEn 425 Lab 4 Makefile

lab4.bin:	lab4final.s
		nasm lab4final.s -o lab4.bin -l lab4.lst

lab4final.s:	clib.s myisr.s myinth.s yakc.s lab4c_app.s
		cat clib.s myisr.s myinth.s yakc.s lab4c_app.s > lab4final.s

myinth.s:	myinth.c
		cpp myinth.c myinth.i
		c86 -g myinth.i myinth.s
		
lab4c_app.s:	lab4c_app.c
		cpp lab4c_app.c lab4c_app.i
		c86 -g lab4c_app.i lab4c_app.s

yakc.s:		yakk.h yaku.h yakc.c  
		cpp yakc.c yakc.i
		c86 -g yakc.i yakc.s

clean:
		rm lab4.bin lab4.lst lab4final.s myinth.s myinth.i lab4c_app.s lab4c_app.i yakc.s yakc.i
