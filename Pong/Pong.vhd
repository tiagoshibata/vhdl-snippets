library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Pong is port (
    clk, rx, is_client: in STD_LOGIC;
    tx, send, busy: out STD_LOGIC;
    dbg_term_data: out STD_LOGIC_VECTOR(7 downto 0);
    dbg_tx_bit_count: out STD_LOGIC_VECTOR(4 downto 0);

    nDTR, nRTS, TD: out STD_LOGIC;
    nCTS, nCD, RD: in STD_LOGIC;

    score1: out STD_LOGIC_VECTOR(6 downto 0)
); end;

architecture Pong_arch of Pong is
    signal Splayer_x_ascii, Senemy_x_ascii, Sball_x_ascii, Sball_y_ascii: STD_LOGIC_VECTOR(15 downto 0);
    signal Sball_x, Sball_y, Splayer_x: STD_LOGIC_VECTOR(6 downto 0);
    signal Senemy_x: STD_LOGIC_VECTOR(6 downto 0) := "0100110";
    signal ballxbuffer, pxbuffer: STD_LOGIC_VECTOR(7 downto 0);
    signal Sdata, Sterminal_data, Smodem_data, Smodem_received_data: STD_LOGIC_VECTOR(7 downto 0);
    signal Ssend, Sbusy, Stimer_slow, Stimer_fast, Stick: STD_LOGIC := '0';
    signal Sgoal, actSc1, actSc2, Sgoal_taken, Sgoal_score, Ssend_goal_taken, Sreset_goal_taken: STD_LOGIC := '0';
    signal Ssend_modem: STD_LOGIC := '1';
    signal Sscore_player, Sscore_enemy: STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal Swait, Smodem_received, Smodem_busy_tx: STD_LOGIC := '0';

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
        data_in: in STD_LOGIC_VECTOR(18 downto 0);
        pulse: out STD_LOGIC
    ); end component;

    component ball port (
        clk, reset, starting_direction, tick: in std_logic;
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

    component hex7seg port (
        x : in std_logic_vector(3 downto 0);
        enable : in std_logic;
        hex_output : out std_logic_vector(6 downto 0)
    ); end component;

    component Modem port (
        clk, liga, enviar: in STD_LOGIC;
        dado: in STD_LOGIC_VECTOR(7 downto 0);
        recebido: out STD_LOGIC;
        dado_recebido: out STD_LOGIC_VECTOR(7 downto 0);
        busy_tx: out STD_LOGIC;

        nDTR, nRTS, TD: out STD_LOGIC;
        nCTS, nCD, RD: in STD_LOGIC
    ); end component;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if Sgoal_taken = '1' then
                Ssend_goal_taken <= '1';
            elsif Stick = '1' then
                Sreset_goal_taken <= '1';
            elsif Sreset_goal_taken = '1' then
                Sreset_goal_taken <= '0';
                Ssend_goal_taken <= '0';
            end if;
            if Ssend_goal_taken = '1' then
                Smodem_data <= (others => '0');
            else
                Smodem_data <= "01001101" - Splayer_x;
            end if;

            if Smodem_received = '1' then
                if Smodem_received_data > "00000000" and Smodem_received_data < "1001101" then
                    Senemy_x <= Smodem_received_data(6 downto 0);
                elsif Smodem_received_data = "00000000" then
                    Sscore_player <= Sscore_player + '1';
                    Senemy_x <= "0100110";
                    Sgoal_score <= '1';
                end if;
            else
                Sgoal_score <= '0';
            end if;
        end if;
    end process;
    Sgoal <= Sgoal_taken or Sgoal_score;
    send <= Ssend;
    busy <= Sbusy;
    dbg_term_data <= Sdata;
    Stick <= (is_client and Stimer_slow) or (not is_client and Smodem_received);

    IUart: Uart port map (clk, '0', rx, Ssend, tx, open, Sbusy, Sdata, Sterminal_data, open, open, open, open, open, dbg_tx_bit_count, open);
    Ipad: pad port map (clk, Sgoal, Stick, Sterminal_data, Splayer_x);
    Iscorer: scorer port map (clk, Sball_x, Sball_y, Splayer_x, Sgoal_taken);
    Itimer_quick: timer port map (clk, is_client, not is_client, "0110000000000000000", Stimer_fast);
    Itimer_slow: timer port map (clk, Stimer_fast, not is_client, "0000000000000101000", Stimer_slow);
    Iterm_draw: term_draw port map (clk, Stick, Sbusy, Splayer_x_ascii, Senemy_x_ascii, Sball_x_ascii, Sball_y_ascii, Sdata, Ssend);
    Iball: ball port map (clk, Sgoal, is_client, Stick, Sball_x, Sball_y);
    ScoreHex: hex7seg port map (Sscore_player, '1', score1);
    Iplayer_x: bin_to_ascii port map (Splayer_x, Splayer_x_ascii);
    Ienemy_x: bin_to_ascii port map (Senemy_x, Senemy_x_ascii);
    Iball_y: bin_to_ascii port map (Sball_y, Sball_y_ascii);
    Iball_x: bin_to_ascii port map (Sball_x, Sball_x_ascii);
    IModem: Modem port map (clk, '1', Stick, Smodem_data, Smodem_received, Smodem_received_data, Smodem_busy_tx, nDTR, nRTS, TD, nCTS, nCD, RD);
end Pong_arch;
