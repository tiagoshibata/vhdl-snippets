library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Receptor_FD is port (
    clk, serial, busy_rx, tick: in STD_LOGIC;
    rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
    data: out STD_LOGIC_VECTOR(7 downto 0);
    parity_ok: out STD_LOGIC
); end;

architecture Receptor_FD_arch of Receptor_FD is
    signal Sdata: STD_LOGIC_VECTOR(10 downto 0);
    signal Ssampling_timer_value: STD_LOGIC_VECTOR(15 downto 0);
    signal Sparity, Ssample: STD_LOGIC;

    component counter port(
        clk, reset, count: in std_logic;
        value: out std_logic_vector(4 downto 0)
    ); end component;

    component timer port (
        clk, enable, load: in STD_LOGIC;
    	data_in: in STD_LOGIC_VECTOR(15 downto 0);
        pulse: out STD_LOGIC
    ); end component;

    component shifter port (
        clk, enable, serial_in, load: in STD_LOGIC;
        serial_out: out STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(10 downto 0);
        data_out: out STD_LOGIC_VECTOR(10 downto 0)
    ); end component;

    component parity port (
        data: in STD_LOGIC_VECTOR(7 downto 0);
        parity: out STD_LOGIC
    ); end component;
begin
    data <= Sdata(8 downto 1);  -- TODO check if correct
    parity_ok <= Sparity xor Sdata(9);
    Ssampling_timer_value <= "0000000000001110" when busy_rx = '1' else "0000000000001001";

    Iparity: parity port map (Sdata(8 downto 1), Sparity);
    bit_counter: counter port map (clk, not busy_rx, Ssample, rx_bit_count);
    sampling_timer: timer port map (clk, tick, not busy_rx, Ssampling_timer_value, Ssample);
    Ishifter: shifter port map (clk, Ssample, serial, '0', open, (others => '0'), Sdata);
end Receptor_FD_arch;
