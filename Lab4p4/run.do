vlib work
vlog *.v
vsim -voptargs=+acc work.lab4_p4_TB
add wave sim:/lab4_p4_TB/*
run 2000ns
