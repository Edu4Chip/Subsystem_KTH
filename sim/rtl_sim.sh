mkdir temp
cd temp
bender -d ../../src/tb script vsim -t sim > read_src.do
cp ../../sw/bin/instr.bin .
cp ../../sw/bin/sram_image_in.bin .
cp ../simulate.do .
cp ../waves.do .
vsim -do simulate.do 


