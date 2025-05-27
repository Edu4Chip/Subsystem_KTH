# This script was generated automatically by bender.
if [ info exists search_path ] {
    set search_path_initial $search_path
} else {
    set search_path_initial {}
}
set ROOT "/home/nooshin/Documents/synth/fft1cell_genus/rtl/interface/kth_ss"

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/common/agu/./rtl/agu.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/common/agu_fft/./rtl/mux_rotator.sv" \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/common/agu_fft/./rtl/twiddle_addr.sv" \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/common/agu_fft/./rtl/agu_fft.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/common/fsm/./rtl/fsm.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/resources/complex_dpu_impl__uvcilbfxawa/./rtl/complex_dpu_pkg.sv" \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/resources/complex_dpu_impl__uvcilbfxawa/./rtl/adder.sv" \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/resources/complex_dpu_impl__uvcilbfxawa/./rtl/multiplier.sv" \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/resources/complex_dpu_impl__uvcilbfxawa/./rtl/complex_dpu.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/resources/radix2_bu_impl__geetgwgvwme/./rtl/radix2_bu.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/resources/rf_io_impl__gcuvy23b1jt/./rtl/rf_io.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/controllers/sequencer_impl__bofiw7zs7vj/./rtl/sequencer.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/resources/swb_impl__dixk93xtnmt/./rtl/swb_pkg.sv" \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/resources/swb_impl__dixk93xtnmt/./rtl/swb.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/cells/cell_single_row_impl__vwlutpz2gsg/./rtl/cell_single_row.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/interface/io_buffer/./rtl/io_buffer.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/interface/apb_slave_interface/./rtl/apb_slave_interface.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/fabric/./rtl/fabric.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "/home/nooshin/Documents/synth/fft1cell_genus/rtl/interface/fabric_wrapper/./rtl/fabric_wrapper.sv" \
    ]

set search_path $search_path_initial
set_db init_hdl_search_path $search_path

read_hdl -language sv \
    -define { \
        TARGET_GENUS \
        TARGET_SYNTHESIS \
    } \
    [list \
        "$ROOT/./rtl/kth_ss.sv" \
    ]

set search_path $search_path_initial
