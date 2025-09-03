// clk_rst_driver.sv
//`timescale 1ns/1ps
class spi_driver extends uvm_driver #(spi_seq_item);

  `uvm_component_utils(spi_driver)
  
  virtual spi_if spi_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    // Get interface reference from config database
    if(!uvm_config_db#(virtual spi_if)::get(this, "", "spi_vif", spi_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
  endfunction  

  task run_phase(uvm_phase phase);
    spi_seq_item req;
    forever begin
      seq_item_port.get_next_item(req);

      // Drive signals to DUT here
      spi_vif.sclk = 1'b0;
      spi_vif.ss = 1'b0;
      #(500ns);
      spi_vif.mosi = req.write;
      spi_vif.ss = 1'b1;
      #(500ns);
      spi_vif.sclk = 1'b1;
      #(1us);
      for (int i = 0; i<3;i++) begin
        spi_vif.sclk = 1'b0;
        spi_vif.mosi = req.address[i];
        #(1us);
        spi_vif.sclk = 1'b1;
        #(1us);
      end
      for (int i = 0; i<8; i++) begin
        spi_vif.sclk = 1'b0;
        spi_vif.mosi = req.value[i];
        #(1us);
        spi_vif.sclk = 1'b1;
        #(1us);
      end
      spi_vif.sclk = 1'b0;
      #(1us);
      spi_vif.mosi = 1'b0;
      spi_vif.ss = 1'b0;
      #(1us);
      spi_vif.sclk = 1'bx;
      spi_vif.mosi = 1'bx;
      spi_vif.ss = 1'bx;
      //`uvm_info("clk_rst_driver", $sformatf("Driving enable_clock=%0b, reset=%0b, reset_dur=%d", req.enable_clock, req.reset_val, req.reset_lenght), UVM_LOW);

      seq_item_port.item_done();
    end
  endtask
endclass : spi_driver
