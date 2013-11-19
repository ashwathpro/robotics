#include <inttypes.h>
	#include <avr/io.h>
	#include <avr/sleep.h>
	#include <assert.h>	
	#include<util/delay.h>
	
	#define M_OUTPUT PORTB
	#define RIGHT_MOTOR_PWM OCR1A
	#define LEFT_MOTOR_PWM OCR1B
	#define MASTER_PWM 200



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
			uint8_t ADC_output,count,temp,PERCENTAGE_LEFT_PWM,PERCENTAGE_RIGHT_PWM,REVERSE_LEFT_RIGHT_MOTOR, LAST_INPUT;		
			DDRB=0xff;   //Check intital_setting_pwm() for description  ,, output port
			DDRD=0x15;  // will give de comparator output
			DDRC=0x00;
			PORTB=15;
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
		
	
	if(LAST_INPUT==temp)continue;
	
		
	switch(temp)
			{
		//normal line follower cases

		case 0b00100:
				
					REVERSE_LEFT_RIGHT_MOTOR=0b1010;
					PERCENTAGE_LEFT_PWM=100;
					PERCENTAGE_RIGHT_PWM=100;
				 
				break;
		
		case 0b00110:
				
					REVERSE_LEFT_RIGHT_MOTOR=0b1001;
					PERCENTAGE_LEFT_PWM=100;
					PERCENTAGE_RIGHT_PWM=30;
				
				break;
		case 0b01100:
				
					REVERSE_LEFT_RIGHT_MOTOR=0b0110;
					PERCENTAGE_LEFT_PWM=30;
					PERCENTAGE_RIGHT_PWM=100;
				 
				break;
		case 0b00010:
				
					REVERSE_LEFT_RIGHT_MOTOR=0b1001;
					PERCENTAGE_LEFT_PWM=100;
					PERCENTAGE_RIGHT_PWM=50;
				 
				break;
		case 0b01000:
					REVERSE_LEFT_RIGHT_MOTOR=0b0110;
					PERCENTAGE_LEFT_PWM=50;
					PERCENTAGE_RIGHT_PWM=100;
				break;
				
		case 0b00001:
					REVERSE_LEFT_RIGHT_MOTOR=0b1010;
					PERCENTAGE_LEFT_PWM=70;
					PERCENTAGE_RIGHT_PWM=10;
				break;
		case 0b10000:
				    REVERSE_LEFT_RIGHT_MOTOR=0b1010;
					PERCENTAGE_LEFT_PWM=10;
					PERCENTAGE_RIGHT_PWM=70;
				break;
		}
		
				
		LAST_INPUT=temp; //store last Actual_input
		
		M_OUTPUT=REVERSE_LEFT_RIGHT_MOTOR; //set the direction of motors
		
		// Setting OCR values of both motors
		if(REVERSE_LEFT_RIGHT_MOTOR==0)
			{
				OCR1A=(MASTER_PWM*PERCENTAGE_RIGHT_PWM/100);   // output compare flag for OC1A   for right motor
				OCR1B=(MASTER_PWM*PERCENTAGE_LEFT_PWM/100);	// output compare flag for OC1B   for left motor
			}
		else if(REVERSE_LEFT_RIGHT_MOTOR==1)
			{
				
				OCR1A=255-255*PERCENTAGE_RIGHT_PWM/100;   // output compare flag for OC1A   for right motor
				OCR1B=(MASTER_PWM*PERCENTAGE_LEFT_PWM/100);	// output compare flag for OC1B   for left motor
			}
		else if(REVERSE_LEFT_RIGHT_MOTOR==8)
			{
				
				OCR1A=(MASTER_PWM*PERCENTAGE_RIGHT_PWM/100);   // output compare flag for OC1A   for right motor
				OCR1B=255-255*PERCENTAGE_LEFT_PWM/100;	// output compare flag for OC1B   for left motor
			}


		
	}

	return 0;
}
