#include <mega16.h>
#include <alcd.h>
#include <init.h>
#include <timer_init.h>
#include <_interrupt.h>
#include <stdio.h>


extern char ms;
extern char sec;
extern char min;
extern char hour;
extern char flag;

extern unsigned char* ms_str;
extern unsigned char* sec_str;
extern unsigned char* min_str;
extern unsigned char* hour_str;
