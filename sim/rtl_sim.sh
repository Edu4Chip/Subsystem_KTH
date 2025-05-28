mkdir -p ./temp
cp ../sw/bin/instr.bin temp
cp ../sw/bin/sram_image_in.bin temp
cp ./simulate.do temp
cp ./waves.do temp

cd temp

bender -d ../../src/tb script vsim -t sim > read_src.do

vsim -do simulate.do 


