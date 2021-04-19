#include <header.h>

void routin1(void){
    duty_cycle = 0;
    DDRA = 0x00;
    duty_cycle = PINA;
    duty_cycle = ((duty_cycle*90)/255) + 5;
    duty_cycle = floor((duty_cycle*255)/100);
    OCR0 = duty_cycle;   
    lcd_gotoxy(1,0);
    lcd_puts("1");
}

void routin2(void){
    if (rpm_counter<=100){
        if (direction == 1 ){ 
            if (temp_counter == 1) {
                PORTB.4 = 1;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 0;  //D
                temp_counter ++ ;
            }
            if (temp_counter == 2) {
                PORTB.4 = 0;  //A
                PORTB.5 = 1;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 0;  //D 
                temp_counter ++ ;
            }
            if (temp_counter == 3) {
                PORTB.4 = 0;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 1;  //C
                PORTB.7 = 0;  //D
                temp_counter ++ ;
            }
            if (temp_counter == 4) {
                PORTB.4 = 0;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 1;  //D
                temp_counter ++ ;
            } 
                
            if (temp_counter > 4){
                temp_counter=1;
            }
        }
        rpm_counter++;  
    }
        
        
    if (rpm_counter==100){ 
           PORTB.4 = 0;  //A
           PORTB.5 = 0;  //B
           PORTB.6 = 0;  //C
           PORTB.7 = 0;  //D
           direction=0;
           //delay_ms(50);
           rpm_counter++;
    }
         
    if (rpm_counter >100 &&  rpm_counter<=200){ 
        if (direction == 0 ){ //Left
            if (temp_counter == 1) {
                PORTB.4 = 0;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 1;  //D
                temp_counter ++ ;
            }
            if (temp_counter == 2) {
                PORTB.4 = 0;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 1;  //C
                PORTB.7 = 0;  //D
                temp_counter ++ ;
            }
            if (temp_counter == 3) {
                PORTB.4 = 0;  //A
                PORTB.5 = 1;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 0;  //D 
                temp_counter ++ ;
            }
            if (temp_counter == 4) {
                PORTB.4 = 1;  //A
                PORTB.5 = 0;  //B
                PORTB.6 = 0;  //C
                PORTB.7 = 0;  //D
                temp_counter ++ ;
            }
                
            if (temp_counter > 4){
                temp_counter=1;
            }
                
        }
        rpm_counter++; 
    }
          
    if (rpm_counter>200){
        rpm_counter=0; 
        direction=1;
    }       
    
    speed = 1/(0.01*4)*60;
    sprintf(temp_str, "%d", speed);
    lcd_gotoxy(0, 0);
    lcd_puts(temp_str);
    lcd_gotoxy(6, 0);
    lcd_puts("rpm");
}