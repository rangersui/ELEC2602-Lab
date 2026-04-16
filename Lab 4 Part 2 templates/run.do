vlib work
vlog *.v
vsim -voptargs=+acc work.lab4_p2_TB
add wave sim:/lab4_p2_TB/*
run 500ns