onerror {exit -code 1}
vlib work
vlog -work work spi_slave.vo
vlog -work work Waveform1.vwf.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.spi_slave_vlg_vec_tst -voptargs="+acc"
vcd file -direction spi_slave.msim.vcd
vcd add -internal spi_slave_vlg_vec_tst/*
vcd add -internal spi_slave_vlg_vec_tst/i1/*
run -all
quit -f
