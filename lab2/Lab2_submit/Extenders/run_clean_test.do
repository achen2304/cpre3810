# QuestaSim Script for Extension Testing - Clean Version
# run_extender_test.do

# Create clean work library
vdel -lib work -all
vlib work

# Compile the extender modules
vcom -2008 -work work signext.vhd
vcom -2008 -work work zeroext.vhd
vcom -2008 -work work extender.vhd

# Compile the testbench
vcom -2008 -work work tb_simple.vhd

# Start simulation
vsim -voptargs="+acc" work.tb_extenders_simple

# Add signals to waveform
add wave -position insertpoint -radix hex sim:/tb_extenders_simple/s_immediate
add wave -position insertpoint sim:/tb_extenders_simple/s_sign_ext
add wave -position insertpoint -radix hex sim:/tb_extenders_simple/s_sign_extended
add wave -position insertpoint -radix hex sim:/tb_extenders_simple/s_zero_extended
add wave -position insertpoint -radix hex sim:/tb_extenders_simple/s_unified_extended

# Add binary representations for detailed analysis
add wave -position insertpoint -radix binary sim:/tb_extenders_simple/s_immediate
add wave -position insertpoint -radix binary sim:/tb_extenders_simple/s_sign_extended
add wave -position insertpoint -radix binary sim:/tb_extenders_simple/s_zero_extended

# Configure wave display
configure wave -namecolwidth 250
configure wave -valuecolwidth 150
configure wave -justifyvalue left

# Run the simulation
run 150 ns

# Zoom to fit all signals
wave zoom full

echo "========================================"
echo "Extension Testing Simulation Complete!"
echo "========================================"
echo ""
echo "Test Cases Completed:"
echo "1. Positive number (+1) - should see 00000001 for both"
echo "2. Negative number (-1) - sign ext: FFFFFFFF, zero ext: 00000FFF"  
echo "3. Zero extension mode test"
echo "4. Large positive (+2047)"
echo "5. Large negative (-2048)"
echo ""
echo "Key Results to Verify:"
echo "- Sign extension: MSB replicated to upper bits"
echo "- Zero extension: Upper bits always zero"
echo "- Unified extender matches individual components"
