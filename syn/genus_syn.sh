mkdir -p genus_results

bender -d ../src/interface/kth_ss script genus -t gf22 > hierarchy.tcl

cd genus_results

genus -f ../scr/global_variables.tcl \
      -f ../scr/library_variables.tcl \
      -f ../scr/genus_topdown.tcl

