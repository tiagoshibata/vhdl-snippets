library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Transmissor_FD is port (
    clk, reset, send: in STD_LOGIC;
    data: in STD_LOGIC_VECTOR(7 downto 0);
    serial: out STD_LOGIC
); end;

architecture Transmissor_FD_arch of Transmissor_FD is
    signal div_clock: STD_LOGIC;

    component timer port (
        clk, enable, load: in STD_LOGIC;
    	data_in: in STD_LOGIC_VECTOR(3 downto 0);
        pulse: out STD_LOGIC
    ); end component;

	component shifter port (
        clk, enable, serial_in, load: in STD_LOGIC;
        serial_out: out STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(9 downto 0);
        data_out: out STD_LOGIC_VECTOR(9 downto 0)
	); end component;
begin
    clock_divider: timer port map (clk, '1', '0', (others => '-'), div_clock);
    Ishifter: shifter port map (clk, div_clock, '1', send, serial, "1" + data + "0", open);
end Transmissor_FD_arch;
