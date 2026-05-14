vlib work
vlog *.v
vsim -voptargs=+acc work.cpu_level1_TB
add wave sim:/cpu_level1_TB/clk
add wave sim:/cpu_level1_TB/instruction
add wave sim:/cpu_level1_TB/dut/bus_w
add wave sim:/cpu_level1_TB/dut/ctrl/step
add wave sim:/cpu_level1_TB/dut/ctrl/done
add wave sim:/cpu_level1_TB/r0
add wave sim:/cpu_level1_TB/r1
add wave sim:/cpu_level1_TB/r2
add wave sim:/cpu_level1_TB/r3
add wave sim:/cpu_level1_TB/r4
add wave sim:/cpu_level1_TB/r5
add wave sim:/cpu_level1_TB/r6
add wave sim:/cpu_level1_TB/r7
add wave sim:/cpu_level1_TB/a_value
add wave sim:/cpu_level1_TB/g_value
add wave sim:/cpu_level1_TB/status_zero
add wave sim:/cpu_level1_TB/status_negative
run -all
