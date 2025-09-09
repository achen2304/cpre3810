library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_adder is
    generic(
        N : integer := 32  -- Default to 32-bit adder
    );
    port(
        i_A    : in std_logic_vector(N-1 downto 0);   -- N-bit input A
        i_B    : in std_logic_vector(N-1 downto 0);   -- N-bit input B
        i_Cin  : in std_logic;                        -- Carry-in
        o_S    : out std_logic_vector(N-1 downto 0);  -- N-bit sum
        o_Cout : out std_logic                        -- Carry-out
    );
end nbit_adder;

architecture structural of nbit_adder is
    -- Component declaration for 1-bit full adder
    component fulladder is
        port(
            i_A    : in std_logic;
            i_B    : in std_logic;
            i_Cin  : in std_logic;
            o_S    : out std_logic;
            o_Cout : out std_logic
        );
    end component;
    
    -- Internal carry signals
    signal s_carry : std_logic_vector(N downto 0);
    
begin
    -- Connect input carry-in to first carry signal
    s_carry(0) <= i_Cin;
    
    -- Generate N full adders
    gen_adders: for i in 0 to N-1 generate
        adder_i: fulladder
            port map(
                i_A    => i_A(i),
                i_B    => i_B(i),
                i_Cin  => s_carry(i),
                o_S    => o_S(i),
                o_Cout => s_carry(i+1)
            );
    end generate gen_adders;
    
    -- Connect final carry to output
    o_Cout <= s_carry(N);

end structural;