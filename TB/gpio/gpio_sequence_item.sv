//`timescale 1ns/1ps
class gpio_seq_item extends uvm_sequence_item;
  // Data fields
  rand bit[7:0] gpio_in;
  bit [7:0] gpio_out;
  bit [7:0] gpio_pd;
  bit [7:0] gpio_pu;

  `uvm_object_utils_begin(gpio_seq_item)
    `uvm_field_int(gpio_in, UVM_DEFAULT)
    `uvm_field_int(gpio_out, UVM_DEFAULT)
    `uvm_field_int(gpio_pd, UVM_DEFAULT)
    `uvm_field_int(gpio_pu, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "gpio_seq_item");
    super.new(name);
  endfunction

  // Optional: implement copy, compare, or do_print methods


  virtual function string convert2string();

    return $sformatf(
      "gpio_in=0x%02h gpio_out=0x%02h gpio_pd=0x%02h gpio_pu=0x%02h",
      gpio_in, gpio_out, gpio_pd, gpio_pu
    );

  endfunction
endclass
