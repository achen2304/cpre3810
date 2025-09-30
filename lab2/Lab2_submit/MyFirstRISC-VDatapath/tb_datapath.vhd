-------------------------------------------------------------------------
-- Testbench for My First RISC-V Datapath
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a VHDL testbench for the simple
-- RISC-V datapath. Implements the specific instruction sequence provided
-- in the lab requirements, demonstrating ADDI, ADD, and SUB operations.
--
-- Expected Final Register State:
-- x1=1, x2=2, x3=3, x4=4, x5=5, x6=6, x7=7, x8=8, x9=9, x10=10
-- x11=3, x12=0, x13=4, x14=-1, x15=5, x16=-2, x17=6, x18=-3, x19=7
-- x20=-35, x21=-28
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_datapath is
    generic(gCLK_HPER : time := 10 ns);  -- Half clock period
end tb_datapath;

architecture behavior of tb_datapath is

    constant cCLK_PER : time := gCLK_HPER * 2;  -- Full clock period
    constant N : integer := 32;  -- 32-bit data width

    component datapath is
        generic(N : integer := 32);
        port(
            i_CLK        : in std_logic;
            i_RST        : in std_logic;
            i_WE         : in std_logic;
            i_ALUSrc     : in std_logic;
            i_nAdd_Sub   : in std_logic;
            i_rs1        : in std_logic_vector(4 downto 0);
            i_rs2        : in std_logic_vector(4 downto 0);
            i_rd         : in std_logic_vector(4 downto 0);
            i_immediate  : in std_logic_vector(N-1 downto 0);
            o_result     : out std_logic_vector(N-1 downto 0);
            o_reg_data1  : out std_logic_vector(N-1 downto 0);
            o_reg_data2  : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Test signals
    signal s_CLK, s_RST, s_WE, s_ALUSrc, s_nAdd_Sub : std_logic := '0';
    signal s_rs1, s_rs2, s_rd : std_logic_vector(4 downto 0) := (others => '0');
    signal s_immediate, s_result, s_reg_data1, s_reg_data2 : std_logic_vector(N-1 downto 0) := (others => '0');
    signal sim_finished : std_logic := '0';

begin

    -- Instantiate the Device Under Test (DUT)
    DUT: datapath
    generic map(N => N)
    port map(
        i_CLK        => s_CLK,
        i_RST        => s_RST,
        i_WE         => s_WE,
        i_ALUSrc     => s_ALUSrc,
        i_nAdd_Sub   => s_nAdd_Sub,
        i_rs1        => s_rs1,
        i_rs2        => s_rs2,
        i_rd         => s_rd,
        i_immediate  => s_immediate,
        o_result     => s_result,
        o_reg_data1  => s_reg_data1,
        o_reg_data2  => s_reg_data2
    );

    -- Clock generation process
    P_CLK: process
    begin
        while sim_finished = '0' loop
            s_CLK <= '0';
            wait for gCLK_HPER;
            s_CLK <= '1';
            wait for gCLK_HPER;
        end loop;
        wait;
    end process;

    -- Test process
    P_TB: process
    begin
        -- Initialize signals - change inputs on negative clock edge
        wait until falling_edge(s_CLK);
        s_RST <= '1';
        s_WE <= '0';
        s_ALUSrc <= '0';
        s_nAdd_Sub <= '0';
        s_rs1 <= "00000";
        s_rs2 <= "00000";
        s_rd <= "00000";
        s_immediate <= (others => '0');
        wait until rising_edge(s_CLK);
        wait until falling_edge(s_CLK);

        -- Release reset
        s_RST <= '0';
        wait until rising_edge(s_CLK);

        report "=== Starting RISC-V Instruction Sequence Test ===" severity note;

        -- Instruction 1: addi x1, zero, 1 # Place "1" in x1
        wait until falling_edge(s_CLK);
        report "Instruction 1: addi x1, zero, 1" severity note;
        s_WE <= '1';            -- regWrite = '1'
        s_ALUSrc <= '1';        -- ALUSrc = '1' (use immediate)
        s_nAdd_Sub <= '0';      -- nAddSub = '0' (addition)
        s_rs1 <= "00000";       -- rs1 = zero (register 0)
        s_rs2 <= "00001";       -- rs2 = 1 (don't care for immediate)
        s_rd <= "00001";        -- rd = 1 (x1)
        s_immediate <= std_logic_vector(to_unsigned(1, 32));
        wait until rising_edge(s_CLK);
        
        assert s_result = std_logic_vector(to_unsigned(1, 32))
            report "ERROR: addi x1, zero, 1 failed" severity error;
        report "PASS: x1 = " & integer'image(to_integer(unsigned(s_result))) severity note;

        -- Instruction 2: addi x2, zero, 2 # Place "2" in x2
        wait until falling_edge(s_CLK);
        report "Instruction 2: addi x2, zero, 2" severity note;
        s_WE <= '1'; s_ALUSrc <= '1'; s_nAdd_Sub <= '0';
        s_rs1 <= "00000"; s_rs2 <= "00000"; s_rd <= "00010";
        s_immediate <= std_logic_vector(to_unsigned(2, 32));
        wait until rising_edge(s_CLK);

        -- Instruction 3: addi x3, zero, 3 # Place "3" in x3
        wait until falling_edge(s_CLK);
        report "Instruction 3: addi x3, zero, 3" severity note;
        s_WE <= '1'; s_ALUSrc <= '1'; s_nAdd_Sub <= '0';
        s_rs1 <= "00000"; s_rs2 <= "00000"; s_rd <= "00011";
        s_immediate <= std_logic_vector(to_unsigned(3, 32));
        wait until rising_edge(s_CLK);

        -- Instruction 4: addi x4, zero, 4 # Place "4" in x4
        wait until falling_edge(s_CLK);
        report "Instruction 4: addi x4, zero, 4" severity note;
        s_WE <= '1'; s_ALUSrc <= '1'; s_nAdd_Sub <= '0';
        s_rs1 <= "00000"; s_rs2 <= "00000"; s_rd <= "00100";
        s_immediate <= std_logic_vector(to_unsigned(4, 32));
        wait until rising_edge(s_CLK);

        -- Instruction 5: addi x5, zero, 5 # Place "5" in x5
        wait until falling_edge(s_CLK);
        report "Instruction 5: addi x5, zero, 5" severity note;
        s_WE <= '1'; s_ALUSrc <= '1'; s_nAdd_Sub <= '0';
        s_rs1 <= "00000"; s_rs2 <= "00000"; s_rd <= "00101";
        s_immediate <= std_logic_vector(to_unsigned(5, 32));
        wait until rising_edge(s_CLK);

        -- Instruction 6: addi x6, zero, 6 # Place "6" in x6
        wait until falling_edge(s_CLK);
        report "Instruction 6: addi x6, zero, 6" severity note;
        s_WE <= '1'; s_ALUSrc <= '1'; s_nAdd_Sub <= '0';
        s_rs1 <= "00000"; s_rs2 <= "00000"; s_rd <= "00110";
        s_immediate <= std_logic_vector(to_unsigned(6, 32));
        wait until rising_edge(s_CLK);

        -- Instruction 7: addi x7, zero, 7 # Place "7" in x7
        wait until falling_edge(s_CLK);
        report "Instruction 7: addi x7, zero, 7" severity note;
        s_WE <= '1'; s_ALUSrc <= '1'; s_nAdd_Sub <= '0';
        s_rs1 <= "00000"; s_rs2 <= "00000"; s_rd <= "00111";
        s_immediate <= std_logic_vector(to_unsigned(7, 32));
        wait until rising_edge(s_CLK);

        -- Instruction 8: addi x8, zero, 8 # Place "8" in x8
        wait until falling_edge(s_CLK);
        report "Instruction 8: addi x8, zero, 8" severity note;
        s_WE <= '1'; s_ALUSrc <= '1'; s_nAdd_Sub <= '0';
        s_rs1 <= "00000"; s_rs2 <= "00000"; s_rd <= "01000";
        s_immediate <= std_logic_vector(to_unsigned(8, 32));
        wait until rising_edge(s_CLK);

        -- Instruction 9: addi x9, zero, 9 # Place "9" in x9
        wait until falling_edge(s_CLK);
        report "Instruction 9: addi x9, zero, 9" severity note;
        s_WE <= '1'; s_ALUSrc <= '1'; s_nAdd_Sub <= '0';
        s_rs1 <= "00000"; s_rs2 <= "00000"; s_rd <= "01001";
        s_immediate <= std_logic_vector(to_unsigned(9, 32));
        wait until rising_edge(s_CLK);

        -- Instruction 10: addi x10, zero, 10 # Place "10" in x10
        wait until falling_edge(s_CLK);
        report "Instruction 10: addi x10, zero, 10" severity note;
        s_WE <= '1'; s_ALUSrc <= '1'; s_nAdd_Sub <= '0';
        s_rs1 <= "00000"; s_rs2 <= "00000"; s_rd <= "01010";
        s_immediate <= std_logic_vector(to_unsigned(10, 32));
        wait until rising_edge(s_CLK);

        -- Instruction 11: add x11, x1, x2 # x11 = x1 + x2 = 1 + 2 = 3
        wait until falling_edge(s_CLK);
        report "Instruction 11: add x11, x1, x2" severity note;
        s_WE <= '1'; s_ALUSrc <= '0'; s_nAdd_Sub <= '0';
        s_rs1 <= "00001"; s_rs2 <= "00010"; s_rd <= "01011";
        wait until rising_edge(s_CLK);
        
        assert s_result = std_logic_vector(to_unsigned(3, 32))
            report "ERROR: add x11, x1, x2 failed, expected 3" severity error;
        report "PASS: x11 = x1 + x2 = " & integer'image(to_integer(unsigned(s_result))) severity note;

        -- Instruction 12: sub x12, x11, x3 # x12 = x11 - x3 = 3 - 3 = 0
        wait until falling_edge(s_CLK);
        report "Instruction 12: sub x12, x11, x3" severity note;
        s_WE <= '1'; s_ALUSrc <= '0'; s_nAdd_Sub <= '1';
        s_rs1 <= "01011"; s_rs2 <= "00011"; s_rd <= "01100";
        wait until rising_edge(s_CLK);
        
        assert s_result = std_logic_vector(to_unsigned(0, 32))
            report "ERROR: sub x12, x11, x3 failed, expected 0" severity error;
        report "PASS: x12 = x11 - x3 = " & integer'image(to_integer(unsigned(s_result))) severity note;

        -- Instruction 13: add x13, x12, x4 # x13 = x12 + x4 = 0 + 4 = 4
        wait until falling_edge(s_CLK);
        report "Instruction 13: add x13, x12, x4" severity note;
        s_WE <= '1'; s_ALUSrc <= '0'; s_nAdd_Sub <= '0';
        s_rs1 <= "01100"; s_rs2 <= "00100"; s_rd <= "01101";
        wait until rising_edge(s_CLK);

        -- Instruction 14: sub x14, x13, x5 # x14 = x13 - x5 = 4 - 5 = -1
        wait until falling_edge(s_CLK);
        report "Instruction 14: sub x14, x13, x5" severity note;
        s_WE <= '1'; s_ALUSrc <= '0'; s_nAdd_Sub <= '1';
        s_rs1 <= "01101"; s_rs2 <= "00101"; s_rd <= "01110";
        wait until rising_edge(s_CLK);

        -- Instruction 15: add x15, x14, x6 # x15 = x14 + x6 = -1 + 6 = 5
        wait until falling_edge(s_CLK);
        report "Instruction 15: add x15, x14, x6" severity note;
        s_WE <= '1'; s_ALUSrc <= '0'; s_nAdd_Sub <= '0';
        s_rs1 <= "01110"; s_rs2 <= "00110"; s_rd <= "01111";
        wait until rising_edge(s_CLK);

        -- Instruction 16: sub x16, x15, x7 # x16 = x15 - x7 = 5 - 7 = -2
        wait until falling_edge(s_CLK);
        report "Instruction 16: sub x16, x15, x7" severity note;
        s_WE <= '1'; s_ALUSrc <= '0'; s_nAdd_Sub <= '1';
        s_rs1 <= "01111"; s_rs2 <= "00111"; s_rd <= "10000";
        wait until rising_edge(s_CLK);

        -- Instruction 17: add x17, x16, x8 # x17 = x16 + x8 = -2 + 8 = 6
        wait until falling_edge(s_CLK);
        report "Instruction 17: add x17, x16, x8" severity note;
        s_WE <= '1'; s_ALUSrc <= '0'; s_nAdd_Sub <= '0';
        s_rs1 <= "10000"; s_rs2 <= "01000"; s_rd <= "10001";
        wait until rising_edge(s_CLK);

        -- Instruction 18: sub x18, x17, x9 # x18 = x17 - x9 = 6 - 9 = -3
        wait until falling_edge(s_CLK);
        report "Instruction 18: sub x18, x17, x9" severity note;
        s_WE <= '1'; s_ALUSrc <= '0'; s_nAdd_Sub <= '1';
        s_rs1 <= "10001"; s_rs2 <= "01001"; s_rd <= "10010";
        wait until rising_edge(s_CLK);

        -- Instruction 19: add x19, x18, x10 # x19 = x18 + x10 = -3 + 10 = 7
        wait until falling_edge(s_CLK);
        report "Instruction 19: add x19, x18, x10" severity note;
        s_WE <= '1'; s_ALUSrc <= '0'; s_nAdd_Sub <= '0';
        s_rs1 <= "10010"; s_rs2 <= "01010"; s_rd <= "10011";
        wait until rising_edge(s_CLK);
        
        assert s_result = std_logic_vector(to_unsigned(7, 32))
            report "ERROR: add x19, x18, x10 failed, expected 7" severity error;
        report "PASS: x19 = x18 + x10 = " & integer'image(to_integer(unsigned(s_result))) severity note;

        -- Instruction 20: addi x20, zero, -35 # Place "-35" in x20
        wait until falling_edge(s_CLK);
        report "Instruction 20: addi x20, zero, -35" severity note;
        s_WE <= '1'; s_ALUSrc <= '1'; s_nAdd_Sub <= '0';
        s_rs1 <= "00000"; s_rs2 <= "00000"; s_rd <= "10100";
        s_immediate <= std_logic_vector(to_signed(-35, 32));
        wait until rising_edge(s_CLK);

        -- Instruction 21: add x21, x19, x20 # x21 = x19 + x20 = 7 + (-35) = -28
        wait until falling_edge(s_CLK);
        report "Instruction 21: add x21, x19, x20" severity note;
        s_WE <= '1'; s_ALUSrc <= '0'; s_nAdd_Sub <= '0';
        s_rs1 <= "10011"; s_rs2 <= "10100"; s_rd <= "10101";
        wait until rising_edge(s_CLK);
        
        assert s_result = std_logic_vector(to_signed(-28, 32))
            report "ERROR: add x21, x19, x20 failed, expected -28" severity error;
        report "PASS: x21 = x19 + x20 = " & integer'image(to_integer(signed(s_result))) severity note;

        -- Final Register State Verification
        report "=== Final Register State Verification ===" severity note;
        s_WE <= '0';  -- Disable writes for final verification
        
        -- Verify final register values
        wait until falling_edge(s_CLK);
        s_rs1 <= "10101"; -- x21
        wait until rising_edge(s_CLK);
        report "Final x21 = " & integer'image(to_integer(signed(s_reg_data1))) & " (expected -28)" severity note;
        
        wait until falling_edge(s_CLK);
        s_rs1 <= "10011"; -- x19
        wait until rising_edge(s_CLK);
        report "Final x19 = " & integer'image(to_integer(signed(s_reg_data1))) & " (expected 7)" severity note;

        report "=== Expected Final Register State ===" severity note;
        report "x0=0, x1=1, x2=2, x3=3, x4=4, x5=5, x6=6, x7=7, x8=8, x9=9, x10=10" severity note;
        report "x11=3, x12=0, x13=4, x14=-1, x15=5, x16=-2, x17=6, x18=-3, x19=7" severity note;
        report "x20=-35, x21=-28" severity note;

        report "=== RISC-V Instruction Sequence Completed Successfully! ===" severity note;
        
        -- Stop simulation
        sim_finished <= '1';
        report "Simulation finished - stopping now" severity note;
        wait;
    end process;

end behavior;
