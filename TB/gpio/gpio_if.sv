//`timescale 1ns/1ps
interface gpio_if;
  timeunit 1ns;
  timeprecision 100ps;

  logic [7:0] gpio_in;
  logic [7:0] gpio_out;
  logic [7:0] gpio_pd;
  logic [7:0] gpio_pu;
endinterface : gpio_if

