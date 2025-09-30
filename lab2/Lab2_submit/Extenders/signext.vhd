-------------------------------------------------------------------------
-- Sign Extender for RISC-V Processor
-- Department of Electrical and Computer Engineering  
-- Iowa State University
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity signextender is
    generic(
        INPUT_WIDTH  : integer := 12;   -- Width of input immediate
        OUTPUT_WIDTH : integer := 32    -- Width of output (extended)
    );
    port(
        i_immediate : in  std_logic_vector(INPUT_WIDTH-1 downto 0);   -- 12-bit input
        o_extended  : out std_logic_vector(OUTPUT_WIDTH-1 downto 0)   -- 32-bit output
    );
end signextender;

architecture dataflow of signextender is
begin
    -- Sign extension: replicate the sign bit (MSB) to fill upper bits
    -- If bit[11] = '0', fill bits[31:12] with '0'  
    -- If bit[11] = '1', fill bits[31:12] with '1'
    
    o_extended <= (OUTPUT_WIDTH-1 downto INPUT_WIDTH => i_immediate(INPUT_WIDTH-1)) & i_immediate;

end dataflow;
