#include<stdio.h>
#include<util/delay.h>
#include<avr/io.h>

void main()
{
	uint8_t a=1;

	uint8_t b=1;

	
	for(;a>0;)
	{
		b=1;
	
     	for(b=1;b<50;b++)
		{
			PORTB=0b01100000;
			_delay_ms(10);
			PORTB=0b10010000;
			_delay_ms(10);
			PORTB=0b00001001;
			_delay_ms(10);
			PORTB=0b00000110;
			_delay_ms(10);
		}
		
		b=1;
		for(b=1;b<50;b++)
		{
			PORTB=0b01000100;
			_delay_ms(10);
			PORTB=0b10001000;
			_delay_ms(10);
			PORTB=0b00010001;
			_delay_ms(10);
			PORTB=0b00100010;
			_delay_ms(10);
		}
	}
}
