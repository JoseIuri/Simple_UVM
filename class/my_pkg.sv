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
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "packet.sv"
`include "monitor.sv"
`include "driver.sv"
`include "agent.sv"
`include "refmod.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "sequence_in.sv"
`include "random_test.sv"

endpackage
