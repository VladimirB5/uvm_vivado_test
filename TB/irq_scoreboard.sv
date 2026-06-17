`include "uvm_macros.svh"
import uvm_pkg::*;
import irq_pkg::*;

`uvm_analysis_imp_decl(_irq)
`uvm_analysis_imp_decl(_pred)

class irq_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(irq_scoreboard)

  uvm_analysis_imp_irq #(irq_item, irq_scoreboard) irq_item_collected_export;
  uvm_analysis_imp_pred #(irq_item, irq_scoreboard) pred_item_collected_export;
  uvm_tlm_fifo #(irq_item) m_mon_fifo;
  uvm_tlm_fifo #(irq_item) m_pred_fifo;

  int VECT_CNT, PASS_CNT, ERR_CNT;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    irq_item_collected_export = new("irq_item_collected_export",  this);
    pred_item_collected_export = new("pred_item_collected_export", this);
    m_mon_fifo  = new("m_mon_fifo", this);
    m_pred_fifo = new("m_pred_fifo", this);
  endfunction : build_phase

  // Called whenever monitor writes a transaction
  function void write_irq(irq_item pkt);
    `uvm_info("IRQ SCOREBOARD", $sformatf("Got transaction(irq mon): %s", pkt.convert2string()), UVM_LOW)
    //pkt.print();
    void'(m_mon_fifo.try_put(pkt));
  endfunction

  function void write_pred(irq_item pkt);
    `uvm_info("IRQ SCOREBOARD", $sformatf("Got transaction(pred): %s", pkt.convert2string()), UVM_LOW)
    //pkt.print();
    void'(m_pred_fifo.try_put(pkt));
  endfunction

  task run_phase(uvm_phase phase);
    irq_item m_pred;
    irq_item m_mon;
    forever begin
      // first IRQ goes to '1'
      m_pred_fifo.get(m_pred); // first should arrive from monitor
      m_mon_fifo.get(m_mon);
      if(m_pred.compare(m_mon))
        PASS();
      else
        ERROR();
      // then goes to '0';
      m_mon_fifo.get(m_mon);
      m_pred_fifo.get(m_pred);
      if(m_pred.compare(m_mon))
        PASS();
      else
        ERROR();
    end
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
    // check that FIFOs are empty...
    if (VECT_CNT) begin
      if (!ERR_CNT)
          `uvm_info("IRQ SCOREBOARD PASSED", $sformatf("\n\n\n*** TEST PASSED, vectors: %0d, pass: %0d", VECT_CNT, PASS_CNT), UVM_LOW)
      else
        `uvm_error("IRQ SCOREBOARD FAILED", $sformatf("\n\n\n*** TEST FAILED, vectors: %0d, errors: %0d", VECT_CNT, ERR_CNT))
    end else
      `uvm_info("IRQ SCOREBOARD NO DATA", $sformatf("vectors: %0d, pass: %0d, err: %0d", VECT_CNT, PASS_CNT, ERR_CNT), UVM_LOW)

    if (m_pred_fifo.is_empty() == 1'b0)
      `uvm_error("IRQ SCOREBOARD FIFO check", "TLM PRED FIFO is not empty !")
    if (m_mon_fifo.is_empty() == 1'b0)
      `uvm_error("IRQ SCOREBOARD FIFO check", "TLM MON FIFO is not empty !")
  endfunction
endclass

