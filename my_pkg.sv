/**
  ******************************************************************************
  *
  * @university UFCG (Universidade Federal de Campina Grande)
  * @lab        Embedded
  *
  * @file      my_pkg.sv
  *
  * @authors   Jose Iuri
  *            Pedro Cavalcante
  *
  ******************************************************************************
**/

package my_pkg;

// Import the UVM library and include the UVM macros
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "packet.sv"
`include "sequence_in.sv"
`include "monitor.sv"
`include "driver.sv"
`include "agent.sv"
`include "refmod.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "simple_test.sv"

endpackage
