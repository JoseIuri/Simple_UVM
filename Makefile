#UVM Configure
#TEST_NAME = basic_test
UVM = +UVM_TR_RECORD +UVM_VERBOSITY=HIGH +UVM_TESTNAME=random_test +vcs+lic+wait
SEED = 100
COVER = 100
MODE = ALL
TRANSA = 2500

PACKAGES = ./class/my_pkg.sv
INTERFACE = mem_if.sv

TOP = top.sv

DUT = memory.sv




run: compile

compile:
	xrun -uvm -define MY_DUT -access +r -input shm.tcl +incdir+class $(UVM) $(INTERFACE) $(PACKAGES) $(DUT) $(TOP) -nowarn "NONPRT" -timescale 1ns/1ps

test:
	$ ./simv +UVM_TR_RECORD +UVM_VERBOSITY=HIGH +UVM_TESTNAME=simple_test +ntb_random_seed=$(SEED)

waves:
	simvision waves.shm &
clean:
	rm -rf xcelium.d/ waves.shm/ xrun* # TODO
