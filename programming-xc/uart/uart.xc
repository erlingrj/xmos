#include "platform.h"
#include "uart.h"


#define BIT_RATE 115200
#define BIT_TIME 100000000 / BIT_RATE

out port TXD = XS1_PORT_1A;

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


int isData() {
  return 1;
}

void uart_duplex(port RX, int rxPeriod, port TX, int txPeriod) {
  int txByte, rxByte;
  int txI, rxI;
  int rxTime, txTime;
  int isTX = 0;
  int isRX = 0;
  timer tmrTX, tmrRX;
  while(1) {
    if(!isTX && isData()) { // no TX and we have new data to send
      isTX = 1;
      txI = 0;
      txByte = 0xb5;
      TX <: 0;
      tmrTX :> txTime;
      txTime += txPeriod;
    }
     // case {guard} => {input} when {ready condition}
     // A HW resource can only appear in one case
     // Case statement can only contain input not output ops.
    select {
    case !isRX => RX when pinseq(0) :> void :
      break;

    case isRX => tmrRX when timerafter(rxTime) :> void :
      break;

    case isTX => tmrTX when timerafter(txTime) :> void :
    break;

    }
  }
}

// Parameterised Selection
// You can make a select function to allow more reuse

select inBit(in port r0, in port r1, int &x0, int &x1, char &byte) {
case r0 when pinsneq(x0) :> x0:
  if (x0 == 1) // Transition 1->0
    byte = (byte << 1) | 1;
  break;
  
case r1 when pinsneq(x1) :> x1 :
  if (x1 == 1)
    byte = (byte << 1) | 0;
  break;
}


/*
int main(void) {
  uart_tx(TXD, 0x52);
  return 0;
}
*/
