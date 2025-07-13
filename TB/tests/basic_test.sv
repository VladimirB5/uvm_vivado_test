// basic_test.sv
//`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
import clk_rst_pkg::*;
import spi_pkg::*;
import gpio_pkg::*;
class basic_test extends uvm_test;
  `uvm_component_utils(basic_test)
    
  clk_rst_env m_clk_rst_env;
  spi_env m_spi_env;
  gpio_env m_gpio_env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_clk_rst_env = clk_rst_env::type_id::create("clk_rst_env", this);
    m_spi_env = spi_env::type_id::create("spi_env", this);
    m_gpio_env = gpio_env::type_id::create("gpio_env", this);
  endfunction

  task run_phase(uvm_phase phase);
    clk_rst_sequence m_clk_rst_seq;
    spi_sequence m_spi_seq;
    gpio_sequence m_gpio_seq;
    phase.raise_objection(this);

    m_clk_rst_seq = clk_rst_sequence::type_id::create("clk_rst_seq");
    //seq.set_clock = 1'b1;
    //seq.enable_clock = 1'b0;
    m_clk_rst_seq.start(m_clk_rst_env.agent.sequencer);
    #(100ns);
    m_gpio_seq = gpio_sequence::type_id::create("gpio_seq");
    m_gpio_seq.start(m_gpio_env.m_agent.m_sequencer);
    
    #(100ns);
    m_spi_seq = spi_sequence::type_id::create("spi_seq");
    m_spi_seq.start(m_spi_env.m_agent.m_sequencer);

    #(100ns);
    m_gpio_seq = gpio_sequence::type_id::create("gpio_seq");
    m_gpio_seq.start(m_gpio_env.m_agent.m_sequencer);

    #(100ns);
    phase.drop_objection(this);
  endtask
endclass
