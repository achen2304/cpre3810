library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder is
    port(
        i_A    : in std_logic;   -- Input A
        i_B    : in std_logic;   -- Input B
        i_Cin  : in std_logic;   -- Carry-in
        o_S    : out std_logic;  -- Sum output
        o_Cout : out std_logic   -- Carry-out
    );
end fulladder;

architecture structural of fulladder is
    -- Component declarations
    component xorg2 is
        port(
            i_A : in std_logic;
            i_B : in std_logic;
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
    
    -- Internal signals
    signal s_xor1  : std_logic;  -- A XOR B
    signal s_and1  : std_logic;  -- A AND B
    signal s_and2  : std_logic;  -- Cin AND (A XOR B)
    
begin
    -- First XOR gate: A XOR B
    g_Xor1: xorg2
        port map(
            i_A => i_A,
            i_B => i_B,
            o_F => s_xor1
        );
    
    -- Second XOR gate: (A XOR B) XOR Cin = Sum
    g_Xor2: xorg2
        port map(
            i_A => s_xor1,
            i_B => i_Cin,
            o_F => o_S
        );
    
    -- First AND gate: A AND B
    g_And1: andg2
        port map(
            i_A => i_A,
            i_B => i_B,
            o_F => s_and1
        );
    
    -- Second AND gate: Cin AND (A XOR B)
    g_And2: andg2
        port map(
            i_A => i_Cin,
            i_B => s_xor1,
            o_F => s_and2
        );
    
    -- OR gate: (A AND B) OR (Cin AND (A XOR B)) = Carry-out
    g_Or: org2
        port map(
            i_A => s_and1,
            i_B => s_and2,
            o_F => o_Cout
        );

end structural;