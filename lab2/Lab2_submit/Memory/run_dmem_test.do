# QuestaSim Script for Data Memory Testing
# run_dmem_test.do

# Create the work library
vlib work

# Compile the memory module
vcom -2008 -work work mem.vhd

# Compile the testbench
vcom -2008 -work work tb_dmem.vhd

# Start simulation
vsim -voptargs="+acc" work.tb_dmem

# Initialize memory from hex file  
mem load -infile dmem.hex -format hex /tb_dmem/dmem/ram

# Add signals to waveform
add wave -position insertpoint sim:/tb_dmem/s_clk
add wave -position insertpoint sim:/tb_dmem/s_we
add wave -position insertpoint sim:/tb_dmem/s_addr
add wave -position insertpoint sim:/tb_dmem/s_data
add wave -position insertpoint sim:/tb_dmem/s_q
add wave -position insertpoint sim:/tb_dmem/read_values

# Configure wave display
configure wave -namecolwidth 200
configure wave -valuecolwidth 120
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

# Run the simulation
run 1000 ns

# Zoom to fit all signals
wave zoom full

echo "Memory test simulation complete. Check the wave window and transcript for results."
echo ""
echo "Expected Test Sequence:"
echo "1. Read initial 10 values from dmem.hex (addresses 0x0-0x9)"
echo "2. Write those values to new addresses 0x100-0x109" 
echo "3. Read back and verify the written values"
echo ""
echo "Expected initial values: -1, 2, -3, 4, 5, 6, -7, -8, 9, -10"
