library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_onescomp_N is
end tb_onescomp_N;

architecture behavior of tb_onescomp_N is
	constant N : integer := 32;
	signal i_A : std_logic_vector(N-1 downto 0) := (others => '0');
	signal o_Y : std_logic_vector(N-1 downto 0);

	component onescomp_N
		generic(N : integer := 32);
		port(
			i_A : in  std_logic_vector(N-1 downto 0);
			o_Y : out std_logic_vector(N-1 downto 0)
		);
	end component;

begin
	DUT: onescomp_N
		generic map(N => N)
		port map(
			i_A => i_A,
			o_Y => o_Y
		);

	stim_proc: process
	begin
		-- Test 1: All zeros (input = 0x00000000)
		i_A <= x"00000000";
		wait for 10 ns;
		-- o_Y should be 0xFFFFFFFF (all ones)

		-- Test 2: All ones (input = 0xFFFFFFFF)
		i_A <= x"FFFFFFFF";
		wait for 10 ns;
		-- o_Y should be 0x00000000 (all zeros)

		-- Test 3: Alternating bits (input = 0xAAAAAAAA)
		i_A <= x"AAAAAAAA"; -- 10101010...
		wait for 10 ns;
		-- o_Y should be 0x55555555 (01010101...)

		-- Test 5: Lower half ones, upper half zeros (input = 0x0000FFFF)
		i_A <= x"0000FFFF";
		wait for 10 ns;
		-- o_Y should be 0xFFFF0000

		-- Test 6: Upper half ones, lower half zeros (input = 0xFFFF0000)
		i_A <= x"FFFF0000";
		wait for 10 ns;
		-- o_Y should be 0x0000FFFF

		wait;
	end process;
end behavior;
