// clk_rst_sequence.sv
//`timescale 1ns/1ps
class clk_rst_sequence extends uvm_sequence#(clk_rst_seq_item);
  `uvm_object_utils(clk_rst_sequence)
  //clk_rst_seq_item req;
  bit set_clock= 1'b0;
  bit enable_clock;

  function new(string name="clk_rst_sequence");
    super.new(name);
  endfunction

  task body();
    clk_rst_seq_item req;
    // Create and configure the transaction
    req = clk_rst_seq_item::type_id::create("req");
    if (set_clock) 
      req.enable_clock = enable_clock;
    else 
      req.enable_clock = 1'b1;  
    req.reset_val = 1'b1;
    if (!req.randomize()) begin
      `uvm_error("my_sequence", "Randomization failed");
    end
    // Start the transaction with the sequencer
    start_item(req);
    // Modify req if needed...
    finish_item(req);
  endtask
endclass
