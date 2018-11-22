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

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            collect_transactions();
            record_tr();
        join
    endtask

    virtual task collect_transactions();
        forever begin
        @(posedge mem_vif.MONITOR.clk);
        wait(`MON_IF.rd_en || `MON_IF.wr_en);
            -> begin_record;
            tr.addr  = `MON_IF.addr;
            tr.wr_en = `MON_IF.wr_en;
            tr.wdata = `MON_IF.wdata;
            tr.rd_en = `MON_IF.rd_en;
            if(`MON_IF.rd_en) begin
                @(posedge mem_vif.MONITOR.clk);
                @(posedge mem_vif.MONITOR.clk);
                tr.rdata = `MON_IF.rdata;
                item_comp_port.write(tr);
            end
            item_ref_port.write(tr);
            @(posedge mem_vif.clk);
            -> end_record;
        end
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
