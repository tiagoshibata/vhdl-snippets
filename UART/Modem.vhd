library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Modem is port (
    -- external interface
    clk, recebe_dado, transmite_dado: in STD_LOGIC;
    dado_trans: in  STD_LOGIC_VECTOR(7 downto 0);
    recebido, transm_iniciada, transm_andamento, tem_dado_rec: out STD_LOGIC;
    dado_rec: out STD_LOGIC_VECTOR(7 downto 0);

    -- modem interface
    nDTR, nRTS, TD: out STD_LOGIC;
    nCTS, nCD, RD: in STD_LOGIC;

    -- debug
    dbg_rx_bit_count: out STD_LOGIC_VECTOR(3 downto 0);
    hex1: out STD_LOGIC_VECTOR(6 downto 0);
    hex2: out STD_LOGIC_VECTOR(6 downto 0)
); end;

architecture Modem_arch of Modem is
    signal enviado, do_send_next: STD_LOGIC;

    component Modem_UC port (
        clk, send, ready, nCTS: in STD_LOGIC;
        nRTS, do_send_next, tr_andamento: out STD_LOGIC
	); end component;

    component Modem_FD port (
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
    ); end component;
begin
	transm_iniciada <= do_send_next;
    IModem_UC: Modem_UC port map (clk, transmite_dado, enviado, nCTS, nRTS, do_send_next, transm_andamento);
    IModem_FD: Modem_FD port map (clk, recebe_dado, '1', do_send_next, dado_trans, recebido, enviado, tem_dado_rec,
		dado_rec, nDTR, TD, nCD, RD, dbg_rx_bit_count, hex1, hex2);
end Modem_arch;
