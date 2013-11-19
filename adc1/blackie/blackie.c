	/*
	
0 line 
1 black (no line)

		*/
	
	#include <avr/io.h> //header file to include input output port

	#include <util/delay.h>

	/*port D as input PORT
			2	  1  	0
	      left        right 
	  for line follower (on line=,not on line=) */
	
//	#define  SENSOR_INPUTS (~PINC) 

	//#define  CHECK_SENSORS_INPUTS (PINC) 
	
	/* 
	At hardware level ( from comparator output ) we are getting 1 for white surface and 0 for black one, 
	but we have black line and we also want line be taken as 1 thus we use NOT(~) before inputs.
 
	*/
		
	#define  M_OUTPUT PORTD
		
	/*port B as output PORT*/
		
	uint8_t MASTER_PWM;
	/* We set MASTER_PWM inversely proportional to battery voltage,
	its also define the overall speed of line follower robot.
	*/
	//uint8_t PERCENTAGE_LEFT_PWM,PERCENTAGE_RIGHT_PWM;
	// shows percentage PWM of left and right motor

	//uint8_t PERCENTAGE_PWM_STEP_SIZE=10;
	/* PERCENTAGE_PWM_STEP_SIZE shows,steps size we are increasing our PWM of each motor*/
 
	//uint8_t M_OUTPUT=0;	
	

	uint8_t calc(uint8_t w)
	{
		//put adc code here...
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


	//	return 0x0;		//change here
	}	
	
int main()
{
			uint8_t Actual_input=0b00100,LAST_INPUT=0b101010,count;	
			
			DDRD=0b00001111; 
			DDRB=0xff;
			PORTB=0x0;
			PORTD=0b1111;

		//	DDRC=0b11100000;  

		OCR1A=0xff;   // output compare register  for right motor  
		OCR1B=0xff;	// output compare register  for left motor
		


		/* TOP value is 00FFh for both OCR1A and OCR1B*/

		TCCR1A=0xA1;	// define type of PWM	

		/*Timer/Counter 1 Control  and pwm at pin OCR1A(PB1) */

		TCCR1B=0x01; //for start pwm
		

		/* pwm at pin OCR1B(PB2) and clock freq. of timer(3 LSB 000 sys. clock) */ 
			/*maximum MASTER_PWM value can be 00FFh */

		MASTER_PWM=230;

		//PERCENTAGE_LEFT_PWM=100;

	//	PERCENTAGE_RIGHT_PWM=100;

				
			
line_following:
		
	//	Actual_input=SENSOR_INPUTS;		//check

		Actual_input=0x0;
		for(count=0;count<=4;count++)
		{
			if(calc(count)>130)		//check
			{
				Actual_input|=0x01<<count;
			}
		}

		Actual_input&=0b11111;


		//if same input from sensor then no need to calculate PWM just follow as last
		if(LAST_INPUT==Actual_input)goto line_following;
		
	
	
		
	//	Actual_input^=0xff;
	switch((Actual_input))
	{
	
		case 0b11011: // forward			done
		case 0b10111: 
		case 0b11101: 
		case 0b11001:  
		case 0b10011:
		case 0b10001:
		case 0b0:
		//case 0b00000000: 	
            M_OUTPUT=0b1010;			 //	output for motors
			OCR1A=(MASTER_PWM*80/100);   // enable for right
			OCR1B=(MASTER_PWM*80/100);	 // enable for left
			break; 


		case 0b11110: // sharp right		done
		case 0b11100: 
		
			M_OUTPUT=0b1001;
			OCR1A=(MASTER_PWM*30/100); 
			OCR1B=(MASTER_PWM*70/100);
			break;


		case 0b01111:// sharp left			done
		case 0b00111:

			M_OUTPUT=0b0110;
			OCR1A=(MASTER_PWM*70/100); 
			OCR1B=(MASTER_PWM*30/100);
			break;		
			
					
		case 0b11000:// sharp right with at slower speed   

		
		case 0b01100: 	//some casses just immediately after nodes
		
		
		case 0b00110:

		case 0b00100: 	//some casses at nodes
		
		case 0b01000: 	//bad casses
		case 0b00010: 
		
		case 0b10100: 	//very bad casses
		case 0b00101: 
		
		
		
		case 0b11111: 	//end or a node
		//case 0b00000: 	//end of a line
		
		
			M_OUTPUT=0b01001;
			OCR1A=(MASTER_PWM*40/100); 
			OCR1B=(MASTER_PWM*60/100);
			break;


		case 0b00011: // sharp left with at slower speed       
		                           
			M_OUTPUT=0b110;
			OCR1A=(MASTER_PWM*60/100); 
			OCR1B=(MASTER_PWM*40/100);
			break;
			
		
		case 0b10000:// this may occur during larger turns( >135 degrees) or it may be noise therefor we set our
		case 0b00001:			// output as same as previous condition.
		
			break;	
			
		
	}
		
				
		LAST_INPUT=Actual_input; //store last Actual_input
		
	
			goto line_following;//infinite loop
		
		return 0;
}
