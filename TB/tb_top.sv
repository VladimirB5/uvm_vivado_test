module tb_top;
   import uvm_pkg::*;
   import tests_pkg::*;

  logic clk;
  clk_rst_if if_clk_rst();

  osc_model i_osc_model (
    .enable(if_clk_rst.enable),
    // sys_clk
    .clk(clk)
  );

  spi_gpio_top i_spi_gpio_top
  (
    // SPI
    .sclk(),
    .ss(),
    .mosi(),
    .miso(),
    // GPIO
    .clk(clk),
    .rst_n(if_clk_rst.rst_n),
    .gpio_in(),
    .gpio_out(),
    .gpio_pd(),
    .gpio_pu(),
    .interupt()
  );

  initial begin
    // Place the interface into the UVM configuration database
    uvm_config_db#(virtual clk_rst_if)::set(null, "*", "clk_rst_vif", if_clk_rst);
    // Start the test
    run_test("basic_test");
  end

endmodule
