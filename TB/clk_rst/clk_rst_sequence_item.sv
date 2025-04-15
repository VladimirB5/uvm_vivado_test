// clk_rst_seq_item.sv
//`timescale 1ns/1ps
class clk_rst_seq_item extends uvm_sequence_item;
  // Data fields
  bit enable_clock;
  bit reset_val;
  rand bit [3:0] reset_lenght;

  `uvm_object_utils(clk_rst_seq_item)

  function new(string name = "clk_rst_seq_item");
    super.new(name);
  endfunction
  
   // Constraint block for some_val:
  constraint reset_lenght_range {
    reset_lenght >= 4'd1;
    reset_lenght <= 4'd11;
  }
  // Optional: implement copy, compare, or do_print methods
endclass

