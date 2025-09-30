library IEEE;
use IEEE.std_logic_1164.all;

entity addsub is
    generic(
        N : integer := 32
    );
    port(
        i_A       : in std_logic_vector(N-1 downto 0);   -- Operand A
        i_B       : in std_logic_vector(N-1 downto 0);   -- Operand B
        nAdd_Sub  : in std_logic;                        -- Control: 0=Add, 1=Sub
        o_S       : out std_logic_vector(N-1 downto 0);  -- Sum/Difference
        o_Cout    : out std_logic                        -- Carry-out/Overflow
    );
end addsub;

architecture structural of addsub is
    -- Component declarations
    component nbit_inverter is
        generic(N : integer := 32);
        port(
            i_A : in std_logic_vector(N-1 downto 0);
            o_F : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    component mux2t1_N is
        generic(N : integer := 16);
        port(
            i_S  : in std_logic;
            i_D0 : in std_logic_vector(N-1 downto 0);
            i_D1 : in std_logic_vector(N-1 downto 0);
            o_O  : out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    component nbit_adder is
        generic(N : integer := 32);
        port(
            i_A    : in std_logic_vector(N-1 downto 0);
            i_B    : in std_logic_vector(N-1 downto 0);
            i_Cin  : in std_logic;
            o_S    : out std_logic_vector(N-1 downto 0);
            o_Cout : out std_logic
        );
    end component;
    
    -- Internal signals
    signal s_B_inverted  : std_logic_vector(N-1 downto 0);  -- ~B
    signal s_B_selected  : std_logic_vector(N-1 downto 0);  -- Mux output
    
begin
    -- Instantiate N-bit inverter to create ~B
    inverter_inst: nbit_inverter
        generic map(N => N)
        port map(
            i_A => i_B,
            o_F => s_B_inverted
        );
    
    -- Instantiate N-bit 2:1 mux to select between B and ~B
    mux_inst: mux2t1_N
        generic map(N => N)
        port map(
            i_S  => nAdd_Sub,      -- Select signal
            i_D0 => i_B,           -- Select this when nAdd_Sub = '0' (addition)
            i_D1 => s_B_inverted,  -- Select this when nAdd_Sub = '1' (subtraction)
            o_O  => s_B_selected
        );
    
    -- Instantiate N-bit adder
    adder_inst: nbit_adder
        generic map(N => N)
        port map(
            i_A    => i_A,
            i_B    => s_B_selected,
            i_Cin  => nAdd_Sub,    -- Carry-in = 0 for add, 1 for sub (completes two's complement)
            o_S    => o_S,
            o_Cout => o_Cout
        );

end structural;