library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Modem_FD is port (
    -- external interface
    clk, recebe_dado, liga, enviar: in STD_LOGIC;
    dado: in  STD_LOGIC_VECTOR(7 downto 0);
    recebido, enviado, tem_dado_rec: out STD_LOGIC;
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
    signal Sdado_recebido, Sdado_receptor, Sbuffer: STD_LOGIC_VECTOR(7 downto 0);
    signal Srecebido: STD_LOGIC;
    signal Sended_receiving: STD_LOGIC;
    signal trx, ttx: STD_LOGIC;

    component Receptor port (
        tick, clk, serial, reset: in STD_LOGIC;
        ready_led, ended_receiving: out STD_LOGIC;
        data: out STD_LOGIC_VECTOR(7 downto 0);
        dbg_rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0)
    ); end component;

    component Transmissor port (
        tick, clk, send: in STD_LOGIC;
        data: in STD_LOGIC_VECTOR(7 downto 0);
        serial, ready: out STD_LOGIC
    ); end component;

    component Register8 port (
        clk, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(7 downto 0);
        data_out: out STD_LOGIC_VECTOR(7 downto 0)
    ); end component;
    
    component AnaliseBuffer port (
		clk, analisa: in STD_LOGIC;
		dado1, dado2: in STD_LOGIC_VECTOR(7 downto 0);
		iguais: out STD_LOGIC
	); end component;

    component hex7seg port (
        x : in std_logic_vector(3 downto 0);
        enable : in std_logic;
        hex_output : out std_logic_vector(6 downto 0)
    ); end component;
    
    component ticker port (
		clk, load_rx: in std_logic;
		tick_rx, tick_tx: out std_logic
	); end component;
begin
    nDTR <= not liga;
    dado_recebido <= Sdado_recebido;
    recebido <= Srecebido;

    IReceptor: Receptor port map (trx, clk, RD , nCD, Srecebido, Sended_receiving, Sdado_receptor, dbg_rx_bit_count);
    ITransmissor: Transmissor port map (ttx, clk, enviar, dado, TD, enviado);
    OutputBuffer: Register8 port map (clk, Sended_receiving, Sdado_receptor , Sbuffer);
    Saida: Register8 port map (clk, recebe_dado, Sbuffer , Sdado_recebido);
    ticks: ticker port map (clk, enviar, trx, ttx);
    DadoRec: AnaliseBuffer port map (clk, Sended_receiving, Sbuffer, Sdado_recebido, tem_dado_rec);
    Display0: hex7seg port map (Sdado_recebido(3 downto 0), Srecebido, hex1);
    Display1: hex7seg port map (Sdado_recebido(7 downto 4), Srecebido, hex2);
end Modem_FD_arch;
