#define R(D) { PORTD=D ; PORTC.3=PORTD.2;}
#define B PORTB
#define rc PORTC.5
#define bc PORTC.4
#define ALL 80
#define PD2 PIND.2
#define POWER 12 
#define DISPLAY 15
#define MINUS 21
#define PLUS 22
#define DOWN 17
#define UP 16
#define MENU 18
#define HELP 47
#define SLEEP 38
#define MUTE 13
#define VIDEO 56
#define TV 63
#define STD 14
#include <mega8.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>
#include <i2c.h>
#include <1wire.h>
#include <ds18b20.h>
    #asm
        .equ __i2c_port=0x15
        .equ __sda_bit=1
        .equ __scl_bit=0
    #endasm
#include <ds1307.h>
#include "fonts.c"
#include "fon.c"
#include "func.c"
    interrupt [EXT_INT0] void ext_int0_isr(void)
{ 

if(PD2) return;
delay_us(10);
if(PD2) return;
GICR&=~0x40;
//if(!RC_FLAG) {GIFR |= (1 << INTF0); GICR|=0x40;  return;} 
    delay_us(120);
 RC5_DATA=0;  
 for(i = 0; i < 13; i++) {
       RC5_DATA <<= 1; 
    _delay_us( 438);        
    if(PD2) { delay_us(10);    if(PD2) { delay_us(10);   if(PD2) {  RC5_DATA++;   }} }    
}
  
    counter++;
  
 if((RC5_DATA & 0b1111111111000000) !=0 )      
 { GIFR |= (1 << INTF0); GICR|=0x40;  return; }
 
 RC_FLAG=1;  
 
 switch(RC5_DATA)
 {
 case 1: 
 case 2: 
  case 3:
   case 4:
    case 5:
     case 6:
      case 7: 
      case 8: background(RC5_DATA-1); break;   
      case MINUS: if(OCR1A>50) OCR1A--;  break;           
      case PLUS: if(OCR1A<510) OCR1A++;    break;      
      case UP: if(OCR2<250) OCR2++;    break;          
      case DOWN:   if(OCR2>20) OCR2--;    break;    
 case MENU:   break; 
 case POWER: bc=rc^=1; break;
 case DISPLAY: TOOGLE ^=1; break;
 case VIDEO: bc^=1; break;
 case TV: rc^=1;  
 }

 
 delay_ms(10);   

 GIFR |= (1 << INTF0);  
 GICR|=0x40;    
  
  }
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{

B=(!TOOGLE)?buf[step2++]:buf2[step2++];  
if (step2>ALL-1) step2=0;
TCNT1=0; 

}
interrupt [TIM2_COMP] void timer1_compb_isr(void)
{
R((TOOGLE)?buf[step++]:buf2[step++]);
if (step>=ALL-1) step=0;
 TCNT2=0;
}


void main(void)
{
 unsigned int x=0;

startup();
fillnil(buf);
test();
R(0);
B=0;
bc=rc=0;
  delay_ms(2000);   

 #asm("sei")
  R(0); rc=0;
  put_char("������...",1000);   
         delay_s(3);     
         for(x=10; x>0; x--) {   ltoa(  x, digbuf); put_char(digbuf,0); delay_ms(1000);     }
            background(6);       
  put_char("",1000);       

    while(1)
     {  

     writeocr();
       while( (temper=ds18b20_temperature(0)) && (temper<-50 || temper>80)) {    delay_ms(5);   }    
        
         ltoa(  temper, digbuf);
  
      fillnil (  buffer );
      
      strcat(buffer,"� �������:");
      strcat(buffer,digbuf);
      strcat(buffer,"c");
       put_char(buffer,1000);
       delay_s(10);
       fillnil (  buffer );
       gettime() ;  
        strcpy(buffer,"�����:  ");
       ltoa(  t.hour, digbuf);
       strcat(buffer,digbuf);
       strcat(buffer,":");  
        ltoa(  t.min, digbuf);
        if(t.min<10) strcat(buffer,"0");
       strcat(buffer,digbuf);
        put_char(buffer,1000);   
          delay_s(10); 
        strcpyf(buffer,week[t.dow-1]);     
        put_char(buffer,1000);
         delay_s(10);     
      
         ltoa(  t.date, digbuf);  
            strcpy(buffer,digbuf); 
             strcat(buffer," ");
             strcatf(buffer,month[t.month-1]); 
             strcat(buffer," 20");
             ltoa(  t.year, digbuf); 
              strcat(buffer,digbuf);
            put_char(buffer,1000);   
       delay_s(10);  
       put_char("AVR ATMEGA 8",2000);     
           delay_s(10);    
            put_char("���� ��� ���",2000);     
           delay_s(10);  
           put_char("�������",2000);     
           delay_s(10);  
           put_char("�. ��������",2000);     
           delay_s(10);     
           put_char("��� ������",2000);     
           delay_s(10);    
                put_char("=) :) ^_^ ;-)",2000);     
           delay_s(10);  
    /*   put_char("�. �����",2000);  
        delay_s(10);        
          put_char("���� <3 �����",2000);     
            delay_s(10); 
          put_char("=) :) ^_^ ;-)",2000);     
           delay_s(10);  
            put_char("����� ������!",2000);     
           delay_s(10);  
           put_char("� �������� :)",2000);     
           delay_s(10);     
           put_char("�������� 45000�",2000);     
           delay_s(10);  
        */                                      
           fillnil (  buffer );
           for(x=100; x>0; x--) {   ltoa(  x, digbuf); put_char(digbuf,0); delay_ms(100);     }  
           put_char("BOOM!!! :-D",5000);     
           delay_s(3);  
     }
 
    /*  
   while(1) { 
   
     while( (temper=ds18b20_temperature(0)) && (temper<-50 || temper>80)) {    delay_us(400);   }
   gettime() ; 
      fillnil (  buffer );
   ltoa(  temper, buffer);  
     
    
        

   
    put_char( buffer ,1000); 
   delay_ms(1000);  
    ltoa(  t.min, buffer); 
     put_char(buffer,1000); 
      delay_ms(1000); } 
    
    
  
    while(1)
    
    {
     
    
  
  
  
    fillnil (  buffer );
  ltoa(  temper, buffer);  *buffer=*strcat("�����������: ",buffer);   put_char(buffer,1000);  
    delay_s(5);
   fillnil (  buffer );
   
   
     
  ltoa(  t.hour, buffer);   
 *buffer=*strcat("�����: ",buffer);
 put_char(buffer,1000);  
      delay_s(5);
       fillnil (  buffer );
     ltoa(  t.min, buffer);    
     
     *buffer=*strcat("�����: ",buffer); 
 put_char(buffer,1000);  
      fillnil (  buffer );
  delay_s(5);
    }
                  
    while(1) {
       
     
    //    ltoa( counter, buffer); put_char(buffer,1);
     while(!RC_FLAG);    
  
  
 
RC_FLAG=0;
 
 
  
  put_char(buffer,1);
   delay_ms(1000);
 
   }  
  
         
     
         
         
          
   for(x=100; x!=0; x--) { ltoa(x, buffer); put_char(buffer,1); delay_ms(50); }
            delay_s(1);
             rc=0;    
             background(6);
             put_char("�������!",1000);
                   delay_s(5);
                   
              
       put_char("",1000);             
       
       background(0); 
       delay_s(5); 
        TOOGLE ^=1;  
         delay_s(10);   
          TOOGLE ^=1;  
    background(2);
           put_char("�����-���",1000);     
             delay_s(15);  
           
     background(3);
  while(1){
    rc=0;       
          
          put_char("���� ��� ���",1000);     
           delay_s(10);  
        put_char("����: bumate.ru",1000); 
         delay_s(10);   
          put_char("������ 29471",1000); 
         delay_s(10);  
          put_char("�����-��� 2015",1000); 
         delay_s(10);   
            put_char(":-) :-D =) ^_^",1000); 
         delay_s(10);  
          bg=(bg>6)?3:(bg+1);   
         background(bg);
         }
              */
 
 
 
 

 
 
}
