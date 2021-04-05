#include <header.h>

void func3(char inport, char outport){
    char selectin;
    switch(inport){
        case portA:
            DDRA = 0x00;     
            selectin = PINA;
            break;
        case portB:
            DDRB = 0x00;  
            selectin = PINB;
            break;
        case portC:
            DDRC = 0x00;   
            selectin = PINC;
            break;
        case portD:
            DDRD = 0x00;   
            selectin = PIND;
            break;
         default:
            DDRA = 0x00;   
            selectin = PINA;
    }
    switch(outport){
        case portA:
            DDRA = 0xFF;      
            PORTA = selectin;
            break;
        case portB:
            DDRB = 0xFF;    
            PORTB = selectin;
            break;
        case portC:
            DDRC = 0xFF;
            PORTC = selectin;
            break;
        case portD:
            DDRD = 0xFF;
            PORTD = selectin;
            break;
         default:
            DDRB = 0xFF;
            PORTB = selectin;
    }                  
}