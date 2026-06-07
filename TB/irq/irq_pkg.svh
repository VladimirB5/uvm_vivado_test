//`timescale 1ns/1ps
package irq_pkg;
  timeunit 1ps;
  timeprecision 1ps;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "irq_item.sv"
  `include "irq_monitor.sv"


endpackage
