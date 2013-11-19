	/*
	The foloowing c code is for simple line folllower robot, having three sensors.
	The line is made of black color on white surface.   
		We wrote this c program for one workshop robot to drive in smooth fashion, thus lots of
	variable may vary if you changed the hardware.
		Dont stick on our coding style try experiments with your ideas also.
		GOOD LUCK
		*/
	
#include <avr/io.h> //header file to include input output port
//#include <avr\iom8.h>
#include <avr\interrupt.h>
//#include <util/delay.h>

 




	/*port C as input PORT
			2	  1  	0
	      left        right 
	  for line follower (on line=1,not on line=0;) */
	
	#define  SENSOR_INPUTS (PINC)
	
	
	/* 
	At hardware level ( from comparator output ) we are getting 1 for white surface and 0 for black one, 
	but we have black line and we also want line be taken as 1 thus we use NOT(~) before inputs.
 
	*/
		
	#define  M_OUTPUT PORTB
		
	/*port B as output PORT*/
		
	uint8_t MASTER_PWM;
	/* We set MASTER_PWM inversely proportional to battery voltage,
	its also define the overall speed of line follower robot.
	*/
	uint8_t PERCENTAGE_LEFT_PWM,PERCENTAGE_RIGHT_PWM;
	// shows percentage PWM of left and right motor

	uint8_t PERCENTAGE_PWM_STEP_SIZE=5;
	/* PERCENTAGE_PWM_STEP_SIZE shows,steps size we are increasing our PWM of each motor*/
 
	uint8_t REVERSE_LEFT_RIGHT_MOTOR=0;	
	/*
	REVERSE_LEFT_RIGHT_MOTOR define the direction of each motor ie they r moving forward or reverse manner.
	if REVERSE_LEFT_RIGHT_MOTOR=0...both  motor moving forward direction 
	if REVERSE_LEFT_RIGHT_MOTOR=1...Left motor moving forward direction ,Right motor moving reverse direction
	and if REVERSE_LEFT_RIGHT_MOTOR=8...Right motor moving forward direction ,Left motor moving reverse direction
	
	*/
	uint8_t Actual_input,LAST_INPUT=0;

/* INT0 Interrupt Service Routine (ISR) */
ISR(INT0_vect)
{
        /* check post sensor 1 */
		
		PORTB=0;
		OCR1A=0;OCR1B=0;
	
		//_delay_ms(1000);
		
}

ISR(INT1_vect)
{
        /* check post sensor 2 */
		
		PORTB=0;
		OCR1A=0;OCR1B=0;
	
		//_delay_ms(1000);
		
		
}

int main()
{
			//uint8_t Actual_input,Check_input,LAST_INPUT=0;	
			DDRC=0b11100000; 
			/* DDR=Data Direction register... its to define PD0(pin2),PD1(pin3),PD2(pin4) as input pin
			rest bits of DDRD can be 0 or 1 does not make any significance */
			DDRB=0b00001111;  
		  /* DDR=Data Direction register... its to define PB0(pin14),PB1(pin15),PB2(pin16),PB3(pin17) as out put pin
			rest bits of DDRD can be 0 or 1 does not make any significance */
			
		/*  PB1(OC1A) o/p for right motor   (connected to positive pin of right motor)
			PB2(OC1B) o/p for left motor	(connected to positive pin of left motor)
			PB0  o/p for right motor Ground (its change in program )	(connected to negative pin of right motor)
			PB3  o/p for left motor Ground (its change in program )	(connected to negative pin of leftt motor)
			*/
		OCR1A=0x00ff;   // output compare register  for right motor  
		OCR1B=0x00ff;	// output compare register  for left motor
		
		/* TOP value is 00FFh for both OC1A and OC1B*/
		TCCR1A=0xA1;	// define type of PWM	
		/*Timer/Counter 1 Control  and pwm at pin OC1A(PB1) */
		TCCR1B=0x01; //for start pwm
		
		/* pwm at pin OC1B(PB2) and clock freq. of timer(3 LSB 000 sys. clock) */ 
			/*maximum MASTER_PWM value can be 00FFh */
		MASTER_PWM=230;
		PERCENTAGE_LEFT_PWM=100;
		PERCENTAGE_RIGHT_PWM=100;
				
			
		// Global Enable INT0,INT1 interrupt
		GICR |= ( 1 << 1);
		GICR |= ( 1 << INT1);
  		// Low Level triggers interrupt
  		MCUCR |= ( 0 << ISC00);
  		MCUCR |= ( 0 << ISC01);
		MCUCR |= ( 0 << ISC10);
  		MCUCR |= ( 0 << ISC11);

        sei();       /* enable interrupts */
			

line_following:
		
		Actual_input=(0b11111)&SENSOR_INPUTS;	
	
		
		
		/*
		Because other bit may be high due to noise. Thus the actual input may differ from we get from harware.
		Therefore, above statement is very important.Here we are using only last three bits of SENSOR_INPUTS, thus
		we make other bits to zero.		
		*/
		if(OCR1A==0)
		{
			goto l;
		}
		//if same input from sensor then no need to calculate PWM just follow as last
		if(LAST_INPUT==Actual_input)goto line_following;
		
		
	l:

	switch(Actual_input)
	{
		// all the variables values we given here,depends on robot behavior on different conditions 
		// these values will differ robot to robot 
		//case 0b00000:
		case 0b01110:  
		case 0b00100: // forward
            REVERSE_LEFT_RIGHT_MOTOR=0;
			PERCENTAGE_LEFT_PWM=PERCENTAGE_PWM_STEP_SIZE*8;
			PERCENTAGE_RIGHT_PWM=PERCENTAGE_PWM_STEP_SIZE*8;
			break; 
		case 0b00001: // sharp right
		case 0b00011:
		case 0b00111:
			REVERSE_LEFT_RIGHT_MOTOR=1;
			PERCENTAGE_LEFT_PWM=PERCENTAGE_PWM_STEP_SIZE*7;
			PERCENTAGE_RIGHT_PWM=PERCENTAGE_PWM_STEP_SIZE*4;
			break;
		case 0b10000:// sharp left
		case 0b11000:
		case 0b11100:
			REVERSE_LEFT_RIGHT_MOTOR=8;
			PERCENTAGE_LEFT_PWM=PERCENTAGE_PWM_STEP_SIZE*4;
			PERCENTAGE_RIGHT_PWM=PERCENTAGE_PWM_STEP_SIZE*7;			
			break;				
		case 0b00010:// sharp right with at slower speed     
		case 0b00110:
			REVERSE_LEFT_RIGHT_MOTOR=1;
			PERCENTAGE_LEFT_PWM=PERCENTAGE_PWM_STEP_SIZE*8;
			PERCENTAGE_RIGHT_PWM=PERCENTAGE_PWM_STEP_SIZE*3;
			break;
		case 0b01000: // sharp left with at slower speed                                  
		case 0b01100:
			REVERSE_LEFT_RIGHT_MOTOR=8;
			PERCENTAGE_LEFT_PWM=PERCENTAGE_PWM_STEP_SIZE*3;
			PERCENTAGE_RIGHT_PWM=PERCENTAGE_PWM_STEP_SIZE*8;
			break;
			
		
		case 0b10001:// this may occur during larger turns( >135 degrees) or it may be noise therefor we set our
					// output as same as previous condition.
		
			break;		
	}
		
				
		LAST_INPUT=Actual_input; //store last Actual_input
		
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

			goto line_following;//infinite loop
		
		return 0;
}
