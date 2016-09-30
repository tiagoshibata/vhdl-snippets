library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Transmissor is port (
    clk, reset, send: in STD_LOGIC;
    data: in STD_LOGIC_VECTOR(7 downto 0);
    serial: out STD_LOGIC
); end;

architecture Transmissor_arch of Transmissor is
    component Transmissor_FD port (
        clk, reset, send: in STD_LOGIC;
        data: in STD_LOGIC_VECTOR(7 downto 0);
        serial: out STD_LOGIC
    ); end component;
begin
    IFD: Transmissor_FD port map (clk, reset, send, data, serial);
end Transmissor_arch;
