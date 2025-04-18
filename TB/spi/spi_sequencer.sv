// clk_rst_sequencer.sv
//`timescale 1ns/1ps
class spi_sequencer extends uvm_sequencer#(spi_seq_item);

  `uvm_component_utils(spi_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
