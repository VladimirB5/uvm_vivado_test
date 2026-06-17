// clk_rst_env.sv
//`timescale 1ns/1ps
class spi_env extends uvm_env;

  spi_reg_block   m_regmodel;
  spi_agent m_agent;
  spi_reg_adapter m_spi_adapter;
  uvm_reg_predictor #(spi_seq_item) spi2reg_predictor;

  gpio2reg_predictor m_gpio2reg;

  `uvm_component_utils(spi_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_regmodel = spi_reg_block::type_id::create("m_regmodel", this);
    m_regmodel.build();
    m_spi_adapter = spi_reg_adapter::type_id::create("m_spi_adapter", this);
    spi2reg_predictor =  new("spi2reg_predictor",this);
    m_agent = spi_agent::type_id::create("spi_agent", this);
    m_gpio2reg = gpio2reg_predictor::type_id::create("m_gpio2reg", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    // connect RAL to spi_sequencer, adapter is used
    m_regmodel.spi_reg_map.set_sequencer(m_agent.m_sequencer, m_spi_adapter);
    spi2reg_predictor.map = m_regmodel.spi_reg_map;
    spi2reg_predictor.adapter = m_spi_adapter;
    m_agent.m_monitor.spi_ap.connect(spi2reg_predictor.bus_in);
    m_gpio2reg.ral = m_regmodel;
    m_agent.m_monitor.spi_ap.connect(m_gpio2reg.spi_item_collected_export);
  endfunction
endclass
