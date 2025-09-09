library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_nbit_adder is
    -- Testbench has no ports
end tb_nbit_adder;

architecture behavior of tb_nbit_adder is
    -- Constants
    constant N : integer := 32;
    constant CLK_PERIOD : time := 10 ns;
    
    -- Component declaration for the Unit Under Test (UUT)
    component nbit_adder is
        generic(
            N : integer := 32
        );
        port(
            i_A    : in std_logic_vector(N-1 downto 0);
            i_B    : in std_logic_vector(N-1 downto 0);
            i_Cin  : in std_logic;
            o_S    : out std_logic_vector(N-1 downto 0);
            o_Cout : out std_logic
        );
    end component;
    
    -- Input signals
    signal s_A    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal s_B    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal s_Cin  : std_logic := '0';
    
    -- Output signals
    signal s_S    : std_logic_vector(N-1 downto 0);
    signal s_Cout : std_logic;
    
    -- Helper procedure to wait and display results
    procedure wait_and_report(
        test_name : string
    ) is
    begin
        wait for CLK_PERIOD;
        report test_name &
               " | A: " & integer'image(to_integer(unsigned(s_A))) &
               ", B: " & integer'image(to_integer(unsigned(s_B))) &
               ", Cin: " & std_logic'image(s_Cin) &
               " | S: " & integer'image(to_integer(unsigned(s_S))) &
               ", Cout: " & std_logic'image(s_Cout);
    end procedure;
    
begin
    -- Instantiate the Unit Under Test (UUT)
    DUT: nbit_adder
        generic map(
            N => N
        )
        port map(
            i_A    => s_A,
            i_B    => s_B,
            i_Cin  => s_Cin,
            o_S    => s_S,
            o_Cout => s_Cout
        );
    
    -- Stimulus process
    stim_proc: process
    begin
        report "Starting N-bit Adder Testbench (N=" & integer'image(N) & ")";


    -- Test 1: 10 + 20 + 0 = 30, Cout = 0
    s_A <= std_logic_vector(to_unsigned(10, N));
    s_B <= std_logic_vector(to_unsigned(20, N));
    s_Cin <= '0';
    wait_and_report("Test 1: 10 + 20 + 0");

    -- Test 2: 99 + 1 + 0 = 100, Cout = 0
    s_A <= std_logic_vector(to_unsigned(99, N));
    s_B <= std_logic_vector(to_unsigned(1, N));
    s_Cin <= '0';
    wait_and_report("Test 2: 99 + 1 + 0");

    -- Test 3: 99 + 99 + 1 = 199, Cout = 0
    s_A <= std_logic_vector(to_unsigned(99, N));
    s_B <= std_logic_vector(to_unsigned(99, N));
    s_Cin <= '1';
    wait_and_report("Test 3: 99 + 99 + 1");

    -- Test 4: MAX + 1 + 0 = 0, Cout = 1
    s_A <= (others => '1');
    s_B <= std_logic_vector(to_unsigned(1, N));
    s_Cin <= '0';
    wait_and_report("Test 4: MAX + 1 + 0");

    -- Test 5: MAX + 0 + 1 = 0, Cout = 1
    s_A <= (others => '1');
    s_B <= (others => '0');
    s_Cin <= '1';
    wait_and_report("Test 5: MAX + 0 + 1");

    -- Test 6: MAX + MAX + 0 = 2^N-2, Cout = 1
    s_A <= (others => '1');
    s_B <= (others => '1');
    s_Cin <= '0';
    wait_and_report("Test 6: MAX + MAX + 0");

    -- Test 7: 55 + 45 + 0 = 100, Cout = 0
    s_A <= std_logic_vector(to_unsigned(55, N));
    s_B <= std_logic_vector(to_unsigned(45, N));
    s_Cin <= '0';
    wait_and_report("Test 7: 55 + 45 + 0");

    -- Test 8: 60 + 39 + 1 = 100, Cout = 0
    s_A <= std_logic_vector(to_unsigned(60, N));
    s_B <= std_logic_vector(to_unsigned(39, N));
    s_Cin <= '1';
    wait_and_report("Test 8: 60 + 39 + 1");

        report "Testbench completed successfully!";
        wait;
    end process;

end behavior;