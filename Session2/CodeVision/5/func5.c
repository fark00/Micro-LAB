#include <header.h>

char array[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};    

void func5(char step){
unsigned int i = 0;
    unsigned int number=0;              
    unsigned int temp = 0;
    unsigned int sadghan=0;
    unsigned int dahghan=0;
    unsigned int yekan=0;
    unsigned int decimal=0;       
    DDRA=0x00;
    DDRC=0xFF;
    DDRD=0x00;  
    number= PINA;
    temp = number * 10;
    while(number > 0){  
        number = temp;   
        if(number >= 1000){
            decimal = number % 10;
            number = number / 10;
            yekan = number % 10;
            number = number / 10;
            dahghan = number % 10;
            number = number / 10;
            sadghan = number % 10;
        }                                           
        else if(number >=100) {
            decimal = number % 10;
            number = number / 10;
            yekan = number % 10;
            number = number / 10;
            dahghan = number % 10;
            sadghan = 0;        
        }  
        else if(number >= 10){
            decimal = number % 10;
            number = number / 10;
            yekan = number % 10;
            dahghan = 0;
            sadghan = 0;
        }     
        else{
            decimal = number % 10;
            yekan = 0;
            dahghan = 0;
            sadghan = 0;
                         
        }
        for(i = 0; i < 25; i = i + 1)
        { 
            DDRD.3 = 1;
            PORTC = array[decimal];
            delay_ms(1);
            
            DDRD.3 = 0;
            DDRD.2 = 1;
            PORTC = array[yekan] + 0b10000000;
            delay_ms(1);
            
            DDRD.2 = 0;
            DDRD.1 = 1;
            PORTC = array[dahghan];
            delay_ms(1);
            
            DDRD.1 = 0;
            DDRD.0 = 1;
            PORTC = array[sadghan]; 
            delay_ms(1);    
            DDRD.0 = 0;
        }
                                  
        DDRD.0 = 0;
        temp = temp - step;
    }
}