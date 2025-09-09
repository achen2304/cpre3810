library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_mux2t1_N is
end tb_mux2t1_N;

architecture behavior of tb_mux2t1_N is
	constant N : integer := 4;
	signal i_S  : std_logic := '0';
	signal i_D0 : std_logic_vector(N-1 downto 0) := (others => '0');
	signal i_D1 : std_logic_vector(N-1 downto 0) := (others => '0');
	signal o_O  : std_logic_vector(N-1 downto 0);

	-- DUT instantiation
	component mux2t1_N
		generic(N : integer := 16);
		port(
			i_S  : in std_logic;
			i_D0 : in std_logic_vector(N-1 downto 0);
			i_D1 : in std_logic_vector(N-1 downto 0);
			o_O  : out std_logic_vector(N-1 downto 0)
		);
	end component;

begin
	DUT: mux2t1_N
		generic map(N => N)
		port map(
			i_S  => i_S,
			i_D0 => i_D0,
			i_D1 => i_D1,
			o_O  => o_O
		);

	stim_proc: process
	begin
		-- Test 1: Select D0
		i_D0 <= x"A"; -- 1010
		i_D1 <= x"5"; -- 0101
		i_S  <= '0';
		wait for 10 ns;
		-- o_O should be A (1010)

		-- Test 2: Select D1
		i_S  <= '1';
		wait for 10 ns;
		-- o_O should be 5 (0101)

		-- Test 3: Change inputs
		i_D0 <= x"F"; -- 1111
		i_D1 <= x"0"; -- 0000
		i_S  <= '0';
		wait for 10 ns;
		-- o_O should be F (1111)

		i_S  <= '1';
		wait for 10 ns;
		-- o_O should be 0 (0000)

		-- Test 4: Random pattern
		i_D0 <= x"3"; -- 0011
		i_D1 <= x"C"; -- 1100
		i_S  <= '0';
		wait for 10 ns;
		-- o_O should be 3 (0011)

		i_S  <= '1';
		wait for 10 ns;
		-- o_O should be C (1100)

		wait;
	end process;
end behavior;
