// clk_rst_agent.sv
//`timescale 1ns/1ps
class gpio_agent extends uvm_agent;

  gpio_driver    m_driver;
  gpio_sequencer m_sequencer;

  `uvm_component_utils(gpio_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_driver    = gpio_driver::type_id::create("gpio_driver", this);
    m_sequencer = gpio_sequencer::type_id::create("gpio_sequencer", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  endfunction
endclass
