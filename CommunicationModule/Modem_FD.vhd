library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Modem_FD is port (
    -- external interface
    clk, reset, enviar: in STD_LOGIC;
    dado: in  STD_LOGIC_VECTOR(7 downto 0);
    recebido, enviado: out STD_LOGIC;
    dado_recebido: out STD_LOGIC_VECTOR(7 downto 0);

    -- modem interface
    nDTR, TD: out STD_LOGIC;
    nCD, RD: in STD_LOGIC;

    -- debug
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
    busy_rx: out STD_LOGIC
); end;

architecture Modem_FD_arch of Modem_FD is
    signal Sdado_receptor: STD_LOGIC_VECTOR(7 downto 0);
    signal Srecebido: STD_LOGIC;
    signal Sended_receiving: STD_LOGIC;
    signal Sundergoing_tx: STD_LOGIC;

    component Uart port (
        clk, reset, rx, recebe_dado, transmite_dado: in STD_LOGIC;
        tx, tem_dado_rec, transm_andamento: out STD_LOGIC;
        dado_trans: in STD_LOGIC_VECTOR(7 downto 0);
        dado_rec: out STD_LOGIC_VECTOR(7 downto 0);
        dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
        dbg_data_rx: out STD_LOGIC_VECTOR(7 downto 0);
        tick_rx, tick_tx: out std_logic;
        sample: out std_logic;
        tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);
		busy_rx: out std_logic
    ); end component;

    component Register8 port (
        clk, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(7 downto 0);
        data_out: out STD_LOGIC_VECTOR(7 downto 0)
    ); end component;
begin
    nDTR <= reset;
    recebido <= Srecebido;
    enviado <= not Sundergoing_tx;

    IModemUart: Uart port map (clk, '0', RD, nCD, enviar, TD, open, Sundergoing_tx, dado, dado_recebido, dbg_rx_bit_count, open, open, open, open, open, busy_rx);
    -- OutputBuffer: Register8 port map (clk, Sended_receiving, Sdado_receptor, dado_recebido);
end Modem_FD_arch;
