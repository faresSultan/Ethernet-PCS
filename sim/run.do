vlib work
vmap work work

vlog rtl/*.v 
vlog tb/*.sv
vsim -voptargs=+acc work.tb_3b4b
add wave -position insertpoint sim:/tb_3b4b/*
run -all