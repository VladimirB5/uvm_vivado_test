`include "uvm_macros.svh"
import uvm_pkg::*;
import irq_pkg::*;

`uvm_analysis_imp_decl(_irq)

class irq_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(irq_scoreboard)

  uvm_analysis_imp_irq #(irq_item, irq_scoreboard) irq_item_collected_export;

  int VECT_CNT, PASS_CNT, ERR_CNT;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    irq_item_collected_export = new("irq_item_collected_export",  this);

  endfunction : build_phase

  // Called whenever monitor writes a transaction
  function void write_irq(irq_item pkt);
    `uvm_info("SCOREBOARD", $sformatf("Got transaction: %s", pkt.convert2string()), UVM_MEDIUM)
    pkt.print();
  endfunction

  task run_phase(uvm_phase phase);

  endtask

  function void PASS();
    VECT_CNT++;
    PASS_CNT++;
  endfunction

  function void ERROR();
    VECT_CNT++;
    ERR_CNT++;
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
//    // check that FIFOs are empty...
//    if (VECT_CNT) begin
//      if (!ERR_CNT)
//        `uvm_info("SCOREBOARD PASSED", $sformatf("\n\n\n*** TEST PASSED, vectors: %0d, pass: %0d", VECT_CNT, PASS_CNT), UVM_LOW)
//      else
//        `uvm_error("SCOREBOARD FAILED", $sformatf("\n\n\n*** TEST FAILERD, vectors: %0d, errors: %0d", VECT_CNT, ERR_CNT))
//    end else
//      `uvm_info("SCOREBOARD NO DATA", $sformatf("vectors: %0d, pass: %0d, err: %0d", VECT_CNT, PASS_CNT, ERR_CNT), UVM_LOW)
//
//    if (m_gpio_fifo.is_empty() == 1'b0)
//      `uvm_error("SCOREBOARD FIFO check", "TLM GPIO FIFO is not empty !")
//    if (m_spi_fifo.is_empty() == 1'b0)
//      `uvm_error("SCOREBOARD FIFO check", "TLM SPI FIFO is not empty !")
  endfunction
endclass

