# QuestaSim Script for Enhanced RISC-V Datapath with Memory Support
# run_datapath_test.do

# Create clean work library
vdel -lib work -all
vlib work

# Compile basic components
echo "Compiling basic components..."
vcom -2008 -work work invg.vhd
vcom -2008 -work work andg2.vhd
vcom -2008 -work work org2.vhd
vcom -2008 -work work xorg2.vhd

# Compile arithmetic components
echo "Compiling arithmetic components..."
vcom -2008 -work work fulladder.vhd
vcom -2008 -work work nbit_adder.vhd
vcom -2008 -work work nbit_inverter.vhd
vcom -2008 -work work addsub.vhd

# Compile multiplexer components
echo "Compiling multiplexer components..."
vcom -2008 -work work mux2t1.vhd
vcom -2008 -work work mux2t1_N.vhd
vcom -2008 -work work mux32t1_N.vhd

# Compile register file components
echo "Compiling register file components..."
vcom -2008 -work work dffg.vhd
vcom -2008 -work work nbit_reg.vhd
vcom -2008 -work work decoder5t32.vhd
vcom -2008 -work work regfile.vhd

# Compile extension components
echo "Compiling extension components..."
vcom -2008 -work work signext.vhd
vcom -2008 -work work zeroext.vhd

# Compile memory component
echo "Compiling memory component..."
vcom -2008 -work work mem.vhd

# Compile main datapath
echo "Compiling enhanced datapath..."
vcom -2008 -work work datapath.vhd

# Compile testbench
echo "Compiling testbench..."
vcom -2008 -work work tb_datapath.vhd

# Start simulation
echo "Starting simulation..."
vsim -voptargs="+acc" work.tb_datapath

# Load memory initialization file
echo "Loading memory initialization..."
mem load -infile dmem_loadstore.hex -format hex /tb_datapath/DUT/DATA_MEM/ram

# Add waves for comprehensive analysis
echo "Adding waveforms..."

# Control signals
add wave -divider "Control Signals"
add wave -position insertpoint sim:/tb_datapath/s_CLK
add wave -position insertpoint sim:/tb_datapath/s_RST
add wave -position insertpoint sim:/tb_datapath/s_RegWrite
add wave -position insertpoint sim:/tb_datapath/s_ALUSrc
add wave -position insertpoint sim:/tb_datapath/s_nAdd_Sub
add wave -position insertpoint sim:/tb_datapath/s_MemRead
add wave -position insertpoint sim:/tb_datapath/s_MemWrite
add wave -position insertpoint sim:/tb_datapath/s_MemToReg
add wave -position insertpoint sim:/tb_datapath/s_ExtSel

# Register addresses
add wave -divider "Register Addresses"
add wave -position insertpoint -radix unsigned sim:/tb_datapath/s_rs1
add wave -position insertpoint -radix unsigned sim:/tb_datapath/s_rs2
add wave -position insertpoint -radix unsigned sim:/tb_datapath/s_rd
add wave -position insertpoint -radix decimal sim:/tb_datapath/s_immediate

# Data paths
add wave -divider "Data Paths"
add wave -position insertpoint -radix hex sim:/tb_datapath/s_reg_data1
add wave -position insertpoint -radix hex sim:/tb_datapath/s_reg_data2
add wave -position insertpoint -radix hex sim:/tb_datapath/s_ALU_result
add wave -position insertpoint -radix hex sim:/tb_datapath/s_mem_data

# Internal datapath signals
add wave -divider "Internal Signals"
add wave -position insertpoint -radix hex sim:/tb_datapath/DUT/s_extended_immediate
add wave -position insertpoint -radix hex sim:/tb_datapath/DUT/s_alu_input2
add wave -position insertpoint -radix hex sim:/tb_datapath/DUT/s_write_data
add wave -position insertpoint -radix hex sim:/tb_datapath/DUT/s_mem_addr

# Memory array for debugging
add wave -divider "Memory Contents"
add wave -position insertpoint -radix hex sim:/tb_datapath/DUT/DATA_MEM/ram

# Configure wave display
configure wave -namecolwidth 250
configure wave -valuecolwidth 120
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2

# Run simulation
echo "Running simulation..."
run 500 ns

# Zoom to fit
wave zoom full

echo "=========================================="
echo "Enhanced RISC-V Datapath Simulation Complete!"
echo "=========================================="
echo ""
echo "Test Program Summary:"
echo "1. Initialize x25 = 0 (pointer to array A)"
echo "2. Initialize x26 = 256 (pointer to array B)"  
echo "3. Load A[0], A[1] and compute sum"
echo "4. Store cumulative sums in array B"
echo "5. Demonstrate signed offset addressing"
echo ""
echo "Key Features Tested:"
echo "- Load Word (LW) with positive offsets"
echo "- Store Word (SW) with positive offsets"  
echo "- Add Immediate (ADDI) for address setup"
echo "- Register arithmetic (ADD)"
echo "- Sign extension of immediate values"
echo "- Memory interface with proper addressing"
echo ""
echo "Memory Layout:"
echo "- Array A: addresses 0x000-0x006 (values: 1,2,4,8,16,32,64)"
echo "- Array B: addresses 0x100-0x104 (cumulative sums)"
echo ""
echo "Check waveforms and transcript for detailed execution trace!"
