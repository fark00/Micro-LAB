/*
 * Lab1_Qst_4.c
 *
 * Created: 2/23/2021 9:22:49 PM
 * Author: farkoo
 */

#include <io.h>
#include <delay.h>

// char array[]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90};	
char array[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};	


void func4();

void main(void)
{
   
   func4();
    while(1);
    return;
}

void func4(){
    int i = 9; 
    DDRC = 0xFF;
    DDRD = 0x0F;
    PORTD = 0x00;      
     while(i !=-1){
        PORTC = array[i];    
        delay_ms(500);
        i--;
      
    }
}