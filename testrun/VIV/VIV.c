#include<avr/io.h>


int main(void)
{

DDRD=0b11111111;
while(1)
{
PORTD=0b11111111;
}
}
