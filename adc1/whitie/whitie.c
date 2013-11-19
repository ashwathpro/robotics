#include <inttypes.h>
	#include <avr/io.h>
	#include <avr/sleep.h>
	#include <assert.h>	
	#include<util/delay.h>
	
	#define M_OUTPUT PORTD
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
			uint8_t ADC_output,count,temp;//,perLeftPWM,perRightPWM,motorDirection;		
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
		for(count=0;count<=4;count++)
		{	
			ADC_output=calc(count);
			if(ADC_output>=130)
			{
				temp|=0x01<<count;
			}
			else;
		}
	
				
		

		temp=~temp&31;	//only LSB 6 bits need to be considered	
		
		
	switch(temp)
			{
		//normal line follower cases
		
		case 0b00100:
				
					M_OUTPUT=0b1010;	//leftPWM=oc1a
					OCR1A=(MASTER_PWM*100/100);   // enable for right
					OCR1B=(MASTER_PWM*100/100);	 // enable for left
			
				break;
		
		case 0b00110:
				
					M_OUTPUT=0b1001;
		OCR1A=(MASTER_PWM*100/100);   // enable for right
			OCR1B=(MASTER_PWM*30/100);	 // enable for left
					
				break;
		case 0b01100:
				
					M_OUTPUT=0b0110;
					OCR1A=(MASTER_PWM*30/100);   // enable for right
					OCR1B=(MASTER_PWM*100/100);	 // enable for left
			
				break;
		case 0b00010:
				
					M_OUTPUT=0b1001;
					OCR1A=(MASTER_PWM*100/100);   // enable for right
					OCR1B=(MASTER_PWM*50/100);	 // enable for left
			 
				break;
		case 0b01000:
					M_OUTPUT=0b0110;
						OCR1A=(MASTER_PWM*50/100);   // enable for right
					OCR1B=(MASTER_PWM*100/100);	 // enable for left
			
				break;
				
		case 0b00001:
					M_OUTPUT=0b1010;
				OCR1A=(MASTER_PWM*70/100);   // enable for right
					OCR1B=(MASTER_PWM*10/100);	 // enable for left
			
				break;
		case 0b10000:
				    M_OUTPUT=0b1010;
					OCR1A=(MASTER_PWM*10/100);   // enable for right
					OCR1B=(MASTER_PWM*70/100);	 // enable for left
			
				break;
		
		
		//near cross line follower cases	
		case 0b00101:
		case 0b01001:
		case 0b00011:
		case 0b01011:
		case 0b01101:
					M_OUTPUT=0b1001;
						OCR1A=(MASTER_PWM*100/100);   // enable for right
					OCR1B=(MASTER_PWM*10/100);	 // enable for left
			
					break;
				
		case 0b10100:
		case 0b10010:
		case 0b11000:
		case 0b11010:
		case 0b10110:
					M_OUTPUT=0b0110;
						OCR1A=(MASTER_PWM*10/100);   // enable for right
					OCR1B=(MASTER_PWM*100/100);	 // enable for left
			
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
		M_OUTPUT=0b0110;
					OCR1A=(MASTER_PWM*20/100);   // enable for right
					OCR1B=(MASTER_PWM*90/100);	 // enable for left
			
		_delay_ms(100);
	}
		return 0;
}
}
