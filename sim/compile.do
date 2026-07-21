vlib work
vmap work work

vlog -sv +incdir+../rtl \
    ../rtl/enc_5b6b.v \
    ../rtl/enc_3b4b.v \
    ../rtl/encoder_8b10b.v \
    ../rtl/decoder_8b10b.v \
    ../rtl/comma_align.v \
    ../rtl/pcs_sync.v \
    ../rtl/elastic_buffer.v \
    ../rtl/pcs_tx.v \
    ../rtl/pcs_rx.v \
    ../rtl/pcs_top.v

vlog -sv +incdir+../tb ../tb/tb_top.sv
