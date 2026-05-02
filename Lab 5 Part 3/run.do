vlib work
vlog *.v
vsim -voptargs=+acc work.lab5_p3_TB
add wave sim:/lab5_p3_TB/*
add wave sim:/lab5_p3_TB/dut/n_reg/n_out
add wave sim:/lab5_p3_TB/dut/fsm_inst/current_count
add wave sim:/lab5_p3_TB/dut/fsm_inst/current_type
add wave sim:/lab5_p3_TB/dut/tick
run 2500ns
