// clk_rst_env.sv
//`timescale 1ns/1ps
class clk_rst_env extends uvm_env;

  clk_rst_agent agent;

  `uvm_component_utils(clk_rst_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = clk_rst_agent::type_id::create("agent", this);
  endfunction
endclass
