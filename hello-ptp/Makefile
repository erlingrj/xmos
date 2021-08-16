# The TARGET variable determines what target system the application is
# compiled for. It either refers to an XN file in the source directories
# or a valid argument for the --target option when compiling.

TARGET=XCORE-200-EXPLORER

# The APP_NAME variable determines the name of the final .xe file. It should
# not include the .xe postfix. If left blank the name will default to
# the project name
APP_NAME=
XMOS_MODULE_PATH=./../lib/
XCOMMON_DISABLE_AUTO_MODULE_SEARCH=1
# The flags passed to xcc when building the application
# You can also set the following to override flags for a particular language:
#
#    XCC_XC_FLAGS, XCC_C_FLAGS, XCC_ASM_FLAGS, XCC_CPP_FLAGS
#
# If the variable XCC_MAP_FLAGS is set it overrides the flags passed to
# xcc for the final link (mapping) stage.

XCC_FLAGS = -report -O2 -g  -save-temps 

# The USED_MODULES variable lists other module used by the application.

USED_MODULES = lib_tsn

#=============================================================================
# The following part of the Makefile includes the common build infrastructure
# for compiling XMOS applications. You should not need to edit below here.

XMOS_MAKE_PATH ?= ../..
include $(XMOS_MAKE_PATH)/xcommon/module_xcommon/build/Makefile.common


EXE = bin/$(APP_NAME).xe
XSIM_LOOPBACK_OPTIONS=--plugin LoopbackPort.dll "-port tile[0] XS1_PORT_1A 1 0 -port tile[0] XS1_PORT_1B 1 0"
XSIM_TRACING_OPTIONS=--vcd-tracing "-o waves/trace.vcd -tile tile[0] -ports"

XSIM_OPTIONS = $(XSIM_LOOPBACK_OPTIONS) $(XSIM_TRACING_OPTIONS)

sim:
	mkdir -p waves
	xsim $(XSIM_OPTIONS) $(EXE)

clean:
	
