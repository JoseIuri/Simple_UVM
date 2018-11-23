/**
  ******************************************************************************
  *
  * @university UFCG (Universidade Federal de Campina Grande)
  * @lab        Embedded
  *
  * @file      driver.sv
  *
  * @authors   Jose Iuri
  *            Pedro Cavalcante
  *
  ******************************************************************************
**/

`define DRIV_IF mem_vif.DRIVER.driver_cb

class driver extends uvm_driver #(packet);

    `uvm_component_utils(driver)

    packet req;

    virtual mem_if mem_vif;
    event begin_record, end_record;

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(virtual mem_if)::get(this, "", "mem_vif", mem_vif));
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            reset_signals();
            get_and_drive();
            record_tr();
        join
    endtask

    virtual protected task reset_signals();
	    wait(mem_vif.reset);
	    $display("--------- [DRIVER] Reset Started ---------");
	    `DRIV_IF.wr_en <= 0;
	    `DRIV_IF.rd_en <= 0;
	    `DRIV_IF.addr  <= 0;
	    `DRIV_IF.wdata <= 0;
	    wait(!mem_vif.reset);
	    $display("--------- [DRIVER] Reset Ended ---------");
    endtask

    //  get_and drive
	virtual task get_and_drive();
	  while (1) begin
	    reset_signals();
	    fork
	      @(negedge mem_vif.reset)
	        `uvm_info(get_type_name(), "Reset asserted", UVM_LOW)
	    begin
	      forever begin
	        @(posedge mem_vif.clk iff (mem_vif.reset));
          seq_item_port.try_next_item(req);
	        -> begin_record;
	        drive_transfer(req);
	        seq_item_port.item_done();
	      end
	    end
	    join_any
	    disable fork;
	    if(req.is_active()) this.end_tr(req);
	  end
	endtask

    virtual protected task drive_transfer(packet tr);
		`DRIV_IF.wr_en <= 0;
		`DRIV_IF.rd_en <= 0;
		$display("--------- [DRIVER-TRANSFER] ---------");
		@(posedge mem_vif.DRIVER.clk);
			`DRIV_IF.addr <= tr.addr;
		if(tr.wr_en) begin
			`DRIV_IF.wr_en <= tr.wr_en;
			`DRIV_IF.wdata <= tr.wdata;
			$display("\tADDR = %0h \tWDATA = %0h",tr.addr,tr.wdata);
			@(posedge mem_vif.DRIVER.clk);
		end
		if(tr.rd_en) begin
			`DRIV_IF.rd_en <= tr.rd_en;
			@(posedge mem_vif.DRIVER.clk);
			`DRIV_IF.rd_en <= 0;
			@(posedge mem_vif.DRIVER.clk);
			tr.rdata = `DRIV_IF.rdata;
			$display("\tADDR = %0h \tRDATA = %0h",tr.addr,`DRIV_IF.rdata);
		end

		$display("-----------------------------------------");
    endtask

    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(req, "driver");
            @(end_record);
            end_tr(req);
        end
    endtask

endclass
