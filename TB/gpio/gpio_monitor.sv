// clk_rst_driver.sv
//`timescale 1ns/1ps
class gpio_monitor extends uvm_monitor;

  // UVM factory registration
  `uvm_component_utils(gpio_monitor)

  virtual gpio_if gpio_vif;
  virtual clk_rst_if clk_rst_vif;
  gpio_seq_item m_gpio_tran;

  // TLM analysis port
  uvm_analysis_port#(gpio_seq_item) ap;


  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
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
    forever begin

      @(gpio_vif.gpio_in, gpio_vif.gpio_out, gpio_vif.gpio_pu, gpio_vif.gpio_pd);
      #(1ns);
      m_gpio_tran = new();
      m_gpio_tran.gpio_in  = gpio_vif.gpio_in;
      m_gpio_tran.gpio_out = gpio_vif.gpio_out;
      m_gpio_tran.gpio_pu  = gpio_vif.gpio_pu;
      m_gpio_tran.gpio_pd  = gpio_vif.gpio_pd;
      `uvm_info(get_type_name(), "GPIO transaction collected", UVM_LOW)
      m_gpio_tran.print();
      ap.write(m_gpio_tran); // send transaction

    end
  endtask
endclass : gpio_monitor

