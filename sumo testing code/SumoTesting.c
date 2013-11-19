#include <inttypes.h>
#include <avr/io.h>
#include<util/delay.h>
//###############################################
#define LED_ON PORTB&=0xFE
#define LED_OFF PORTB|=0x01
#define RIGHT_MOTOR_SPEED OCR1A
#define LEFT_MOTOR_SPEED  OCR1B
#define MOTOR_OUTPUT      PORTD

#define I0 PC0
#define I1 PC1
#define I2 PC2
#define I3 PC3
#define I4 PC4
#define POT PC5

#define RIGHT_TURN 8
#define LEFT_TURN 2
#define FORWARD 10
#define STOP 0

//################################################


void initi_IO(void);
void initi_ADC(void);
void initi_PWM(void);
int main(void);
uint8_t getDigitalValueOf(uint8_t channel);

//################################################


void initi_IO()	

	{
		DDRD=0x0F;  //configure output pins of motors
		DDRC=0x00;  //configure input pins for sensors
		DDRB=0x07;  //configure ouptput pin for LED , PWM and input pin for switch
		PORTB|=0x20; // activate internal pull up for switch 
	}
	
void initi_ADC()
	{
		ADCSRA |= (0 << ADPS2) | (1 << ADPS1) | (1 << ADPS0); // Set ADC prescalar to 8 //125KHz sample rate @ 1MHz 
		ADMUX |= (1 << REFS0);   // Set ADC reference to AVCC 
		ADMUX |= (1 << ADLAR);   // Left adjust ADC result to allow easy 8 bit reading
		ADCSRA|= (1<<ADEN);      //enable adc
	}
	
void initi_PWM()	
	{
		TCCR1A=0xA1; //setting for PWM
		TCCR1B=0x05; // seting for prescaler and start
	}
	
uint8_t getDigitalValueOf(uint8_t channel)
	{
		ADMUX&=0xF0;
		ADMUX|=channel;  // MUX values needed to be changed to use ADC0
		ADCSRA|= (1<<ADSC);    //start conversion
		
		while(!(ADCSRA & 0x10))
		{
		;//wait to finish convertion ADIF is set.will come out of loop 
		}	
		return ADCH; //return digital value 
	} 
//################################################


int main()

{

	initi_IO(); // configure the IO pins
	initi_ADC(); // configure the ADC
	initi_PWM(); // configure the PWM
	uint8_t sensorInput,maxSpeed, digitalVlaue, threshold;
	threshold = 150;	
	while(1)
	{
		
		// LED control
		
		if(PINB&0x20)
			LED_OFF;
		else
			LED_ON;

		//motor control
		maxSpeed = getDigitalValueOf(POT);  //SET the Speed of motors

		digitalVlaue = getDigitalValueOf(I0);	//get input form sensor1	
		sensorInput = (digitalVlaue > threshold)?(1<<I0):0;
		
		digitalVlaue = getDigitalValueOf(I1);	//get input form sensor2	
		sensorInput|=(digitalVlaue > threshold)?(1<<I1):0;
		
		
		
		switch (sensorInput)
		{
			case 0b00:
				{
					RIGHT_MOTOR_SPEED=0;	LEFT_MOTOR_SPEED=0;		MOTOR_OUTPUT=STOP;
					continue;
				}
			case 0b01:
				{
					RIGHT_MOTOR_SPEED=maxSpeed;		LEFT_MOTOR_SPEED=0;		MOTOR_OUTPUT=LEFT_TURN;
					continue;
				}			
			case 0b10:
				{
					RIGHT_MOTOR_SPEED=0;	LEFT_MOTOR_SPEED=maxSpeed;		MOTOR_OUTPUT=RIGHT_TURN;
					continue;
				}
			case 0b11:
				{
					RIGHT_MOTOR_SPEED=maxSpeed;		LEFT_MOTOR_SPEED=maxSpeed;		MOTOR_OUTPUT=FORWARD;
					continue;
				}
		}//end of switch
	} //end of while(1)
	
	
return 0;
}
