library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Modem_FD is port (
    -- external interface
    clk, liga, enviar: in STD_LOGIC;
    dado: in  STD_LOGIC_VECTOR(7 downto 0);
    recebido, enviado: out STD_LOGIC;
    dado_recebido: out STD_LOGIC_VECTOR(7 downto 0);

    -- modem interface
    nDTR, TD: out STD_LOGIC;
    nCD, RD: in STD_LOGIC;

    -- debug
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
); end;

architecture Modem_FD_arch of Modem_FD is
    signal Sdado_recebido, Sdado_receptor: STD_LOGIC_VECTOR(7 downto 0);
    signal Sended_receiving, Sbusy_rx, Stick_rx, Stick_tx: STD_LOGIC;

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

    component Register8 port (
        clk, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(7 downto 0);
        data_out: out STD_LOGIC_VECTOR(7 downto 0)
    ); end component;

    component ticker port (
        clk, load_rx, load_tx: in STD_LOGIC;
        tick_rx, tick_tx: out STD_LOGIC
    ); end component;
begin
    nDTR <= not liga;
    dado_recebido <= Sdado_recebido;

    IReceptor: Receptor port map (clk, RD, nCD, Stick_rx, Sbusy_rx, recebido, Sdado_receptor, open, open);
    ITransmissor: Transmissor port map (clk, enviar, Stick_tx, dado, TD, open, open, open);
    OutputBuffer: Register8 port map (clk, Sended_receiving, Sdado_receptor, Sdado_recebido);
    Iticker: ticker port map (clk, not Sbusy_rx, enviar, Stick_rx, Stick_tx);
end Modem_FD_arch;
