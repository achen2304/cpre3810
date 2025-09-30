-------------------------------------------------------------------------
-- Unified Extender for RISC-V Processor (Alternative Implementation)
-- Department of Electrical and Computer Engineering  
-- Iowa State University
-------------------------------------------------------------------------

-- extender.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a unified VHDL implementation that can
-- perform both sign extension and zero extension based on a control signal.
-- Uses simple VHDL constructs for clean, efficient implementation.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity extender is
    generic(
        INPUT_WIDTH  : integer := 12;   -- Width of input immediate
        OUTPUT_WIDTH : integer := 32    -- Width of output (extended)
    );
    port(
        i_immediate : in  std_logic_vector(INPUT_WIDTH-1 downto 0);   -- 12-bit input
        i_sign_ext  : in  std_logic;                                  -- 0=zero ext, 1=sign ext
        o_extended  : out std_logic_vector(OUTPUT_WIDTH-1 downto 0)   -- 32-bit output
    );
end extender;

architecture dataflow of extender is
begin
    -- Unified extension using conditional assignment
    -- When i_sign_ext = '1': Sign extension (replicate MSB)
    -- When i_sign_ext = '0': Zero extension (pad with zeros)
    
    o_extended <= (OUTPUT_WIDTH-1 downto INPUT_WIDTH => (i_immediate(INPUT_WIDTH-1) and i_sign_ext)) & i_immediate;

end dataflow;
