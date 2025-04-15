// clk_rst_sequencer.sv
//`timescale 1ns/1ps
class clk_rst_sequencer extends uvm_sequencer#(clk_rst_seq_item);

  `uvm_component_utils(clk_rst_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
