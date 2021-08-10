#include <platform.h>
#include "uart_lib.h"
#include "stdio.h"


on stdcore[0] : out port tx_port = XS1_PORT_1A;


void thread_tx(chanend dataIn, out port tx, int iter) {
  int data;
  while(iter > 0) {
dataIn :> data;
    uart_tx(tx, (unsigned) data);
    iter--;
  }
}


void thread_getData(chanend dataOut, int iter) {
  for (int i = 0; i<iter; i++) {
    dataOut <: i;
  }
}



int main(void) {
  chan c;
  par {
  on stdcore[0] : thread_tx(c, tx_port, 10);
  on stdcore[0] : thread_getData(c,10);
  }
  return 0;
}




