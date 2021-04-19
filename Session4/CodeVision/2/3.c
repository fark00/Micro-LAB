/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 4/4/2021
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

// Declare your global variables here

int capacity = 1000;
// External Interrupt 0 service routine

void main(void)
{
// Declare your local variables here



// Global enable interrupts
    init();
    DDRB = 0x00;
    #asm("sei")

while (1)
      {
      // Place your code here

      }
}
