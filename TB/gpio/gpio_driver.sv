// clk_rst_driver.sv
//`timescale 1ns/1ps
class gpio_driver extends uvm_driver #(gpio_seq_item);

  `uvm_component_utils(gpio_driver)
  
  virtual gpio_if gpio_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual gpio_if)::get(this, "", "gpio_vif", gpio_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
  endfunction  

  task run_phase(uvm_phase phase);
    gpio_seq_item req;
    forever begin
      seq_item_port.get_next_item(req);

      // Drive signals to DUT here
      gpio_vif.gpio_in = req.gpio_in;
      #(10ns);

      //`uvm_info("clk_rst_driver", $sformatf("Driving enable_clock=%0b, reset=%0b, reset_dur=%d", req.enable_clock, req.reset_val, req.reset_lenght), UVM_LOW);

      seq_item_port.item_done();
    end
  endtask
endclass : gpio_driver
