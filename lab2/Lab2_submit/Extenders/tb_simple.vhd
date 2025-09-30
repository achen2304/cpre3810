-------------------------------------------------------------------------
-- Simple Testbench for Extenders
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_extenders_simple is
end tb_extenders_simple;

architecture behavior of tb_extenders_simple is

    constant INPUT_WIDTH  : integer := 12;
    constant OUTPUT_WIDTH : integer := 32;
    
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
    
    component extender is
        generic(
            INPUT_WIDTH  : integer := 12;
            OUTPUT_WIDTH : integer := 32
        );
        port(
            i_immediate : in  std_logic_vector(INPUT_WIDTH-1 downto 0);
            i_sign_ext  : in  std_logic;
            o_extended  : out std_logic_vector(OUTPUT_WIDTH-1 downto 0)
        );
    end component;

    -- Test signals
    signal s_immediate : std_logic_vector(INPUT_WIDTH-1 downto 0) := (others => '0');
    signal s_sign_ext : std_logic := '0';
    signal s_sign_extended : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    signal s_zero_extended : std_logic_vector(OUTPUT_WIDTH-1 downto 0);
    signal s_unified_extended : std_logic_vector(OUTPUT_WIDTH-1 downto 0);

begin

    -- Instantiate the sign extender
    SIGN_EXT: signextender
    generic map(
        INPUT_WIDTH  => INPUT_WIDTH,
        OUTPUT_WIDTH => OUTPUT_WIDTH
    )
    port map(
        i_immediate => s_immediate,
        o_extended  => s_sign_extended
    );
    
    -- Instantiate the zero extender  
    ZERO_EXT: zeroextender
    generic map(
        INPUT_WIDTH  => INPUT_WIDTH,
        OUTPUT_WIDTH => OUTPUT_WIDTH
    )
    port map(
        i_immediate => s_immediate,
        o_extended  => s_zero_extended
    );
    
    -- Instantiate the unified extender
    UNIFIED_EXT: extender
    generic map(
        INPUT_WIDTH  => INPUT_WIDTH,
        OUTPUT_WIDTH => OUTPUT_WIDTH
    )
    port map(
        i_immediate => s_immediate,
        i_sign_ext  => s_sign_ext,
        o_extended  => s_unified_extended
    );

    -- Test process
    P_TB: process
    begin
        report "=== Starting Extension Testing ===" severity note;
        
        -- Test 1: Positive number (1)
        s_immediate <= "000000000001";  -- +1
        s_sign_ext <= '1';
        wait for 20 ns;
        report "Test 1 - Input: +1" severity note;
        report "Sign Ext: " & to_hstring(s_sign_extended) severity note;
        report "Zero Ext: " & to_hstring(s_zero_extended) severity note;
        report "Unified (sign): " & to_hstring(s_unified_extended) severity note;
        
        -- Test 2: Negative number (-1)
        s_immediate <= "111111111111";  -- -1 (all ones)
        s_sign_ext <= '1';
        wait for 20 ns;
        report "Test 2 - Input: -1" severity note;
        report "Sign Ext: " & to_hstring(s_sign_extended) severity note;
        report "Zero Ext: " & to_hstring(s_zero_extended) severity note;
        report "Unified (sign): " & to_hstring(s_unified_extended) severity note;
        
        -- Test 3: Unified extender with zero extension
        s_sign_ext <= '0';
        wait for 20 ns;
        report "Test 3 - Unified zero extension of -1:" severity note;
        report "Unified (zero): " & to_hstring(s_unified_extended) severity note;
        
        -- Test 4: Large positive
        s_immediate <= "011111111111";  -- +2047
        s_sign_ext <= '1';
        wait for 20 ns;
        report "Test 4 - Input: +2047" severity note;
        report "Sign Ext: " & to_hstring(s_sign_extended) severity note;
        report "Zero Ext: " & to_hstring(s_zero_extended) severity note;
        
        -- Test 5: Large negative  
        s_immediate <= "100000000000";  -- -2048
        wait for 20 ns;
        report "Test 5 - Input: -2048" severity note;
        report "Sign Ext: " & to_hstring(s_sign_extended) severity note;
        report "Zero Ext: " & to_hstring(s_zero_extended) severity note;
        
        report "=== Extension Testing Completed! ===" severity note;
        wait;
    end process;

end behavior;
