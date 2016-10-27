library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Pong is port (
    clk, redraw: in STD_LOGIC;
    tx, send, busy: out STD_LOGIC;
    dbg_term_data: out STD_LOGIC_VECTOR(7 downto 0);
    dbg_tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
); end;

architecture Pong_arch of Pong is
    signal Splayer_x, Senemy_x, Sball_x, Sball_y: STD_LOGIC_VECTOR(15 downto 0);
    signal Sdata: STD_LOGIC_VECTOR(7 downto 0);
    signal Ssend, Sbusy: STD_LOGIC := '0';

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

    component term_draw port (
        clk, redraw, serial_busy: in STD_LOGIC;
        player_x: in STD_LOGIC_VECTOR(15 downto 0);
        enemy_x: in STD_LOGIC_VECTOR(15 downto 0);
        ball_x: in STD_LOGIC_VECTOR(15 downto 0);
        ball_y: in STD_LOGIC_VECTOR(15 downto 0);
        data: out STD_LOGIC_VECTOR(7 downto 0);
        serial_send: out STD_LOGIC
    ); end component;

    component bin_to_ascii port (
        bin: in STD_LOGIC_VECTOR(6 downto 0);
        dec: out STD_LOGIC_VECTOR(15 downto 0)
    ); end component;
begin
    send <= Ssend;
    busy <= Sbusy;
    dbg_term_data <= Sdata;

    IUart: Uart port map (clk, '0', '1', '0', Ssend, tx, open, Sbusy, Sdata, open, open, open, open, open, open, dbg_tx_bit_count, open);
    Iterm_draw: term_draw port map (clk, redraw, Sbusy, Splayer_x, Senemy_x, Sball_x, Sball_y, Sdata, Ssend);
    Iplayer_x: bin_to_ascii port map ("0000001", Splayer_x);
    Ienemy_x: bin_to_ascii port map ("0000001", Senemy_x);
    Iball_x: bin_to_ascii port map ("0000100", Sball_x);
    Iball_y: bin_to_ascii port map ("0000101", Sball_y);
end Pong_arch;
