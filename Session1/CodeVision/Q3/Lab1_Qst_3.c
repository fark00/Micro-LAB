/*
 * Lab1_Qst_3.c
 *
 * Created: 2/23/2021 9:10:27 PM
 * Author: farkoo
 */

#include <io.h>
#include <delay.h>

void func3();

void main(void)
{
    
    func3();
    while (1)
    {
    // Please write your application code here

    }    
    return;
}

void func3(){
    DDRA = 0x00;
    DDRB = 0xFF;
    PORTB = PINA;
    return;            
}
