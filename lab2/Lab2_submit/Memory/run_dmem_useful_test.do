# QuestaSim Script for Data Memory Testing with Useful Results
# run_dmem_useful_test.do

# Create the work library
vlib work

# Compile the memory module
vcom -2008 -work work mem.vhd

# Compile the testbench
vcom -2008 -work work tb_dmem.vhd

# Start simulation
vsim -voptargs="+acc" work.tb_dmem

# Load memory initialization from hex file (CRITICAL STEP)
# This command loads the hex file into the memory array
# Syntax: mem load -infile <filename> -format hex <memory_path>
mem load -infile dmem_useful_results.hex -format hex /tb_dmem/dmem/ram

# Add signals to waveform for comprehensive analysis
add wave -position insertpoint sim:/tb_dmem/s_clk
add wave -position insertpoint sim:/tb_dmem/s_we
add wave -position insertpoint -radix hex sim:/tb_dmem/s_addr
add wave -position insertpoint -radix hex sim:/tb_dmem/s_data
add wave -position insertpoint -radix hex sim:/tb_dmem/s_q
add wave -position insertpoint -radix hex sim:/tb_dmem/read_values

# Also add the internal memory array for debugging
add wave -position insertpoint -radix hex sim:/tb_dmem/dmem/ram

# Configure wave display for better visibility
configure wave -namecolwidth 200
configure wave -valuecolwidth 150
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

echo "=========================================="
echo "Memory Test Simulation Complete!"
echo "=========================================="
echo ""
echo "Test Sequence Performed:"
echo "1. Read initial values from addresses 0x0-0x9"
echo "2. Write those values to addresses 0x100-0x109" 
echo "3. Read back and verify written values"
echo ""
echo "Expected Values (Hex Format):"
echo "0x0: 00000001 (+1)     0x5: 00000020 (+32)"
echo "0x1: 00000002 (+2)     0x6: FFFFFFFF (-1)"
echo "0x2: 00000004 (+4)     0x7: FFFFFFFE (-2)" 
echo "0x3: 00000008 (+8)     0x8: 00000064 (+100)"
echo "0x4: 00000010 (+16)    0x9: FFFFFF9C (-100)"
echo ""
echo "Verification Points:"
echo "- Powers of 2 sequence: 1,2,4,8,16,32"
echo "- Negative values: -1 (all F's), -2, -100"
echo "- Positive landmark: +100"
echo "- All values should appear identically at 0x100-0x109"
echo ""
echo "Check waveform for:"
echo "- Address transitions: 0x0→0x9, then 0x100→0x109"
echo "- Data values matching expected hex patterns"
echo "- Successful write/read verification"
