#include <header.h>

void func4(){
    lcd_clear();
    DDRB=0x0F;
    PORTB=0xF0;
    
    lcd_puts("Qst4: Start...");
    delay_ms(1000);       
    lcd_clear();                    
    
    #asm("sei")  
    
   while(1){            
         PORTB.0=1; PORTB.1=0; PORTB.2=0; PORTB.3=0;                      
        delay_ms(10);
        PORTB.0=0; PORTB.1=1; PORTB.2=0; PORTB.3=0;                     
        delay_ms(10);
        PORTB.0=0; PORTB.1=0; PORTB.2=1; PORTB.3=0;       
        delay_ms(10);
        PORTB.0=0; PORTB.1=0; PORTB.2=0; PORTB.3=1;
        delay_ms(10);
         }    
}