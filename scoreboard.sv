/**
  ******************************************************************************
  *
  * @university UFCG (Universidade Federal de Campina Grande)
  * @lab        Embedded
  *
  * @file      scoreboard.sv
  *
  * @authors   Jose Iuri
  *            Pedro Cavalcante
  *
  ******************************************************************************
**/

class scoreboard extends uvm_scoreboard;

  typedef packet T;
  typedef uvm_in_order_class_comparator #(T) comp_type;
  uvm_tlm_analysis_fifo #(packet) to_refmod;

  //typedef uvm_in_order_comparator #(T,uvm_class_comp#(comp_policy),uvm_class_converter#(T),uvm_class_pair #(T)) comp_type;
  refmod rfm;
  comp_type comp;

  uvm_analysis_port #(T) ap_comp;
  uvm_analysis_port #(T) ap_rfm;

  `uvm_component_utils(scoreboard)

  function new(string name = "translator", uvm_component parent = null);
    super.new(name, parent);
    ap_comp = new("ap_comp", this);
    ap_rfm = new("ap_rfm", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rfm = refmod::type_id::create("rfm", this);
    comp = comp_type::type_id::create("comp", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ap_comp.connect(comp.before_export);
    ap_rfm.connect(to_refmod.analysis_export);
    rfm.out.connect(comp.after_export);
    rfm.in.connect(to_refmod.get_export);

  endfunction
endclass
