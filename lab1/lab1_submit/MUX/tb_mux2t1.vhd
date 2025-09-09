library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux2t1 is
    -- Testbench has no ports
end tb_mux2t1;

architecture behavior of tb_mux2t1 is
    -- Component declaration for the Unit Under Test (UUT)
    component mux2t1 is
        port(
            i_D0 : in std_logic;
            i_D1 : in std_logic;
            i_S  : in std_logic;
            o_O  : out std_logic
        );
    end component;
    
    -- Input signals
    signal s_D0 : std_logic := '0';
    signal s_D1 : std_logic := '0';
    signal s_S  : std_logic := '0';
    
    -- Output signal
    signal s_O  : std_logic;
    
begin
    -- Instantiate the Unit Under Test (UUT)
    DUT: mux2t1
        port map(
            i_D0 => s_D0,
            i_D1 => s_D1,
            i_S  => s_S,
            o_O  => s_O
        );
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Test all combinations exhaustively
        -- Test case 1: S=0, D0=0, D1=0 -> O=0
        s_S <= '0'; s_D0 <= '0'; s_D1 <= '0';
        wait for 10 ns;
        
        -- Test case 2: S=0, D0=0, D1=1 -> O=0
        s_S <= '0'; s_D0 <= '0'; s_D1 <= '1';
        wait for 10 ns;
        
        -- Test case 3: S=0, D0=1, D1=0 -> O=1
        s_S <= '0'; s_D0 <= '1'; s_D1 <= '0';
        wait for 10 ns;
        
        -- Test case 4: S=0, D0=1, D1=1 -> O=1
        s_S <= '0'; s_D0 <= '1'; s_D1 <= '1';
        wait for 10 ns;
        
        -- Test case 5: S=1, D0=0, D1=0 -> O=0
        s_S <= '1'; s_D0 <= '0'; s_D1 <= '0';
        wait for 10 ns;
        
        -- Test case 6: S=1, D0=0, D1=1 -> O=1
        s_S <= '1'; s_D0 <= '0'; s_D1 <= '1';
        wait for 10 ns;
        
        -- Test case 7: S=1, D0=1, D1=0 -> O=0
        s_S <= '1'; s_D0 <= '1'; s_D1 <= '0';
        wait for 10 ns;
        
        -- Test case 8: S=1, D0=1, D1=1 -> O=1
        s_S <= '1'; s_D0 <= '1'; s_D1 <= '1';
        wait for 10 ns;
        
        -- End simulation
        wait;
    end process;

end behavior;