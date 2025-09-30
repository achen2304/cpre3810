-------------------------------------------------------------------------
-- Testbench for RISC-V Register File
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_regfile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a VHDL testbench for the RISC-V
-- register file. Tests write/read operations, register 0 behavior,
-- and dual read port functionality.
--
-- NOTES:
-- Comprehensive test covering all register file operations
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_regfile is
    generic(gCLK_HPER : time := 10 ns);  -- Half clock period
end tb_regfile;

architecture behavior of tb_regfile is

    constant cCLK_PER : time := gCLK_HPER * 2;  -- Full clock period
    constant N : integer := 32;  -- 32-bit data width

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

    -- Test signals
    signal s_CLK, s_RST, s_WE : std_logic := '0';
    signal s_rs1, s_rs2, s_rd : std_logic_vector(4 downto 0) := (others => '0');
    signal s_write_data, s_read_data1, s_read_data2 : std_logic_vector(N-1 downto 0) := (others => '0');
    signal sim_finished : std_logic := '0';  -- Signal to stop clock

begin

    -- Instantiate the Device Under Test (DUT)
    DUT: regfile
    generic map(N => N)
    port map(
        i_CLK        => s_CLK,
        i_RST        => s_RST,
        i_WE         => s_WE,
        i_rs1        => s_rs1,
        i_rs2        => s_rs2,
        i_rd         => s_rd,
        i_write_data => s_write_data,
        o_read_data1 => s_read_data1,
        o_read_data2 => s_read_data2
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
        wait;  -- Stop clock when simulation is finished
    end process;

    -- Test process
    P_TB: process
    begin
        -- Initialize signals
        s_RST <= '1';
        s_WE <= '0';
        s_rs1 <= "00000";
        s_rs2 <= "00000";
        s_rd <= "00000";
        s_write_data <= (others => '0');
        wait for cCLK_PER;

        -- Release reset
        s_RST <= '0';
        wait for cCLK_PER;

        report "=== Starting Register File Tests ===" severity note;

        -- Test 1: Verify register 0 always returns 0
        report "Test 1: Register 0 always returns 0" severity note;
        s_rs1 <= "00000";  -- Read register 0
        s_rs2 <= "00000";  -- Read register 0
        wait for cCLK_PER;
        assert s_read_data1 = std_logic_vector(to_unsigned(0, 32)) and s_read_data2 = std_logic_vector(to_unsigned(0, 32))
            report "ERROR: Register 0 should always be 0" severity error;
        report "PASS: Register 0 correctly returns 0" severity note;

        -- Test 2: Try to write to register 0 (should be ignored)
        report "Test 2: Attempt to write to register 0 (should be ignored)" severity note;
        s_WE <= '1';
        s_rd <= "00000";  -- Try to write to register 0
        s_write_data <= std_logic_vector(to_unsigned(123456789, 32));  -- Large decimal value
        wait for cCLK_PER;
        s_WE <= '0';
        
        -- Read register 0 again
        s_rs1 <= "00000";
        wait for cCLK_PER;
        assert s_read_data1 = std_logic_vector(to_unsigned(0, 32))
            report "ERROR: Register 0 was modified when it shouldn't be" severity error;
        report "PASS: Register 0 write correctly ignored" severity note;

        -- Test 3: Write and read from various registers
        report "Test 3: Write and read from registers 1-31" severity note;
        for i in 1 to 31 loop
            -- Write unique data to register i
            s_WE <= '1';
            s_rd <= std_logic_vector(to_unsigned(i, 5));
            s_write_data <= std_logic_vector(to_unsigned(i * 1000 + 123, 32)); -- Unique pattern
            wait for cCLK_PER;
            s_WE <= '0';
            
            -- Read back the data
            s_rs1 <= std_logic_vector(to_unsigned(i, 5));
            wait for cCLK_PER;
            
            -- Verify correct data
            assert s_read_data1 = std_logic_vector(to_unsigned(i * 1000 + 123, 32))
                report "ERROR: Register " & integer'image(i) & " write/read failed" severity error;
        end loop;
        report "PASS: All registers 1-31 write/read correctly" severity note;

        -- Test 4: Test dual read ports
        report "Test 4: Test dual read ports" severity note;
        -- Write different values to registers 5 and 10
        s_WE <= '1';
        s_rd <= "00101";  -- Register 5
        s_write_data <= std_logic_vector(to_unsigned(305419896, 32));  -- Valid decimal value
        wait for cCLK_PER;
        
        s_rd <= "01010";  -- Register 10
        s_write_data <= std_logic_vector(to_unsigned(987654321, 32));  -- Valid decimal value
        wait for cCLK_PER;
        s_WE <= '0';
        
        -- Read both simultaneously
        s_rs1 <= "00101";  -- Read register 5
        s_rs2 <= "01010";  -- Read register 10
        wait for cCLK_PER;
        
        assert s_read_data1 = std_logic_vector(to_unsigned(305419896, 32)) and s_read_data2 = std_logic_vector(to_unsigned(987654321, 32))
            report "ERROR: Dual read ports failed" severity error;
        report "PASS: Dual read ports work correctly" severity note;

        -- Test 5: Write enable functionality
        report "Test 5: Write enable functionality" severity note;
        -- Write to register 15
        s_WE <= '1';
        s_rd <= "01111";  -- Register 15
        s_write_data <= std_logic_vector(to_unsigned(1717986918, 32));  -- Valid decimal value
        wait for cCLK_PER;
        s_WE <= '0';
        
        -- Try to "write" with WE disabled
        s_WE <= '0';  -- Write disabled
        s_rd <= "01111";  -- Same register
        s_write_data <= std_logic_vector(to_unsigned(1111111111, 32));  -- Different valid decimal value
        wait for cCLK_PER;
        
        -- Read register 15
        s_rs1 <= "01111";
        wait for cCLK_PER;
        
        assert s_read_data1 = std_logic_vector(to_unsigned(1717986918, 32))
            report "ERROR: Data changed when write enable was disabled" severity error;
        report "PASS: Write enable correctly controls writes" severity note;

        -- Test 6: Reset functionality
        report "Test 6: Reset functionality" severity note;
        -- Apply reset
        s_RST <= '1';
        wait for cCLK_PER;
        s_RST <= '0';
        
        -- Check that some previously written registers are now 0
        s_rs1 <= "00101";  -- Register 5 (previously had decimal 305419896)
        s_rs2 <= "01010";  -- Register 10 (previously had decimal 987654321)
        wait for cCLK_PER;
        
        assert s_read_data1 = std_logic_vector(to_unsigned(0, 32)) and s_read_data2 = std_logic_vector(to_unsigned(0, 32))
            report "ERROR: Reset did not clear registers" severity error;
        report "PASS: Reset correctly clears all registers" severity note;

        -- Test 7: Edge case - simultaneous read/write to same register
        report "Test 7: Simultaneous read/write to same register" severity note;
        -- Write to register 20
        s_WE <= '1';
        s_rd <= "10100";  -- Register 20
        s_write_data <= std_logic_vector(to_unsigned(2000000000, 32));  -- Valid large decimal value
        s_rs1 <= "10100";  -- Read from same register simultaneously
        wait for cCLK_PER;
        s_WE <= '0';
        
        -- The read should show the NEW value after the clock edge
        wait for cCLK_PER;
        assert s_read_data1 = std_logic_vector(to_unsigned(2000000000, 32))
            report "ERROR: Simultaneous read/write failed" severity error;
        report "PASS: Simultaneous read/write works correctly" severity note;

        report "=== All Register File Tests Completed Successfully! ===" severity note;
        
        -- IMPORTANT: Stop the simulation properly
        sim_finished <= '1';  -- Signal to stop clock
        report "Simulation finished - stopping now" severity note;
        wait;
    end process;

end behavior;
