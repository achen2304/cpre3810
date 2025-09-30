-------------------------------------------------------------------------
-- Enhanced RISC-V Datapath with Memory Support
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural VHDL implementation of
-- a simplified RISC-V processor datapath with support for:
-- - Immediate arithmetic (ADDI)
-- - Register arithmetic (ADD, SUB)
-- - Load instructions (LW)
-- - Store instructions (SW)
-- - Memory interface with proper address calculation
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity datapath is
    generic(N : integer := 32);
    port(
        i_CLK        : in std_logic;                        -- Clock
        i_RST        : in std_logic;                        -- Reset
        i_RegWrite   : in std_logic;                        -- Register write enable
        i_ALUSrc     : in std_logic;                        -- ALU source select
        i_nAdd_Sub   : in std_logic;                        -- ALU operation select
        i_MemRead    : in std_logic;                        -- Memory read enable
        i_MemWrite   : in std_logic;                        -- Memory write enable
        i_MemToReg   : in std_logic;                        -- Memory to register select
        i_ExtSel     : in std_logic;                        -- Extension type select
        i_rs1        : in std_logic_vector(4 downto 0);     -- Source register 1
        i_rs2        : in std_logic_vector(4 downto 0);     -- Source register 2
        i_rd         : in std_logic_vector(4 downto 0);     -- Destination register
        i_immediate  : in std_logic_vector(11 downto 0);    -- 12-bit immediate
        o_ALU_result : out std_logic_vector(N-1 downto 0);  -- ALU result output
        o_mem_data   : out std_logic_vector(N-1 downto 0);  -- Memory data output
        o_reg_data1  : out std_logic_vector(N-1 downto 0);  -- Register data 1
        o_reg_data2  : out std_logic_vector(N-1 downto 0)   -- Register data 2
    );
end datapath;

architecture structural of datapath is

    -- Component declarations
    component regfile is
        generic(N : integer := 32);
        port(
            i_CLK        : in std_logic;
            i_RST        : in std_logic;
            i_WE         : in std_logic;
            i_rs1        : in std_logic_vector(4 downto 0);
            i_rs2        : in std_logic_vector(4 downto 0);
            i_rd         : in std_logic_vector(4 downto 0);
            i_write_data : in std_logic_vector(N-1 downto 0);
            o_read_data1 : out std_logic_vector(N-1 downto 0);
            o_read_data2 : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    component signextender is
        generic(
            INPUT_WIDTH  : integer := 12;
            OUTPUT_WIDTH : integer := 32
        );
        port(
            i_immediate : in  std_logic_vector(INPUT_WIDTH-1 downto 0);
            o_extended  : out std_logic_vector(OUTPUT_WIDTH-1 downto 0)
        );
    end component;
    
    component zeroextender is
        generic(
            INPUT_WIDTH  : integer := 12;
            OUTPUT_WIDTH : integer := 32
        );
        port(
            i_immediate : in  std_logic_vector(INPUT_WIDTH-1 downto 0);
            o_extended  : out std_logic_vector(OUTPUT_WIDTH-1 downto 0)
        );
    end component;
    
    component mux2t1_N is
        generic(N : integer := 32);
        port(
            i_S  : in std_logic;
            i_D0 : in std_logic_vector(N-1 downto 0);
            i_D1 : in std_logic_vector(N-1 downto 0);
            o_O  : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    component addsub is
        generic(N : integer := 32);
        port(
            nAdd_Sub : in std_logic;
            i_A      : in std_logic_vector(N-1 downto 0);
            i_B      : in std_logic_vector(N-1 downto 0);
            o_S      : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    component mem is
        generic (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10
        );
        port (
            clk  : in std_logic;
            addr : in std_logic_vector(9 downto 0);  -- 10-bit address
            data : in std_logic_vector(31 downto 0); -- 32-bit data
            we   : in std_logic;
            q    : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Internal signals
    signal s_reg_data1, s_reg_data2 : std_logic_vector(N-1 downto 0);
    signal s_sign_extended, s_zero_extended : std_logic_vector(N-1 downto 0);
    signal s_extended_immediate : std_logic_vector(N-1 downto 0);
    signal s_alu_input2 : std_logic_vector(N-1 downto 0);
    signal s_alu_result : std_logic_vector(N-1 downto 0);
    signal s_mem_data : std_logic_vector(N-1 downto 0);
    signal s_write_data : std_logic_vector(N-1 downto 0);
    signal s_mem_addr : std_logic_vector(9 downto 0);

begin

    -- Register File
    REG_FILE: regfile
    generic map(N => N)
    port map(
        i_CLK        => i_CLK,
        i_RST        => i_RST,
        i_WE         => i_RegWrite,
        i_rs1        => i_rs1,
        i_rs2        => i_rs2,
        i_rd         => i_rd,
        i_write_data => s_write_data,
        o_read_data1 => s_reg_data1,
        o_read_data2 => s_reg_data2
    );

    -- Sign Extender
    SIGN_EXT: signextender
    generic map(
        INPUT_WIDTH  => 12,
        OUTPUT_WIDTH => N
    )
    port map(
        i_immediate => i_immediate,
        o_extended  => s_sign_extended
    );

    -- Zero Extender
    ZERO_EXT: zeroextender
    generic map(
        INPUT_WIDTH  => 12,
        OUTPUT_WIDTH => N
    )
    port map(
        i_immediate => i_immediate,
        o_extended  => s_zero_extended
    );

    -- Extension Selection MUX
    EXT_MUX: mux2t1_N
    generic map(N => N)
    port map(
        i_S  => i_ExtSel,
        i_D0 => s_zero_extended,  -- ExtSel = 0: Zero extension
        i_D1 => s_sign_extended,  -- ExtSel = 1: Sign extension
        o_O  => s_extended_immediate
    );

    -- ALU Input MUX (ALUSrc)
    ALU_SRC_MUX: mux2t1_N
    generic map(N => N)
    port map(
        i_S  => i_ALUSrc,
        i_D0 => s_reg_data2,         -- ALUSrc = 0: Register data
        i_D1 => s_extended_immediate, -- ALUSrc = 1: Extended immediate
        o_O  => s_alu_input2
    );

    -- ALU
    ALU: addsub
    generic map(N => N)
    port map(
        nAdd_Sub => i_nAdd_Sub,
        i_A      => s_reg_data1,
        i_B      => s_alu_input2,
        o_S      => s_alu_result
    );

    -- Memory address is lower 10 bits of ALU result (word-addressable)
    s_mem_addr <= s_alu_result(9 downto 0);

    -- Data Memory
    DATA_MEM: mem
    generic map(
        DATA_WIDTH => 32,
        ADDR_WIDTH => 10
    )
    port map(
        clk  => i_CLK,
        addr => s_mem_addr,
        data => s_reg_data2,  -- Store data comes from rs2
        we   => i_MemWrite,
        q    => s_mem_data
    );

    -- Write-Back MUX (MemToReg)
    WB_MUX: mux2t1_N
    generic map(N => N)
    port map(
        i_S  => i_MemToReg,
        i_D0 => s_alu_result,  -- MemToReg = 0: ALU result
        i_D1 => s_mem_data,    -- MemToReg = 1: Memory data
        o_O  => s_write_data
    );

    -- Output assignments
    o_ALU_result <= s_alu_result;
    o_mem_data   <= s_mem_data;
    o_reg_data1  <= s_reg_data1;
    o_reg_data2  <= s_reg_data2;

end structural;
