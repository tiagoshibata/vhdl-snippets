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
    hex1: out std_logic_vector(6 downto 0);
    hex2: out std_logic_vector(6 downto 0);
    tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
); end;

architecture Uart_arch of Uart is
    signal Snew_rx_data, Sbusy_tx, Spulse_send_next: STD_LOGIC;
    signal Sdado_rec: STD_LOGIC_VECTOR(7 downto 0);

    component Uart_UC port (
        clk, send, new_rx_data, recebe_dado, busy_tx: in STD_LOGIC;
        pulse_send_next, has_rx_data: out STD_LOGIC
    ); end component;

    component Uart_FD port (
        clk, reset, serial_rx, do_send: in STD_LOGIC;
        serial_tx, busy_tx, new_rx_data: out STD_LOGIC;
        data_tx: in STD_LOGIC_VECTOR(7 downto 0);
        data_rx: out STD_LOGIC_VECTOR(7 downto 0);
        dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
        dbg_data_rx: out STD_LOGIC_VECTOR(7 downto 0);
        tick_rx, tick_tx: out std_logic;
        sample: out std_logic;
        tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
    ); end component;

    component hex7seg port (
  		x: in std_logic_vector(3 downto 0);
  		enable: in std_logic;
  		hex_output: out std_logic_vector(6 downto 0)
  	); end component;
begin
    transm_andamento <= Sbusy_tx;
    dado_rec <= Sdado_rec;

    IUC: Uart_UC port map (clk, transmite_dado, Snew_rx_data, recebe_dado, Sbusy_tx, Spulse_send_next, tem_dado_rec);
    IFD: Uart_FD port map (clk, reset, rx, Spulse_send_next, tx, Sbusy_tx,
        Snew_rx_data, dado_trans, Sdado_rec, dbg_rx_bit_count, dbg_data_rx, tick_rx, tick_tx, sample, tx_bit_count);
    Ihex1: hex7seg port map (Sdado_rec(3 downto 0), '1', hex1);
    Ihex2: hex7seg port map (Sdado_rec(7 downto 4), '1', hex2);
end Uart_arch;
