#vlib work
#vlog list.svh
#vsim -novopt -suppress 12110 top +testcase=cycle_write_read_no_wait +count=3
#add wave -position insertpoint sim:/top/pif/*
#do wave.do
#run -all


# Includes code coverage too
vlog list.svh
vopt work.top +cover=fcbest -o cycle_write_read_no_wait
vsim -coverage cycle_write_read_no_wait +testcase=cycle_write_read_no_wait +count=3
coverage save -onexit ./ucdb/cycle_write_read_no_wait.ucdb
#add wave -position insertpoint sim:/top/pif/*
do wave.do
run -all
