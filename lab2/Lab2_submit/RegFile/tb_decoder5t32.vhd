library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_decoder5t32 is
end tb_decoder5t32;

architecture behavior of tb_decoder5t32 is

    component decoder5t32
        port(
            i_A : in std_logic_vector(4 downto 0);   -- 5-bit input address
            o_Y : out std_logic_vector(31 downto 0)  -- 32-bit one-hot output
        );
    end component;

    -- Test signals
    signal s_A : std_logic_vector(4 downto 0);
    signal s_Y : std_logic_vector(31 downto 0);
    
    -- Helper function to count number of high bits
    function count_ones(input_vector : std_logic_vector) return integer is
        variable count : integer := 0;
    begin
        for i in input_vector'range loop
            if input_vector(i) = '1' then
                count := count + 1;
            end if;
        end loop;
        return count;
    end function;

begin

    -- Instantiate the Device Under Test (DUT)
    DUT: decoder5t32 
    port map(
        i_A => s_A,
        o_Y => s_Y
    );

    -- Test process
    P_TB: process
    begin
        -- Test all possible 5-bit input combinations (0 to 31)
        for i in 0 to 31 loop
            -- Convert integer to 5-bit std_logic_vector
            s_A <= std_logic_vector(to_unsigned(i, 5));
            wait for 10 ns;
            
            -- Verify that exactly one output bit is high
            assert count_ones(s_Y) = 1 
                report "ERROR: Expected exactly one output bit high for input " & integer'image(i) &
                       ", but got " & integer'image(count_ones(s_Y)) & " bits high"
                severity error;
            
            -- Verify that the correct bit is high
            assert s_Y(i) = '1'
                report "ERROR: Expected output bit " & integer'image(i) & " to be high for input " & 
                       integer'image(i) & ", but it was low"
                severity error;
            
            -- Report successful test
            report "PASS: Input " & integer'image(i) & " (" & 
                   std_logic'image(s_A(4)) & std_logic'image(s_A(3)) & 
                   std_logic'image(s_A(2)) & std_logic'image(s_A(1)) & 
                   std_logic'image(s_A(0)) & ") -> Output bit " & 
                   integer'image(i) & " is high"
                severity note;
        end loop;
        
        -- Additional edge case tests
        
        -- Test input "00000" (should activate output 0)
        s_A <= "00000";
        wait for 10 ns;
        assert s_Y = "00000000000000000000000000000001"
            report "ERROR: Input 00000 failed" severity error;
        
        -- Test input "11111" (should activate output 31)  
        s_A <= "11111";
        wait for 10 ns;
        assert s_Y = "10000000000000000000000000000000"
            report "ERROR: Input 11111 failed" severity error;
        
        -- Test some middle values
        s_A <= "01010"; -- 10 in decimal
        wait for 10 ns;
        assert s_Y = "00000000000000000000010000000000"
            report "ERROR: Input 01010 (decimal 10) failed" severity error;
            
        s_A <= "10101"; -- 21 in decimal
        wait for 10 ns;
        assert s_Y = "00000000001000000000000000000000"
            report "ERROR: Input 10101 (decimal 21) failed" severity error;
        
        report "All decoder tests completed successfully!" severity note;
        wait;
    end process;

end behavior;
