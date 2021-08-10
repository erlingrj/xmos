#include <platform.h>

// declare 1bit output port named tx refer to port 1A on standard core number 0
on stdcore[0] : out port tx = XS1_PORT_1A;

on stdcore[0] : in port rx = XS1_PORT_1B;
on stdcore[1] : out port lcdData = XS1_PORT_32A;
on stdcore[2] : in port keys = XS1_PORT_8B;

int main(void) {
  // par starts concurrent execution of threads.
  // max 8 per core. Has fork-join parallelism.
  par {
    on stdcore[0] : uartTX(tx);
    on stdcore[0] : uartRX(rx);
    on stdcore[1] : lcdDrive(lcdData);
    on stdcore[2] : kbListen(keys);
  }
}
