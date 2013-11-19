#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/iom32.h>
#define A_DEN 0x80
#define A_DSC 0X40
#define S_REG 0x80

unsigned char Channel = 1;



unsigned char value = 0;
unsigned char value1 = 0;
unsigned char value6 = 0;
unsigned char Ready = 0;

unsigned char val1 =0;
unsigned char val2 =0;
unsigned char val3 =0;
unsigned char val4 =0;
unsigned char val5 =0;
unsigned char val6 =0;



void delay(int del);
void Tx_Comm(unsigned char S_Data);
void Serial_Tx(void);
void ADC_convert(void);

//This section convertes Higher Nibble HEX to ASCII Value & Transmits to PC

void ADC_convert()
{
value=0x00;
value1=0x00;

ADCSRA |= 0X80; //ENABLE ADC
ADCSRA|= 0x40; //starting the conversion
//delay(50);
while(ADCSRA & 0x40); // wait for the end of the conversion
delay(100);
value = ADCL;
value1 = ADCH;

} 

void Serial_Tx(void)
{
value1 = ADCH;
(val2 = value1 + 0x30);
Tx_Comm(val2); // Transmit the Value.

value = ADCL;

val3 = (value >>4);
val3 = (val3 & 0x0f);
if(val3 >= 0x0A)
{
(val2 = val3 + 0x37);
}
else
{
(val2 = val3 + 0x30);
}
Tx_Comm(val2); // Transmit the Value.

value = ADCL;

// This section convertes Lower Nibble HEX to ASCII Value & Transmits to PC

(val4 = value & 0x0f);
if (val4 >= 0x0A)
{
(val2 = val4 + 0x37);
}
else
{
(val2 = val4 + 0x30);
}
Tx_Comm(val2);

Tx_Comm(0x0D);
Tx_Comm(0x0A);
}



int main (void)
{
UBRRH = 0x00;
UBRRL = 23;
// Enable receiver and transmitter
UCSRB = (1<<RXEN)|(1<<TXEN);
// Set frame format: 8data, 1stop bit
UCSRC = (1<<URSEL)|(3<<UCSZ0);

DDRB = 0xFF;
DDRA = 0x00;
//GICR = 0X02;
//SREG = 0x80 ; // SREG Bit 7 - Global Interrupt Enable. I bit set to 1
//sei();


//ADCSRA |= A_DEN; //ENABLE ADC
ADCSRA = 0x84; //
ADMUX =0xC0; //reference external voltage, channel selection

ADCSRA |= 0X80; //ENABLE ADC

PORTB = 0xFF; //switch of all led's
SFIOR=0x00; //free running mode selection

while(1)
{

PORTB= 0X0f;
//delay(10000);
//delay(10000);
delay(10000);
delay(10000);
Tx_Comm(0x09);
Tx_Comm(Channel + 0x30);
Tx_Comm(0x20);

//Tx_Comm('a');
ADC_convert();
Serial_Tx();
delay(1000);

PORTB= 0Xf0;
delay(10000);
//delay(10000);
//delay(10000);
//delay(10000);

}
}

void delay(int del)
{
while(del--);

}

void Tx_Comm(unsigned char S_Data)
{
while(1)
{
value6 = (UCSRA & 0x20);
if(value6 == 0x20)
break;
}
UDR = S_Data;
}


