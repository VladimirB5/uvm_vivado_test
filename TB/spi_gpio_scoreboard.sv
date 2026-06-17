`include "uvm_macros.svh"
import uvm_pkg::*;
import spi_pkg::*;
import gpio_pkg::*;

`uvm_analysis_imp_decl(_gpio)
`uvm_analysis_imp_decl(_spi)

// thisa scoreboard check that SPI writes into GPIO_OUT, GPIO_PD, GPIO_PU will be
// correctly processed
class spi_gpio_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(spi_gpio_scoreboard)

  uvm_analysis_imp_gpio #(gpio_seq_item, spi_gpio_scoreboard) gpio_item_collected_export;
  uvm_analysis_imp_spi #(spi_seq_item, spi_gpio_scoreboard) spi_item_collected_export;

  uvm_tlm_fifo #(gpio_seq_item) m_gpio_fifo;
  uvm_tlm_fifo #(gpio_seq_item) m_spi_fifo;
  gpio_seq_item m_gpio_status;
  gpio_seq_item m_spi_status;
  //
  int VECT_CNT, PASS_CNT, ERR_CNT;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gpio_item_collected_export = new("gpio_item_collected_export",  this);
    spi_item_collected_export  = new("spi_item_collected_export",  this);
    m_gpio_fifo = new("m_gpio_fifo", this);
    m_spi_fifo = new("m_spi_fifo", this);
    m_gpio_status = new("m_gpio_status");
    m_spi_status = new("m_spi_status");
  endfunction : build_phase

  // Called whenever monitor writes a transaction
 function void write_gpio(gpio_seq_item pkt);
    `uvm_info("SCOREBOARD", $sformatf("Got transaction: %s", pkt.convert2string()), UVM_MEDIUM)
    if (!m_gpio_status.compare_out(pkt)) begin // consdider only change in output signals
      m_gpio_status.copy(pkt);
      //pkt.print();
      void'(m_gpio_fifo.try_put(pkt));
    end
  endfunction

 function void write_spi(spi_seq_item pkt);
    `uvm_info("SCOREBOARD", $sformatf("Got transaction:"), UVM_MEDIUM)
    //pkt.print();
    if (pkt.write == 1'b1) begin // check write packet, read are alredy checked by RAL and predictor
      case (pkt.address)
        0: begin
          m_spi_status.gpio_out = pkt.value;
          void'(m_spi_fifo.try_put(m_spi_status));
        end
        2: begin
          m_spi_status.gpio_pd = pkt.value;
          void'(m_spi_fifo.try_put(m_spi_status));
        end
        3: begin
          m_spi_status.gpio_pu = pkt.value;
          void'(m_spi_fifo.try_put(m_spi_status));
        end
      endcase
      //`uvm_info("SCOREBOARD", $sformatf("DATA:"), UVM_LOW)
      //spi_status.print();
    end
  endfunction

  task run_phase(uvm_phase phase);
    gpio_seq_item gpio_pkt;
    gpio_seq_item spi_pkt;
      forever begin
         #(1);
         m_spi_fifo.get(spi_pkt);
         if (m_gpio_fifo.is_empty() == 1'b1) begin
           // there is no GPIO stimuli this can be caused by write same data into same registers
           `uvm_warning("SCOREBOARD", $sformatf("There is no new GPIO, check stimuli in waves"))
           if (m_gpio_status.compare_out(spi_pkt))
             PASS();
           else
             ERROR();
         end else begin
           m_gpio_fifo.get(gpio_pkt);
           if (gpio_pkt.compare_out(spi_pkt))
             PASS();
           else
             ERROR();
         end
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
        `uvm_info("SCOREBOARD PASSED", $sformatf("\n\n\n*** TEST PASSED, vectors: %0d, pass: %0d", VECT_CNT, PASS_CNT), UVM_LOW)
      else
        `uvm_error("SCOREBOARD FAILED", $sformatf("\n\n\n*** TEST FAILED, vectors: %0d, errors: %0d", VECT_CNT, ERR_CNT))
    end else
      `uvm_info("SCOREBOARD NO DATA", $sformatf("vectors: %0d, pass: %0d, err: %0d", VECT_CNT, PASS_CNT, ERR_CNT), UVM_LOW)

    if (m_gpio_fifo.is_empty() == 1'b0)
      `uvm_error("SCOREBOARD FIFO check", "TLM GPIO FIFO is not empty !")
    if (m_spi_fifo.is_empty() == 1'b0)
      `uvm_error("SCOREBOARD FIFO check", "TLM SPI FIFO is not empty !")
  endfunction
endclass
