#include "platform.h"

out port p = XS1_PORT_1A;

#define DELAY 50


int main(void) {
  unsigned int state = 1;
  unsigned int time;
  timer t; //Creates a timer named t, sourced from a pool of timers
  t :> time; // Read value of timer t into variable time
  
  unsigned int iterations = 1000; // Limit ourselves


  while (iterations > 0) {
    p <: state;
    time += DELAY;
    t when timerafter(time) :> void; //waits until time is reached
    state = !state;
    iterations--;
}
return 0;
}


