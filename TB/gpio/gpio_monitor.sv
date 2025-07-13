// clk_rst_driver.sv
//`timescale 1ns/1ps
class gpio_monitor extends uvm_monitor;

  // UVM factory registration
  `uvm_component_utils(gpio_monitor)

  virtual gpio_if gpio_vif;
  virtual clk_rst_if clk_rst_vif;
  logic [7:0] i_gpio_out;
  logic [7:0] i_gpio_pd;
  logic [7:0] i_gpio_pu;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual gpio_if)::get(this, "", "gpio_vif", gpio_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
    if(!uvm_config_db#(virtual clk_rst_if)::get(this, "", "clk_rst_vif", clk_rst_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
  endfunction

  task run_phase(uvm_phase phase);
    i_gpio_out = 8'b0;
    i_gpio_pd  = 8'b0;
    i_gpio_pu  = 8'b0;

    forever begin

      @(posedge clk_rst_vif.clk);
      #(1ns);
      if (i_gpio_out != gpio_vif.gpio_out) begin
        `uvm_info("gpio_monitor", $sformatf("gpio_out=%0h", gpio_vif.gpio_out), UVM_LOW);
        i_gpio_out = gpio_vif.gpio_out;
      end
      if (i_gpio_pu != gpio_vif.gpio_pu) begin
        `uvm_info("gpio_monitor", $sformatf("gpio_pu=%0h", gpio_vif.gpio_pu), UVM_LOW);
        i_gpio_pu = gpio_vif.gpio_pu;
      end
      if (i_gpio_pd != gpio_vif.gpio_pd) begin
        `uvm_info("gpio_monitor", $sformatf("gpio_pd=%0h", gpio_vif.gpio_pd), UVM_LOW);
        i_gpio_pd = gpio_vif.gpio_pd;
      end

    end
  endtask
endclass : gpio_monitor

