do compile.do

vsim work.tb_top
add wave -r /tb_top/*
run -all
