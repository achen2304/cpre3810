-------------------------------------------------------------------------
-- Testbench for Data Memory Module
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- tb_dmem.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a VHDL testbench for the data memory
-- module (mem.vhd). The testbench:
-- 1. Reads initial 10 values from memory (addresses 0x0 to 0x9)
-- 2. Writes those values to new locations starting at 0x100
-- 3. Reads back the written values to verify correct operation
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_dmem is
    generic(gCLK_HPER : time := 10 ns);  -- Half clock period
end tb_dmem;

architecture behavior of tb_dmem is

    constant cCLK_PER : time := gCLK_HPER * 2;  -- Full clock period
    constant DATA_WIDTH : integer := 32;
    constant ADDR_WIDTH : integer := 10;

    component mem is
        generic (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10
        );
        port (
            clk    : in std_logic;
            addr   : in std_logic_vector((ADDR_WIDTH-1) downto 0);
            data   : in std_logic_vector((DATA_WIDTH-1) downto 0);
            we     : in std_logic := '1';
            q      : out std_logic_vector((DATA_WIDTH-1) downto 0)
        );
    end component;

    -- Test signals
    signal s_clk : std_logic := '0';
    signal s_addr : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
    signal s_data : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal s_we : std_logic := '0';
    signal s_q : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal sim_finished : std_logic := '0';

    -- Array to store read values
    type memory_array is array(0 to 9) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal read_values : memory_array;

begin

    -- Instantiate the Device Under Test (DUT) - labeled as dmem
    dmem: mem
    generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map(
        clk  => s_clk,
        addr => s_addr,
        data => s_data,
        we   => s_we,
        q    => s_q
    );

    -- Clock generation process
    P_CLK: process
    begin
        while sim_finished = '0' loop
            s_clk <= '0';
            wait for gCLK_HPER;
            s_clk <= '1';
            wait for gCLK_HPER;
        end loop;
        wait;
    end process;

    -- Test process
    P_TB: process
    begin
        -- Initialize signals
        s_we <= '0';  -- Start in read mode
        s_addr <= (others => '0');
        s_data <= (others => '0');
        
        wait for cCLK_PER * 3;  -- Wait for memory initialization and settling
        
        report "=== Starting Data Memory Test ===" severity note;

        -- Phase 1: Read initial 10 values from memory (addresses 0x0 to 0x9)
        report "Phase 1: Reading initial values from addresses 0x0 to 0x9" severity note;
        
        for i in 0 to 9 loop
            -- Set address for reading
            s_addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            wait for cCLK_PER;  -- Wait for address to settle and read to complete
            
            -- Store the read value
            read_values(i) <= s_q;
            
            report "Read from address 0x" & integer'image(i) & 
                   ": 0x" & to_hstring(s_q) & 
                   " (decimal: " & integer'image(to_integer(signed(s_q))) & ")" severity note;
        end loop;

        -- Phase 2: Write values to new locations starting at 0x100
        report "Phase 2: Writing values to addresses 0x100 to 0x109" severity note;
        s_we <= '1';  -- Enable write mode
        
        for i in 0 to 9 loop
            -- Set address for writing (0x100 + i)
            s_addr <= std_logic_vector(to_unsigned(256 + i, ADDR_WIDTH)); -- 0x100 = 256
            s_data <= read_values(i);  -- Write the previously read value
            
            wait for cCLK_PER;  -- Wait for write to complete on clock edge
            
            report "Wrote to address 0x" & integer'image(256 + i) & 
                   ": 0x" & to_hstring(read_values(i)) & 
                   " (decimal: " & integer'image(to_integer(signed(read_values(i)))) & ")" severity note;
        end loop;

        -- Phase 3: Read back written values to verify
        report "Phase 3: Reading back written values for verification" severity note;
        s_we <= '0';  -- Switch back to read mode
        
        for i in 0 to 9 loop
            -- Set address for reading back (0x100 + i)
            s_addr <= std_logic_vector(to_unsigned(256 + i, ADDR_WIDTH)); -- 0x100 = 256
            wait for cCLK_PER;  -- Wait for read to complete
            
            -- Verify the read value matches what was written
            if s_q = read_values(i) then
                report "PASS: Address 0x" & integer'image(256 + i) & 
                       " verification successful. Read: 0x" & to_hstring(s_q) severity note;
            else
                report "ERROR: Address 0x" & integer'image(256 + i) & 
                       " verification failed! Expected: 0x" & to_hstring(read_values(i)) &
                       ", Got: 0x" & to_hstring(s_q) severity error;
            end if;
        end loop;

        -- Summary
        report "=== Memory Test Summary ===" severity note;
        report "Expected initial values (decimal): -1, 2, -3, 4, 5, 6, -7, -8, 9, -10" severity note;
        report "Test operations completed:" severity note;
        report "  1. Read 10 initial values from addresses 0x0-0x9" severity note;
        report "  2. Wrote same values to addresses 0x100-0x109" severity note;
        report "  3. Verified written values by reading them back" severity note;
        report "=== Data Memory Test Completed Successfully! ===" severity note;
        
        -- Stop simulation
        sim_finished <= '1';
        wait;
    end process;

end behavior;
