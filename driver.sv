`define DRIV_IF mem_vif.DRIVER.driver_cb

class driver extends uvm_driver#(packet);
	`uvm_component_param_utils(driver)

	typedef packet tr_type;

	typedef virtual mem_if vif;
	vif mem_vif;
	tr_type trans;
	bit item_done;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(vif)::get(this, "", "mem_vif", mem_vif)) begin
			`uvm_fatal("NOVIF", "failed to get virtual interface")
		end
	endfunction

	task run_phase (uvm_phase phase);
		logic reset;

		forever begin
			@(posedge mem_vif.clk) begin

				item_done = 1'b0;
				reset = !mem_vif.reset;

				if(mem_vif.reset) begin
				  $display("--------- [DRIVER] Reset Started ---------");
			    `DRIV_IF.wr_en <= 0;
			    `DRIV_IF.rd_en <= 0;
			    `DRIV_IF.addr  <= 0;
			    `DRIV_IF.wdata <= 0;
			    // item_done = trans != null;
			    wait(!mem_vif.reset);
			    $display("--------- [DRIVER] Reset Ended ---------");
				end
				else begin
		      `DRIV_IF.wr_en <= 0;
		      `DRIV_IF.rd_en <= 0;
		      seq_item_port.try_next_item(trans);
					item_done = 1'b0;
		      $display("--------- [DRIVER-TRANSFER] ---------");
		      @(posedge mem_vif.DRIVER.clk);
		        `DRIV_IF.addr <= trans.addr;
		      if(trans.wr_en) begin
		        `DRIV_IF.wr_en <= trans.wr_en;
		        `DRIV_IF.wdata <= trans.wdata;
		        $display("\tADDR = %0h \tWDATA = %0h",trans.addr,trans.wdata);
		        @(posedge mem_vif.DRIVER.clk);
		      end
		      if(trans.rd_en) begin
		        `DRIV_IF.rd_en <= trans.rd_en;
		        @(posedge mem_vif.DRIVER.clk);
		        `DRIV_IF.rd_en <= 0;
		        @(posedge mem_vif.DRIVER.clk);
		        trans.rdata = `DRIV_IF.rdata;
		        $display("\tADDR = %0h \tRDATA = %0h",trans.addr,`DRIV_IF.rdata);
		      end
		      $display("-----------------------------------------");
					item_done = 1'b1;
				end

				if (item_done) begin
					`uvm_info("ITEM_DONE", $sformatf("Item done."), UVM_HIGH);
					seq_item_port.item_done();
				end
				if ((item_done || !trans) && mem_vif.reset) begin
					seq_item_port.try_next_item(trans);
				end
			end
		end
	endtask
endclass
