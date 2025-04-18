// clk_rst_env.sv
//`timescale 1ns/1ps
class spi_env extends uvm_env;

  spi_agent m_agent;

  `uvm_component_utils(spi_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_agent = spi_agent::type_id::create("spi_agent", this);
  endfunction
endclass
