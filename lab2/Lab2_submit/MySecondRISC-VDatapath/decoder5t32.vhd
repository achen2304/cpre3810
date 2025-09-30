
library IEEE;
use IEEE.std_logic_1164.all;

entity decoder5t32 is
    port(
        i_A : in std_logic_vector(4 downto 0);   -- 5-bit input address
        o_Y : out std_logic_vector(31 downto 0)  -- 32-bit one-hot output
    );
end decoder5t32;

architecture dataflow of decoder5t32 is
begin
    -- Each output bit is high when the input matches its binary representation
    o_Y(0)  <= (not i_A(4)) and (not i_A(3)) and (not i_A(2)) and (not i_A(1)) and (not i_A(0)); -- 00000
    o_Y(1)  <= (not i_A(4)) and (not i_A(3)) and (not i_A(2)) and (not i_A(1)) and (    i_A(0)); -- 00001
    o_Y(2)  <= (not i_A(4)) and (not i_A(3)) and (not i_A(2)) and (    i_A(1)) and (not i_A(0)); -- 00010
    o_Y(3)  <= (not i_A(4)) and (not i_A(3)) and (not i_A(2)) and (    i_A(1)) and (    i_A(0)); -- 00011
    o_Y(4)  <= (not i_A(4)) and (not i_A(3)) and (    i_A(2)) and (not i_A(1)) and (not i_A(0)); -- 00100
    o_Y(5)  <= (not i_A(4)) and (not i_A(3)) and (    i_A(2)) and (not i_A(1)) and (    i_A(0)); -- 00101
    o_Y(6)  <= (not i_A(4)) and (not i_A(3)) and (    i_A(2)) and (    i_A(1)) and (not i_A(0)); -- 00110
    o_Y(7)  <= (not i_A(4)) and (not i_A(3)) and (    i_A(2)) and (    i_A(1)) and (    i_A(0)); -- 00111
    o_Y(8)  <= (not i_A(4)) and (    i_A(3)) and (not i_A(2)) and (not i_A(1)) and (not i_A(0)); -- 01000
    o_Y(9)  <= (not i_A(4)) and (    i_A(3)) and (not i_A(2)) and (not i_A(1)) and (    i_A(0)); -- 01001
    o_Y(10) <= (not i_A(4)) and (    i_A(3)) and (not i_A(2)) and (    i_A(1)) and (not i_A(0)); -- 01010
    o_Y(11) <= (not i_A(4)) and (    i_A(3)) and (not i_A(2)) and (    i_A(1)) and (    i_A(0)); -- 01011
    o_Y(12) <= (not i_A(4)) and (    i_A(3)) and (    i_A(2)) and (not i_A(1)) and (not i_A(0)); -- 01100
    o_Y(13) <= (not i_A(4)) and (    i_A(3)) and (    i_A(2)) and (not i_A(1)) and (    i_A(0)); -- 01101
    o_Y(14) <= (not i_A(4)) and (    i_A(3)) and (    i_A(2)) and (    i_A(1)) and (not i_A(0)); -- 01110
    o_Y(15) <= (not i_A(4)) and (    i_A(3)) and (    i_A(2)) and (    i_A(1)) and (    i_A(0)); -- 01111
    o_Y(16) <= (    i_A(4)) and (not i_A(3)) and (not i_A(2)) and (not i_A(1)) and (not i_A(0)); -- 10000
    o_Y(17) <= (    i_A(4)) and (not i_A(3)) and (not i_A(2)) and (not i_A(1)) and (    i_A(0)); -- 10001
    o_Y(18) <= (    i_A(4)) and (not i_A(3)) and (not i_A(2)) and (    i_A(1)) and (not i_A(0)); -- 10010
    o_Y(19) <= (    i_A(4)) and (not i_A(3)) and (not i_A(2)) and (    i_A(1)) and (    i_A(0)); -- 10011
    o_Y(20) <= (    i_A(4)) and (not i_A(3)) and (    i_A(2)) and (not i_A(1)) and (not i_A(0)); -- 10100
    o_Y(21) <= (    i_A(4)) and (not i_A(3)) and (    i_A(2)) and (not i_A(1)) and (    i_A(0)); -- 10101
    o_Y(22) <= (    i_A(4)) and (not i_A(3)) and (    i_A(2)) and (    i_A(1)) and (not i_A(0)); -- 10110
    o_Y(23) <= (    i_A(4)) and (not i_A(3)) and (    i_A(2)) and (    i_A(1)) and (    i_A(0)); -- 10111
    o_Y(24) <= (    i_A(4)) and (    i_A(3)) and (not i_A(2)) and (not i_A(1)) and (not i_A(0)); -- 11000
    o_Y(25) <= (    i_A(4)) and (    i_A(3)) and (not i_A(2)) and (not i_A(1)) and (    i_A(0)); -- 11001
    o_Y(26) <= (    i_A(4)) and (    i_A(3)) and (not i_A(2)) and (    i_A(1)) and (not i_A(0)); -- 11010
    o_Y(27) <= (    i_A(4)) and (    i_A(3)) and (not i_A(2)) and (    i_A(1)) and (    i_A(0)); -- 11011
    o_Y(28) <= (    i_A(4)) and (    i_A(3)) and (    i_A(2)) and (not i_A(1)) and (not i_A(0)); -- 11100
    o_Y(29) <= (    i_A(4)) and (    i_A(3)) and (    i_A(2)) and (not i_A(1)) and (    i_A(0)); -- 11101
    o_Y(30) <= (    i_A(4)) and (    i_A(3)) and (    i_A(2)) and (    i_A(1)) and (not i_A(0)); -- 11110
    o_Y(31) <= (    i_A(4)) and (    i_A(3)) and (    i_A(2)) and (    i_A(1)) and (    i_A(0)); -- 11111

end dataflow;
