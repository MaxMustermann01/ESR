#!/bin/sh

ghdl -a --ieee=standard SP_Decoder.vhd

ghdl -a --ieee=standard tb_SP_Decoder.vhd

ghdl -e --ieee=standard tb_SP_Decoder

ghdl -r --ieee=standard tb_SP_Decoder --vcd=SP_Decoder.vcd --stop-time=1us

gtkwave SP_Decoder.vcd