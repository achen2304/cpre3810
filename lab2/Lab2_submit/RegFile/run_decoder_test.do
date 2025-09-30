# QuestaSim/ModelSim script to test the 5:32 decoder
# Run this script in QuestaSim with: do run_decoder_test.do

# Create work library
vlib work

# Compile all VHDL files
echo "Compiling VHDL files..."
vcom -work work decoder5t32.vhd
vcom -work work tb_decoder5t32.vhd

# Start simulation
echo "Starting simulation..."
vsim -gui work.tb_decoder5t32

# Add signals to wave window
add wave -position insertpoint sim:/tb_decoder5t32/s_A
add wave -position insertpoint sim:/tb_decoder5t32/s_Y

# Configure wave window for better viewing
configure wave -namecolwidth 200
configure wave -valuecolwidth 300
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

# Run the simulation
echo "Running simulation..."
run -all

# Zoom to fit all signals
wave zoom full

echo "Simulation complete. Check the wave window and transcript for results."
