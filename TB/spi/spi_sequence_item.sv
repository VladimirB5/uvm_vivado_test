// clk_rst_seq_item.sv
//`timescale 1ns/1ps
class spi_seq_item extends uvm_sequence_item;
  // Data fields
  rand bit write;
  rand bit [2:0] address;
  rand bit [7:0]value;

  `uvm_object_utils(spi_seq_item)

  function new(string name = "spi_seq_item");
    super.new(name);
  endfunction
  
  // Optional: implement copy, compare, or do_print methods
endclass

