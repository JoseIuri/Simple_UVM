/**
  ******************************************************************************
  *
  * @university UFCG (Universidade Federal de Campina Grande)
  * @lab        Embedded
  *
  * @file      env.sv
  *
  * @authors   Jose Iuri
  *            Pedro Cavalcante
  *
  ******************************************************************************
**/

class env extends uvm_env;
    agent       ag;
    scoreboard  sb;
    cover_mem   cv;

    `uvm_component_utils(env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ag = agent::type_id::create("ag", this);
        sb = scoreboard::type_id::create("sb", this);
        cv = cover_mem::type_id::create("cv", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        ag.item_comp_port.connect(sb.ap_comp);
        ag.item_ref_port.connect(sb.ap_rfm);
        ag.item_ref_port.connect(cv.req_port);
        ag.item_comp_port.connect(cv.resp_port);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction
  endclass
