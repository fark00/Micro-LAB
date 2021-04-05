#include <header.h>

char array2[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};    

void func4(char direction, char concurrent, char which){
    int i; 
    DDRC = 0xFF;
    if(concurrent == True)
        DDRD = 0x0F;
    else if(concurrent == False){
        switch(which){
            case 1:
                DDRD.1 = 1;
                break;
             case 2:
                DDRD.2 = 1;
                break;
            case 3:
                DDRD.3 = 1;
                break;
            case 4:
                DDRD.4 = 1;
                break;
            default:
                DDRD = 0x0F;
        }
    }  
    if(direction == inc) {
        i = 0;
        while(i != 10){
            PORTC = array2[i];
            delay_ms(500);            
            i++;     
        }
    }
    else if(direction == dec) {
        i = 9;
        while(i != -1){
            PORTC = array2[i];   
            delay_ms(500);
            i--;
        }
    }    
}