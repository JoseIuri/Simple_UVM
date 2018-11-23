/**
  ******************************************************************************
  *
  * @university UFCG (Universidade Federal de Campina Grande)
  * @lab        Embedded
  *
  * @file      packet.sv
  *
  * @authors   Jose Iuri
  *            Pedro Cavalcante
  *
  ******************************************************************************
**/

class packet extends uvm_sequence_item;

	//declaring the transaction items
	rand bit [1:0] addr;
	rand bit       wr_en;
	rand bit       rd_en;
	rand bit [7:0] wdata;
	bit [7:0] rdata;
	bit [1:0] cnt;

	//constaint, to generate any one among write and read
	constraint wr_rd_c { wr_en != rd_en; };

	`uvm_object_utils_begin(packet)
		`uvm_field_int(addr, UVM_DEFAULT)
		`uvm_field_int(wr_en, UVM_DEFAULT)
		`uvm_field_int(rd_en, UVM_DEFAULT)
		`uvm_field_int(wdata, UVM_DEFAULT)
		`uvm_field_int(rdata, UVM_DEFAULT)
		`uvm_field_int(cnt, UVM_DEFAULT)
	`uvm_object_utils_end

    //postrandomize function, displaying randomized values of items
	function void post_randomize();
		$display("--------- [Trans] post_randomize ------");
		//$display("\t addr  = %0h",addr);
		if(wr_en) $display("\t addr  = %0h\t wr_en = %0h\t wdata = %0h",addr,wr_en,wdata);
		if(rd_en) $display("\t addr  = %0h\t rd_en = %0h",addr,rd_en);
		$display("-----------------------------------------");
	endfunction

    function new(string name="packet_in");
        super.new(name);
    endfunction: new

endclass: packet
