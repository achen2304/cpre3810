# QuestaSim/ModelSim script to test the 32:1 N-bit multiplexer
# Run this script in QuestaSim with: do run_mux_test.do

# Create work library
vlib work

# Compile all VHDL files
echo "Compiling VHDL files..."
vcom -work work mux32t1_N.vhd
vcom -work work tb_mux32t1_N.vhd

# Start simulation
echo "Starting simulation..."
vsim -gui work.tb_mux32t1_N

# Add signals to wave window
echo "Adding signals to wave window..."
add wave -position insertpoint sim:/tb_mux32t1_N/s_S
add wave -position insertpoint sim:/tb_mux32t1_N/s_D0
add wave -position insertpoint sim:/tb_mux32t1_N/s_D1
add wave -position insertpoint sim:/tb_mux32t1_N/s_D2
add wave -position insertpoint sim:/tb_mux32t1_N/s_D3
add wave -position insertpoint sim:/tb_mux32t1_N/s_D4
add wave -position insertpoint sim:/tb_mux32t1_N/s_D5
add wave -position insertpoint sim:/tb_mux32t1_N/s_D15
add wave -position insertpoint sim:/tb_mux32t1_N/s_D16
add wave -position insertpoint sim:/tb_mux32t1_N/s_D30
add wave -position insertpoint sim:/tb_mux32t1_N/s_D31
add wave -position insertpoint sim:/tb_mux32t1_N/s_F

# Configure wave window for better viewing
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

# Set radix for better visualization
radix -hexadecimal

# Run the simulation
echo "Running simulation..."
run -all

# Zoom to fit all signals
wave zoom full

echo "Simulation complete. Check the wave window and transcript for results."
echo "Note: Only a subset of input signals are shown in wave window for clarity."
echo "The testbench verifies all 32 inputs are working correctly."
