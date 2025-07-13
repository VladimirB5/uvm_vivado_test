// clk_rst_env.sv
//`timescale 1ns/1ps
class gpio_env extends uvm_env;

  gpio_agent m_agent;

  `uvm_component_utils(gpio_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_agent = gpio_agent::type_id::create("gpio_agent", this);
  endfunction
endclass
