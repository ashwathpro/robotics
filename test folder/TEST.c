#include <avr/io.h> 	//header file to include input output port

#include <util/delay.h>
int main()
{
		DDRD=0b00001111; 
		while(1)
			PORTD|=0b10100000;
}

