// clk_rst_driver.sv
//`timescale 1ns/1ps
class spi_monitor extends uvm_monitor;

  // UVM factory registration
  `uvm_component_utils(spi_monitor)

  virtual spi_if spi_vif;
  spi_seq_item m_spi_tran;
  bit [11:0] data_out;
  bit [11:0] data_in;
  // TLM analysis port
  uvm_analysis_port#(spi_seq_item) spi_ap;


  function new(string name, uvm_component parent);
    super.new(name, parent);
    spi_ap = new("spi_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual spi_if)::get(this, "", "spi_vif", spi_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
  endfunction

  task run_phase(uvm_phase phase);
    int i = 0;
    forever begin
      data_out = 12'h000;
      data_in = 12'h000;
      //@(posedge spi_vif.ss);
      wait (spi_vif.ss === 1'b1); // avoid edges 0 -> X
      m_spi_tran = new();
      fork
        begin
          for (int i = 11; i>=0; i--) begin
            @(posedge spi_vif.sclk);
            data_out[i] = spi_vif.miso;
            data_in[i] = spi_vif.mosi;
          end
          @(negedge spi_vif.ss);
        end
        @(negedge spi_vif.ss);
      join_any
      disable fork;
      if (data_in[11] == 1'b0) begin // write
        m_spi_tran.write = 1'b1;
        m_spi_tran.address = data_in[10:8];
        m_spi_tran.value = data_in[7:0];
      end else begin  // read
        m_spi_tran.write = 1'b0;
        m_spi_tran.address = data_in[10:8];
        m_spi_tran.value = data_out[7:0];
      end
      `uvm_info(get_type_name(), "SPI transaction collected", UVM_HIGH)
      spi_ap.write(m_spi_tran);
    end
  endtask
endclass : spi_monitor
