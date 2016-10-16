library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Transmissor is port (
    clk, send, tick: in STD_LOGIC;
    data: in STD_LOGIC_VECTOR(7 downto 0);
    serial, busy_tx: out STD_LOGIC
); end;

architecture Transmissor_arch of Transmissor is
    signal Sbit_count: STD_LOGIC_VECTOR(3 downto 0);

    component Transmissor_FD port (
        clk, send, tick: in STD_LOGIC;
        data: in STD_LOGIC_VECTOR(7 downto 0);
        serial: out STD_LOGIC;
        bit_count: out STD_LOGIC_VECTOR(3 downto 0)
    ); end component;

    component Transmissor_UC port (
        clk, send: in STD_LOGIC;
        bit_count: in STD_LOGIC_VECTOR(3 downto 0);
        busy_tx: out STD_LOGIC
    ); end component;
begin
    IUC: Transmissor_UC port map (clk, send, Sbit_count, busy_tx);
    IFD: Transmissor_FD port map (clk, send, tick, data, serial, Sbit_count);
end Transmissor_arch;
