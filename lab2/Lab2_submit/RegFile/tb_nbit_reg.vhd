library IEEE;
use IEEE.std_logic_1164.all;

entity tb_nbit_reg is
  generic(gCLK_HPER   : time := 50 ns);
end tb_nbit_reg;

architecture behavior of tb_nbit_reg is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;
  
  -- Test with 8-bit register for easier visualization
  constant N : integer := 8;

  component nbit_reg
    generic(N : integer := 32);
    port(i_CLK : in std_logic;                       -- Clock input
         i_RST : in std_logic;                       -- Reset input
         i_WE  : in std_logic;                       -- Write enable input
         i_D   : in std_logic_vector(N-1 downto 0); -- Data input
         o_Q   : out std_logic_vector(N-1 downto 0) -- Data output
    );
  end component;

  -- Temporary signals to connect to the nbit_reg component
  signal s_CLK, s_RST, s_WE  : std_logic;
  signal s_D, s_Q : std_logic_vector(N-1 downto 0);

begin

  DUT: nbit_reg 
  generic map(N => N)
  port map(i_CLK => s_CLK, 
           i_RST => s_RST,
           i_WE  => s_WE,
           i_D   => s_D,
           o_Q   => s_Q);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    -- Reset the register
    s_RST <= '1';
    s_WE  <= '0';
    s_D   <= "00000000";
    wait for cCLK_PER;

    -- Test 1: Store "10101010"
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= "10101010";
    wait for cCLK_PER;  

    -- Test 2: Keep "10101010" (WE disabled, different input)
    s_RST <= '0';
    s_WE  <= '0';
    s_D   <= "01010101";  -- This should not be stored
    wait for cCLK_PER;  

    -- Test 3: Store "01010101"    
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= "01010101";
    wait for cCLK_PER;  

    -- Test 4: Keep "01010101" (WE disabled)
    s_RST <= '0';
    s_WE  <= '0';
    s_D   <= "11111111";  -- This should not be stored
    wait for cCLK_PER;  

    -- Test 5: Store "11111111"
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= "11111111";
    wait for cCLK_PER;

    -- Test 6: Store "00000000"
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= "00000000";
    wait for cCLK_PER;

    -- Test 7: Test reset functionality while holding data
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= "11110000";
    wait for cCLK_PER;
    
    -- Apply reset (should clear output regardless of WE and input)
    s_RST <= '1';
    s_WE  <= '1';
    s_D   <= "11110000";
    wait for cCLK_PER;

    -- Test 8: Verify reset worked, then store new pattern
    s_RST <= '0';
    s_WE  <= '1';
    s_D   <= "00001111";
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
