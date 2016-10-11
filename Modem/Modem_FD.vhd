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
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0);
    hex1: out STD_LOGIC_VECTOR(6 downto 0);
    hex2: out STD_LOGIC_VECTOR(6 downto 0)
); end;

architecture Modem_FD_arch of Modem_FD is
	signal Sdado_recebido: STD_LOGIC_VECTOR(7 downto 0);
	signal Srecebido: STD_LOGIC;

    component Receptor port (
        clk, serial, reset: in STD_LOGIC;
        ready_led: out STD_LOGIC;
        data: out STD_LOGIC_VECTOR(7 downto 0);
        dbg_rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0)
    ); end component;

    component Transmissor port (
        clk, send: in STD_LOGIC;
        data: in STD_LOGIC_VECTOR(7 downto 0);
        serial, ready: out STD_LOGIC
    ); end component;

    component hex7seg port (
		x : in std_logic_vector(3 downto 0);
		enable : in std_logic;
		hex_output : out std_logic_vector(6 downto 0)
	); end component;
begin
    nDTR <= not liga;
    dado_recebido <= Sdado_recebido;
    recebido <= Srecebido;

    IReceptor: Receptor port map (clk, RD , nCD, Srecebido, Sdado_recebido, dbg_rx_bit_count);
    ITransmissor: Transmissor port map (clk, enviar, dado, TD, enviado);
    Display0: hex7seg port map (Sdado_recebido(3 downto 0), Srecebido, hex1);
    Display1: hex7seg port map (Sdado_recebido(7 downto 4), Srecebido, hex2);
end Modem_FD_arch;
