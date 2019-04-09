/**
  ******************************************************************************
  *
  * @university UFCG (Universidade Federal de Campina Grande)
  * @lab        Embedded
  *
  * @file      monitor.sv
  *
  * @authors   Jose Iuri
  *            Pedro Cavalcante
  *
  ******************************************************************************
**/


`define MON_IF mem_vif.MONITOR.monitor_cb
class monitor extends uvm_monitor;

    virtual mem_if  mem_vif;
    event begin_record, end_record;
    packet tr;

    uvm_analysis_port #(packet) item_comp_port;
    uvm_analysis_port #(packet) item_ref_port;
    `uvm_component_utils(monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_comp_port = new ("item_comp_port", this);
        item_ref_port = new ("item_ref_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(virtual mem_if)::get(this, "", "mem_vif", mem_vif));
        tr = packet::type_id::create("tr", this);
    endfunction

    task pre_reset_phase(uvm_phase phase);
    endtask : pre_reset_phase

    // Wait for reset to de-assert
    task reset_phase(uvm_phase phase);
        @(negedge mem_vif.reset);
        `uvm_info(get_name(), $sformatf("rstn deassertion detected"), UVM_LOW);
    endtask : reset_phase

    virtual task main_phase(uvm_phase phase);
        super.main_phase(phase);
        forever begin
            fork
                begin
                    collect_transactions();
                end
                begin
                    record_tr();
                end
                begin
                    @(posedge mem_vif.reset);
                    `uvm_info(get_name(), $sformatf("rstn is asserted during reception of data"), UVM_LOW);
                    `uvm_info(get_name(), $sformatf(" tr:\n%s", tr.convert2string()), UVM_LOW);
                end
            join_any
            disable fork;
            item_ref_port.write(tr);
        end
    endtask

    virtual task collect_transactions();
        @(posedge mem_vif.MONITOR.clk);
        -> begin_record;
        tr.wr_en = 0;
        tr.rd_en = 0;
        tr.addr  = `MON_IF.addr;
        if(`MON_IF.wr_en) begin
            tr.wr_en = `MON_IF.wr_en;
            tr.wdata = `MON_IF.wdata;
            @(posedge mem_vif.MONITOR.clk);
        end
        if(`MON_IF.rd_en) begin
            tr.rd_en = `MON_IF.rd_en;
            @(posedge mem_vif.MONITOR.clk);
            @(posedge mem_vif.MONITOR.clk);
            tr.rdata = `MON_IF.rdata;
            $display("\tADDR = %0h \tRDATA = %0h",tr.addr,`MON_IF.rdata);
        end
        item_comp_port.write(tr);
        -> end_record;
    endtask

    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(tr, "monitor");
            @(end_record);
            end_tr(tr);
        end
    endtask
endclass
