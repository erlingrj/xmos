#include <platform.h>
#include <stdio.h>

// This program configures a port to be clocked at 12.5MHz and also outputs the
// clock signal with the data

out port outP = XS1_PORT_8A;
out port outClock = XS1_PORT_1A;
clock clk = XS1_CLKBLK_1;

int main(void) {
  configure_clock_rate(clk,100,20); //100 cock 20 divisor
  configure_out_port(outP,clk,0); //Drive outP enable signal from clk
  configure_port_clock_output(outClock, clk); // drive outClock directly from
  clock
  start_clock(clk);

  for(int i=0; i<5; i++) {
    outP <: i;
  }

  return 0;
}


void doToggle(out port toggle) {
  int count;
  toggle <: 0 @ count; // Write 0 to toggle and store the port counter in count
  while (1) {
    count += 3;
    toggle @ count <: 1; // Drive toggle to 1 when port counter == count
    count += 2;
    toggle @ count <: 0; // drive toggle to 0 when port counter == count
  }
}
