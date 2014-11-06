
File List
------------
Documentation
  Übung_3.pdf
ISE Project
  Exercise_3.xise
Source files for LED-Code
  src/led.vhd
  src/tb_led.vhd
Source files for debounce
  src/debounce.vhd
User Constraint File
  src/AtlysGeneral.ucf
Bitstream for FPGA
  src/led.bit

Flash Bitstream
---------------
In order to flash the .bit-file
  $ djtgcfg prog -d Atlys -i 0 -f led.bit