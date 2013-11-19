#include<avr/io.h>
#include<stdint.h>


void USART_Init( uint8_t baud )
{
/* Set baud rate */
//UBRRH = (unsigned char)(baud>>8);
UBRRL = (unsigned char)baud;
/* Enable Receiver and Transmitter */
UCSRB = (1<<RXEN)|(1<<TXEN);
/* Set frame format: 8data, 2stop bit */
UCSRC = (1<<URSEL)|(1<<USBS)|(3<<UCSZ0);
}


void USART_Transmit( unsigned char data )
{
/* Wait for empty transmit buffer */
while ( !( UCSRA & (1<<UDRE)) )
;
/* Put data into buffer, sends the data */
UDR = data;
//while ( !( UCSRA & (1<<UDRE)) )

}

unsigned char USART_Receive( void )
{
/* Wait for data to be received */
while ( !(UCSRA & (1<<RXC)) );
/* Get and return received data from buffer */
return UDR;
}



int main(void)
{
//DDRB=0b11111111;
DDRD=0b11111111;

unsigned char a,b;
uint8_t baud=207;
USART_Init( baud );
a='v';

PORTD=0b11111111;
/*
while(1)
{
USART_Transmit(a);
b=USART_Receive();
if(b=='v')
PORTC=0b00011000;
else
PORTC=0b00001000;
}
*/
}
