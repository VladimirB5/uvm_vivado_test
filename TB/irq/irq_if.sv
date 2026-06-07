//`timescale 1ns/1ps
interface irq_if;
  timeunit 1ns;
  timeprecision 100ps;

  logic interrupt;

endinterface : irq_if
