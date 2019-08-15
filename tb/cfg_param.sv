class cfg_param extends uvm_object;
  `uvm_object_utils(cfg_param)

  function new ( string name = "cfg_param" );
       super.new( name );
  endfunction : new

  rand real in_energy;
  rand real in_osnr;
  rand real in_imbalance_hi;
  rand real in_imbalance_hq;
  rand real in_hybrid_error;
  rand real in_sps_out;
  rand real in_static_freq;
  rand real i_static_step;
  rand real i_static_step;
  rand real i_static_energy;
  rand real i_static_energy;

  constraint param_gen {
    in_imbalance_hi >= -3; 
    in_imbalance_hi <= 3; 
    in_imbalance_hq >= -3; 
    in_imbalance_hq <= 3; 
    in_energy >= 0.15; 
    in_energy <= 0.5; 
    in_osnr >= 23; 
    in_osnr <= 28;
    in_hybrid_error <= 85;
    in_hybrid_error >= 95;
    in_static_freq >= -1.8;
    in_static_freq <= 1.8;
    i_static_step >= 0;
    i_static_step <= 0.125;
    i_static_energy >= 0.15;
    i_static_energy <= 0.35;
  }

  function void post_randomize ();
    $display ("Parameters randomization done.");
  endfunction

endclass : cfg_param