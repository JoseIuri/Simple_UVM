/**
  ******************************************************************************
  *
  * @university UFCG (Universidade Federal de Campina Grande)
  * @lab        Embedded
  *
  * @file      top.sv
  *
  * @authors   Jose Iuri
  *            Pedro Cavalcante
  *
  ******************************************************************************
**/

module top;
  import uvm_pkg::*;

  logic clk;
  logic reset;

  initial begin
    clk = 0;
    reset = 1;
    #22 reset = 0;

  end

  always #5 clk = !clk;

  logic [1:0] state;

  mem_if intif (.clk(clk), .reset(reset));

  memory DUT (
    .clk(intif.clk),
    .reset(intif.reset),
    .addr(intif.addr),
    .wr_en(intif.wr_en),
    .rd_en(intif.rd_en),
    .wdata(intif.wdata),
    .rdata(intif.rdata)
   );

  initial begin
    `ifdef XCELIUM
       $recordvars();
    `endif
    `ifdef VCS
       $vcdpluson;
    `endif
    `ifdef QUESTA
       $wlfdumpvars();
       set_config_int("*", "recording_detail", 1);
    `endif

    uvm_config_db#(virtual mem_if)::set(uvm_root::get(), "*.env_h.ag.*", "mem_vif", intif);

    run_test("random_test");
  end
endmodule
