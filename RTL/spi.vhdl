LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;


ENTITY spi IS
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
END ENTITY spi;

ARCHITECTURE rtl OF spi IS
  -- registers
  signal data_wr_c, data_wr_s : std_logic_vector(7 downto 0);
  signal data_rd_c, data_rd_s : std_logic_vector(6 downto 0);
  signal read_c, read_s : std_logic;
  signal miso_c, miso_s : std_logic;
  signal addr_c, addr_s : std_logic_vector(2 downto 0);
  signal cnt_c, cnt_s : unsigned(2 downto 0);
  signal valid_c, valid_s : std_logic;


  -- fsm read declaration
  TYPE t_spi_state IS (S_HEAD, S_ADDR, S_DATA_RD7, S_DATA_RD, S_DATA_WR, S_END, S_IGNORE);
  SIGNAL fsm_spi_c, fsm_spi_s :t_spi_state;

  begin
-------------------------------------------------------------------------------
-- sequential
-------------------------------------------------------------------------------
 state_reg : PROCESS (sclk, ss)
   BEGIN
    IF ss = '0' THEN
      fsm_spi_s <= S_HEAD;
      read_s <= '0';
      cnt_s <= (others => '0');
      addr_s <= (others => '0');
      data_wr_s <= (others => '0');
      data_rd_s <= (others => '0');
      valid_s <= '0';
    ELSIF sclk = '1' AND sclk'EVENT THEN
      fsm_spi_s <= fsm_spi_c;
      read_s <= read_c;
      cnt_s <= cnt_c;
      addr_s <= addr_c;
      data_wr_s <= data_wr_c;
      data_rd_s <= data_rd_c;
      valid_s <= valid_c;
    END IF;
 END PROCESS state_reg;

 fall_state_reg : PROCESS(sclk, ss)
   BEGIN
     IF ss = '0' THEN
       miso_s <= '0';
     ELSIF sclk = '0' AND sclk'EVENT THEN
       miso_s <= miso_c;
     END IF;
 END PROCESS fall_state_reg;

-------------------------------------------------------------------------------
-- combinational parts
-------------------------------------------------------------------------------

 next_state_spi : PROCESS (fsm_spi_s, read_s, cnt_s, mosi, data_rd, data_rd_s, data_wr_s)
 BEGIN
    fsm_spi_c <= fsm_spi_s;
    read_c <= read_s;
    cnt_c <= cnt_s;
    miso_c <= '0';
    valid_c <= '0';
    data_rd_c <= data_rd_s;
    data_wr_c <= data_wr_s;
    CASE fsm_spi_s IS
      WHEN S_HEAD =>
        read_c <= mosi;
        fsm_spi_c <= S_ADDR;

      WHEN S_ADDR =>
        if (cnt_s = 2) then
          cnt_c <= (others => '0');
          if read_s = '0' then
            fsm_spi_c <= S_DATA_RD7;
          else
            fsm_spi_c <= S_DATA_WR;
          end if;
        else
          cnt_c <= cnt_s + 1;
        end if;

      WHEN S_DATA_RD7 =>
        miso_c <= data_rd(7);
        data_rd_c <= data_rd(6 downto 0);
        fsm_spi_c <= S_DATA_RD;

      WHEN S_DATA_RD =>
        data_rd_c(6 downto 1) <= data_rd_s(5 downto 0);
        miso_c <= data_rd_s(6);
        if (cnt_s = 7) then
          valid_c <= '1';
          fsm_spi_c <= S_END;
        else
          cnt_c <= cnt_s + 1;
        end if;

      WHEN S_DATA_WR =>
        data_wr_c(0) <= mosi;
        data_wr_c(7 downto 1) <= data_wr_s(6 downto 0);
        if (cnt_s = 7) then
          valid_c <= '1';
          fsm_spi_c <= S_END;
        else
          cnt_c <= cnt_s + 1;
        end if;

      WHEN S_END =>
        fsm_spi_c <= S_IGNORE; -- there shoudl be no other clocks

      WHEN S_IGNORE => -- other clocs are ignored


    END CASE;

 END PROCESS next_state_spi;

addr_c <= mosi & addr_s(1 downto 0) when fsm_spi_s = S_ADDR else
          addr_s;


-------------------------------------------------------------------------------
-- output assigment
-------------------------------------------------------------------------------
  miso <= miso_s;
  -- internal signals
  read    <= read_s;
  addr    <= unsigned(addr_s);
  data_wr <= data_wr_s;
  valid   <= valid_s;
END ARCHITECTURE rtl;
