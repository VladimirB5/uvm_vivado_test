// clk_rst_seq_item.sv
//`timescale 1ns/1ps
class spi_seq_item extends uvm_sequence_item;
  // Data fields
  rand bit write;
  rand bit [2:0] address;
  rand bit [7:0] value;

  `uvm_object_utils_begin(spi_seq_item)
    `uvm_field_int(write, UVM_DEFAULT)
    `uvm_field_int(address, UVM_DEFAULT)
    `uvm_field_int(value, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "spi_seq_item");
    super.new(name);
  endfunction
  
  // Optional: implement copy, compare, or do_print methods
endclass

