/**
  ******************************************************************************
  *
  * @university UFCG (Universidade Federal de Campina Grande)
  * @lab        Embedded
  *
  * @file      refmod.sv
  *
  * @authors   Jose Iuri
  *            Pedro Cavalcante
  *
  ******************************************************************************
  **/

class refmod extends uvm_component;
  `uvm_component_utils(refmod)

  packet tr_in;
  packet tr_out;
  bit [7:0] mem[4];
  uvm_analysis_imp #(packet, refmod) in;
  uvm_analysis_export #(packet) out;
  event begin_refmodtask;

  function new(string name = "refmod", uvm_component parent);
    super.new(name, parent);
    in = new("in", this);
    out = new("out", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase

  virtual function write (packet t);
    tr_in = packet#()::type_id::create("tr_in", this);
    tr_in.copy(t);
    -> begin_refmodtask;
  endfunction

  virtual task reset_phase(uvm_phase phase);
  for (int i = 0; i<4; i++)
    mem[i] = 8'hFF;
  endtask : reset_phase

  virtual task main_phase(uvm_phase phase);
  super.main_phase(phase);
  forever begin
    @begin_refmodtask;
    if (tr_in.wr_en)
      mem[tr_in.addr] = tr_in.wdata;
    else if (tr_in.rd_en)
    begin
      tr_out = packet#()::type_id::create("tr_out", this);
      begin_tr(tr_out,"refmod");
      tr_out.rdata = mem[tr_in.addr];
      tr_out.rd_en = tr_in.rd_en;
      tr_out.wr_en = tr_in.wr_en;
      tr_out.wdata = tr_in.wdata;
      tr_out.addr  = tr_in.addr;
      end_tr(tr_out);
      out.write(tr_out);
    end
  end
  endtask: run_phase
endclass: refmod
