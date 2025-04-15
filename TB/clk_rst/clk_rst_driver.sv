// clk_rst_driver.sv
//`timescale 1ns/1ps
class clk_rst_driver extends uvm_driver #(clk_rst_seq_item);

  `uvm_component_utils(clk_rst_driver)
  
  virtual clk_rst_if clk_rst_vif;  

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual clk_rst_if)::get(this, "", "clk_rst_vif", clk_rst_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
  endfunction  

  task run_phase(uvm_phase phase);
    clk_rst_seq_item req;
    forever begin
      seq_item_port.get_next_item(req);

      // Drive signals to DUT here
      clk_rst_vif.enable = req.enable_clock;
      clk_rst_vif.rst_n = 1'b0;
      #(5ns * req.reset_lenght);
      clk_rst_vif.rst_n = 1'b1;
      `uvm_info("clk_rst_driver", $sformatf("Driving enable_clock=%0b, reset=%0b, reset_dur=%d", req.enable_clock, req.reset_val, req.reset_lenght), UVM_LOW);

      seq_item_port.item_done();
    end
  endtask
endclass : clk_rst_driver
