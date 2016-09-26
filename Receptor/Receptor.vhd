library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Receptor is port (
    serial, clk: in STD_LOGIC;
    ready_led, parity_ok_led: out STD_LOGIC;
    display_1, display_2, display_3, display_4, display_5, display_6: out STD_LOGIC_VECTOR(6 downto 0);
    dbg_rx_bit_count: out  STD_LOGIC_VECTOR(3 downto 0)
); end;

architecture receptor_arch of Receptor is
    signal rx_bit_count: STD_LOGIC_VECTOR(3 downto 0);
    signal ready_to_receive, start_receiving, output_ready: STD_LOGIC;

    component UC port (
		cont: in STD_LOGIC_VECTOR(3 downto 0);
		serial, clk: in STD_LOGIC;
	    ready_to_receive, start_receiving, output_ready: out STD_LOGIC
	); end component;

    component FD port (
        serial, pronto, clk, starting_rx, output_ready: in STD_LOGIC;
        paridade_ok: out STD_LOGIC;
        rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0);
        display_1: out STD_LOGIC_VECTOR(6 downto 0);
        display_2: out STD_LOGIC_VECTOR(6 downto 0);
        display_3: out STD_LOGIC_VECTOR(6 downto 0);
        display_4: out STD_LOGIC_VECTOR(6 downto 0);
        display_5: out STD_LOGIC_VECTOR(6 downto 0);
        display_6: out STD_LOGIC_VECTOR(6 downto 0)
    ); end component;
begin
    ready_led <= ready_to_receive;
    dbg_rx_bit_count <= rx_bit_count;
    uct: UC port map (rx_bit_count, serial, clk, ready_to_receive, start_receiving, output_ready);
    fdt: FD port map (serial, ready_to_receive, clk, start_receiving, output_ready, parity_ok_led, rx_bit_count, display_1, display_2, display_3, display_4, display_5, display_6);
end receptor_arch;
