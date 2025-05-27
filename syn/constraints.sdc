# Constraints for the clock and reset signals

create_clock -period 1400 -name clk_in [get_ports clk_in]
set_false_path -from [get_ports reset_int]



