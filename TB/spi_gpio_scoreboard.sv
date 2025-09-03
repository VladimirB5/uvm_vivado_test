`include "uvm_macros.svh"
import uvm_pkg::*;
import spi_pkg::*;
import gpio_pkg::*;

`uvm_analysis_imp_decl(_gpio)
`uvm_analysis_imp_decl(_spi)

class spi_gpio_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(spi_gpio_scoreboard)

  uvm_analysis_imp_gpio #(gpio_seq_item, spi_gpio_scoreboard) gpio_item_collected_export;
  uvm_analysis_imp_spi #(spi_seq_item, spi_gpio_scoreboard) spi_item_collected_export;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gpio_item_collected_export = new("gpio_item_collected_export",  this);
    spi_item_collected_export  = new("spi_item_collected_export",  this);
  endfunction : build_phase

  // Called whenever monitor writes a transaction
 function void write_gpio(gpio_seq_item pkt);
    `uvm_info("SCOREBOARD", $sformatf("Got transaction: %s", pkt.convert2string()), UVM_LOW)
    // compare with reference model here
  endfunction

 function void write_spi(spi_seq_item pkt);
    `uvm_info("SCOREBOARD", $sformatf("Got transaction:"), UVM_LOW)
    pkt.print();
    // compare with reference model here
  endfunction
endclass
