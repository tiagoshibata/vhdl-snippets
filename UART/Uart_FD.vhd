library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Uart_FD is port (
    clk, reset, serial_rx, do_send, receive: in STD_LOGIC;
    serial_tx, busy_tx, new_rx_data: out STD_LOGIC;
    data_tx: in STD_LOGIC_VECTOR(7 downto 0);
    data_rx: out STD_LOGIC_VECTOR(7 downto 0);
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
    dbg_data_rx: out STD_LOGIC_VECTOR(7 downto 0);
    tick_rx, tick_tx: out std_logic;
    sample: out std_logic;
    tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
); end;

architecture Uart_FD_arch of Uart_FD is
    signal Stick_rx, Stick_tx, Shas_rx_data: STD_LOGIC;
    signal Sdata_rx: STD_LOGIC_VECTOR(7 downto 0);

    component Receptor port (
        clk, serial, reset, tick: in STD_LOGIC;
        busy_rx, has_rx_data: out STD_LOGIC;
        data: out STD_LOGIC_VECTOR(7 downto 0);
        dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
        sample: out STD_LOGIC
    ); end component;

    component Transmissor port (
        clk, send, tick: in STD_LOGIC;
        data: in STD_LOGIC_VECTOR(7 downto 0);
        serial, busy_tx: out STD_LOGIC;
        tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
    ); end component;

    component hex7seg port (
        x: in std_logic_vector(3 downto 0);
        enable: in std_logic;
        hex_output: out std_logic_vector(6 downto 0)
    ); end component;

    component ticker port (
		clk: in std_logic;
		tick_rx, tick_tx: out std_logic
	); end component;

    component register8 port (
        clk, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(7 downto 0);
        data_out: out STD_LOGIC_VECTOR(7 downto 0)
    ); end component;
begin
    new_rx_data <= Shas_rx_data;
    dbg_data_rx <= Sdata_rx;
    tick_rx <= Stick_rx;
    tick_tx <= Stick_tx;

    IRxBuffer: register8 port map (clk, receive, Sdata_rx, data_rx);
    IReceptor: Receptor port map (clk, serial_rx, reset, Stick_rx, open, Shas_rx_data, Sdata_rx, dbg_rx_bit_count, sample);
    ITransmissor: Transmissor port map (clk, do_send, Stick_tx, data_tx, serial_tx, busy_tx, tx_bit_count);
    Iticker: ticker port map (clk, Stick_rx, Stick_tx);
end Uart_FD_arch;
