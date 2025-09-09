library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_dataflow is
    port(
        i_D0 : in std_logic;   -- Data input 0
        i_D1 : in std_logic;   -- Data input 1  
        i_S  : in std_logic;   -- Select signal
        o_O  : out std_logic   -- Output
    );
end mux2t1_dataflow;

architecture dataflow of mux2t1_dataflow is
begin
    -- Conditional signal assignment
    -- When i_S = '0', select i_D0; when i_S = '1', select i_D1
    o_O <= i_D0 when i_S = '0' else i_D1;
    
end dataflow;