//`timescale 1ns/1ps
package clk_rst_pkg;
  timeunit 1ps;
  timeprecision 1ps;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "clk_rst_sequence_item.sv"
  `include "clk_rst_sequencer.sv"
  `include "clk_rst_driver.sv"
  `include "clk_rst_agent.sv"
  `include "clk_rst_env.sv"
  `include "clk_rst_sequence.sv"

endpackage
