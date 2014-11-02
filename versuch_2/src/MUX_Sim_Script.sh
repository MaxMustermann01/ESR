#!/bin/sh

ghdl -a --ieee=standard MUX.vhd

ghdl -a --ieee=standard tb_MUX.vhd

ghdl -e --ieee=standard tb_MUX

ghdl -r --ieee=standard tb_MUX --vcd=MUX.vcd --stop-time=1us

gtkwave MUX.vcd