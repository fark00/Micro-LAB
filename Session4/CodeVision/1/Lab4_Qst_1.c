/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 3/29/2021
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <header.h>

// Global Variable
char ms = 0;
char sec = 0;
char min = 0;
char hour = 0;
char flag = 0;

unsigned char* ms_str = "00";
unsigned char* sec_str = "00";
unsigned char* min_str = "00";
unsigned char* hour_str = "00";

void main(void)
{
    // Declare your local variables here
    init();



    // Global enable interrupts
    #asm("sei")
    DDRB = 0x00;
    while (1)
      {
      // Place your code here

      }
}
