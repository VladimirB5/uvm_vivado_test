//`timescale 1ns/1ps
interface spi_if;
  timeunit 1ns;
  timeprecision 100ps;

  logic sclk;
  logic ss;
  logic mosi;
  logic miso;
endinterface : spi_if
