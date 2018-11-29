#UVM Configure
#TEST_NAME = basic_test
UVM = +UVM_TR_RECORD +UVM_VERBOSITY=HIGH +UVM_TESTNAME=simple_test
SEED = 100
COVER = 100
MODE = ALL
TRANSA = 2500

PACKAGES = my_pkg.sv
INTERFACE = mem_if.sv

TOP = top.sv

DUT = memory.sv

RUN_ARGS_COMMON = -access +r -input shm.tcl \
		  +uvm_set_config_int=*,recording_detail,1 -coverage all -covoverwrite


run: compile

compile:
	# irun -uvm -access +r -input shm.tcl $(INTERFACE) $(PACKAGES) $(DUT) $(TOP) $(UVM) -nowarn "NONPRT" -timescale 1ns/1ps
	irun -64bit -uvm $(PACKAGES) $(INTERFACE) $(DUT) top.sv \
	  +UVM_TESTNAME=simple_test -covtest simple_test-$(SEED) -svseed $(SEED)  \
		-defparam top.min_cover=$(COVER) -defparam top.min_transa=$(TRANSA) $(RUN_ARGS_COMMON) \

waves:
	simvision waves.shm &
clean:
	rm -rf xcelium.d/ waves.shm/ irun* top-* cov_work INCA_libs
