
#include <platform.h>
#include <stdio.h>

// This is a first try at Input Cature functionality in XCore
#define N_IC_PORTS 2


on stdcore[0] : in port p_ic[N_IC_PORTS] = {XS1_PORT_1A, XS1_PORT_1B};
on stdcore[1] : out buffered port:1 p_tb_ic[N_IC_PORTS]= {XS1_PORT_1C, XS1_PORT_1D};



select inputCaptureSel(int id, in port ic, unsigned &v, timer tmr) {
  case ic when pinsneq(v) :> v @ unsigned hw_ts:
  {
    if ( v == 1) {
      unsigned sw_ts;
      static unsigned last_hw_ts = 0;
      static unsigned last_sw_ts = 0;
      tmr :> sw_ts;
      printf("ic -%i-  hw_ts: %u sw_ts: %u delta_hw: %u delta_sw: %u\n", id, hw_ts,
        sw_ts, ((unsigned short)  (hw_ts - last_hw_ts)), sw_ts - last_sw_ts);

      last_hw_ts = hw_ts;
      last_sw_ts = sw_ts;
    }
    break;
  }
}


int inputCapture(in port p_ic[N_IC_PORTS]) 
{
  timer ic_tmr;
  unsigned int port_value[N_IC_PORTS];

  while (1) {
    for (int i = 0; i<N_IC_PORTS; i++) {
      inputCaptureSel(i, p_ic[i], port_value[i], ic_tmr);
    }
  }

  return 0;

}


// The testbench generates a pulse with a static ferquency specified på the
// interval variable
int tb_inputCapture(out buffered port:1 p_tb_ic[N_IC_PORTS])
{
  unsigned count;
  const int interval = 30000;
  const int hi_time = 1000;
    p_tb_ic[0] <: 0 @ count;
    while (1) {
      count += interval - hi_time;
      p_tb_ic[0] @ count <: 1;
      p_tb_ic[1] @ count <: 1;
      count += hi_time;
      p_tb_ic[0] @ count <: 0;
      p_tb_ic[1] @ count <: 0;
    }

    return 0;
}


int main(void) {

  par {
     
    on stdcore[0] : inputCapture(p_ic);
    on stdcore[1] : tb_inputCapture(p_tb_ic);
  }
  return 0;

}
