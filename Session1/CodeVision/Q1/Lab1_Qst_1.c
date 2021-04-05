/*
 * Lab1_Qst_1.c
 *
 * Created: 2/23/2021 7:44:19 PM
 * Author: farkoo
 */

#include <io.h>
#include <delay.h>

void func1();

void main(void)
{
           
    func1();

    while (1)
    {
    // Please write your application code here

    }
}

void func1(){
    char i;      
    DDRB = 0xFF;
    for(i = 0; i < 4; i++){
                    PORTB = 0xFF;
                    delay_ms(500);
                    PORTB = 0x00;
                    delay_ms(500);
    }                            
    return;
}