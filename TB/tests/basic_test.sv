// basic_test.sv
//`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
import clk_rst_pkg::*;
class basic_test extends uvm_test;
  `uvm_component_utils(basic_test)
    
  clk_rst_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = clk_rst_env::type_id::create("clk_rst_env", this);
  endfunction

  task run_phase(uvm_phase phase);
    clk_rst_sequence seq;
    phase.raise_objection(this);

    seq = clk_rst_sequence::type_id::create("clk_rst_seq");
    //seq.set_clock = 1'b1;
    //seq.enable_clock = 1'b0;
    seq.start(env.agent.sequencer);
    
    #(100ns);

    phase.drop_objection(this);
  endtask
endclass
