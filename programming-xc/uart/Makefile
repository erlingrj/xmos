TARGET=XCORE-200-EXPLORER
XSIM_OPTIONS=--vcd-tracing "-o trace.vcd -tile tile[0] -ports"
SOURCES=$(wildcard *.xc)

EXE=run.xe


all:
	xcc -target=$(TARGET) $(SOURCES) -o $(EXE)
	xsim $(XSIM_OPTIONS) $(EXE)


clean:
	rm *.xe *.vcd *.gtkw
