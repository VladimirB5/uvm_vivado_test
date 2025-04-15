// clk_rst_agent.sv
//`timescale 1ns/1ps
class clk_rst_agent extends uvm_agent;

  clk_rst_driver    driver;
  clk_rst_sequencer sequencer;

  `uvm_component_utils(clk_rst_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver    = clk_rst_driver::type_id::create("driver", this);
    sequencer = clk_rst_sequencer::type_id::create("sequencer", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction
endclass
