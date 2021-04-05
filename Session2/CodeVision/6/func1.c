#include <header.h>

void func1(char num, char port, int ms_delay){
    char i;           
    switch(port){
        case portA:
            DDRA = 0xFF;
            break;
        case portB:
            DDRB = 0xFF;
            break;
        case portC:
            DDRC = 0xFF;
            break;     
        case portD:
            DDRD = 0xFF;
            break;
        default:
            DDRB = 0xFF;
    }
    for(i = 0; i < num; i++){
                    PORTB = 0xFF;
                    delay_ms(ms_delay);
                    PORTB = 0x00;
                    delay_ms(ms_delay);
    }                            
    return;
}