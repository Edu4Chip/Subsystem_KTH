source read_src.do
vsim -voptargs=+acc -debugDB work.kth_ss_tb
do waves.do
log * -r
run -all
