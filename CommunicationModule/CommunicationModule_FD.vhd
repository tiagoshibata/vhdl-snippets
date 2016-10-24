library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

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
    term_tx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
    term_rx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
    modem_tx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0);
    modem_rx_byte_count_hex: out STD_LOGIC_VECTOR(6 downto 0)
); end;

architecture CommunicationModule_FD_arch of CommunicationModule_FD is
    signal Sterm_tick_rx, Sold_send_term, Sold_nCD, SnRTS, Sold_nRTS: STD_LOGIC;
    signal Sterm_dbg_rx_bit_count: STD_LOGIC_VECTOR(4 downto 0);
    signal Sterm_received, Smodem_received: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal Sterm_tx_byte_count_hex, Sterm_rx_byte_count_hex, Smodem_tx_byte_count_hex, Smodem_rx_byte_count_hex: STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

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

    component Modem port (
        -- external interface
        clk, reset, enviar: in STD_LOGIC;
        dado: in  STD_LOGIC_VECTOR(7 downto 0);
        recebido: out STD_LOGIC;
        dado_recebido: out STD_LOGIC_VECTOR(7 downto 0);

        -- modem interface
        nDTR, nRTS, TD: out STD_LOGIC;
        nCTS, nCD, RD: in STD_LOGIC;

        -- debug
        dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
    ); end component;

    component hex7seg port (
    		x: in std_logic_vector(3 downto 0);
    		enable: in std_logic;
    		hex_output: out std_logic_vector(6 downto 0)
  	); end component;
begin
    nDTR <= reset;
    nRTS <= SnRTS;

    ITermUart: Uart port map (clk, reset, rx_term, receive_term, send_term, tx_term, open, open, data, Sterm_received, open, open, Sterm_tick_rx, open, open, Sterm_dbg_rx_bit_count);
    IModem: Modem port map (clk, reset, send_modem, data, open, Smodem_received, nDTR, SnRTS, TD, nCTS, nCD, RD, open);
    IHexTerm1: hex7seg port map (Sterm_received(3 downto 0), '1', terminal_data_hex_1);
    IHexTerm2: hex7seg port map (Sterm_received(7 downto 4), '1', terminal_data_hex_2);
    IHexModem1: hex7seg port map (Smodem_received(3 downto 0), '1', modem_data_hex_1);
    IHexModem2: hex7seg port map (Smodem_received(7 downto 4), '1', modem_data_hex_2);

    process(clk)
    begin
        if rising_edge(clk) then
            if Sterm_tick_rx = '1' and Sterm_dbg_rx_bit_count = "00010" then
                Sterm_rx_byte_count_hex <= Sterm_rx_byte_count_hex + 1;
            end if;

            if Sold_send_term = '0' and send_term = '1' then
                Sterm_tx_byte_count_hex <= Sterm_tx_byte_count_hex + 1;
            end if;

            if Sold_nCD = '0' and nCD = '1' then
                Smodem_rx_byte_count_hex <= Smodem_rx_byte_count_hex + 1;
            end if;

            if Sold_nRTS = '0' and SnRTS = '1' then
                Smodem_tx_byte_count_hex <= Smodem_tx_byte_count_hex + 1;
            end if;

            Sold_send_term <= send_term;
            Sold_nCD <= nCD;
            Sold_nRTS <= SnRTS;
        end if;
    end process;

    -- statistics
    IStatTermRx: hex7seg port map (Sterm_rx_byte_count_hex, '1', term_rx_byte_count_hex);
    IStatTermTx: hex7seg port map (Sterm_tx_byte_count_hex, '1', term_tx_byte_count_hex);
    IStatModemRx: hex7seg port map (Smodem_rx_byte_count_hex, '1', modem_rx_byte_count_hex);
    IStatModemTx: hex7seg port map (Smodem_tx_byte_count_hex, '1', modem_tx_byte_count_hex);
end CommunicationModule_FD_arch;
