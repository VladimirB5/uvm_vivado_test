// clk_rst_agent.sv
//`timescale 1ns/1ps
class spi_agent extends uvm_agent;

  spi_driver    m_driver;
  spi_sequencer m_sequencer;

  `uvm_component_utils(spi_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_driver    = spi_driver::type_id::create("spi_driver", this);
    m_sequencer = spi_sequencer::type_id::create("spi_sequencer", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  endfunction
endclass
