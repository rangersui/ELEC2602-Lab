vlib work
vlog *.v
vsim -voptargs=+acc work.lab3_P2_TB
add wave sim:/lab3_P2_TB/*
run 500ns