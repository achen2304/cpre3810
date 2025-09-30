library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is
    port(
        i_D0 : in std_logic;   -- Data input 0
        i_D1 : in std_logic;   -- Data input 1  
        i_S  : in std_logic;   -- Select signal
        o_O  : out std_logic   -- Output
    );
end mux2t1;

architecture structural of mux2t1 is
    -- Component declarations
    component invg is
        port(
            i_A : in std_logic;
            o_F : out std_logic
        );
    end component;
    
    component andg2 is
        port(
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic
        );
    end component;
    
    component org2 is
        port(
            i_A : in std_logic;
            i_B : in std_logic;
            o_F : out std_logic
        );
    end component;
    
    -- Internal signal declarations
    signal s_notS   : std_logic;  -- NOT i_S
    signal s_and0   : std_logic;  -- i_D0 AND (NOT i_S)
    signal s_and1   : std_logic;  -- i_D1 AND i_S
    
begin
    -- Instantiate NOT gate for select signal
    g_Not: invg
        port map(
            i_A => i_S,
            o_F => s_notS
        );
    
    -- Instantiate AND gate for first term (i_D0 AND NOT i_S)
    g_And0: andg2
        port map(
            i_A => i_D0,
            i_B => s_notS,
            o_F => s_and0
        );
    
    -- Instantiate AND gate for second term (i_D1 AND i_S)
    g_And1: andg2
        port map(
            i_A => i_D1,
            i_B => i_S,
            o_F => s_and1
        );
    
    -- Instantiate OR gate for final output
    g_Or: org2
        port map(
            i_A => s_and0,
            i_B => s_and1,
            o_F => o_O
        );

end structural;
