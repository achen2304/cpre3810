-------------------------------------------------------------------------
-- My First RISC-V Datapath Implementation
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of a 
-- simple RISC-V datapath supporting immediate arithmetic instructions.
-- Includes register file, ALU, and ALUSrc multiplexer control.
--
-- Control Table:
-- nAdd_Sub | ALUSrc | Operation
--    0     |   0    | C = A + B (register + register)
--    0     |   1    | C = A + Immediate
--    1     |   0    | C = A - B (register - register)  
--    1     |   1    | C = A - Immediate
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity datapath is
    generic(N : integer := 32);  -- Data width (32-bit for RISC-V)
    port(
        i_CLK        : in std_logic;                         -- Clock
        i_RST        : in std_logic;                         -- Reset
        i_WE         : in std_logic;                         -- Register write enable
        i_ALUSrc     : in std_logic;                         -- ALU source select (0=reg, 1=imm)
        i_nAdd_Sub   : in std_logic;                         -- ALU operation (0=add, 1=sub)
        i_rs1        : in std_logic_vector(4 downto 0);     -- Source register 1 address
        i_rs2        : in std_logic_vector(4 downto 0);     -- Source register 2 address
        i_rd         : in std_logic_vector(4 downto 0);     -- Destination register address
        i_immediate  : in std_logic_vector(N-1 downto 0);   -- Immediate value
        o_result     : out std_logic_vector(N-1 downto 0);  -- ALU result
        o_reg_data1  : out std_logic_vector(N-1 downto 0);  -- Register rs1 data (for debug)
        o_reg_data2  : out std_logic_vector(N-1 downto 0)   -- Register rs2 data (for debug)
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

    component addsub is
        generic(N : integer := 32);
        port(
            i_A       : in std_logic_vector(N-1 downto 0); -- Input A
            i_B       : in std_logic_vector(N-1 downto 0); -- Input B
            nAdd_Sub  : in std_logic;                       -- Add/Sub control
            o_S       : out std_logic_vector(N-1 downto 0); -- Sum/Difference
            o_Cout    : out std_logic                       -- Carry-out (unused)
        );
    end component;

    component mux2t1_N is
        generic(N : integer := 16);
        port(
            i_S  : in std_logic;
            i_D0 : in std_logic_vector(N-1 downto 0);
            i_D1 : in std_logic_vector(N-1 downto 0);
            o_O  : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Internal signals
    signal s_read_data1 : std_logic_vector(N-1 downto 0);  -- Data from rs1
    signal s_read_data2 : std_logic_vector(N-1 downto 0);  -- Data from rs2
    signal s_alu_input_b : std_logic_vector(N-1 downto 0); -- ALU input B (after mux)
    signal s_alu_result : std_logic_vector(N-1 downto 0);  -- ALU output
    signal s_carry_out : std_logic;                         -- Unused carry output

begin

    -- Register File Instance
    REGISTER_FILE: regfile
    generic map(N => N)
    port map(
        i_CLK        => i_CLK,
        i_RST        => i_RST,
        i_WE         => i_WE,
        i_rs1        => i_rs1,
        i_rs2        => i_rs2,
        i_rd         => i_rd,
        i_write_data => s_alu_result,  -- Write ALU result back to register
        o_read_data1 => s_read_data1,
        o_read_data2 => s_read_data2
    );

    -- ALUSrc Multiplexer: Select between register data and immediate
    ALU_SRC_MUX: mux2t1_N
    generic map(N => N)
    port map(
        i_S  => i_ALUSrc,      -- 0 = use register, 1 = use immediate
        i_D0 => s_read_data2,  -- Register rs2 data
        i_D1 => i_immediate,   -- Immediate value
        o_O  => s_alu_input_b  -- Selected input to ALU
    );

    -- ALU (Add/Subtract Unit)
    ALU: addsub
    generic map(N => N)
    port map(
        i_A      => s_read_data1,  -- Always from rs1
        i_B      => s_alu_input_b, -- From mux (rs2 or immediate)
        nAdd_Sub => i_nAdd_Sub,    -- 0 = add, 1 = subtract
        o_S      => s_alu_result,  -- ALU result
        o_Cout   => s_carry_out    -- Unused carry output
    );

    -- Output assignments
    o_result    <= s_alu_result;  -- ALU result output
    o_reg_data1 <= s_read_data1;  -- Debug: rs1 data
    o_reg_data2 <= s_read_data2;  -- Debug: rs2 data

end structural;
