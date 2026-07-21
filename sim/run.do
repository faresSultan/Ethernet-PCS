vlib work
vmap work work

vlog rtl/*.v 
vlog tb/*.sv
vsim -voptargs=+acc work.tb_top
add wave -position insertpoint sim:/tb_top/*
run -all