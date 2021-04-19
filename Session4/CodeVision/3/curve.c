#include <header.h>

void curve(void){
    int num;  
    float temp1;  
    int temp2;
    int error;
    char arr[20];
    DDRA = 0x00; 
    DDRD.4 = 1;
    DDRD.5 = 1;  
     TCNT1 = 0; 
    TCCR1A = 0x50;
    TCCR1B = 0x0a; 
    
    num = PINA;  
    temp1 = 39.0625;    
    temp1 = num*temp1;
    temp2 = temp1;          
    temp2 = temp2/2;
    error = ((temp1 - temp2*2)/temp1)*100;  
    if(error > 9)
        error = 9;   
    OCR1A = temp2%256;
    OCR1B = temp2/256;
    
    sprintf(arr,"%dUS%d",temp2*2,error);
    lcd_puts(arr);   
      
    
                 
    
  
       
    
}