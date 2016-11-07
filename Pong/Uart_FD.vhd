library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Uart_FD is port (
    clk, reset, serial_rx, do_send: in STD_LOGIC;
    serial_tx, busy_tx, new_rx_data: out STD_LOGIC;
    data_tx: in STD_LOGIC_VECTOR(7 downto 0);
    data_rx: out STD_LOGIC_VECTOR(7 downto 0);
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
    dbg_data_rx: out STD_LOGIC_VECTOR(7 downto 0);
    tick_rx, tick_tx: out std_logic;
    sample: out std_logic;
    tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
    busy_rx: out std_logic
); end;

architecture Uart_FD_arch of Uart_FD is
    constant ZERO: STD_LOGIC_VECTOR(18 downto 0) := (others => '0');

    signal Stick_rx, Stick_tx, Shas_rx_data, Sbusy_rx, Sbusy_tx, Sstart_tx: STD_LOGIC;
    signal Sdata_rx: STD_LOGIC_VECTOR(7 downto 0);
    signal Sdbg_rx_bit_count: STD_LOGIC_VECTOR(4 downto 0);

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
        tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
        start_tx: out std_LOGIC
    ); end component;

    component hex7seg port (
        x: in std_logic_vector(3 downto 0);
        enable: in std_logic;
        hex_output: out std_logic_vector(6 downto 0)
    ); end component;

    component ticker port (
        clk, load_rx, load_tx: in STD_LOGIC;
        modulo: in STD_LOGIC_VECTOR(18 downto 0);
        tick_rx, tick_tx: out STD_LOGIC
    ); end component;
begin
    new_rx_data <= Shas_rx_data;
    dbg_data_rx <= Sdata_rx;
    tick_rx <= Stick_rx;
    tick_tx <= Stick_tx;
    busy_rx <= Sbusy_rx;
    busy_tx <= Sbusy_tx;
    dbg_rx_bit_count <= Sdbg_rx_bit_count;
    data_rx <= Sdata_rx;
    IReceptor: Receptor port map (clk, serial_rx, reset, Stick_rx, Sbusy_rx, Shas_rx_data, Sdata_rx, Sdbg_rx_bit_count, sample);
    ITransmissor: Transmissor port map (clk, do_send, Stick_tx, data_tx, serial_tx, Sbusy_tx, tx_bit_count, Sstart_tx);
    Iticker: ticker port map (clk, not Sbusy_rx, Sstart_tx, ZERO + "1010001011000", Stick_rx, Stick_tx);
end Uart_FD_arch;
