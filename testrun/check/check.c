#include <avr/io.h>



/* Main */
int main(void) {
while(1)
{
DDRD=0B110;
DDRC=1<<DDRD;
}
}
