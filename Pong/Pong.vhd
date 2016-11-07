library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Pong is port (
    clk, redraw: in STD_LOGIC;
    tx, send, busy: out STD_LOGIC;
    dbg_term_data: out STD_LOGIC_VECTOR(7 downto 0);
    dbg_tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);

    nDTR, nRTS, TD: out STD_LOGIC;
    nCTS, nCD, RD: in STD_LOGIC
); end;

architecture Pong_arch of Pong is
    signal Splayer_x, Senemy_x, Sball_x_ascii, Sball_y_ascii: STD_LOGIC_VECTOR(15 downto 0);
    signal Sball_x, Sball_y, Sp1, Sp2: STD_LOGIC_VECTOR(6 downto 0);
    signal Sdata, Scomm: STD_LOGIC_VECTOR(7 downto 0);
    signal Ssend, Sbusy, Stimer_slow, Stimer_fast: STD_LOGIC := '0';
    signal Sgoal, Smove: STD_LOGIC := '0';
    signal Ssend_modem: STD_LOGIC := '0';
    signal Sscore1, Sscore2: STD_LOGIC_VECTOR(2 downto 0) := "000";

    component Uart port (
        clk, reset, rx, transmite_dado: in STD_LOGIC;
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

    component timer port (
        clk, enable, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(17 downto 0);
        pulse: out STD_LOGIC
    ); end component;

    component ball port (
        clk, reset, tick: in std_logic;
        ball_down: out std_logic;
        x: out std_logic_vector(6 downto 0);
        y: out std_logic_vector(6 downto 0)
    ); end component;

    component pad port (
      clk, reset, tick: in STD_LOGIC;
      command: in STD_LOGIC_VECTOR(7 downto 0);
      x: out STD_LOGIC_VECTOR(6 downto 0)
    ); end component;

    component scorer port (
        clk: in STD_LOGIC;
        ball_x, ball_y, player_x: in STD_LOGIC_VECTOR(6 downto 0);
        goal: out STD_LOGIC
    ); end component;

    component Modem port (
        clk, liga, enviar: in STD_LOGIC;
        dado: in STD_LOGIC_VECTOR(7 downto 0);
        recebido: out STD_LOGIC;
        dado_recebido: out STD_LOGIC_VECTOR(7 downto 0);

        nDTR, nRTS, TD: out STD_LOGIC;
        nCTS, nCD, RD: in STD_LOGIC;

        dbg_rx_bit_count: out STD_LOGIC_VECTOR(4 downto 0)
    ); end component;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            Ssend_modem <= '0';
        end if;
    end process;
    send <= Ssend;
    busy <= Sbusy;
    dbg_term_data <= Sdata;

    IUart: Uart port map (clk, '0', '1', Ssend, tx, Smove, Sbusy, Sdata, Scomm, open, open, open, open, open, dbg_tx_bit_count, open);
    P1: pad port map (clk, Sgoal, Smove, Scomm, Sp1);
    P2: pad port map (clk, Sgoal, Smove, Scomm, Sp2);
    ScP2: scorer port map (clk, Sball_x, Sball_y, Sp1, Sgoal);
    Itimer_quick: timer port map (clk, redraw, '0', "110000000000000000", Stimer_fast);
    Itimer_slow: timer port map (clk, Stimer_fast, '0', "000000000000100000", Stimer_slow);
    Iterm_draw: term_draw port map (clk, Stimer_slow, Sbusy, Splayer_x, Senemy_x, Sball_x_ascii, Sball_y_ascii, Sdata, Ssend);
    Iball: ball port map (clk, '0', Stimer_slow, open, Sball_x, Sball_y);
    Iplayer_x: bin_to_ascii port map (Sp1, Splayer_x);
    Ienemy_x: bin_to_ascii port map (Sp2, Senemy_x);
    Iball_y: bin_to_ascii port map (Sball_y, Sball_y_ascii);
    Iball_x: bin_to_ascii port map (Sball_x, Sball_x_ascii);

    IModem: Modem port map (clk, '1', Ssend_modem, "10011000", open, open, nDTR, nRTS, TD, nCTS, nCD, RD, open);
end Pong_arch;
