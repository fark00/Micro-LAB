#include <header.h>

void func1(void){
    lcd_init(16);
    lcd_clear();
    lcd_puts("Farzaneh");
    lcd_gotoxy(0,1);
    lcd_puts("9733503");    
    return;
}