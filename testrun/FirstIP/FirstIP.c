#include<avr/io.h>
#include<util/delay.h>

/*#define DELAY_TIME 500   
 DELAY_tIME for much time should the motor
 be on if one Char is received */

void USART_Init( unsigned int baud )
{
	/* Set baud rate */
	UBRRH = (unsigned char)(baud>>8);
	UBRRL = (unsigned char)baud;
	
	/* Enable Receiver and Transmitter */
	UCSRB = (1<<RXEN)|(1<<TXEN);
	
	/* Set frame format: 8data, 2stop bit */
	UCSRC = (1<<URSEL)|(0<<USBS)|(3<<UCSZ0);
}



/*void USART_Transmit( unsigned char data )
{
	// Wait for empty transmit buffer 
	while ( !( UCSRA & (1<<UDRE)) );
	
	// Put data into buffer, sends the data 
	UDR = data;
	PORTC=0b00111111;
	
}*/


unsigned char USART_Receive( void )
{
	// Wait for data to be received 
	while ( !(UCSRA & (1<<RXC)) );
	// Get and return received data from buffer 
	return UDR;
}


int main(void)
{
	DDRB=0b11111111;
	PORTB=0b00000000;
	unsigned char b;
	uint8_t baud;
	baud=12;
	USART_Init(baud);
	while(1)
	{
	PORTB=0b00000000;
//	USART_Transmit(a);	
	b=USART_Receive();
	if(b=='3')
	{
		PORTB=0b0110;
		_delay_ms(10);
	}
	else
	{
		if(b=='1')
		{ 	
			PORTB=0b1010;
			_delay_ms(5);
		}
		else
		if(b=='5')
		{ 
			PORTB=0b101;
			_delay_ms(5);
		}
	 

	}
	}	
}

