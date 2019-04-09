/**
  ******************************************************************************
  *
  * @university UFCG (Universidade Federal de Campina Grande)
  * @lab        Embedded
  *
  * @file      simple_test.sv
  *
  * @authors   Jose Iuri
  *            Pedro Cavalcante
  *
  ******************************************************************************
**/


class simple_test extends uvm_test;
  env env_h;
  int unsigned run_count;  

  `uvm_component_utils(simple_test)

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
    run_count = 0;
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h = env::type_id::create("env_h", this);
  endfunction

  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    if (run_count == 0) begin
      fork
        begin
          sequence_in seq;
          seq = sequence_in::type_id::create("seq", this);
          seq.start(env_h.ag.sqr);
        end
        begin
          @(posedge env_h.ag.drv.mem_vif.reset)
          `uvm_info(get_name(), $sformatf("rst assertion detected"), UVM_LOW)
        end
      join_any
      disable fork;
    end
    else if(run_count == 1) begin
      sequence_in seq;
      seq = sequence_in::type_id::create("seq", this);
      seq.start(env_h.ag.sqr);
    end

    if (run_count == 0) begin
      phase.get_objection().set_report_severity_id_override(UVM_WARNING, "OBJTN_CLEAR", UVM_INFO);
      phase.jump(uvm_pre_reset_phase::get());
    end
    else begin
      phase.drop_objection(this);
    end
    run_count++;
  endtask: main_phase

endclass
