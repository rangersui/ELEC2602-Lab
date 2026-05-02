vlib work
vlog *.v
vsim -voptargs=+acc work.lab5_p1_TB
add wave sim:/lab5_p1_TB/*
add wave sim:/lab5_p1_TB/dut/sec_count
add wave sim:/lab5_p1_TB/dut/one_sec_pulse
run 2000ns
