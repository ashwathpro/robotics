#include <inttypes.h>
#include <avr/io.h>
#include <avr/sleep.h>
#include <assert.h>	
#include<util/delay.h>

// sensor Position
#define FRONT_LINE_SENSOR PC0
#define BACK_LINE_SENSOR  PC1
#define FRONT_OBST_SENSOR PC2
#define BACK_OBST_SENSOR  PC3
#define FOUR_SENSOR_MASK  0x0F

#define PER_PWM_WINDOW   80

#define RIGHT_MOTOR_PWM   OCR1A
#define LEFT_MOTOR_PWM    OCR1B
#define MOTOR_OUTPUT      PORTD
#define LED_ON PORTB|=0x01
#define LED_OFF PORTB&=0xFE




// motor outputs
#define MOTOR_OUTPUT_FRONT  0b1010
#define MOTOR_OUTPUT_BACK   0b0101
#define MOTOR_OUTPUT_CLOCKWISE       0b1001
#define MOTOR_OUTPUT_ANTICLOCKWISE   0b0110
     

#define LINE_SENSOR_THRESHHOLD_ADC 60
#define OBS_SENSOR_THRESHHOLD_ADC  80

#define DELAY_FOR_NINTY_DEGREE    56
#define DELAY_PRECISION            2

//######################################################
void initVariables( void );
uint8_t RandomNumGenerator(uint8_t min , uint8_t max);
inline void MakePWMrandom( void );
void RotateRobotAtCornor( void );
uint8_t getSensorValues( void );
inline uint8_t getADCValue(uint8_t selectADC);
//#######################################################
uint8_t temp1,temp2,makeRandomPWMflag=0,sensorInput ;
uint8_t g_TOP_PWM=160;
uint8_t temp;

int main()
{
	

	initVariables();	
		
	//if all sensors are not detect any objects then do random movement
	
	
while(1)
	{
		//sensorInput = PINC;
	sensorInput=getSensorValues();
	sensorInput=~sensorInput;
		//temp = (( sensorInput ^ 0x0C) & FOUR_SENSOR_MASK );
		temp = ( sensorInput  & FOUR_SENSOR_MASK );
		
	switch(temp)
		{
		 case 1<<FRONT_LINE_SENSOR : // only Front Sensor Detects
		 case (1<<FRONT_LINE_SENSOR | 1<<FRONT_OBST_SENSOR) :
		 case (1<<FRONT_LINE_SENSOR | 1<<FRONT_OBST_SENSOR | 1<<BACK_OBST_SENSOR) :
		 		makeRandomPWMflag = 0;
				MOTOR_OUTPUT  = MOTOR_OUTPUT_BACK;//move back of with random PWMs
				break;

		 case 1<<BACK_LINE_SENSOR  : // only Back Sensor Detects
		 case (1<<BACK_LINE_SENSOR | 1<<BACK_OBST_SENSOR) :
	     case (1<<BACK_LINE_SENSOR | 1<<FRONT_OBST_SENSOR | 1<<BACK_OBST_SENSOR) :
				makeRandomPWMflag = 0;
		 		MOTOR_OUTPUT  = MOTOR_OUTPUT_FRONT;//move forward with random PWMs
				break;

		 case 1<<FRONT_OBST_SENSOR  ://only front obstracle sensor detect
		 		makeRandomPWMflag=0;
		 		MOTOR_OUTPUT  = MOTOR_OUTPUT_FRONT;//move front with full PWM
				break;

		 case 1<<BACK_OBST_SENSOR :
		 		makeRandomPWMflag=0;//move back with full PWM
				MOTOR_OUTPUT  = MOTOR_OUTPUT_BACK;
				break;

		 case (1<<BACK_OBST_SENSOR) | (1<<FRONT_LINE_SENSOR ) :
		 		RotateRobotAtCornor();//rotate robot at corners
				MOTOR_OUTPUT  = MOTOR_OUTPUT_FRONT;
				makeRandomPWMflag = 0;
				break;
		 case (1<<FRONT_OBST_SENSOR) | (1<<BACK_LINE_SENSOR ) :
		 		RotateRobotAtCornor();//rotate robot at corners
				MOTOR_OUTPUT  = MOTOR_OUTPUT_BACK;
				makeRandomPWMflag = 0;
				break;

		 default ://random move
		 	if(!makeRandomPWMflag) 
			{
				LED_ON;
				MakePWMrandom();
				
			}
			makeRandomPWMflag = 1;
		}//end of switch
	
		if(!makeRandomPWMflag)
			{
				LED_OFF;
				// give maximum PWM to motors	
				RIGHT_MOTOR_PWM = g_TOP_PWM;
				LEFT_MOTOR_PWM	= g_TOP_PWM;
			}		
		
	}//end of while	return 0;
}// end of main()

void initVariables()
{

	//check for sensors
	DDRC = ~(FOUR_SENSOR_MASK);
	DDRD=0xFF;
	DDRB=0x07;


	//setting robot direction in forward direction
	MOTOR_OUTPUT   = MOTOR_OUTPUT_FRONT;
	// PWM starting
	TCCR0=0x04;
	/* TOP value is 00FFh for both OC1A and OC1B*/
	TCCR1A=0xA1;
		/*Timer/Counter 1 Control  and pwm at pin OC1A(PB1) */
	TCCR1B=0x04;
		/* pwm at pin OC1B(PB2) and clock freq. of timer(3 LSB 000 sys. clock) */

	
		
		   ADCSRA |= (0 << ADPS2) | (1 << ADPS1) | (1 << ADPS0); // Set ADC prescalar to 8 -     125KHz sample rate @ 1MHz 
			ADMUX |= (1 << REFS0);   // Set ADC reference to AVCC 
			ADMUX |= (1 << ADLAR); // Left adjust ADC result to allow easy 8 bit reading 
		
		/* setting of Top PWM */
		
		ADCSRA|= (1<<ADEN); //enable adc
		//g_TOP_PWM = getADCValue(5);
		ADCSRA=(0<<ADEN);// added by me to switc off the adc , so as it doesnt consume power

}

uint8_t RandomNumGenerator(uint8_t min , uint8_t max)
{
	uint8_t randumNum , clockNum = (TCNT0 & 0xFF) ;
	
	randumNum = ((clockNum - min)%(max-min+1)) + min;
	
	return randumNum;

}

inline void MakePWMrandom()
{
	//get a  randomNum
	uint8_t	randumNum = RandomNumGenerator( 1 , 2 * PER_PWM_WINDOW);
	if(randumNum <= PER_PWM_WINDOW)
		{
			LEFT_MOTOR_PWM  =  g_TOP_PWM;
			RIGHT_MOTOR_PWM =  ((100-randumNum)* g_TOP_PWM)/100;
		}
	if(randumNum > PER_PWM_WINDOW)
		{
			LEFT_MOTOR_PWM  =  ((100 - (randumNum - PER_PWM_WINDOW))* g_TOP_PWM)/100;
			RIGHT_MOTOR_PWM =  g_TOP_PWM;
		}
}

void RotateRobotAtCornor()
{
	// give maximum PWM to motors	
	RIGHT_MOTOR_PWM = g_TOP_PWM;
	LEFT_MOTOR_PWM	= g_TOP_PWM;
	//move robot either clock wise or anti clock wise
	if(RandomNumGenerator(0 ,1))
		//rotate clock wise
			MOTOR_OUTPUT = MOTOR_OUTPUT_CLOCKWISE;
	else
		//rotate Anti-clock wise
 		MOTOR_OUTPUT = MOTOR_OUTPUT_ANTICLOCKWISE;
	// creating delay for some time	
	for(temp1=0;temp1 < DELAY_FOR_NINTY_DEGREE;temp1++ )
				_delay_ms(DELAY_PRECISION);
	
	// switch off the motors
	RIGHT_MOTOR_PWM = LEFT_MOTOR_PWM = MOTOR_OUTPUT =0;
    
			
}

uint8_t getSensorValues()
{
	ADCSRA|= (1<<ADEN); //enable adc
	temp1=0;
	//Line sensors
		for(temp2=0;temp2<2;temp2++)
			if(getADCValue(temp2) > LINE_SENSOR_THRESHHOLD_ADC )
				temp1|=1<<temp2;
		
	//OBST sensors
		for(temp2=2;temp2<4;temp2++)
			if(getADCValue(temp2) > OBS_SENSOR_THRESHHOLD_ADC )
				temp1|=1<<temp2;
	
		ADCSRA=(0<<ADEN);// added by me to switc off the adc , so as it doesnt consume power
		return temp1;

}

inline uint8_t getADCValue(uint8_t selectADC)
{
	
	ADMUX&=0xF0;
	ADMUX|=selectADC;  // MUX values needed to be changed to use ADC0

	ADCSRA|= (1<<ADSC);    //start conversion
	while(!(ADCSRA & 0x10))
		{
		;//wait to finish convertion ADIF is set.will come out of loop 
		}			
	return ADCH;
}