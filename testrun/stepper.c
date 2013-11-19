#inckude<stdio.h>
#include<util/delay.h>
int main(void)
{
while(1)
{
	PORTB=0b00010000;
	_delay_ms(50);
	PORTB=0b00001000;
	_delay_ms(50);
	PORTB=0b00000100;
	_delay_ms(50);
	PORTB=0b00010010;
	_delay_ms(50);
}
}