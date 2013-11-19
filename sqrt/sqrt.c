/*
	my assumption...
	PORTC		PC3	PC2	PC1	PC0
				BLS	FLS	BBS	FBS
	in da bot originally....
	PORTC		PC3	PC2	PC1	PC0
				BBS	FBS	BLS	FLS
	OCR1B	ENABLE FOR RIGHT
	OCR1A	ENABLE FOR LEFT
	+++*


*/

#include <avr/io.h> 	//header file to include input output port

#include <util/delay.h>
//#define LED_ON PORTD|=0x80;
//#define LED_OFF PORTD&=0xBE;
//#define SWITCH_PRESSED !(PINB & 0x20)	
#define M_OUTPUT PORTD

#define RIGHT_MOTOR OCR1A
#define LEFT_MOTOR OCR1B
//#define rightdec 0
uint8_t calc(uint8_t w)
	{
	ADMUX&=0xF0;
	ADMUX|=w;
	ADCSRA|=_BV(ADEN);
	ADCSRA|= (1<<ADSC);
	while(!(ADCSRA & 0x10));//ADIF is set.will come out of loop 
	ADCSRA=(0<<ADEN);// added by me to switc off the adc , so as it doesnt consume power
	return ADCH;


	//	return 0x0;		//change here
	}


	
uint8_t MASTER_PWM,lineSensors;



void main_initialize()
{
		
		ADCSRA&=~(1<<ADIF);  		// to disable the adc interrupt flag....
		ADMUX |= (1 << REFS0); 		// set the voltage reference as AVcc 
		ADMUX|=_BV(ADLAR);			// left adjusted Result
		
		ADCSRA|=(_BV(ADPS0) | _BV(ADPS1) );  // set the ADC input frequency at 125 Khz(Prescaling of 8)
	
		OCR1B=0xff;   	// output compare register  for right motor  
		OCR1A=0xff;		// output compare register  for left motor
		


		/* TOP value is 00FFh for both OCR1A and OCR1B*/

		TCCR1A=0xA1;	// define type of PWM	

		/*Timer/Counter 1 Control  and pwm at pin OCR1A(PB1) */

		TCCR1B=0x04; //for start pwm
}

int main()
{
		uint8_t sensorReference0,sensorReference1,sensorReference2,sensorReference3,sensorReference4,Actual_input=0b0,lastInput=0b0;
		uint16_t count=0x0,cnt1=0,loopInOutFlag=0;
		uint8_t forValue=25,binOp=0,prevCnt=0,square=0,lastDir=0;
		DDRD=0b00001111; 
		DDRB=0x0f;
		PORTB=0xf0;
		DDRC=0x00;  

		main_initialize();
			
		PORTB=0x00;
		//PORTD=0x1010;			

		/* pwm at pin OCR1B(PB2) and clock freq. of timer(3 LSB 000 sys. clock) */ 
		/* maximum MASTER_PWM value can be 00FFh */
		
		MASTER_PWM=230;
		sensorReference0=128;
		sensorReference1=180;
		sensorReference2=128;
		sensorReference3=128;
		sensorReference4=180;
		/*
		LED_ON;
		while(SWITCH_PRESSED)
		{
			LED_ON;
		        _delay_ms(20);
		        LED_OFF;
		        _delay_ms(20);
		}
		//*/
		//LED_OFF;
		while(1)
		{	
			test:
			Actual_input=0x0;
			if(calc(0)>sensorReference0)		//check
				Actual_input|=(1<<PC0);
			if(calc(1)>sensorReference1)
				Actual_input|=(1<<PC1);
			if(calc(2)>sensorReference2)
				Actual_input|=(1<<PC2);
			if(calc(3)>sensorReference3)
				Actual_input|=(1<<PC3);
			if(calc(4)>sensorReference4)
				Actual_input|=(1<<PC4);
			
			Actual_input&=0b11111;  // make bits zero other than 4 LSB bits
			//PORTD=Actual_input;
			
			//goto test;
			
			lineSensors=(Actual_input)&0b11111;
			
			if(loopInOutFlag==0b10)		//check if entered in loop or not
				cnt1 += 1;
			if(cnt1 >= 0xFE)
			{
				count=count+1;
				cnt1=0;
			}
           		if(loopInOutFlag==0b11)
           		{		//check if exited in loop or not
				loopInOutFlag=0;
				
				PORTB|=binOp<<2;
			}
			
			if(lastInput==lineSensors)
				continue;
				
			
			
			switch(lineSensors)
			{
			
				case 0b00000100: // forward
				case 0b00001000:  
				case 0b00000010:  
				
				//case 0b00001110:  
				
				//case 0b00000110:  
				//case 0b00001100:  
				
				
		           		M_OUTPUT=0b00001010;			 //	output for motors
					RIGHT_MOTOR=(MASTER_PWM*80/100);   // enable for right
					LEFT_MOTOR=(MASTER_PWM*80/100);	 // enable for left
					lastDir==12;
					break; 
				//*
				case 0b00000110:  
					M_OUTPUT=0b1010;			 //	output for motors
					RIGHT_MOTOR=(MASTER_PWM*75/100);   // enable for right
					LEFT_MOTOR=(MASTER_PWM*80/100);	 // enable for left
					lastDir=3;
					break;
				
				case 0b00001100:  
					M_OUTPUT=0b1010;			 //	output for motors
					RIGHT_MOTOR=(MASTER_PWM*80/100);   // enable for right
					LEFT_MOTOR=(MASTER_PWM*75/100);	 // enable for left
					lastDir=9;
					break; 
				//*/
				case 0b00011111:
					if(loopInOutFlag==0)
						loopInOutFlag=0b10;
					else if(loopInOutFlag==0b10)
					{
						loopInOutFlag=0b11;
						if(prevCnt > (count==0) ? cnt1:count) binOp|=1<<square;
						square+=1;
						prevCnt=(count==0)?cnt1:count;
						count=0;
						cnt1=0;
					}
					//LED_ON;
		           		for (uint8_t i = 0; i < forValue; i += 1);
					//LED_OFF;
					M_OUTPUT=0b00001010;			 //	output for motors
					RIGHT_MOTOR=(MASTER_PWM*80/100);   // enable for right
					LEFT_MOTOR=(MASTER_PWM*80/100);	 // enable for left
					_delay_ms(forValue);
					lastDir=12;
		           		break;
				
				case 0b00011100:  	//slow left
				case 0b00011110:
					M_OUTPUT=0b0110;			 	//	output for motors
					RIGHT_MOTOR=(MASTER_PWM*80/100);   // enable for right
					LEFT_MOTOR=(MASTER_PWM*65/100);	 // enable for left
					lastDir=9;
					break;
				
				case 0b00011000:  	//sharp left
				case 0b00010000: 
					
					M_OUTPUT=0b0110;			 	//	output for motors
					RIGHT_MOTOR=(MASTER_PWM*70/100);   // enable for right
					LEFT_MOTOR=(MASTER_PWM*80/100);	 // enable for left
					lastDir=9;
					break;

				case 0b00000111:	//slow right
				case 0b00001111:
					M_OUTPUT=0b1001;			 	//	output for motors
					RIGHT_MOTOR=(MASTER_PWM*65/100);   // enable for right
					LEFT_MOTOR=(MASTER_PWM*80/100);	 // enable for left
					lastDir=3;
					break;
		           		
				case 0b00000011:	//sharp right
				case 0b00000001: 
					
					M_OUTPUT=0b1001;			 	//	output for motors
					RIGHT_MOTOR=(MASTER_PWM*80/100);   // enable for right
					LEFT_MOTOR=(MASTER_PWM*70/100);	 // enable for left
					lastDir=3;
					break;
				case 0b00001110:
					if(lastDir==3)
					{
						M_OUTPUT=0b1001;			 	//	output for motors
						RIGHT_MOTOR=(MASTER_PWM*80/100);   // enable for right
						LEFT_MOTOR=(MASTER_PWM*70/100);	 // enable for left
						lastDir=3;
						break;
					}
					if(lastDir==9)
					{
						M_OUTPUT=0b0110;			 	//	output for motors
						RIGHT_MOTOR=(MASTER_PWM*70/100);   // enable for right
						LEFT_MOTOR=(MASTER_PWM*80/100);	 // enable for left
						lastDir=9;
						break;
					}
					break;
				case 0b00000000:
				
					break;

			}
		lastInput=lineSensors;
		}
			return 0;
	}	
				
