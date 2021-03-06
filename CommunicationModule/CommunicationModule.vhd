library IEEE;
use IEEE.std_logic_1164.all;

entity CommunicationModule is port (
    clk, reset, send_term, send_modem, receive_term, rx_term: in STD_LOGIC;
    tx_term: out STD_LOGIC;

    nCTS, nCD, RD: in STD_LOGIC;
    nDTR, nRTS, TD: out STD_LOGIC;

    data: in STD_LOGIC_VECTOR(7 downto 0);
    terminal_data_hex_1: out STD_LOGIC_VECTOR(6 downto 0);
    terminal_data_hex_2: out STD_LOGIC_VECTOR(6 downto 0);
    modem_data_hex_1: out STD_LOGIC_VECTOR(6 downto 0);
    modem_data_hex_2: out STD_LOGIC_VECTOR(6 downto 0);
    term_tx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
    term_rx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
    modem_tx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
    modem_rx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
    uart_busy_rx: out STD_LOGIC;
    busy_rx: out std_logic;
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
); end;

architecture CommunicationModule_arch of CommunicationModule is
    component CommunicationModule_FD port (
        clk, reset, send_term, send_modem, receive_term, rx_term: in STD_LOGIC;
        tx_term: out STD_LOGIC;

        nCTS, nCD, RD: in STD_LOGIC;
        nDTR, nRTS, TD: out STD_LOGIC;

        data: in STD_LOGIC_VECTOR(7 downto 0);
        terminal_data_hex_1: out STD_LOGIC_VECTOR(6 downto 0);
        terminal_data_hex_2: out STD_LOGIC_VECTOR(6 downto 0);
        modem_data_hex_1: out STD_LOGIC_VECTOR(6 downto 0);
        modem_data_hex_2: out STD_LOGIC_VECTOR(6 downto 0);
        term_tx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
        term_rx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
        modem_tx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
        modem_rx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
		uart_busy_rx: out STD_LOGIC;
		busy_rx: out std_logic;
		data_received_modem: out STD_LOGIC_VECTOR(7 downto 0);
		dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
    ); end component;
begin
    IFD: CommunicationModule_FD port map (clk, reset, send_term, send_modem, receive_term,
      rx_term, tx_term, nCTS, nCD, RD,nDTR, nRTS, TD, data, terminal_data_hex_1, terminal_data_hex_2,
      modem_data_hex_1, modem_data_hex_2, term_tx_byte_count_hex, term_rx_byte_count_hex,
      modem_tx_byte_count_hex, modem_rx_byte_count_hex, uart_busy_rx, busy_rx, open, dbg_rx_bit_count);
end CommunicationModule_arch;
