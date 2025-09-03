`include "uvm_macros.svh"
import uvm_pkg::*;
import spi_pkg::*;
import gpio_pkg::*;

//`uvm_analysis_imp_decl(_gpio)

class spi_gpio_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(spi_gpio_scoreboard)

  uvm_analysis_imp #(gpio_seq_item, spi_gpio_scoreboard) gpio_item_collected_export;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gpio_item_collected_export = new("gpio_item_collected_export",  this);
  endfunction : build_phase

  // Called whenever monitor writes a transaction
 function void write(gpio_seq_item pkt);
    `uvm_info("SCOREBOARD", $sformatf("Got transaction: %s", pkt.convert2string()), UVM_LOW)
    // compare with reference model here
  endfunction
endclass
