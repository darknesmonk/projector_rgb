eeprom  unsigned int OCRA,OCRB;
volatile unsigned int RC5_DATA=0,counter=300;
signed int temper=0;
volatile bit TOOGLE=0, RC_FLAG=0;
volatile unsigned char step=0, step2=0;
volatile unsigned char buf[ALL]={NULL},buf2[ALL]={NULL},buffer[ALL]={NULL},digbuf[12]={NULL},i;
flash unsigned char *month[]={ 
"������","�������","�����","������","���","����","����","�������","��������","�������","������","�������" };
flash unsigned char *week[]=
{"�����������","�������","�����","�������","�������","�������","�����������"}; 
typedef struct{ 
    unsigned char sec;
    unsigned char min;
    unsigned char hour; 
    unsigned char dow;
    unsigned char date;
    unsigned char month;
    unsigned char year;
}time; time t; 
void startup();
void send_num(unsigned char p,unsigned char sym);
void put_char(unsigned char *s, unsigned char d) ;
void fillnil(unsigned char *b);
void test();
void background(unsigned char bg);
void _delay_us(unsigned int us);
void gettime();
 void gettime()
 {
 
  rtc_get_time(&t.hour,&t.min,&t.sec);  
  rtc_get_date(&t.dow,&t.date,&t.month,&t.year);  
  
  
 } 
 
void startup()
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State6=T State5=T State4=T State3=T State2=T State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x04;
DDRD=0xFB;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x0A;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
if  (OCRA<50 || OCRA >510) OCRA=250; 

OCR1A=OCRA;
OCR1B=OCRB;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 125,000 kHz
// Mode: CTC top=OCR2
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x0B;
TCNT2=0x00;
if  (OCRB<10 || OCRB >254) OCRB=47; 
OCR2=OCRB;
// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
GICR|=0x40;
MCUCR=0x02;
GIFR=0x40;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x90;
// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;
 
  i2c_init();
rtc_init(0,1,0);
 //rtc_set_time(18,50,0);
 //rtc_set_date(3,20,5,15);
  

     w1_init();   
  

ds18b20_init(0,-30,60,DS18B20_10BIT_RES);  
ds18b20_temperature(0);

  

}
  void _delay_us(unsigned int us) 
  {
  while(--us) delay_us(1);
  }
  /*
unsigned char rev (unsigned char source)
{
return         ((source & 128)>> 7)
            |  ((source & 64) >> 5)
            |  ((source & 32) >> 3)
            |  ((source & 16) >> 1)
            |  ((source & 8)  << 1)
            |  ((source & 4)  << 3)
            |  ((source & 2)  << 5)
            |  ((source & 1)  << 7);
}
   */
void send_num(unsigned char p,unsigned char sym)
{
unsigned char i;
 if(sym>223) sym-=32;



 if (sym>96 && sym<127) sym-=32; else
 if (sym>96) sym-=95; 
// if (sym>127) sym-=64; 
for(i=0; i<5; i++)
{
//buf[ (p*5) +i ]=rev(num[sym-32][i]);
buf[ (p*5) +i ]=num[sym-32][i];
delay_ms(1);
}
}

void put_char(unsigned char *s, unsigned char d)
{
unsigned char i = 0; 
  
   
fillnil(buf);
    
  while(s[i]) {   send_num(i,s[i++]);   if(d) delay_ms(d); } 
  
}
void fillnil(unsigned char *b)
{
/*
unsigned char i;
for(i=0; i<ALL; i++)
{
b[i]=0;
} */

memset(b,0,ALL);

}

void test()
{
unsigned char i,l=0;
      rc=0;
      for (i=8; i>0; i--) { R(1<<i); delay_ms(100); }   
      R(0);
      delay_ms(50);
      for (i=0; i<8; i++) {l= l | 1<<i; R(l); delay_ms(100); }    
      delay_ms(1000);                                     
      
       bc=0;
        for (i=8; i>0; i--) {B = (1<<i); delay_ms(100); }   
      B=0;
      delay_ms(50);
      for (i=0; i<8; i++) {B = B | (1<<i); delay_ms(100); }    
      delay_ms(1000);
}
void delay_s(unsigned char s)
{
while(s--) delay_ms(1000);
}

void background(unsigned char bg)
{
unsigned char i;
for(i=0; i<ALL; i++) buf2[i]=m[bg][i];



}

void writeocr()
{
if(OCR1A!=OCRA ) OCRA=OCR1A;
if(OCR2!=OCRB) OCRB=OCR2; 
 }
