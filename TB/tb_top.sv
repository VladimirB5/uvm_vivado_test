module tb_top;
   import uvm_pkg::*;
   import tests_pkg::*;

  logic clk;
  clk_rst_if if_clk_rst();

  spi_if spi_if_i();

  osc_model i_osc_model (
    .enable(if_clk_rst.enable),
    // sys_clk
    .clk(clk)
  );

  spi_gpio_top i_spi_gpio_top
  (
    // SPI
    .sclk(spi_if_i.sclk),
    .ss(spi_if_i.ss),
    .mosi(spi_if_i.mosi),
    .miso(spi_if_i.miso),
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
    uvm_config_db#(virtual spi_if)::set(null, "*", "spi_vif", spi_if_i);
    // Start the test
    run_test("basic_test");
  end

endmodule
