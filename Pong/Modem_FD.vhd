library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Modem_FD is port (
    -- external interface
    clk, enable, send: in STD_LOGIC;
    data_in: in  STD_LOGIC_VECTOR(7 downto 0);
    received, busy_tx: out STD_LOGIC;
    data_out: out STD_LOGIC_VECTOR(7 downto 0);

    -- modem interface
    nDTR, TD: out STD_LOGIC;
    nCD, RD: in STD_LOGIC
); end;

architecture Modem_FD_arch of Modem_FD is
    signal Sbusy_rx, Stick_rx, Stick_tx: STD_LOGIC;

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

    component ticker port (
        clk, load_rx, load_tx: in STD_LOGIC;
        modulo: in STD_LOGIC_VECTOR(18 downto 0);
        tick_rx, tick_tx: out STD_LOGIC
    ); end component;
begin
    nDTR <= not enable;

    IReceptor: Receptor port map (clk, RD, nCD, Stick_rx, Sbusy_rx, received, data_out, open, open);
    ITransmissor: Transmissor port map (clk, send, Stick_tx, data_in, TD, busy_tx, open, open);
    Iticker: ticker port map (clk, not Sbusy_rx, send, "1101110111110010001", Stick_rx, Stick_tx);
end Modem_FD_arch;
