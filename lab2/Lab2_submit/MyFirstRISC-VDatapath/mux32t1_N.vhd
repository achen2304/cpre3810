library IEEE;
use IEEE.std_logic_1164.all;

entity mux32t1_N is
    generic(N : integer := 32);  -- Data width (default 32-bit)
    port(
        i_S   : in std_logic_vector(4 downto 0);              -- 5-bit select signal
        i_D0  : in std_logic_vector(N-1 downto 0);            -- Data input 0
        i_D1  : in std_logic_vector(N-1 downto 0);            -- Data input 1
        i_D2  : in std_logic_vector(N-1 downto 0);            -- Data input 2
        i_D3  : in std_logic_vector(N-1 downto 0);            -- Data input 3
        i_D4  : in std_logic_vector(N-1 downto 0);            -- Data input 4
        i_D5  : in std_logic_vector(N-1 downto 0);            -- Data input 5
        i_D6  : in std_logic_vector(N-1 downto 0);            -- Data input 6
        i_D7  : in std_logic_vector(N-1 downto 0);            -- Data input 7
        i_D8  : in std_logic_vector(N-1 downto 0);            -- Data input 8
        i_D9  : in std_logic_vector(N-1 downto 0);            -- Data input 9
        i_D10 : in std_logic_vector(N-1 downto 0);            -- Data input 10
        i_D11 : in std_logic_vector(N-1 downto 0);            -- Data input 11
        i_D12 : in std_logic_vector(N-1 downto 0);            -- Data input 12
        i_D13 : in std_logic_vector(N-1 downto 0);            -- Data input 13
        i_D14 : in std_logic_vector(N-1 downto 0);            -- Data input 14
        i_D15 : in std_logic_vector(N-1 downto 0);            -- Data input 15
        i_D16 : in std_logic_vector(N-1 downto 0);            -- Data input 16
        i_D17 : in std_logic_vector(N-1 downto 0);            -- Data input 17
        i_D18 : in std_logic_vector(N-1 downto 0);            -- Data input 18
        i_D19 : in std_logic_vector(N-1 downto 0);            -- Data input 19
        i_D20 : in std_logic_vector(N-1 downto 0);            -- Data input 20
        i_D21 : in std_logic_vector(N-1 downto 0);            -- Data input 21
        i_D22 : in std_logic_vector(N-1 downto 0);            -- Data input 22
        i_D23 : in std_logic_vector(N-1 downto 0);            -- Data input 23
        i_D24 : in std_logic_vector(N-1 downto 0);            -- Data input 24
        i_D25 : in std_logic_vector(N-1 downto 0);            -- Data input 25
        i_D26 : in std_logic_vector(N-1 downto 0);            -- Data input 26
        i_D27 : in std_logic_vector(N-1 downto 0);            -- Data input 27
        i_D28 : in std_logic_vector(N-1 downto 0);            -- Data input 28
        i_D29 : in std_logic_vector(N-1 downto 0);            -- Data input 29
        i_D30 : in std_logic_vector(N-1 downto 0);            -- Data input 30
        i_D31 : in std_logic_vector(N-1 downto 0);            -- Data input 31
        o_F   : out std_logic_vector(N-1 downto 0)            -- Output
    );
end mux32t1_N;

architecture dataflow of mux32t1_N is
begin
    -- 32:1 multiplexer using with-select-when construct
    with i_S select
        o_F <= i_D0  when "00000",   -- Select input 0
               i_D1  when "00001",   -- Select input 1
               i_D2  when "00010",   -- Select input 2
               i_D3  when "00011",   -- Select input 3
               i_D4  when "00100",   -- Select input 4
               i_D5  when "00101",   -- Select input 5
               i_D6  when "00110",   -- Select input 6
               i_D7  when "00111",   -- Select input 7
               i_D8  when "01000",   -- Select input 8
               i_D9  when "01001",   -- Select input 9
               i_D10 when "01010",   -- Select input 10
               i_D11 when "01011",   -- Select input 11
               i_D12 when "01100",   -- Select input 12
               i_D13 when "01101",   -- Select input 13
               i_D14 when "01110",   -- Select input 14
               i_D15 when "01111",   -- Select input 15
               i_D16 when "10000",   -- Select input 16
               i_D17 when "10001",   -- Select input 17
               i_D18 when "10010",   -- Select input 18
               i_D19 when "10011",   -- Select input 19
               i_D20 when "10100",   -- Select input 20
               i_D21 when "10101",   -- Select input 21
               i_D22 when "10110",   -- Select input 22
               i_D23 when "10111",   -- Select input 23
               i_D24 when "11000",   -- Select input 24
               i_D25 when "11001",   -- Select input 25
               i_D26 when "11010",   -- Select input 26
               i_D27 when "11011",   -- Select input 27
               i_D28 when "11100",   -- Select input 28
               i_D29 when "11101",   -- Select input 29
               i_D30 when "11110",   -- Select input 30
               i_D31 when "11111",   -- Select input 31
               (others => '0') when others;  -- Default case

end dataflow;
