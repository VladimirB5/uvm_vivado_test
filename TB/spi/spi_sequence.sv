// clk_rst_sequence.sv
//`timescale 1ns/1ps
class spi_sequence extends uvm_sequence#(spi_seq_item);
  `uvm_object_utils(spi_sequence)
  //clk_rst_seq_item req;


  function new(string name="spi_sequence");
    super.new(name);
  endfunction

  task body();
    spi_seq_item req;
    // Create and configure the transaction
    req = spi_seq_item::type_id::create("req");
    if (!req.randomize()) begin
      `uvm_error("spi_sequence", "Randomization failed");
    end
    // Start the transaction with the sequencer
    start_item(req);
    // Modify req if needed...
    finish_item(req);
  endtask
endclass

class spi_sequence_gpio_out extends uvm_sequence#(spi_seq_item);
  `uvm_object_utils(spi_sequence_gpio_out)
  //clk_rst_seq_item req;

  function new(string name="spi_sequence_gpio_out");
    super.new(name);
  endfunction

  task body();
    spi_seq_item req;
    // Create and configure the transaction
    req = spi_seq_item::type_id::create("req");
    start_item(req);
    if (!req.randomize() with {  write == 1'b1; address inside {0, 2, 3}; }) begin
      `uvm_error("spi_sequence_gpio_out", "Randomization failed");
    end
    finish_item(req);
    start_item(req);
    req.write = 1'b0; // read
    finish_item(req);

  endtask
endclass
