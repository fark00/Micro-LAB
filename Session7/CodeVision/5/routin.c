#include <header.h>


void routin1(int BAUD, int transmitter_status, int reciever_status){
    int temp = (1000000/(2*BAUD))-1;
    int q,r;
    q = temp/256;
    r = temp - (q*256);
    
    if(transmitter_status == 0 && reciever_status == 0){
        UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    } // tx: off     rx: off
    else if(transmitter_status == 1 && reciever_status == 0){
        UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    } // tx: enable_noneinterrupt       rx: off   
    else if(transmitter_status == 2 && reciever_status == 0){
        UCSRB=(0<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    } // tx: enable_interrupt       rx: off  
    else if(transmitter_status == 0 && reciever_status == 1){
        UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    } // tx: off     rx:  enable_noneinterrupt
    else if(transmitter_status == 1 && reciever_status == 1){
        UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    } // tx: enable_noneinterrupt       rx:  enable_noneinterrupt   
    else if(transmitter_status == 2 && reciever_status == 1){
        UCSRB=(0<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    } // tx: enable_interrupt       rx:  enable_noneinterrupt       
    else if(transmitter_status == 0 && reciever_status == 2){
        UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    } // tx: off     rx:  enable_interrupt
    else if(transmitter_status == 1 && reciever_status == 2){
        UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    } // tx: enable_noneinterrupt       rx:  enable_interrupt   
    else if(transmitter_status == 2 && reciever_status == 2){
        UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
    } // tx: enable_interrupt       rx:  enable_interrupt    
    UBRRH = q;
    UBRRL = r;
}

void routin2(){
    char str2[100] = "";
    char temp = '';
    int n = 0;      
    temp = getchar();
    putchar(temp);
    str2[0] = '(';
    n++;
    while(temp != '\r'){
        str2[n] = temp;
        temp = getchar();
        putchar(temp);
        n++;
    }       
    str2[n] = ')';
    puts(str2);  
    putchar('\r');
    
}

void routin3(void){
    unsigned char temp='';
    int a=0;
    unsigned char str[3]="";
    temp = getchar_(); 
    switch (temp){
        case '0':
            a=0;
            break;
        case '1':
            a=1;
            break;
        case '2':
            a=2;
            break;
        case '3':
            a=3;
            break;
        case '4':
            a=4;
            break;
        case '5':
            a=5;
            break;
        case '6':
            a=6;
            break;
        case '7':
            a=7;
            break; 
        case '8':
            a=8;
            break;
        case '9':
            a=9;
            break;
        default:
            a=100;
    }  
    if( a>=0 && a<10){
        puts("\rTx:");
        putchar(temp);
        puts("\rRx: Data is a integer and 10*data=");
        a=a*10;
        sprintf(str, "%d", a);
        puts(str);
        puts("\r");
     } 
    
    else if(temp=='D'){
        lcd_puts("LCD delete");
    } 
    
    else if(temp=='H'){
        puts("\rMicro Laboratory\r");
    }
    
    else {
        puts("\rNo function defined!\r");
    }    

}


void routin4(void){
    unsigned char my_data[55]="";
    unsigned char in4='';  
    int i=0;
    int a=0;
    int j=0;
    in4 = getchar_();
    putchar_(in4); 
    my_data[0]='(';
    i++; 
    while (in4!='\r'){ 
        my_data[i]=in4; 
        in4 = getchar_();
        putchar_(in4);
        i++;    
    }
    my_data[i]=')';  
    for (j=0;my_data[j]!=')';j++){ 
        if((my_data[j]<'0' || my_data[j]>'9')&&my_data[j]!='(')   
        {
            a = 100;
            break ;
        }    
    }     
    if(i<6){  
        puts("\tLength of frame not correct\r");
    }
    else if (a>9 || i > 6){
       puts("\tFrame must be 5 integer\r"); 
    }
    else { 
        puts("\tFrame is correct\r");
        lcd_init(16);
        lcd_puts(my_data);
    }  
}
