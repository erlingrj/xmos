TARGET=XCORE-200-EXPLORER
XSIM_OPTIONS=--vcd-tracing "-o trace.vcd -tile tile[0] -ports"


all:
	xcc -target=$(TARGET) io.xc -o io.xe
	xsim $(XSIM_OPTIONS) io.xe


clean:
	rm *.xe *.vcd *.gtkw
