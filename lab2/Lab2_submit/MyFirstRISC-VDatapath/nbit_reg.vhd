library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_reg is
    generic(
        N : integer := 32
    );
    port(
        i_CLK : in std_logic;                       -- Clock input
        i_RST : in std_logic;                       -- Reset input
        i_WE  : in std_logic;                       -- Write enable input
        i_D   : in std_logic_vector(N-1 downto 0); -- Data input
        o_Q   : out std_logic_vector(N-1 downto 0) -- Data output
    );
end nbit_reg;

architecture structural of nbit_reg is

    -- Component declaration for dffg
    component dffg is
        port(
            i_CLK : in std_logic;     -- Clock input
            i_RST : in std_logic;     -- Reset input
            i_WE  : in std_logic;     -- Write enable input
            i_D   : in std_logic;     -- Data value input
            o_Q   : out std_logic     -- Data value output
        );
    end component;

begin

    -- Generate N instances of dffg flip-flops
    G_NBit_Reg: for i in 0 to N-1 generate
        DFFI: dffg port map(
            i_CLK => i_CLK,
            i_RST => i_RST,
            i_WE  => i_WE,
            i_D   => i_D(i),
            o_Q   => o_Q(i)
        );
    end generate G_NBit_Reg;

end structural;