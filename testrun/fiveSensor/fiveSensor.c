/*
    File:       main.c
    Version:    1.1
    Date:       May. 23, 2006
    
    FailureBot 5 Version 1. Schematics and details at www.micahcarrick.com
    
    ****************************************************************************
    Copyright (C) 2006 Micah Carrick   <email@micahcarrick.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
    ****************************************************************************
*/

#define F_CPU 8000000UL         /* 8 MHz crystal clock */

/* defines for line sensors */
#define LED_PORT PORTD
#define LED_DDR DDRD
#define LED1 PD3                /* left-most sensor */
#define LED2 PD4
#define LED3 PD5
#define LED4 PD6
#define LED5 PD7                /* right-most sensor */

/* defines for motor control */
#define MOTOR_PORT PORTB
#define MOTOR_DDR DDRB
#define M1PULSE PB0
#define M1DIR PB1
#define M2PULSE PB2
#define M2DIR PB3
#define MOTOR_ENABLE PB4

#define MOTOR_FORWARD 0
#define MOTOR_REVERSE 1

#define GO_LEFT 0
#define GO_HARD_LEFT 1
#define GO_FORWARD 2
#define GO_HARD_RIGHT 3
#define GO_RIGHT 4
#define GO_BRAKE 5

/* defines for switch */
#define SW_PORT PORTD
#define SW_BIT PD2
#define SW_DELAY 250

#include <avr/io.h> 
#include <avr/interrupt.h>   
#include <util/delay.h>

/* function prototypes */
void init_io();
void init_adc();
void enable_motors();
void disable_motors();
void set_motor_direction(uint8_t motor, uint8_t direction);
void steer_robot(uint8_t direction);
uint8_t get_line_sensor_value(uint8_t led_index);
void calibrate_line_sensors(uint8_t *midpoint);
void delay_ms(uint16_t ms);

/* INT0 Interrupt Service Routine (ISR) */
ISR(INT0_vect)
{
        /* toggle motor enable and delay for de-bounce */
        MOTOR_PORT ^= _BV(MOTOR_ENABLE);
        delay_ms(SW_DELAY);
        
        /* clear pending interrupts */
        GIFR |= _BV (INTF0);
}

int
main (void)
{
        
        uint8_t adc_value;                      /* ADC value */ 
        uint8_t midpoint[5] = { 0,0,0,0,0 };    /* sensor trip points */
        uint8_t last_direction = GO_FORWARD;    /* last direction steered */
        uint8_t i;                              /* loop counter */
        uint8_t sensor_bits;                    /* sensor bit values */
        
        /* initializations */
        init_io();        
        init_adc();
        
        /* calibration */
        enable_motors();    
        steer_robot(GO_HARD_LEFT);
        calibrate_line_sensors(midpoint); 
        disable_motors();        

        while (1)                       
        {
                /* clear previous value */
                sensor_bits = 0;
                
                /* 
                create bit patter for sensors where a 1 represents the line
                under the sensor and a 0 represents no line
                */
                for (i=0; i<5; i++)
                {
                        sensor_bits = sensor_bits << 1;
                        adc_value = get_line_sensor_value(i);
                        if (adc_value >= midpoint[i]) 
                        {
                                sensor_bits |= _BV(0);  
                        }
                        else
                        {
                                sensor_bits &= ~_BV(0);
                        }
                }

                /* hexidecimal representations for various bit patterns of lines */  
                            
                if (sensor_bits == 0x04 || sensor_bits == 0x0E || sensor_bits == 0x1F)
                {
                        steer_robot(GO_FORWARD);
                        last_direction = GO_FORWARD;
                }
                else if (sensor_bits == 0x0C || sensor_bits == 0x08)
                {
                        steer_robot(GO_LEFT);
                        last_direction = GO_LEFT;
                }
                else if (sensor_bits == 0x02 || sensor_bits == 0x06)
                {
                        steer_robot(GO_RIGHT);
                        last_direction = GO_RIGHT;
                }
                else if (sensor_bits == 0x10 || sensor_bits == 0x18 || sensor_bits == 0x1C)
                {
                        steer_robot(GO_HARD_LEFT);
                        last_direction = GO_HARD_LEFT;
                }
                else if (sensor_bits == 0x01 || sensor_bits == 0x03 || sensor_bits == 0x07)
                {
                        steer_robot(GO_HARD_RIGHT);
                        last_direction = GO_HARD_RIGHT;
                }
                else
                {
                        /*
                        If the robot does not see a line at all, it's possible that
                        the line is between sensors. Continue going the direction
                        previously determined until the line is found.
                        */
                        steer_robot(last_direction);
                }   
        }
        return (0);
}

void 
init_io()
{
        /* setup input/outpus */
        LED_DDR = _BV(LED1) | _BV(LED2) | _BV(LED3) | _BV(LED4) | _BV(LED5); 
        MOTOR_DDR = _BV(M1PULSE) | _BV(M1DIR) | _BV(M2PULSE) | _BV(M2DIR) | _BV(MOTOR_ENABLE);
        
        /* turn on internal pull-up resistor for the switch */
        SW_PORT |= _BV(SW_BIT);
        
        /* set INT0 interrupt enable bit */
        GICR |= _BV(INT0);
        
        /* enable interrupts */
        sei();
}

void 
init_adc(void)
{
        ADMUX = 0 | _BV(ADLAR); // channel 0, left-justified result
        ADCSRA = _BV(ADEN) | _BV(ADPS2);
}

void
enable_motors()
{
        MOTOR_PORT |= _BV(MOTOR_ENABLE);        /* set ENABLE pin */
}

void
disable_motors()
{
        MOTOR_PORT &= ~_BV(MOTOR_ENABLE);       /* clear ENABLE pin */
}

void 
set_motor_direction(uint8_t motor, uint8_t direction)
{
        if (direction == MOTOR_REVERSE)
        {
                MOTOR_PORT |= _BV(motor);       /* set DIR pin */
        }
        else
        {
                MOTOR_PORT &= ~_BV(motor);      /* clear DIR pin */ 
        }
}

void steer_robot(uint8_t direction)
{
        /* 
        The gear motors have such a high reduction ration that I actually don't
        need to use PWM at this point in time. Therefore, this routine will simply
        set or clear the pulse pins depending on the desired direction of the motor.
        */
        
        switch (direction)
        {
                case GO_LEFT:
                        set_motor_direction(M1DIR, MOTOR_FORWARD);
                        set_motor_direction(M2DIR, MOTOR_FORWARD);
        
                        MOTOR_PORT &= ~_BV(M1PULSE);        /* clear M1PULSE pin */
                        MOTOR_PORT |= _BV(M2PULSE);         /* set M2PULSE pin */
                        break;
                
                case GO_HARD_LEFT:
                        set_motor_direction(M1DIR, MOTOR_REVERSE);
                        set_motor_direction(M2DIR, MOTOR_FORWARD);
        
                        MOTOR_PORT &= ~_BV(M1PULSE);        /* clear M1PULSE pin */
                        MOTOR_PORT |= _BV(M2PULSE);         /* set M2PULSE pin */
                        break;
                
                case GO_FORWARD:
                        set_motor_direction(M1DIR, MOTOR_FORWARD);
                        set_motor_direction(M2DIR, MOTOR_FORWARD);
        
                        MOTOR_PORT |= _BV(M1PULSE);         /* set M1PULSE pin */
                        MOTOR_PORT |= _BV(M2PULSE);         /* set M2PULSE pin */
                        break;
                
                
                case GO_HARD_RIGHT:
                        set_motor_direction(M1DIR, MOTOR_FORWARD);
                        set_motor_direction(M2DIR, MOTOR_REVERSE);
        
                        MOTOR_PORT |= _BV(M1PULSE);         /* set M1PULSE pin */
                        MOTOR_PORT &= ~_BV(M2PULSE);        /* clear M2PULSE pin */
                        break;
                
                case GO_RIGHT:
                        set_motor_direction(M1DIR, MOTOR_FORWARD);
                        set_motor_direction(M2DIR, MOTOR_FORWARD);
        
                        MOTOR_PORT |= _BV(M1PULSE);         /* set M1PULSE pin */
                        MOTOR_PORT &= ~_BV(M2PULSE);        /* clear M2PULSE pin */
                        break;
                
                case GO_BRAKE:
                        set_motor_direction(M1DIR, MOTOR_FORWARD);
                        set_motor_direction(M2DIR, MOTOR_FORWARD);
        
                        MOTOR_PORT &= ~_BV(M1PULSE);        /* clear M1PULSE pin */
                        MOTOR_PORT &= ~_BV(M2PULSE);        /* clear M2PULSE pin */
                        break;
                break;    
        }
}

uint8_t get_line_sensor_value(uint8_t led_index)
{
        uint8_t adc_value;
        uint8_t led_bit;
        
        /* convert led_index (for arrays) into it's bit value */
        switch (led_index)
        {
                case 0: led_bit = _BV(LED1); break;
                case 1: led_bit = _BV(LED2); break;
                case 2: led_bit = _BV(LED3); break;
                case 3: led_bit = _BV(LED4); break;
                case 4: led_bit = _BV(LED5); break;
        }
        
        /* turn on LED */
        LED_PORT &= ~led_bit;
        _delay_ms(5);
        
        /* read output from ADC */
        ADCSRA |= _BV(ADSC);
        while (!(ADCSRA & _BV(ADIF)));
        adc_value = ADCH;
        ADCSRA |= _BV(ADIF);
        
        /* turn off LED */
        LED_PORT |= led_bit;
        
        return adc_value;
}

void calibrate_line_sensors(uint8_t *midpoint)
{
        uint8_t adc_value;              /* ADC value */
        uint8_t i, j;                   /* loop counter */ 
        uint8_t thresh_high[5] = { 0,0,0,0,0 };
        uint8_t thresh_low[5] = { 255,255,255,255,255 };
                     
        for (i=0; i<100; i++) 
        { 
                for (j=0; j<5; j++)
                {
                        adc_value = get_line_sensor_value(j);
                        if (adc_value < thresh_low[j]) thresh_low[j] = adc_value;
                        if (adc_value > thresh_high[j]) thresh_high[j] = adc_value;
                }
                _delay_ms(250); 
        }
        
        for (i=0; i<5; i++)
        {
                midpoint[i] = (thresh_low[i] + (thresh_high[i] - thresh_low[i]) / 2);
        }
  
}

/* 
 * delay_ms - Perform long delays in approximate milliseconds.
*/ 
void 
delay_ms(uint16_t ms) 
{
        while ( ms ) 
        {
                _delay_ms(1);
                ms--;
        }
}
