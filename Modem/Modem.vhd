library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Modem is port (
    -- external interface
    clk, reset, liga: in STD_LOGIC;
    dado: in  STD_LOGIC_VECTOR(7 downto 0);
    enviar: in STD_LOGIC;
    recebido: out STD_LOGIC;
    dado_recebido: out STD_LOGIC_VECTOR(7 downto 0);

    -- modem interface
    nDTR, nRTS, TD: out STD_LOGIC;
    nCTS, nCD, RD: in STD_LOGIC;

    -- debug
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0)
); end;

architecture Modem_arch of Modem is
    signal ready_to_receive, start_receiving, output_ready: STD_LOGIC;

    component Modem_UC port (
		cont: in STD_LOGIC_VECTOR(3 downto 0);
		serial, clk: in STD_LOGIC;
	    ready_to_receive, start_receiving, output_ready: out STD_LOGIC
	); end component;

    component Receptor port (
        clk, serial: in STD_LOGIC;
        ready_led: out STD_LOGIC;
        data: out STD_LOGIC_VECTOR(7 downto 0);
        dbg_rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0)
    ); end component;
begin
    nDTR <= not liga;
    IReceptor: Receptor port map (clk, RD or nCD, recebido, dado_recebido, dbg_rx_bit_count);
    IModem_UC: Modem_UC port map (rx_bit_count, serial, clk, ready_to_receive, start_receiving, output_ready);
end Modem_arch;
