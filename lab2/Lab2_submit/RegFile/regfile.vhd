library IEEE;
use IEEE.std_logic_1164.all;

entity regfile is
    generic(N : integer := 32);  -- Data width (32-bit for RISC-V)
    port(
        i_CLK        : in std_logic;                         -- Clock
        i_RST        : in std_logic;                         -- Reset
        i_WE         : in std_logic;                         -- Write Enable
        i_rs1        : in std_logic_vector(4 downto 0);     -- Read address 1 (rs1)
        i_rs2        : in std_logic_vector(4 downto 0);     -- Read address 2 (rs2)
        i_rd         : in std_logic_vector(4 downto 0);     -- Write address (rd)
        i_write_data : in std_logic_vector(N-1 downto 0);   -- Write data
        o_read_data1 : out std_logic_vector(N-1 downto 0);  -- Read data 1
        o_read_data2 : out std_logic_vector(N-1 downto 0)   -- Read data 2
    );
end regfile;

architecture structural of regfile is

    -- Component declarations
    component nbit_reg is
        generic(N : integer := 32);
        port(
            i_CLK : in std_logic;
            i_RST : in std_logic;
            i_WE  : in std_logic;
            i_D   : in std_logic_vector(N-1 downto 0);
            o_Q   : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component decoder5t32 is
        port(
            i_A : in std_logic_vector(4 downto 0);
            o_Y : out std_logic_vector(31 downto 0)
        );
    end component;

    component mux32t1_N is
        generic(N : integer := 32);
        port(
            i_S   : in std_logic_vector(4 downto 0);
            i_D0, i_D1, i_D2, i_D3, i_D4, i_D5, i_D6, i_D7 : in std_logic_vector(N-1 downto 0);
            i_D8, i_D9, i_D10, i_D11, i_D12, i_D13, i_D14, i_D15 : in std_logic_vector(N-1 downto 0);
            i_D16, i_D17, i_D18, i_D19, i_D20, i_D21, i_D22, i_D23 : in std_logic_vector(N-1 downto 0);
            i_D24, i_D25, i_D26, i_D27, i_D28, i_D29, i_D30, i_D31 : in std_logic_vector(N-1 downto 0);
            o_F   : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- Define array type for register outputs
    type reg_array is array (0 to 31) of std_logic_vector(N-1 downto 0);
    
    -- Internal signals
    signal decoder_out : std_logic_vector(31 downto 0);  -- Decoder output (write enable for each register)
    signal write_enables : std_logic_vector(31 downto 0);  -- Individual write enables
    signal reg0_output : std_logic_vector(N-1 downto 0);   -- Always zero for register 0
    signal reg_data : reg_array;  -- Outputs from all registers

begin

    -- Register 0 is hardwired to zero (RISC-V requirement)
    reg0_output <= (others => '0');
    reg_data(0) <= reg0_output;

    -- Write address decoder - generates write enable for selected register
    WRITE_DECODER: decoder5t32
    port map(
        i_A => i_rd,
        o_Y => decoder_out
    );

    -- Generate write enable signals (AND with global write enable)
    -- Register 0 never gets written (always 0), so mask its write enable
    write_enables(0) <= '0';  -- Register 0 never written
    GEN_WE: for i in 1 to 31 generate
        write_enables(i) <= decoder_out(i) and i_WE;
    end generate GEN_WE;

    -- Generate 31 registers (skip register 0 since it's hardwired to 0)
    GEN_REGISTERS: for i in 1 to 31 generate
        REG_I: nbit_reg
        generic map(N => N)
        port map(
            i_CLK => i_CLK,
            i_RST => i_RST,
            i_WE  => write_enables(i),
            i_D   => i_write_data,
            o_Q   => reg_data(i)
        );
    end generate GEN_REGISTERS;

    -- Read port 1 multiplexer (rs1)
    READ_MUX1: mux32t1_N
    generic map(N => N)
    port map(
        i_S => i_rs1,
        i_D0 => reg_data(0), i_D1 => reg_data(1), i_D2 => reg_data(2), i_D3 => reg_data(3),
        i_D4 => reg_data(4), i_D5 => reg_data(5), i_D6 => reg_data(6), i_D7 => reg_data(7),
        i_D8 => reg_data(8), i_D9 => reg_data(9), i_D10 => reg_data(10), i_D11 => reg_data(11),
        i_D12 => reg_data(12), i_D13 => reg_data(13), i_D14 => reg_data(14), i_D15 => reg_data(15),
        i_D16 => reg_data(16), i_D17 => reg_data(17), i_D18 => reg_data(18), i_D19 => reg_data(19),
        i_D20 => reg_data(20), i_D21 => reg_data(21), i_D22 => reg_data(22), i_D23 => reg_data(23),
        i_D24 => reg_data(24), i_D25 => reg_data(25), i_D26 => reg_data(26), i_D27 => reg_data(27),
        i_D28 => reg_data(28), i_D29 => reg_data(29), i_D30 => reg_data(30), i_D31 => reg_data(31),
        o_F => o_read_data1
    );

    -- Read port 2 multiplexer (rs2)
    READ_MUX2: mux32t1_N
    generic map(N => N)
    port map(
        i_S => i_rs2,
        i_D0 => reg_data(0), i_D1 => reg_data(1), i_D2 => reg_data(2), i_D3 => reg_data(3),
        i_D4 => reg_data(4), i_D5 => reg_data(5), i_D6 => reg_data(6), i_D7 => reg_data(7),
        i_D8 => reg_data(8), i_D9 => reg_data(9), i_D10 => reg_data(10), i_D11 => reg_data(11),
        i_D12 => reg_data(12), i_D13 => reg_data(13), i_D14 => reg_data(14), i_D15 => reg_data(15),
        i_D16 => reg_data(16), i_D17 => reg_data(17), i_D18 => reg_data(18), i_D19 => reg_data(19),
        i_D20 => reg_data(20), i_D21 => reg_data(21), i_D22 => reg_data(22), i_D23 => reg_data(23),
        i_D24 => reg_data(24), i_D25 => reg_data(25), i_D26 => reg_data(26), i_D27 => reg_data(27),
        i_D28 => reg_data(28), i_D29 => reg_data(29), i_D30 => reg_data(30), i_D31 => reg_data(31),
        o_F => o_read_data2
    );

end structural;
