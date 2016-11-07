library IEEE;
use IEEE.std_logic_1164.all;

entity Uart is port (
    clk, reset, rx, recebe_dado, transmite_dado: in STD_LOGIC;
    tx, tem_dado_rec, transm_andamento: out STD_LOGIC;
    dado_trans: in STD_LOGIC_VECTOR(7 downto 0);
    dado_rec: out STD_LOGIC_VECTOR(7 downto 0);
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
    dbg_data_rx: out STD_LOGIC_VECTOR(7 downto 0);
    tick_rx, tick_tx: out std_logic;
    sample: out std_logic;
    tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
    busy_rx: out std_logic
); end;

architecture Uart_arch of Uart is
    signal Snew_rx_data, Sbusy_tx, Spulse_send_next: STD_LOGIC;

    component Uart_UC port (
        clk, send, new_rx_data, recebe_dado, busy_tx: in STD_LOGIC;
        pulse_send_next, has_rx_data: out STD_LOGIC
    ); end component;

    component Uart_FD port (
        clk, reset, serial_rx, do_send, receive: in STD_LOGIC;
        serial_tx, busy_tx, new_rx_data: out STD_LOGIC;
        data_tx: in STD_LOGIC_VECTOR(7 downto 0);
        data_rx: out STD_LOGIC_VECTOR(7 downto 0);
        dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
        dbg_data_rx: out STD_LOGIC_VECTOR(7 downto 0);
        tick_rx, tick_tx: out std_logic;
        sample: out std_logic;
        tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
    busy_rx: out std_logic
    ); end component;
begin
    transm_andamento <= Sbusy_tx;

    IUC: Uart_UC port map (clk, transmite_dado, Snew_rx_data, recebe_dado, Sbusy_tx, Spulse_send_next, tem_dado_rec);
    IFD: Uart_FD port map (clk, reset, rx, Spulse_send_next, recebe_dado, tx, Sbusy_tx,
        Snew_rx_data, dado_trans, dado_rec, dbg_rx_bit_count, dbg_data_rx, tick_rx, tick_tx, sample, tx_bit_count, busy_rx);
end Uart_arch;
