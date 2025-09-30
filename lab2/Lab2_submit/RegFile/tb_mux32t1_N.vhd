-------------------------------------------------------------------------
-- Testbench for 32:1 N-bit Multiplexer
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_mux32t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a VHDL testbench for the 32-to-1
-- N-bit multiplexer. Tests all 32 select combinations to verify
-- correct input selection behavior.
--
-- NOTES:
-- Uses 8-bit data width for easier verification and visualization
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_mux32t1_N is
end tb_mux32t1_N;

architecture behavior of tb_mux32t1_N is

    -- Test with 8-bit data for easier visualization
    constant N : integer := 8;

    component mux32t1_N
        generic(N : integer := 32);
        port(
            i_S   : in std_logic_vector(4 downto 0);
            i_D0  : in std_logic_vector(N-1 downto 0);
            i_D1  : in std_logic_vector(N-1 downto 0);
            i_D2  : in std_logic_vector(N-1 downto 0);
            i_D3  : in std_logic_vector(N-1 downto 0);
            i_D4  : in std_logic_vector(N-1 downto 0);
            i_D5  : in std_logic_vector(N-1 downto 0);
            i_D6  : in std_logic_vector(N-1 downto 0);
            i_D7  : in std_logic_vector(N-1 downto 0);
            i_D8  : in std_logic_vector(N-1 downto 0);
            i_D9  : in std_logic_vector(N-1 downto 0);
            i_D10 : in std_logic_vector(N-1 downto 0);
            i_D11 : in std_logic_vector(N-1 downto 0);
            i_D12 : in std_logic_vector(N-1 downto 0);
            i_D13 : in std_logic_vector(N-1 downto 0);
            i_D14 : in std_logic_vector(N-1 downto 0);
            i_D15 : in std_logic_vector(N-1 downto 0);
            i_D16 : in std_logic_vector(N-1 downto 0);
            i_D17 : in std_logic_vector(N-1 downto 0);
            i_D18 : in std_logic_vector(N-1 downto 0);
            i_D19 : in std_logic_vector(N-1 downto 0);
            i_D20 : in std_logic_vector(N-1 downto 0);
            i_D21 : in std_logic_vector(N-1 downto 0);
            i_D22 : in std_logic_vector(N-1 downto 0);
            i_D23 : in std_logic_vector(N-1 downto 0);
            i_D24 : in std_logic_vector(N-1 downto 0);
            i_D25 : in std_logic_vector(N-1 downto 0);
            i_D26 : in std_logic_vector(N-1 downto 0);
            i_D27 : in std_logic_vector(N-1 downto 0);
            i_D28 : in std_logic_vector(N-1 downto 0);
            i_D29 : in std_logic_vector(N-1 downto 0);
            i_D30 : in std_logic_vector(N-1 downto 0);
            i_D31 : in std_logic_vector(N-1 downto 0);
            o_F   : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Test signals
    signal s_S : std_logic_vector(4 downto 0);
    signal s_D0, s_D1, s_D2, s_D3, s_D4, s_D5, s_D6, s_D7 : std_logic_vector(N-1 downto 0);
    signal s_D8, s_D9, s_D10, s_D11, s_D12, s_D13, s_D14, s_D15 : std_logic_vector(N-1 downto 0);
    signal s_D16, s_D17, s_D18, s_D19, s_D20, s_D21, s_D22, s_D23 : std_logic_vector(N-1 downto 0);
    signal s_D24, s_D25, s_D26, s_D27, s_D28, s_D29, s_D30, s_D31 : std_logic_vector(N-1 downto 0);
    signal s_F : std_logic_vector(N-1 downto 0);

    -- Array to hold expected values for easy verification
    type data_array is array (0 to 31) of std_logic_vector(N-1 downto 0);
    signal expected_data : data_array;

begin

    -- Instantiate the Device Under Test (DUT)
    DUT: mux32t1_N 
    generic map(N => N)
    port map(
        i_S => s_S,
        i_D0 => s_D0, i_D1 => s_D1, i_D2 => s_D2, i_D3 => s_D3,
        i_D4 => s_D4, i_D5 => s_D5, i_D6 => s_D6, i_D7 => s_D7,
        i_D8 => s_D8, i_D9 => s_D9, i_D10 => s_D10, i_D11 => s_D11,
        i_D12 => s_D12, i_D13 => s_D13, i_D14 => s_D14, i_D15 => s_D15,
        i_D16 => s_D16, i_D17 => s_D17, i_D18 => s_D18, i_D19 => s_D19,
        i_D20 => s_D20, i_D21 => s_D21, i_D22 => s_D22, i_D23 => s_D23,
        i_D24 => s_D24, i_D25 => s_D25, i_D26 => s_D26, i_D27 => s_D27,
        i_D28 => s_D28, i_D29 => s_D29, i_D30 => s_D30, i_D31 => s_D31,
        o_F => s_F
    );

    -- Test process
    P_TB: process
    begin
        -- Initialize all inputs with unique, easily identifiable patterns
        -- Each input has a unique value for easy verification
        s_D0  <= "00000000";  expected_data(0)  <= "00000000";
        s_D1  <= "00000001";  expected_data(1)  <= "00000001";
        s_D2  <= "00000010";  expected_data(2)  <= "00000010";
        s_D3  <= "00000011";  expected_data(3)  <= "00000011";
        s_D4  <= "00000100";  expected_data(4)  <= "00000100";
        s_D5  <= "00000101";  expected_data(5)  <= "00000101";
        s_D6  <= "00000110";  expected_data(6)  <= "00000110";
        s_D7  <= "00000111";  expected_data(7)  <= "00000111";
        s_D8  <= "00001000";  expected_data(8)  <= "00001000";
        s_D9  <= "00001001";  expected_data(9)  <= "00001001";
        s_D10 <= "00001010";  expected_data(10) <= "00001010";
        s_D11 <= "00001011";  expected_data(11) <= "00001011";
        s_D12 <= "00001100";  expected_data(12) <= "00001100";
        s_D13 <= "00001101";  expected_data(13) <= "00001101";
        s_D14 <= "00001110";  expected_data(14) <= "00001110";
        s_D15 <= "00001111";  expected_data(15) <= "00001111";
        s_D16 <= "00010000";  expected_data(16) <= "00010000";
        s_D17 <= "00010001";  expected_data(17) <= "00010001";
        s_D18 <= "00010010";  expected_data(18) <= "00010010";
        s_D19 <= "00010011";  expected_data(19) <= "00010011";
        s_D20 <= "00010100";  expected_data(20) <= "00010100";
        s_D21 <= "00010101";  expected_data(21) <= "00010101";
        s_D22 <= "00010110";  expected_data(22) <= "00010110";
        s_D23 <= "00010111";  expected_data(23) <= "00010111";
        s_D24 <= "00011000";  expected_data(24) <= "00011000";
        s_D25 <= "00011001";  expected_data(25) <= "00011001";
        s_D26 <= "00011010";  expected_data(26) <= "00011010";
        s_D27 <= "00011011";  expected_data(27) <= "00011011";
        s_D28 <= "00011100";  expected_data(28) <= "00011100";
        s_D29 <= "00011101";  expected_data(29) <= "00011101";
        s_D30 <= "00011110";  expected_data(30) <= "00011110";
        s_D31 <= "00011111";  expected_data(31) <= "00011111";

        wait for 10 ns;  -- Allow signals to settle

        -- Test all 32 select combinations
        for i in 0 to 31 loop
            -- Set select signal
            s_S <= std_logic_vector(to_unsigned(i, 5));
            wait for 10 ns;
            
            -- Verify correct output
            assert s_F = expected_data(i)
                report "ERROR: Select " & integer'image(i) & 
                       " expected " & integer'image(to_integer(unsigned(expected_data(i)))) &
                       " but got " & integer'image(to_integer(unsigned(s_F)))
                severity error;
            
            -- Report successful test
            report "PASS: Select " & integer'image(i) & " (" &
                   std_logic'image(s_S(4)) & std_logic'image(s_S(3)) & 
                   std_logic'image(s_S(2)) & std_logic'image(s_S(1)) & 
                   std_logic'image(s_S(0)) & ") -> Output = " & 
                   integer'image(to_integer(unsigned(s_F)))
                severity note;
        end loop;
        
        -- Additional targeted tests
        
        -- Test boundary cases
        s_S <= "00000";  -- Select input 0
        wait for 10 ns;
        assert s_F = "00000000" report "ERROR: Boundary test 0 failed" severity error;
        
        s_S <= "11111";  -- Select input 31
        wait for 10 ns;
        assert s_F = "00011111" report "ERROR: Boundary test 31 failed" severity error;
        
        -- Test some middle values
        s_S <= "01111";  -- Select input 15
        wait for 10 ns;
        assert s_F = "00001111" report "ERROR: Middle test 15 failed" severity error;
        
        s_S <= "10000";  -- Select input 16
        wait for 10 ns;
        assert s_F = "00010000" report "ERROR: Middle test 16 failed" severity error;
        
        report "All multiplexer tests completed successfully!" severity note;
        wait;
    end process;

end behavior;
