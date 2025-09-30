-------------------------------------------------------------------------
-- N-bit 2:1 Multiplexer (Legacy Interface)
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- nbit_mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 
-- 2:1 multiplexer using structural VHDL. This version uses the legacy
-- port interface expected by the addsub component.
--
-- NOTES:
-- Different port names from mux2t1_N.vhd for compatibility
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_mux2t1 is
    generic(N : integer := 32); -- Generic for bit width
    port(
        i_D0 : in std_logic_vector(N-1 downto 0);  -- Data input 0
        i_D1 : in std_logic_vector(N-1 downto 0);  -- Data input 1
        i_S  : in std_logic;                        -- Select signal
        o_O  : out std_logic_vector(N-1 downto 0)  -- Output
    );
end nbit_mux2t1;

architecture structural of nbit_mux2t1 is

    component mux2t1 is
        port(
            i_S  : in std_logic;
            i_D0 : in std_logic;
            i_D1 : in std_logic;
            o_F  : out std_logic
        );
    end component;

begin

    -- Generate N instances of 1-bit 2:1 multiplexers
    G_NBit_MUX: for i in 0 to N-1 generate
        MUXI: mux2t1 port map(
            i_S  => i_S,        -- Same select for all bits
            i_D0 => i_D0(i),    -- Bit i of input 0
            i_D1 => i_D1(i),    -- Bit i of input 1  
            o_F  => o_O(i)      -- Bit i of output
        );
    end generate G_NBit_MUX;

end structural;
