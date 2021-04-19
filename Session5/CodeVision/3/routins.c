#include <header.h>

void routin1(void){
    duty_cycle = 0;
    DDRA = 0x00;
    duty_cycle = PINA;
    duty_cycle = ((duty_cycle*90)/255) + 5;
    duty_cycle = floor((duty_cycle*255)/100);
    OCR0 = duty_cycle;
}