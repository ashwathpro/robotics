#include <inttypes.h>
#include <avr/io.h>
#include<util/delay.h>
#include<avr/wdt.h>

#define TOP 100;
#define INPUT (((0b00111100)&PINC)>>2)
#define RM_PWM OCR1A
#define LM_PWM OCR1B
#define MOV_FORWORD PORTD=0b10100
#define MOV_BACK    PORTD=0b01010
#define TURN_RIGHT  PORTD=0b10010
#define TURN_LEFT   PORTD=0b01100
#define FLAP_OPEN   PORTB=0x20
#define FLAP_CLOSE  PORTB=0x10
#define HOLD_FLAP	PORTB=0
#define LED_ON PORTB&=0xFE
#define LED_OFF PORTB|=0x01
//#define RESET wdt_enable(1);while(1) {}
#define STOP		PORTD=0;PORTB=0;RM_PWM=0;LM_PWM=0

/* asumption
	{
combination	significant
	0		STOP
	1		MOV_FORWORD
	2		MOV_BACK
	3		TURN_LEFT
	4		TURN_RIGHT
	5		FLOP_OPEN
	6		FLOP_CLOSE
	7		HOLD_FLAP
	8		//
	9		//
	10		//
	11		20% PWM
	12		40% PWM
	13		60% PWM
	14		80% PWM
	15		100%PWM
				
	}
*/

void main_initi()
	{
		DDRC=0x00;   //input pin for encoder
		DDRD=0x1E;   //motor poutput pins
		DDRB=0xFF;   //flap+LED
		TCCR1A=0xA1; //PWM
		TCCR1B=0x04; //PWM
		RM_PWM=0;  //initi
		LM_PWM=0;  //initi
		STOP;LED_ON;
		wdt_enable(7);
	}
		

int main()

{
	main_initi();

	uint8_t input;
	uint16_t topPWM=TOP;
	
while(1)
 {
	input=INPUT;
	
	if(input==0)	    {		STOP;LED_ON;}
	
	else if(input==1)	{		MOV_FORWORD;LED_OFF;}
	
	else if(input==2)	{		MOV_BACK;LED_OFF;}
	
	else if(input==3)	{		TURN_LEFT;LED_OFF;}
	
	else if(input==4)	{		TURN_RIGHT;LED_OFF;}
	
	else if(input==5)	{		FLAP_OPEN;LED_OFF;}
	
	else if(input==6)	{		FLAP_CLOSE;LED_OFF;}
	
	else if(input==7)	{		HOLD_FLAP;LED_OFF;}
	
	else if(input==8)	{		;}
	
	else if(input==9)	{		;}
	
	else if(input==10)	{		;}
	
	else if(input==11)	{		RM_PWM=LM_PWM=(uint8_t)((topPWM*3)/10);LED_OFF;}
	
	else if(input==12)	{		LM_PWM=RM_PWM=(uint8_t)((topPWM*5)/10);LED_OFF;}
	
	else if(input==13)	{		LM_PWM=RM_PWM=(uint8_t)((topPWM*6)/10);LED_OFF;}
	
	else if(input==14)	{		LM_PWM=RM_PWM=(uint8_t)((topPWM*8)/10);LED_OFF;}
	
	else if(input==15)	{		RM_PWM=LM_PWM=TOP;LED_OFF;}
	else            	{		;}
	
	
 } //while(1)
return 0;
}
