//`timescale 1ns/1ps
package gpio_pkg;
  timeunit 1ps;
  timeprecision 1ps;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "gpio_sequence_item.sv"
  `include "gpio_sequencer.sv"
  `include "gpio_driver.sv"
  `include "gpio_monitor.sv"
  `include "gpio_agent.sv"
  `include "gpio_env.sv"
  `include "gpio_sequence.sv"

endpackage
