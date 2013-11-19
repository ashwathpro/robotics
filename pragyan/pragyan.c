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
#define LED_ON PORTB&=0xFE;
#define LED_OFF PORTB|=0x01;
#define SWITCH_PRESSED !(PINB & 0x20)	
#define RIGHT_MOTOR OCR1A
#define LEFT_MOTOR OCR1B
#define rightdec 0
uint8_t calc(uint8_t w)
	{
		//put adc code here...
	ADMUX&=0xF0;
	ADMUX|=w;
	ADCSRA|=_BV(ADEN);
	ADCSRA|= (1<<ADSC);
	while(!(ADCSRA & 0x10));//ADIF is set.will come out of loop 
	ADCSRA=(0<<ADEN);// added by me to switc off the adc , so as it doesnt consume power
	return ADCH;


	//	return 0x0;		//change here
	}

#define  M_OUTPUT PORTD
	
uint8_t MASTER_PWM,lineSensors,botSensors;



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
			uint8_t SWAP=0,lastDir=0b0,botDir=0,forward=0b1010,count=0x0,sensorReference0,sensorReference1,sensorReference2,sensorReference3,sensorReference4,Actual_input=0b0;
			uint16_t cnt=0,temp;
			//uint8_t 
			DDRD=0b00001111; 
			DDRB=0x0f;
			PORTB=0xf0;
			DDRC=0x00;  

		main_initialize();
		
		/*
		while(!(SWITCH_PRESSED))
		{
			//wait here
		}
		*/
				
			for(temp=0;temp<5;temp++)
				{
				_delay_ms(20);
				}
				PORTB=0x00;
				//PORTD=0x1010;			

		/* pwm at pin OCR1B(PB2) and clock freq. of timer(3 LSB 000 sys. clock) */ 
		/* maximum MASTER_PWM value can be 00FFh */

		MASTER_PWM=75;
		sensorReference0=128;
		sensorReference1=180;
		sensorReference2=128;
		sensorReference3=128;
		sensorReference4=180;
		
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
			
			//my assumption
			lineSensors=(Actual_input)&0b11111;
			//botSensors=(Actual_input>>2)&0b11;
			/*	
			SWAP=botSensors;
			botSensors=lineSensors;
			lineSensors=SWAP;
			//*/
			
			//botSensors=0b11&~(botSensors);

			//botSensors=0b11&~(botSensors);

			
			switch(lineSensors)
			{
			
				case 0b00000100: // forward			done
				case 0b00001000:  
				case 0b00000010:  
				
				case 0b00001110:  
				
				case 0b00000110:  
				case 0b00001100:  
				
				//case 0b00011110:
				//case 0b00001111:
				
				
				//case 0b00011111:
				
		           		M_OUTPUT=0b1010;			 //	output for motors
					RIGHT_MOTOR=(MASTER_PWM*80/100)-rightdec;   // enable for right
					LEFT_MOTOR=(MASTER_PWM*80/100);	 // enable for left
					//lastDir=0;
					break; 

				/*case 0b00011111:
				
		           		M_OUTPUT=0b1010;			 //	output for motors
					RIGHT_MOTOR=(MASTER_PWM*80/100)-rightdec;   // enable for right
					LEFT_MOTOR=(MASTER_PWM*80/100);	 // enable for left
					_delay_ms(50);
		           		break;
				
				case 0b00011110:
				
					M_OUTPUT=0b1110;			 //	output for motors
					RIGHT_MOTOR=(MASTER_PWM*30/100)-rightdec;   // enable for right
					LEFT_MOTOR=(MASTER_PWM*30/100);	 // enable for left
					//_delay_ms(1);
		           		break; 

				case 0b00001111:
				
		           		M_OUTPUT=0b1011;			 //	output for motors
					RIGHT_MOTOR=(MASTER_PWM*30/100)-rightdec;   // enable for right
					LEFT_MOTOR=(MASTER_PWM*30/100);	 // enable for left
					//_delay_ms(1);
		           		break; 
		           	*/

				case 0b00011100:  	//slow left
				case 0b00011110:
				//case 0b00011000:  
				//case 0b00010000: 
					
					M_OUTPUT=0b1010;			 	//	output for motors
					RIGHT_MOTOR=(MASTER_PWM*80/100)-rightdec;   // enable for right
					LEFT_MOTOR=(MASTER_PWM*0/100);	 // enable for left
					//_delay_ms(5);
		           		break;
				
				case 0b00011000:  	//sharp left
				case 0b00010000: 
					
					M_OUTPUT=0b0110;			 	//	output for motors
					RIGHT_MOTOR=(MASTER_PWM*50/100)-rightdec;   // enable for right
					LEFT_MOTOR=(MASTER_PWM*50/100);	 // enable for left
					break;


				case 0b00000111:	//slow right
				case 0b00001111:
				//case 0b00000011:
				//case 0b00000001: 
					
					M_OUTPUT=0b1010;			 	//	output for motors
					RIGHT_MOTOR=(MASTER_PWM*80/100)-rightdec;   // enable for right
					LEFT_MOTOR=(MASTER_PWM*0/100);	 // enable for left
					//_delay_ms(5);
		           		break;
		           		
				case 0b00000011:	//sharp right
				case 0b00000001: 
					
					M_OUTPUT=0b1001;			 	//	output for motors
					RIGHT_MOTOR=(MASTER_PWM*50/100)-rightdec;   // enable for right
					LEFT_MOTOR=(MASTER_PWM*50/100);	 // enable for left
					break;

			}
		
		}
			return 0;
	}	
				/*
				case 0b00011111:
				
					M_OUTPUT=0b1010;			 //	output for motors
					OCR1A=(MASTER_PWM*60/100);   // enable for right
					OCR1B=(MASTER_PWM*70/100);	 // enable for left
					//lastDir=3;
					break;
				case 0b00000001: // sharp right		done
				case 0b00000011:
				
				M_OUTPUT=0b1001;
					OCR1A=(MASTER_PWM*70/100); 
					OCR1B=(MASTER_PWM*50/100);
					//lastDir=3;
					break;

				case 0b00010000:// sharp left			done
				case 0b00011000:
				
				M_OUTPUT=0b0110;
					OCR1A=(MASTER_PWM*50/100); 
					OCR1B=(MASTER_PWM*70/100);
					//lastDir=9;
					break;		


				case 0b00011100:// sharp left slow			done
			

					M_OUTPUT=0b0110;
					OCR1A=(MASTER_PWM*40/100); 
					OCR1B=(MASTER_PWM*70/100);
					//lastDir=9;
					break;		
						//*
						


			
				case 0b00000111:// sharp right with at slower speed   
				
				
				case 0b00010011: 	//some casses just immediately after nodes
				
				
				case 0b00011001: 

				case 0b00011011: 	//some casses at nodes
				
				case 0b00010111: 	//bad casses
				case 0b00011101: 
				
				case 0b00010101: 
				
				case 0b00001011: 	//very bad casses
				case 0b00011010: 
				
				case 0b00010010:
				case 0b00001001:
				
				 
				case 0b00010001: 
				
				
				
				
				
					M_OUTPUT=0b01001;
					OCR1A=(MASTER_PWM*70/100); 
					OCR1B=(MASTER_PWM*70/100);
					//lastDir=3;
					break;
				case 0b00001111:
				case 0b00011110:
				break;
				
			}				
				*/	
/*
			if(~(lineSensors) & 0b01)
			{
				botDir=6;
				LED_ON;
				forward=0b0000;
				_delay_ms(10);
				forward=0b0101;
				M_OUTPUT=forward;
				OCR1A=(MASTER_PWM*70/100); 
				OCR1B=(MASTER_PWM*70/100);
				_delay_ms(5);
				
				continue;
			}
			else if(~(lineSensors) & 0b10)
			{
				botDir=1;
				LED_ON;
				forward=0b0000;
				_delay_ms(10);
				forward=0b1010;
				M_OUTPUT=forward;
				OCR1A=(MASTER_PWM*70/100); 
				OCR1B=(MASTER_PWM*70/100);
				_delay_ms(5);
				
				continue;
			}
			
			if((botSensors&0b01) && (lineSensors&0b11))
			{
				botDir=1;
				LED_ON;
				forward=0b00001010;
				M_OUTPUT=forward;
				OCR1A=(MASTER_PWM*90/100); 
				OCR1B=(MASTER_PWM*90/100);
				//LED_OFF;
				continue;
			}
			else if((botSensors&0b10) && (lineSensors&0b11))
			{
				botDir=6;
				LED_ON;
				forward=0b00000101;
				M_OUTPUT=forward;
				OCR1A=(MASTER_PWM*90/100); 
				OCR1B=(MASTER_PWM*90/100);
				//LED_OFF;
				continue;
			}

			if(lineSensors==0b11 && botSensors==0b00)
			{
				LED_OFF;
				
				if(cnt<100)
				{
				M_OUTPUT=forward;				
				OCR1A=(MASTER_PWM*55/100);	 // enable for left
				OCR1B=(MASTER_PWM*20/100);
				_delay_ms(3);
				}
				else
				{
				M_OUTPUT=forward;
				OCR1A=(MASTER_PWM*20/100);
				OCR1B=(MASTER_PWM*55/100);
				_delay_ms(3);
				}
				if(cnt>=200)
					cnt=0;
				botDir=3;
				cnt=cnt+1;

				continue;
			}
	
		}	
	return 0;
}

*/
