library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Receptor_FD is port (
    tk, clk, starting_rx, serial, pronto: in STD_LOGIC;
    rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0);
    data: out STD_LOGIC_VECTOR(7 downto 0)
); end;

architecture Receptor_FD_arch of Receptor_FD is
    signal serial_data: STD_LOGIC_VECTOR(9 downto 0);
    
    component counter port(
        clk, reset, count: in std_logic;
        value: out std_logic_vector(3 downto 0)
    ); end component;

    component shifter port (
        clk, enable, serial_in, load: in STD_LOGIC;
        serial_out: out STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(9 downto 0);
        data_out: out STD_LOGIC_VECTOR(9 downto 0)
    ); end component;
begin
    data <= serial_data(8 downto 1);
    rx_bit_counter: counter port map (clk, pronto, tk, rx_bit_count);
    serial_shifter: shifter port map (clk, tk, serial, starting_rx, open, (others => '0'), serial_data);
end Receptor_FD_arch;
