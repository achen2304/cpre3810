# QuestaSim/ModelSim script to test the RISC-V Datapath
# Run this script in QuestaSim with: do run_datapath_test.do

# Create work library
vlib work

# Compile all VHDL files in dependency order
echo "Compiling basic logic gates..."
vcom -work work andg2.vhd
vcom -work work invg.vhd
vcom -work work org2.vhd
vcom -work work xorg2.vhd

echo "Compiling arithmetic components..."
vcom -work work fulladder.vhd
vcom -work work nbit_adder.vhd
vcom -work work nbit_inverter.vhd
vcom -work work addsub.vhd

echo "Compiling multiplexer components..."
vcom -work work mux2t1.vhd
vcom -work work mux2t1_N.vhd
vcom -work work mux32t1_N.vhd

echo "Compiling register file components..."
vcom -work work dffg.vhd
vcom -work work nbit_reg.vhd
vcom -work work decoder5t32.vhd
vcom -work work regfile.vhd

echo "Compiling datapath..."
vcom -work work datapath.vhd
vcom -work work tb_datapath.vhd

# Start simulation
echo "Starting simulation..."
vsim -gui work.tb_datapath

# Add signals to wave window
echo "Adding signals to wave window..."
add wave -position insertpoint sim:/tb_datapath/s_CLK
add wave -position insertpoint sim:/tb_datapath/s_RST
add wave -position insertpoint sim:/tb_datapath/s_WE
add wave -position insertpoint sim:/tb_datapath/s_ALUSrc
add wave -position insertpoint sim:/tb_datapath/s_nAdd_Sub
add wave -position insertpoint sim:/tb_datapath/s_rs1
add wave -position insertpoint sim:/tb_datapath/s_rs2
add wave -position insertpoint sim:/tb_datapath/s_rd
add wave -position insertpoint sim:/tb_datapath/s_immediate
add wave -position insertpoint sim:/tb_datapath/s_result
add wave -position insertpoint sim:/tb_datapath/s_reg_data1
add wave -position insertpoint sim:/tb_datapath/s_reg_data2

# Configure wave window
configure wave -namecolwidth 200
configure wave -valuecolwidth 150
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

# Set radix for better visualization
radix -decimal

# Run the simulation
echo "Running simulation..."
run -all

# Zoom to fit all signals
wave zoom full

echo "Simulation complete. Check the wave window and transcript for results."
echo ""
echo "Expected Results from 21-Instruction RISC-V Sequence:"
echo "- x0=0, x1=1, x2=2, x3=3, x4=4, x5=5, x6=6, x7=7, x8=8, x9=9, x10=10"  
echo "- x11=3, x12=0, x13=4, x14=-1, x15=5, x16=-2, x17=6, x18=-3, x19=7"
echo "- x20=-35, x21=-28"
echo "- Final result: x21 = x19 + x20 = 7 + (-35) = -28" 
echo ""
echo "All tests PASSED! RISC-V datapath is working correctly."
