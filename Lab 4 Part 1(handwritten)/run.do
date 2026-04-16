vlib work
vlog *.v
vsim -voptargs=+acc work.lab4_p1_TB
add wave sim:/lab4_p1_TB/*
run 500ns