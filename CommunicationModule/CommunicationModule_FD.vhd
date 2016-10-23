library IEEE;
use IEEE.std_logic_1164.all;

entity CommunicationModule_FD is port (
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

architecture CommunicationModule_FD_arch of CommunicationModule_FD is
    signal Sterm_received, Smodem_received: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

    component Uart port (
        clk, reset, rx, recebe_dado, transmite_dado: in STD_LOGIC;
        tx, tem_dado_rec, transm_andamento: out STD_LOGIC;
        dado_trans: in STD_LOGIC_VECTOR(7 downto 0);
        dado_rec: out STD_LOGIC_VECTOR(7 downto 0);
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

    ITermUart: Uart port map (clk, reset, rx_term, receive_term, send_term, tx_term, open, open, data, Sterm_received, open, open, open, open, open, open);
    IModemUart: Uart port map (clk, reset, RD, '1', send_modem, TD, open, open, data, Smodem_received, open, open, open, open, open, open);
    IHexTerm1: hex7seg port map (Sterm_received(3 downto 0), '1', terminal_data_hex_1);
    IHexTerm2: hex7seg port map (Sterm_received(7 downto 4), '1', terminal_data_hex_2);
    IHexModem1: hex7seg port map (Smodem_received(3 downto 0), '1', modem_data_hex_1);
    IHexModem2: hex7seg port map (Smodem_received(7 downto 4), '1', modem_data_hex_2);
end CommunicationModule_FD_arch;
