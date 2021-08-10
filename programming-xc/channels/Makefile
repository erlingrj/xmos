TARGET=XCORE-200-EXPLORER
XSIM_OPTIONS=--vcd-tracing "-o trace.vcd -tile tile[0] -ports"
#SOURCES=$(wildcard *.xc)

SOURCES=channels.xc ../uart/uart_lib.xc
INCLUDE_OPTIONS=-I../uart

EXE=run.X


all:
	xcc -target=$(TARGET) $(SOURCES) $(INCLUDE_OPTIONS) -o $(EXE)
	xsim $(XSIM_OPTIONS) $(EXE)

clean:
	rm *.xe *.vcd *.gtkw
