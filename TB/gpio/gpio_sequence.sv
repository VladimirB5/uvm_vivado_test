// clk_rst_sequence.sv
//`timescale 1ns/1ps
class gpio_sequence extends uvm_sequence#(gpio_seq_item);
  `uvm_object_utils(gpio_sequence)
  //clk_rst_seq_item req;


  function new(string name="gpio_sequence");
    super.new(name);
  endfunction

  task body();
    gpio_seq_item req;
    // Create and configure the transaction
    req = gpio_seq_item::type_id::create("req");
    if (!req.randomize()) begin
      `uvm_error("gpio_sequence", "Randomization failed");
    end
    // Start the transaction with the sequencer
    start_item(req);
    // Modify req if needed...
    finish_item(req);
  endtask
endclass
