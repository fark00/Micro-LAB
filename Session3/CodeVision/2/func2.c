#include <header.h>

void func2(void){
    int i = 0, j;               
    char temp[17];
    char arr[]="Welcome to the online lab classes due to Corona disease.";
    char len = strlen(arr);   
    lcd_init(16);
    lcd_clear();
    while(i != len){
        for(j = 0; j < 16; j = j + 1){       
            if(arr[i] == '\0')
                break;
            temp[j] = arr[i+j];    
        }                  
        temp[16]='\0';
        i = i + 1;          
        lcd_clear();   
        lcd_gotoxy(0,0);
        lcd_puts(temp);
        delay_ms(100);
    }       
    lcd_clear();
    return;
}