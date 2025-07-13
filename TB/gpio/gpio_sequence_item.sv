//`timescale 1ns/1ps
class gpio_seq_item extends uvm_sequence_item;
  // Data fields
  rand bit[7:0] gpio_in;
  bit [7:0] gpio_out;
  bit [7:0] gpio_pd;
  bit [7:0] gpio_pu;

  `uvm_object_utils(gpio_seq_item)

  function new(string name = "gpio_seq_item");
    super.new(name);
  endfunction

  // Optional: implement copy, compare, or do_print methods
endclass
