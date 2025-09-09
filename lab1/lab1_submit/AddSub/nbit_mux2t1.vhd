library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_mux2t1 is
    generic(
        N : integer := 32
    );
    port(
        i_D0 : in std_logic_vector(N-1 downto 0);   -- Input 0
        i_D1 : in std_logic_vector(N-1 downto 0);   -- Input 1
        i_S  : in std_logic;                        -- Select signal
        o_O  : out std_logic_vector(N-1 downto 0)   -- Output
    );
end nbit_mux2t1;

architecture structural of nbit_mux2t1 is
    component mux2t1 is
        port(
            i_D0 : in std_logic;
            i_D1 : in std_logic;
            i_S  : in std_logic;
            o_O  : out std_logic
        );
    end component;
    
begin
    gen_muxes: for i in 0 to N-1 generate
        mux_i: mux2t1
            port map(
                i_D0 => i_D0(i),
                i_D1 => i_D1(i),
                i_S  => i_S,
                o_O  => o_O(i)
            );
    end generate gen_muxes;
    
end structural;