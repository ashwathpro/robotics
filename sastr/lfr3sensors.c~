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
#include <avr/interrupt.h>
//#include <util/delay.h>

 
#define LED_ON PORTB&=0xFE;
#define LED_OFF PORTB|=0x01;




	/*port C as input PORT
			2	  1  	0
	      left        right 
	  for line follower (on line=1,not on line=0;) */
	
	//#define  SENSOR_INPUTS (PINC)
	
	
	/* 
	At hardware level ( from comparator output ) we are getting 1 for white surface and 0 for black one, 
	but we have black line and we also want line be taken as 1 thus we use NOT(~) before inputs.
 
	*/
	//	l   r
	//	+ - - +
	#define  M_OUTPUT PORTD
		
	/*port D as output PORT*/
	
	/*	PORTD ==== L M R M
			   + - - +
	*/
	
	#define FORWARD 9	//CHECK ALL THIS
	#define LEFT 5
	#define RIGHT 10
	//#define SHARPLEFT 
	//#define SHARPRIGHT
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
	uint8_t Actual_input,LAST_INPUT=0,SENSOR_INPUTS,sensorReference0,sensorReference1,sensorReference2;

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


int main()
{
			//uint8_t Actual_input,Check_input,LAST_INPUT=0;	
			//DDRC=0b11000000; 
			/* DDR=Data Direction register... its to define PD0(pin2),PD1(pin3),PD2(pin4) as input pin
			rest bits of DDRD can be 0 or 1 does not make any significance */
			DDRD=0b00001111;  
			DDRB=0x0f;
			PORTB=0xf0;
			DDRC=0x00;  

		  /* DDR=Data Direction register... its to define PB0(pin14),PB1(pin15),PB2(pin16),PB3(pin17) as out put pin
			rest bits of DDRD can be 0 or 1 does not make any significance */
			
		/*  PB1(OC1A) o/p for right motor   (connected to positive pin of right motor)
			PB2(OC1B) o/p for left motor	(connected to positive pin of left motor)
			PB0  o/p for right motor Ground (its change in program )	(connected to negative pin of right motor)
			PB3  o/p for left motor Ground (its change in program )	(connected to negative pin of leftt motor)
			*/
			
		ADCSRA&=~(1<<ADIF);  		// to disable the adc interrupt flag....
		ADMUX |= (1 << REFS0); 		// set the voltage reference as AVcc 
		ADMUX|=_BV(ADLAR);			// left adjusted Result
		
		ADCSRA|=(_BV(ADPS0) | _BV(ADPS1) );  // set the ADC input frequency at 125 Khz(Prescaling of 8)
	
		OCR1A=0x00ff;   // output compare register  for right motor  
		OCR1B=0x00ff;	// output compare register  for left motor
		
		/* TOP value is 00FFh for both OC1A and OC1B*/
		TCCR1A=0xA1;	// define type of PWM	
		/*Timer/Counter 1 Control  and pwm at pin OC1A(PB1) */
		TCCR1B=0x01; //for start pwm
		
		/* pwm at pin OC1B(PB2) and clock freq. of timer(3 LSB 000 sys. clock) */ 
			/*maximum MASTER_PWM value can be 00FFh */
		//MASTER_PWM=230;
		PERCENTAGE_LEFT_PWM=100;
		PERCENTAGE_RIGHT_PWM=100;
				
			
		/*/ Global Enable INT0,INT1 interrupt
		GICR |= ( 1 << 1);
		GICR |= ( 1 << INT1);
  		// Low Level triggers interrupt
  		MCUCR |= ( 0 << ISC00);
  		MCUCR |= ( 0 << ISC01);
		MCUCR |= ( 0 << ISC10);
  		MCUCR |= ( 0 << ISC11);

        sei();       /* enable interrupts */
		
			

line_following:
		
		
		
		MASTER_PWM=75;
		sensorReference0=100;
		sensorReference1=100;
		sensorReference2=100;
		//sensorReference3=128;
		//sensorReference4=128;
		
		Actual_input=0x0;
		if(calc(0)>sensorReference0)		//check
			Actual_input|=(1<<PC0);
		if(calc(1)>sensorReference1)
			Actual_input|=(1<<PC1);
		if(calc(2)>sensorReference2)
			Actual_input|=(1<<PC2);
			
		//MASTER_PWM=calc(5);
		/*
		if(calc(3)>sensorReference3)
			Actual_input|=(1<<PC3);
		if(calc(4)>sensorReference4)
			Actual_input|=(1<<PC4);
		*/
		
		
		Actual_input = (~Actual_input) & 0b111;  // make bits zero other than 4 LSB bits
		//*
		//while(1)
			//PORTD=Actual_input;
			//goto line_following;
		//*/
		//Actual_input=(0b111)&SENSOR_INPUTS;	
	
		if(LAST_INPUT==Actual_input)goto line_following;
		
		
		/*
		Because other bit may be high due to noise. Thus the actual input may differ from we get from harware.
		Therefore, above statement is very important.Here we are using only last three bits of SENSOR_INPUTS, thus
		we make other bits to zero.		
		*/
		/*
		if(OCR1A==0)
		{
			goto l;
		}
		//if same input from sensor then no need to calculate PWM just follow as last
		if(LAST_INPUT==Actual_input)goto line_following;
		*/
		
		
	
	switch(Actual_input)
	{
		// all the variables values we given here,depends on robot behavior on different conditions 
		// these values will differ robot to robot 
		//case 0b00000:
		//case 0b111:  
		case 0b010: // forward
            		M_OUTPUT=FORWARD;	//	output for motors
			OCR1A=(MASTER_PWM*80/100);   // enable for right
			OCR1B=(MASTER_PWM*80/100);	 // enable for left
			LED_OFF;
            		break; 
		case 0b001: // sharp right 
		//case 0b011:
		//case 0b111:
			LED_OFF;
			M_OUTPUT=LEFT;				
			OCR1A=(MASTER_PWM*70/100);	 // enable for left
			OCR1B=(MASTER_PWM*50/100);
			
			break;
		case 0b100:// sharp left
		//case 0b11000:
		//case 0b11100:
			M_OUTPUT=RIGHT;
			OCR1A=(MASTER_PWM*50/100); 
			OCR1B=(MASTER_PWM*70/100);
			LED_OFF;
			break;				
		//case 0b010: 
		case 0b011: 	// sharp right with at slower speed    
			M_OUTPUT=FORWARD;	//	output for motors
			OCR1A=(MASTER_PWM*60/100);   // enable for right
			OCR1B=(MASTER_PWM*80/100);	 // enable for left
			LED_OFF;
			break;
		//case 0b01000:                                   
		case 0b110:	// sharp left with at slower speed
			M_OUTPUT=FORWARD;	//	output for motors
			OCR1A=(MASTER_PWM*80/100);   // enable for right
			OCR1B=(MASTER_PWM*60/100);	 // enable for left
			LED_ON;
			break;
			
		
		case 0b101:		// arbit case
					// output as same as previous condition.
		case 0b111:		// for breaks and intersection
		case 0b000:
			LED_OFF;
			break;		
	}
		
		
		LAST_INPUT=Actual_input; //store last Actual_input
		
		
			goto line_following;//infinite loop
		
		return 0;
}
