TARGET=XCORE-200-EXPLORER
#SOURCES=$(wildcard *.xc)

SOURCES=main.c
INCLUDE_OPTIONS=

EXE=run.X

#XSIM_LOOPBACK_OPTIONS=--plugin LoopbackPort.dll "-port tile[1] XS1_PORT_1C 1 0 -port tile[0] XS1_PORT_1A 1 0 -port tile[1] XS1_PORT_1D 1 0 -port tile[0] XS1_PORT_1B 1 0"
XSIM_TRACING_OPTIONS=--vcd-tracing "-o trace.vcd -tile tile[0] -ports"

XSIM_OPTIONS = $(XSIM_LOOPBACK_OPTIONS) $(XSIM_TRACING_OPTIONS)




all:
	xcc -target=$(TARGET) $(SOURCES) $(INCLUDE_OPTIONS) -o $(EXE) -report
	xsim $(XSIM_OPTIONS) $(EXE)

clean:
	rm *.xe *.vcd *.gtkw
