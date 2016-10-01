library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Receptor is port (
    clk, serial: in STD_LOGIC;
    ready_led: out STD_LOGIC;
    data: out STD_LOGIC_VECTOR(7 downto 0);
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0)
); end;

architecture Receptor_arch of Receptor is
    signal rx_bit_count: STD_LOGIC_VECTOR(3 downto 0);
    signal ready_to_receive, start_receiving: STD_LOGIC;

    component Receptor_UC port (
		cont: in STD_LOGIC_VECTOR(3 downto 0);
		serial, clk: in STD_LOGIC;
	    ready_to_receive, start_receiving: out STD_LOGIC
	); end component;

    component Receptor_FD port (
        clk, starting_rx, serial, pronto: in STD_LOGIC;
        rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0);
        data: out STD_LOGIC_VECTOR(7 downto 0)
    ); end component;
begin
    ready_led <= ready_to_receive;
    dbg_rx_bit_count <= rx_bit_count;

    IUC: Receptor_UC port map (rx_bit_count, serial, clk, ready_to_receive, start_receiving);
    IFD: Receptor_FD port map (clk, start_receiving, serial, ready_to_receive, rx_bit_count, data);
end Receptor_arch;
