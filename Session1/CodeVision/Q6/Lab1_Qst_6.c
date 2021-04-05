/*
 * Lab1_Qst_6.c
 *
 * Created: 2/28/2021 12:40:29 PM
 * Author: farkoo
 */

#include <io.h>
#include <delay.h>

// char array[]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90};    
char array[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};    


void func6();

void main(void)
{
    func6();
    while(1);
    return;
}

void func6(){
    unsigned int i = 0;
    unsigned int number=0;              
    unsigned int temp = 0;
    unsigned int sadghan=0;
    unsigned int dahghan=0;
    unsigned int yekan=0;
    unsigned int decimal=0;         
                                               
    unsigned int sadghan_tmp=0;
    unsigned int dahghan_tmp=0;
    unsigned int yekan_tmp=0;
    unsigned int decimal_tmp=0;         
    unsigned int number_tmp = 0;
    
    DDRA=0x00;
    DDRC=0xFF;
    DDRD=0x00;  
    number= PINA;
    temp = number * 10;        
    
    number_tmp = temp;
    decimal_tmp = number_tmp % 10;
    number_tmp = number_tmp / 10;
    yekan_tmp = number_tmp % 10;
    number_tmp = number_tmp / 10;
    dahghan_tmp = number_tmp % 10;
    number_tmp = number_tmp / 10;
    sadghan_tmp = number_tmp % 10; 
    
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
        temp = temp - 2;        
        
        if(PIND.7 == 0)
        {
            temp = sadghan_tmp * 1000 + dahghan * 100 + yekan * 10 + decimal - 2;    
        }
        if(PIND.6 == 0)
        {
            temp = sadghan * 1000 + dahghan_tmp * 100 + yekan * 10 + decimal - 2;    
        }
        if(PIND.5 == 0)
        {
            temp = sadghan_tmp * 1000 + dahghan * 100 + yekan_tmp * 10 + decimal - 2;    
        }
        if(PIND.4 == 0)
        {
            temp = sadghan_tmp * 1000 + dahghan * 100 + yekan * 10 + decimal_tmp;    
        }
    }

}