# script for run xsim in command line

xvlog -sv TB/clk_rst/osc_model.sv
xvlog -sv TB/clk_rst/clk_rst_if.sv
xvlog -sv -L uvm TB/clk_rst/clk_rst_pkg.svh
xvlog -sv -L uvm TB/spi/spi_if.sv
xvlog -sv -L uvm TB/spi/spi_pkg.svh
xvlog -sv -L uvm TB/gpio/gpio_if.sv
xvlog -sv -L uvm TB/gpio/gpio_pkg.svh
xvlog -sv -L uvm TB/tests/tests_pkg.svh

#xvlog -sv eth_pcie_top.sv
xvhdl RTL/spi_gpio_pkg.vhdl
xvhdl RTL/spi.vhdl
xvhdl RTL/synchronizer.vhdl
xvhdl RTL/spi_gpio_top.vhdl
xvlog -sv -L uvm TB/tb_top.sv

#xelab tb_top -s -L uvm top_behav sim_work
xelab tb_top -s sim_work -L uvm -timescale 1ns/1ps -debug all
xsim sim_work -gui # -gui or -R
