# Simple SPI 2 GPIO expander
It is simple desing written in VHDL verified by UVM TB under XSIM simulator (Vivado native simulator).<br>
8 GPIO lines can be controled by SPI interface. <br>
Purpose of this repo is to play with UVM in publicly available tool.<br>

There are several registers accessible through SPI.<br>
Throught these register GPIO can be configured, <br>
written or read values from it.<br>

These registers are: <br>

| register name  | description      | address | acces |
| -------------  | -----------------|---------|-------|
| gpio_out       | GPIO output      |   0     |RW     |
| gpio_in        | GPIO input       |   1     |RO     |
| gpio_pd        | pull down enable |   2     |RW     |
| gpio_pu        | pull up enable   |   3     |RW     |
| input_en       | input enable     |   4     |RW     |
| int_en         | interrupt enable |   5     |RW     |
| int_clr        | interrupt clear  |   6     |WO     |


## SPI interface
SPI is asynchronous and frame contain 12 bits.<br>
1 bit determine write or read frame (log 1 for read), <br>
3 bits of address, <br>
8 bits of data <br>
Address and data are send from MSB bit. <br>

## GPIO
There is output, input which must enabled, <br>
signals for pull down and pull up. <br>

## UVM
There is uvc for clock and reset, SPI, GPIO. There is also scoreboard. <br>
RAL is used for SPI registers.
