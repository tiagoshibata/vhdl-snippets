library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Transmissor is port (
    clk, send: in STD_LOGIC;
    data: in STD_LOGIC_VECTOR(7 downto 0);
    serial, ready: out STD_LOGIC
); end;

architecture Transmissor_arch of Transmissor is
    component Transmissor_FD port (
        clk, send: in STD_LOGIC;
        data: in STD_LOGIC_VECTOR(7 downto 0);
        serial, ready: out STD_LOGIC
    ); end component;
begin
    IFD: Transmissor_FD port map (clk, send, data, serial, ready);
end Transmissor_arch;
