#include <header.h>

void func5(void){
    unsigned char dig1, dig2;
    lcd_puts("Qst5: Start ...");
    delay_ms(1000);
    lcd_clear();
                
   while(1){
        lcd_clear();                       
        lcd_puts("Speed:??(00-50r)");
        lcd_gotoxy(0,1);       
        lcd_puts("Input: ");
        dig1 = keypad();
        dig2 = keypad();
        
        if(dig1>5 || dig2>9||(dig1 == 5 && dig2 != 0)){
             lcd_gotoxy(6,0);
             lcd_putchar('E');
             lcd_gotoxy(7,0);
             lcd_putchar('E');
             lcd_gotoxy(1,0);
             delay_ms(1000);  
             lcd_clear(); 
             lcd_puts("ERROR!");
             delay_ms(1000);
        }     
        else{
             lcd_gotoxy(6,0);
             lcd_putchar(key_pad[dig1]);
             lcd_gotoxy(7,0);
             lcd_putchar(key_pad[dig2]);    
             delay_ms(1000);
             break;
        }    
        }
   while(1){
        lcd_clear();                       
        lcd_puts("Time:??(00-99s)");
        lcd_gotoxy(0,1);       
        lcd_puts("Input: ");
        dig1 = keypad();
        dig2 = keypad();
            
        if(dig1>9 || dig2>9){
             lcd_gotoxy(5,0);
             lcd_putchar('E');
             lcd_gotoxy(6,0);
             lcd_putchar('E');
             lcd_gotoxy(1,0);
             delay_ms(1000);  
             lcd_clear(); 
             lcd_puts("ERROR!");
             delay_ms(1000);
        }     
        else{
             lcd_gotoxy(5,0);
             lcd_putchar(key_pad[dig1]);
             lcd_gotoxy(6,0);
             lcd_putchar(key_pad[dig2]);    
             delay_ms(1000);
             break;
        }        
   }          
   while(1){
            lcd_clear();                       
            lcd_puts("Weigt:??(00-99F)");
            lcd_gotoxy(0,1);       
            lcd_puts("Input: ");
            dig1 = keypad();
            dig2 = keypad();
            
            if(dig1>9 || dig2>9){
                 lcd_gotoxy(6,0);
                 lcd_putchar('E');
                 lcd_gotoxy(7,0);
                 lcd_putchar('E');
                 lcd_gotoxy(1,0);
                 delay_ms(1000);  
                 lcd_clear(); 
                 lcd_puts("ERROR!");
                 delay_ms(1000);
            }     
            else{
                 lcd_gotoxy(6,0);
                 lcd_putchar(key_pad[dig1]);
                 lcd_gotoxy(7,0);
                 lcd_putchar(key_pad[dig2]);    
                 delay_ms(1000);
                 break;
            }   
        }
   while(1){
        lcd_clear();                       
        lcd_puts("Temp:??(20-80C)");
        lcd_gotoxy(0,1);       
        lcd_puts("Input: ");
        dig1 = keypad();
        dig2 = keypad();
            
        if(dig1>8 || dig1<2 || dig2>9||(dig1 == 8 && dig2 != 0)){
             lcd_gotoxy(5,0);
             lcd_putchar('E');
             lcd_gotoxy(6,0);
             lcd_putchar('E');
             lcd_gotoxy(1,0);
             delay_ms(1000);  
             lcd_clear(); 
             lcd_puts("ERROR!");
             delay_ms(1000);
        }     
        else{
             lcd_gotoxy(5,0);
             lcd_putchar(key_pad[dig1]);
             lcd_gotoxy(6,0);
             lcd_putchar(key_pad[dig2]);    
             delay_ms(1000);
             break;
        }      
        
    }
}
