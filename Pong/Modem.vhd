library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Modem is port (
    -- external interface
    clk, liga, enviar: in STD_LOGIC;
    dado: in STD_LOGIC_VECTOR(7 downto 0);
    recebido: out STD_LOGIC;
    dado_recebido: out STD_LOGIC_VECTOR(7 downto 0);
    busy_tx: out STD_LOGIC;

    -- modem interface
    nDTR, nRTS, TD: out STD_LOGIC;
    nCTS, nCD, RD: in STD_LOGIC;

    -- debug
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
); end;

architecture Modem_arch of Modem is
    signal Sbusy_tx, do_send_next: STD_LOGIC;

    component Modem_UC port (
        clk, send, busy_tx, nCTS: in STD_LOGIC;
        nRTS, do_send_next: out STD_LOGIC
    ); end component;

    component Modem_FD port (
        -- external interface
        clk, liga, enviar: in STD_LOGIC;
        dado: in  STD_LOGIC_VECTOR(7 downto 0);
        recebido, busy_tx: out STD_LOGIC;
        dado_recebido: out STD_LOGIC_VECTOR(7 downto 0);

        -- modem interface
        nDTR, TD: out STD_LOGIC;
        nCD, RD: in STD_LOGIC;

        -- debug
        dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
    ); end component;
begin
    busy_tx <= Sbusy_tx;

    IModem_UC: Modem_UC port map (clk, enviar, Sbusy_tx, nCTS, nRTS, do_send_next);
    IModem_FD: Modem_FD port map (clk, liga, do_send_next, dado, recebido, Sbusy_tx, dado_recebido, nDTR, TD, nCD, RD, dbg_rx_bit_count);
end Modem_arch;
