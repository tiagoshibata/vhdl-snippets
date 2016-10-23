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
    term_tx_bit_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
    term_rx_bit_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
    modem_tx_bit_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
    modem_rx_bit_count_hex: out STD_LOGIC_VECTOR(6 downto 0)
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
        term_tx_bit_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
        term_rx_bit_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
        modem_tx_bit_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
        modem_rx_bit_count_hex: out STD_LOGIC_VECTOR(6 downto 0)
    ); end component;
begin
    IFD: CommunicationModule_FD port map (clk, reset, send_term, send_modem, receive_term,
      rx_term, tx_term, nCTS, nCD, RD,nDTR, nRTS, TD, data, terminal_data_hex_1, terminal_data_hex_2,
      modem_data_hex_1, modem_data_hex_2, term_tx_bit_count_hex, term_rx_bit_count_hex,
      modem_tx_bit_count_hex, modem_rx_bit_count_hex);
end CommunicationModule_arch;
