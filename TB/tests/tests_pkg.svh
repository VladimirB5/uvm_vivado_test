//`timescale 1ns/1ps
package tests_pkg;
  timeunit 1ps;
  timeprecision 1ps;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import clk_rst_pkg::*;
  import spi_pkg::*;
  import gpio_pkg::*;
  import irq_pkg::*;
  `include "TB/spi_gpio_scoreboard.sv"
  `include "TB/irq_scoreboard.sv"

  // tests
  `include "base_test.sv"
  `include "basic_test.sv"
  `include "gpio_in_test.sv"

endpackage

