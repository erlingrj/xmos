#include <platform.h>
#include "uart_lib.h"

#define BIT_RATE 115200
#define BIT_TIME 100000000 / BIT_RATE


void uart_tx(out port TXD, unsigned byte)
{
  unsigned time;
  timer t;

    t :> time;
    // Output start bit
    TXD <: 0;
    time += BIT_TIME;
    t when timerafter(time) :> void;

    // output data bits
    for (int i = 0; i<8; i++) {
      TXD <: >> byte;
      time += BIT_TIME;
      t when timerafter(time) :> void;
    }
    
    // OUtput stop bit
    TXD <: 1;
    time += BIT_TIME;
    t when timerafter(time) :> void;
    

}
