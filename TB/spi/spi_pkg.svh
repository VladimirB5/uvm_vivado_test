//`timescale 1ns/1ps
package spi_pkg;
  timeunit 1ps;
  timeprecision 1ps;

  import uvm_pkg::*;
  import irq_pkg::*;
  import gpio_pkg::*;
  `include "uvm_macros.svh"

  `include "spi_sequence_item.sv"
  `include "RAL/spi_ral.sv"
  `include "RAL/gpio2reg_predictor.sv"
  `include "spi_sequencer.sv"
  `include "spi_driver.sv"
  `include "spi_monitor.sv"
  `include "spi_agent.sv"
  `include "spi_env.sv"
  `include "spi_sequence.sv"

endpackage
