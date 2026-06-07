LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

library work;
-- Package Declaration Section
package spi_gpio_pkg is


  -- reg addresses
  CONSTANT  C_ADDR_GPIO_OUT : unsigned(2 downto 0) := "000";
  CONSTANT  C_ADDR_GPIO_IN  : unsigned(2 downto 0) := "001";
  CONSTANT  C_ADDR_GPIO_PD  : unsigned(2 downto 0) := "010";
  CONSTANT  C_ADDR_GPIO_PU  : unsigned(2 downto 0) := "011";
  CONSTANT  C_ADDR_INPUT_EN : unsigned(2 downto 0) := "100";
  CONSTANT  C_ADDR_INT_EN   : unsigned(2 downto 0) := "101";
  CONSTANT  C_ADDR_INT_STS  : unsigned(2 downto 0) := "110";

end package spi_gpio_pkg;
