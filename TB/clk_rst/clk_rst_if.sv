//`timescale 1ns/1ps
interface clk_rst_if;
  timeunit 1ns;
  timeprecision 100ps;

  bit enable;
  bit rst_n;
  logic clk;
endinterface : clk_rst_if
