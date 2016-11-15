library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Transmissor_FD is port (
    clk, send, tick: in STD_LOGIC;
    data: in STD_LOGIC_VECTOR(7 downto 0);
    serial: out STD_LOGIC;
    bit_count: out STD_LOGIC_VECTOR(4 downto 0)
); end;

architecture Transmissor_FD_arch of Transmissor_FD is
    signal Sparity: STD_LOGIC;

    component shifter port (
        clk, enable, serial_in, load: in STD_LOGIC;
        serial_out: out STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(10 downto 0);
        data_out: out STD_LOGIC_VECTOR(10 downto 0)
    ); end component;

    component counter port (
        clk, reset, count: in std_logic;
        value: out std_logic_vector(4 downto 0)
    ); end component;

    component parity port (
        clk: in STD_LOGIC;
        data: in STD_LOGIC_VECTOR(7 downto 0);
        parity: out STD_LOGIC
    ); end component;
begin
    Iparity: parity port map (clk, data, Sparity);
    Ishifter: shifter port map (clk, tick, '1', send, serial, "1" & Sparity & data & "0", open);
    Icounter: counter port map (clk, send, tick, bit_count);
end Transmissor_FD_arch;
