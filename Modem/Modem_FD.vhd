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
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0)
); end;

architecture Modem_FD_arch of Modem_FD is
    component Receptor port (
        clk, serial: in STD_LOGIC;
        ready_led: out STD_LOGIC;
        data: out STD_LOGIC_VECTOR(7 downto 0);
        dbg_rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0)
    ); end component;

    component Transmissor port (
        clk, send: in STD_LOGIC;
        data: in STD_LOGIC_VECTOR(7 downto 0);
        serial, ready: out STD_LOGIC
    ); end component;
begin
    nDTR <= not liga;
    IReceptor: Receptor port map (clk, RD or nCD, recebido, dado_recebido, dbg_rx_bit_count);
    ITransmissor: Transmissor port map (clk, enviar, dado, TD, enviado);
end Modem_FD_arch;
