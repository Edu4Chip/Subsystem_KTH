# This script was generated automatically by bender.
set ROOT "/home/saba/edu4chip/Subsystem_KTH/src/tb"

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/common/agu/./rtl/agu.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/common/agu_fft/./rtl/mux_rotator.sv" \
    "/home/saba/edu4chip/Subsystem_KTH/src/common/agu_fft/./rtl/twiddle_addr.sv" \
    "/home/saba/edu4chip/Subsystem_KTH/src/common/agu_fft/./rtl/agu_fft.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/common/fsm/./rtl/fsm.sv" \

}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/resources/complex_dpu_impl__uvcilbfxawa/./rtl/complex_dpu_pkg.sv" \
    "/home/saba/edu4chip/Subsystem_KTH/src/resources/complex_dpu_impl__uvcilbfxawa/./rtl/adder.sv" \
    "/home/saba/edu4chip/Subsystem_KTH/src/resources/complex_dpu_impl__uvcilbfxawa/./rtl/multiplier.sv" \
    "/home/saba/edu4chip/Subsystem_KTH/src/resources/complex_dpu_impl__uvcilbfxawa/./rtl/complex_dpu.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/resources/radix2_bu_impl__geetgwgvwme/./rtl/radix2_bu.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/resources/rf_io_impl__gcuvy23b1jt/./rtl/rf_io.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/controllers/sequencer_impl__bofiw7zs7vj/./rtl/sequencer.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/resources/swb_impl__dixk93xtnmt/./rtl/swb_pkg.sv" \
    "/home/saba/edu4chip/Subsystem_KTH/src/resources/swb_impl__dixk93xtnmt/./rtl/swb.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/cells/cell_single_row_impl__vwlutpz2gsg/./rtl/cell_single_row.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/interface/io_buffer/./rtl/io_buffer.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/interface/apb_slave_interface/./rtl/apb_slave_interface.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/fabric/./rtl/fabric.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/interface/fabric_wrapper/./rtl/fabric_wrapper.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "/home/saba/edu4chip/Subsystem_KTH/src/interface/kth_ss/./rtl/kth_ss.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIM" \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "$ROOT/./rtl/kth_ss_tb.sv" \
}]} {return 1}

