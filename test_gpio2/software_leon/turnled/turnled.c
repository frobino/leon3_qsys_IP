#include <stdio.h>

main()
{
volatile long int *leds;

leds=(long int*) (0xeee00000);

printf("Hello World\n");

*leds=(long int) (0x01);
  
}
