#include <headers.h>


void question1(void){
    int j = 0, k = 0;
   data=0;
   i=0; 
   mat=0;
   pat=0; 
   lcd_clear();
   lcd_puts("Q1 started!");
   for(i=0;i<8;i++){ 
        data = read_adc(i);
        pat = data * 5;
        mat = pat / 1023;
        mat = mat * 1000;
        data = floor(mat);
        sprintf(stringdata,"ADC(%d): %d mv",i,data);
        lcd_gotoxy(0,1);
        lcd_puts("                 ");
        lcd_gotoxy(0,1);
        lcd_puts(stringdata);
        j = 0;
        while(j < 10000){
            j++;
            k = 0;
            while(k<90)
                k++;
        }
   }
}

void question2(void){
   
    i = 0;
    #asm("sei")
}

void question3(void){
    #asm("sei")
}