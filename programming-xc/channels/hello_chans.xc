#include <platform.h>
#include "stdio.h"


void tx(chanend chan_in, int iter) {
  printf("Hello from tx thread\n");

  int recv;
  int i = iter;
  while (i > 0) {
    chan_in :> recv;
    printf("Received: %d\n", recv);
    i--;
  }
}


void rx(chanend chan_out, int iter) {
  printf("Hello from rx thread\n");
  for (int i = 0; i<iter; i++) {
    chan_out <: i;
  }
}

int main(void) {
  chan c;
  par {
    on stdcore[0] :   rx(c,100);
    on stdcore[1] :   tx(c, 100);
  }
  return 0;
}
