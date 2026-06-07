LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

library work;
use work.spi_gpio_pkg.all;

ENTITY spi_gpio_top IS
  port (
  -- SPI
  sclk    : IN std_logic;
  ss      : IN std_logic;
  mosi    : IN std_logic;
  miso    : OUT std_logic;
  -- GPIO
  clk      : IN std_logic;
  rst_n    : IN std_logic;
  gpio_in  : IN std_logic_vector(7 downto 0);
  gpio_out : OUT std_logic_vector(7 downto 0);
  gpio_pd  : OUT std_logic_vector(7 downto 0);
  gpio_pu  : OUT std_logic_vector(7 downto 0);
  interrupt : OUT std_logic --interupt
  );
END ENTITY spi_gpio_top;

ARCHITECTURE rtl OF spi_gpio_top IS

COMPONENT spi IS
  port (
  sclk    : IN std_logic;
  ss      : IN std_logic;
  mosi    : IN std_logic;
  miso    : OUT std_logic;
  -- internal signals
  read    : out std_logic;
  addr    : out unsigned(2 downto 0);
  data_wr : out std_logic_vector(7 downto 0);
  data_rd : in std_logic_vector(7 downto 0);
  valid   : out std_logic
  );
END COMPONENT;

COMPONENT synchronizer is
    Port ( clk       : in  STD_LOGIC;
           res_n     : in  STD_LOGIC;
           enable    : in  STD_LOGIC;
           data_in   : in  STD_LOGIC;
           data_out  : out STD_LOGIC
         );
end COMPONENT;
  -- registers
  signal gpio_out_c, gpio_out_s : std_logic_vector(7 downto 0);
  signal gpio_in_c, gpio_in_s   : std_logic_vector(7 downto 0);
  signal gpio_pd_c, gpio_pd_s   : std_logic_vector(7 downto 0);
  signal gpio_pu_c, gpio_pu_s   : std_logic_vector(7 downto 0);
  signal input_en_c, input_en_s : std_logic_vector(7 downto 0);
  signal int_en_c, int_en_s     : std_logic_vector(7 downto 0);
  signal int_sts_c, int_sts_s   : std_logic_vector(7 downto 0);
  signal int_c, int_s           : std_logic;
  signal pvalid_c, pvalid_s     : std_logic;

  signal data_rd    : std_logic_vector(7 downto 0);
  signal data_wr    : std_logic_vector(7 downto 0);
  signal valid      : std_logic;
  signal read       : std_logic;
  signal addr       : unsigned(2 downto 0);
  signal spi_valid  : std_logic;

BEGIN
-------------------------------------------------------------------------------
-- components
-------------------------------------------------------------------------------
i_spi: spi
  port map(
  sclk    => sclk,
  ss      => ss,
  mosi    => mosi,
  miso    => miso,
  -- internal signals
  read    => read,
  addr    => addr,
  data_wr => data_wr,
  data_rd => data_rd,
  valid   => spi_valid
  );

u0: for i in 0 to 7 generate
  synchro: synchronizer
  Port map(
    clk       => clk,
    res_n     => rst_n,
    enable    => input_en_s(i),
    data_in   => gpio_in(i),
    data_out  => gpio_in_c(i)
  );
end generate u0;

-------------------------------------------------------------------------------
-- sequential
-------------------------------------------------------------------------------
 state_reg : PROCESS (clk, rst_n)
   BEGIN
    IF rst_n = '0' THEN
      gpio_in_s  <= (others => '0');
      gpio_out_s <= (others => '0');
      gpio_pd_s  <= (others => '0');
      gpio_pu_s  <= (others => '0');
      input_en_s <= (others => '0');
      int_en_s   <= (others => '0');
      int_sts_s  <= (others => '0');
      int_s      <= '0';
      pvalid_s   <= '0';
    ELSIF clk = '1' AND clk'EVENT THEN
      gpio_in_s  <= gpio_in_c;
      gpio_out_s <= gpio_out_c;
      gpio_pd_s  <= gpio_pd_c;
      gpio_pu_s  <= gpio_pu_c;
      input_en_s <= input_en_c;
      int_en_s   <= int_en_c;
      int_sts_s  <= int_sts_c;
      int_s      <= int_c;
      pvalid_s   <= pvalid_c;
    END IF;
 END PROCESS state_reg;
-------------------------------------------------------------------------------
-- combinational parts
-------------------------------------------------------------------------------
pvalid_c <= spi_valid;
valid <= '1' when spi_valid = '1' and pvalid_s = '0' else
         '0';

data_rd <= gpio_in_s  when addr = C_ADDR_GPIO_IN and read = '1' else
           gpio_pd_s  when addr = C_ADDR_GPIO_PD and read = '1' else
           gpio_pd_s  when addr = C_ADDR_GPIO_PU and read = '1' else
           int_en_s   when addr = C_ADDR_INT_EN and read = '1' else
           input_en_s when addr = C_ADDR_INPUT_EN and read = '1' else
           gpio_out_s when addr = C_ADDR_GPIO_OUT and read = '1' else
           int_en_s   when addr = C_ADDR_INT_EN and read = '1' else
           int_sts_s  when addr = C_ADDR_INT_STS and read = '1' else
           (others => '0');

gpio_out_c <= data_wr when addr = C_ADDR_GPIO_OUT and valid = '1' and read = '0' else
              gpio_out_s;

gpio_pd_c <= data_wr when addr = C_ADDR_GPIO_PD and valid = '1' and read = '0' else
             gpio_pd_s;

gpio_pu_c <= data_wr when addr = C_ADDR_GPIO_PU and valid = '1' and read = '0' else
             gpio_pu_s;

input_en_c <= data_wr when addr = C_ADDR_INPUT_EN and valid = '1' and read = '0' else
              input_en_s;

int_en_c <= data_wr when addr = C_ADDR_INT_EN and valid = '1' and read = '0' else
            int_en_s;

int_sts_c <= (others => '0') when addr = C_ADDR_INT_STS and valid = '1' and read = '1' else
             (gpio_in_c xor gpio_in_s) and int_en_s;

int_c <= ((int_sts_s(7) or int_sts_s(6)) or (int_sts_s(5) or int_sts_s(4))) or
         ((int_sts_s(3) or int_sts_s(2)) or (int_sts_s(1) or int_sts_s(0)));


-------------------------------------------------------------------------------
-- output assigment
-------------------------------------------------------------------------------
gpio_out <= gpio_out_s;
gpio_pd  <= gpio_pd_s;
gpio_pu  <= gpio_pu_s;
interrupt <= int_s;
END ARCHITECTURE rtl;
