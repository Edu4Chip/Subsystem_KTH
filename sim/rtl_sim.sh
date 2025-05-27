bender -d ../src/tb script vsim -t sim > read_src.do

vlib work

vsim -voptargs=+acc -debugDB -do read_src.do -do "do waves.do; log * -r;run -all" work.kth_ss_tb


