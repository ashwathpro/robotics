#include <avr/io.h>


#define FOSC 8000000// Clock Speed
#define BAUD 9600
#define MYUBRR FOSC/16/BAUD-1


void USART_Init( unsigned int ubrr)
{
UBRRH = (unsigned char)(ubrr>>8);	/* Set baud rate */
UBRRL = (unsigned char)ubrr;
UCSRB = (1<<RXEN);	/* Enable receiver and transmitter */
UCSRC = (1<<URSEL)|(3<<UCSZ0);	/* Set frame format: 8data, 2stop bit */
}


unsigned char USART_Receive( void )
{
while ( !(UCSRA & (1<<RXC)) );
return UDR;
}

int main (void)
{
 uint8_t t; 
 unsigned char c;
 DDRD=0b00000000;
 DDRB=0b11111111;
 DDRC=0b11111111;
 PORTD=0b11111111;
 PORTB=0b11111111;
 USART_Init ( MYUBRR );
 while(1)
 {
 c= USART_Receive();
 if(c=='a')
 PORTC=0b11111111;
 else
 PORTC=0b00000000;}
 
}


 
 
 
