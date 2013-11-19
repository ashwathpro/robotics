#include <inttypes.h>
	#include <avr/io.h>
	#include <avr/sleep.h>
	#include <assert.h>	
	#include<util/delay.h>
	
	#define M_OUTPUT PORTD
	#define RIGHT_MOTOR_PWM OCR1A
	#define LEFT_MOTOR_PWM OCR1B
	#define TOP_PWM 200



uint8_t calc(uint8_t w){
	ADCSRA&=~(1<<ADIF);
	ADMUX=w;
	ADMUX|=_BV(ADLAR);
	//start conversion
	ADCSRA|=_BV(ADEN);
	ADCSRA|=(_BV(ADPS2) | _BV(ADPS1) );
	ADCSRA|= (1<<ADSC);
	while(!(ADCSRA & 0x10));//ADIF is set.will come out of loop 
	ADCSRA=(0<<ADEN);// added by me to switc off the adc , so as it doesnt consume power
	return ADCH;
	}	


int main()
{
			uint8_t ADC_output,count,temp,perLeftPWM,perRightPWM,motorDirection;		
			DDRB=0xff;   //Check intital_setting_pwm() for description  ,, output port
			DDRD=0x07;  // will give de comparator output
			DDRC=0x00;
			PORTB=7;
			PORTD=0;
			
		TCCR0=0x04;
		RIGHT_MOTOR_PWM=200;   // output compare flag for OC1A   for right motor  
		LEFT_MOTOR_PWM=200;	// output compare flag for OC1B   for left motor
		TCCR1A=0xA1;
		TCCR1B=0x01;
		
while(1)
	{
		temp=0x00;
		for(count=0;count<=5;count++)
		{	
			ADC_output=calc(count);
			if(ADC_output>=120)
			{
				temp|=0x01<<count;
			}
			else;
		}
	
				
		

		temp&=31;	//only LSB 6 bits need to be considered	
		
		
	switch(temp)
			{
		//normal line follower cases
		
		case 0b00100:
				
					motorDirection=0b1010;
					perLeftPWM=100;
					perRightPWM=100;
				 
				break;
		
		case 0b00110:
				
					motorDirection=0b1001;
					perLeftPWM=100;
					perRightPWM=30;
				
				break;
		case 0b01100:
				
					motorDirection=0b0110;
					perLeftPWM=30;
					perRightPWM=100;
				 
				break;
		case 0b00010:
				
					motorDirection=0b1001;
					perLeftPWM=100;
					perRightPWM=50;
				 
				break;
		case 0b01000:
					motorDirection=0b0110;
					perLeftPWM=50;
					perRightPWM=100;
				break;
				
		case 0b00001:
					motorDirection=0b1010;
					perLeftPWM=70;
					perRightPWM=10;
				break;
		case 0b10000:
				    motorDirection=0b1010;
					perLeftPWM=10;
					perRightPWM=70;
				break;
		
		
		//near cross line follower cases	
		case 0b00101:
		case 0b01001:
		case 0b00011:
		case 0b01011:
		case 0b01101:
					motorDirection=0b1001;
					perLeftPWM=100;
					perRightPWM=10;
					break;
				
		case 0b10100:
		case 0b10010:
		case 0b11000:
		case 0b11010:
		case 0b10110:
					motorDirection=0b0110;
					perLeftPWM=10;
					perRightPWM=100;
				break;
		
		// abnormal cases
		// in these cases previous conditions will be concidered
		case 0b00000:
		case 0b01010:
		case 0b10001:
		case 0b10101:
					break;
		
		
		
		// cross detected
		// good cases
		
		case 0b11111:
		case 0b11101:
		case 0b10111:
		case 0b11011:
		case 0b11110:
		case 0b01111:
		
		
		
		
		// bad cases
		
		case 0b11100:
		case 0b00111:
		case 0b01110:
		
		case 0b11001:
		case 0b10011:
		motorDirection=0b0110;
					perLeftPWM=20;
					perRightPWM=90;
		_delay_ms(100);
	}
		return 0;
}
