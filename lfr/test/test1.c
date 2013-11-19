#include <avr/io.h> // this contains all the IO port definitions 
#include <compat/ina90.h>    // among other things, contains _NOP()    
int main() 
{ 
  DDRB=0b00001111;     
     /*DDR=Data Direction register... its to define PB0 (pin14), PB1(pin15),PB2 (pin16), 
PB3 pin17) as out put pin rest bits of DDRD can be 0 or 1 does not make any significance */ 
    
   /*  PB1(OC1A) o/p for right motor    
   PB2(OC1B)  o/p  for  left  motor   
   * /  
    OCR1A=0x00ff;       // output compare flag  for right motor   
  OCR1B=0x00ff;  // output compare flag  for left motor 
   
   /* TOP value is 00FFh for both OC1A and OC1B*/ 
  TCCR1A=0xA1;    
   /*Timer/Counter 1 Control  and pwm at pin OC1A(PB1) */ 
  TCCR1B=0x01;      //start pwm 
   
   /* pwm at pin OC1B(PB2) and clock freq. of timer(3 LSB 000 sys. clock) */  
      /*maximum TOP_PWM value can be 00FFh */ 
    OCR1A=100;         // output compare flag for right motor   
    OCR1B=200;          // output compare flag for left motor 
 
  while(1) 
  {  
      _NOP(); 
     //wait here 
  }   
   
  return  0; 
} 