#vlib work
#vlog list.svh
#vsim -novopt -suppress 12110 top +testcase=cycle_write_read_no_wait +count=3
#add wave -position insertpoint sim:/top/pif/*
#do wave.do
#run -all


# Includes code coverage too
file mkdir logs
file mkdir ucdb
set timestamp [clock format [clock seconds] -format "%Y-%m-%d_%H-%M-%S"]
set casename "multi_rand_write_read_wait"
set runcount 5
set log_file "./logs/${casename}__${timestamp}.log"

vlog list.svh
vopt work.top +cover=fcbest -o $casename
vsim -coverage $casename \
	-l $log_file \
	+testcase=$casename \
	+count=$runcount
coverage save -onexit ./ucdb/${casename}.ucdb
#add wave -position insertpoint sim:/top/pif/*
do wave.do
run -all
