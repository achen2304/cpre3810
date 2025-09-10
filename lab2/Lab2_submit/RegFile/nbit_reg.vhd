library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_reg is
    generic(
        N : integer := 32
    );
    port(
        i_D   : in std_logic_vector(N-1 downto 0);  -- Data input
        i_CLK : in std_logic;                       -- Clock input
        o_Q   : out std_logic_vector(N-1 downto 0)  -- Data output
    );
end nbit_reg;

architecture behavioral of nbit_reg is
    signal r_Q : std_logic_vector(N-1 downto 0) := (others => '0'); -- Internal register signal
begin
    process(i_CLK)
    begin
        if rising_edge(i_CLK) then
            r_Q <= i_D; -- On rising edge of clock, capture input data
        end if;
    end process;

    o_Q <= r_Q; -- Connect internal register to output
end behavioral;