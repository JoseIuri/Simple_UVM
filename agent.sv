class agent extends uvm_agent;
    uvm_sequencer#(packet) sqr;
    driver    drv;
    monitor   mon;

    uvm_analysis_port #(packet) item_comp_port;
    uvm_analysis_port #(packet) item_ref_port;

    `uvm_component_utils(agent)

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
        item_comp_port = new("item_comp_port", this);
        item_ref_port = new("item_ref_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = monitor::type_id::create("mon", this);
        sqr = uvm_sequencer#(packet)::type_id::create("sqr", this);
        drv = driver::type_id::create("drv", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.item_comp_port.connect(item_comp_port);
        mon.item_ref_port.connect(item_ref_port);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
    task pre_reset_phase(uvm_phase phase);
      // Tells the sequencer to kill all sequences and child sequences currently
      // operating on the sequencer, and remove all requests, locks and responses
      // that are currently queued.
      // This essentially resets the sequencer to an idle state.
      sqr.stop_sequences();
      // Indicates Driver that reset is asserted
      ->drv.reset_driver;
      `uvm_info(get_name(), $sformatf("reset_driver event is triggered"), UVM_LOW)
    endtask : pre_reset_phase
endclass: agent
