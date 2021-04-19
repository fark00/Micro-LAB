#include <header.h>

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{    
// Place your code here
    char num[20];
    char temp[20];        
    if(PINB.3 == 0){    
        if(capacity == 1000){      //out
            //capacity is empty
            lcd_gotoxy(0, 1);
            lcd_puts("                ");
            lcd_gotoxy(0, 1);
            lcd_puts("CE:1000"); 
        }
        else{
            capacity++; 
            sprintf(num,"%d", capacity);    
            strcpy(temp, "CE:");
            strcat(temp, num);
            lcd_gotoxy(0, 1);
            lcd_puts("                ");
            lcd_gotoxy(0, 1);
            lcd_puts(temp); 
        }
    }    
    else if(PINB.7 == 0){             //in
        if(capacity == 0){
            lcd_gotoxy(0, 1);
            lcd_puts("                ");
            lcd_gotoxy(0, 1);
            lcd_puts("CE:FULL"); 
        }                       
        else{         
            capacity--;
            sprintf(num,"%d", capacity);    
            strcpy(temp, "CE:");
            strcat(temp, num);
            lcd_gotoxy(0, 1);
            lcd_puts("                ");
            lcd_gotoxy(0, 1);
            lcd_puts(temp);      
        }
            
    }                 
    

}