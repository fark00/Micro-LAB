/*
 * Lab1_Qst_2.c
 *
 * Created: 2/23/2021 8:01:25 PM
 * Author: farkoo
 */

#include <io.h>
#include <delay.h>

void func2();

void main(void)
{
    func2();    
    while(1);
    return ;
}

void func2(){
    int counter;   
    DDRB = 0xFF; 
    PORTB = 0x80;
    counter = 0;
    while(counter != 3000){
              PORTB = PORTB>>1;     
              if(PORTB == 0x00)
                PORTB =  0x80;
              delay_ms(50);
              counter += 50;
    }
    return;
}
