-------------------------------------------------------------------------
-- Zero Extender for RISC-V Processor
-- Department of Electrical and Computer Engineering  
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity zeroextender is
    generic(
        INPUT_WIDTH  : integer := 12;   -- Width of input immediate
        OUTPUT_WIDTH : integer := 32    -- Width of output (extended)
    );
    port(
        i_immediate : in  std_logic_vector(INPUT_WIDTH-1 downto 0);   -- 12-bit input
        o_extended  : out std_logic_vector(OUTPUT_WIDTH-1 downto 0)   -- 32-bit output
    );
end zeroextender;

architecture dataflow of zeroextender is
begin
    -- Zero extension: fill upper bits with zeros regardless of MSB
    -- Always fill bits[31:12] with '0'
    
    o_extended <= (OUTPUT_WIDTH-1 downto INPUT_WIDTH => '0') & i_immediate;

end dataflow;
