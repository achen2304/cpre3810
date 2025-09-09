library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_addsub is
    -- Testbench has no ports
end tb_addsub;

architecture behavior of tb_addsub is
    -- Constants
    constant N : integer := 32;
    constant CLK_PERIOD : time := 20 ns;
    
    -- Component declaration
    component addsub is
        generic(N : integer := 32);
        port(
            i_A       : in std_logic_vector(N-1 downto 0);
            i_B       : in std_logic_vector(N-1 downto 0);
            nAdd_Sub  : in std_logic;
            o_S       : out std_logic_vector(N-1 downto 0);
            o_Cout    : out std_logic
        );
    end component;
    
    -- Input signals
    signal s_A       : std_logic_vector(N-1 downto 0) := (others => '0');
    signal s_B       : std_logic_vector(N-1 downto 0) := (others => '0');
    signal s_nAdd_Sub: std_logic := '0';
    
    -- Output signals
    signal s_S       : std_logic_vector(N-1 downto 0);
    signal s_Cout    : std_logic;
    
    -- Helper procedure for reporting results (like nbit_adder)
    procedure wait_and_report(
        test_name : string
    ) is
    begin
        wait for CLK_PERIOD;
        report test_name &
               " | A: " & integer'image(to_integer(signed(s_A))) &
               ", B: " & integer'image(to_integer(signed(s_B))) &
               ", nAdd_Sub: " & std_logic'image(s_nAdd_Sub) &
               " | S: " & integer'image(to_integer(signed(s_S))) &
               ", Cout: " & std_logic'image(s_Cout);
    end procedure;
    
begin
    -- Instantiate Unit Under Test
    DUT: addsub
        generic map(N => N)
        port map(
            i_A       => s_A,
            i_B       => s_B,
            nAdd_Sub  => s_nAdd_Sub,
            o_S       => s_S,
            o_Cout    => s_Cout
        );
    
    -- Test process
    test_proc: process
    begin
    report "=== Starting Adder-Subtractor Testbench (N=" & integer'image(N) & ") ===";


    -- 1. Simple addition: 7 + 5 = 12
    s_A <= std_logic_vector(to_signed(7, N));
    s_B <= std_logic_vector(to_signed(5, N));
    s_nAdd_Sub <= '0';
    wait_and_report("ADD: 7 + 5");

    -- 2. Simple subtraction: 10 - 3 = 7
    s_A <= std_logic_vector(to_signed(10, N));
    s_B <= std_logic_vector(to_signed(3, N));
    s_nAdd_Sub <= '1';
    wait_and_report("SUB: 10 - 3");

    -- 3. Small - big: 4 - 9 = -5
    s_A <= std_logic_vector(to_signed(4, N));
    s_B <= std_logic_vector(to_signed(9, N));
    s_nAdd_Sub <= '1';
    wait_and_report("SUB: 4 - 9");

    -- 4. Negative - negative: -8 - (-3) = -5
    s_A <= std_logic_vector(to_signed(-8, N));
    s_B <= std_logic_vector(to_signed(-3, N));
    s_nAdd_Sub <= '1';
    wait_and_report("SUB: -8 - (-3)");

    -- 5. Negative + negative: -6 + (-7) = -13
    s_A <= std_logic_vector(to_signed(-6, N));
    s_B <= std_logic_vector(to_signed(-7, N));
    s_nAdd_Sub <= '0';
    wait_and_report("ADD: -6 + (-7)");

    -- 6. Negative small - negative big: -2 - (-10) = 8
    s_A <= std_logic_vector(to_signed(-2, N));
    s_B <= std_logic_vector(to_signed(-10, N));
    s_nAdd_Sub <= '1';
    wait_and_report("SUB: -2 - (-10)");

    report "=== Testbench Completed Successfully! ===";
    wait;
    end process;

end behavior;