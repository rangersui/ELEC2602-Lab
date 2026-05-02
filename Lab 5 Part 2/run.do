vlib work
vlog *.v
vsim -voptargs=+acc work.lab5_p2_TB
add wave sim:/lab5_p2_TB/*
add wave sim:/lab5_p2_TB/dut/fsm_inst/current_state
add wave sim:/lab5_p2_TB/dut/fsm_inst/next_state
add wave sim:/lab5_p2_TB/dut/sec_count
add wave sim:/lab5_p2_TB/dut/tick
run 1500ns
