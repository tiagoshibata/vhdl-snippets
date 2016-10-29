library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity term_draw is port (
    clk, redraw, serial_busy: in STD_LOGIC;
    player_x: in STD_LOGIC_VECTOR(15 downto 0);
    enemy_x: in STD_LOGIC_VECTOR(15 downto 0);
    ball_x: in STD_LOGIC_VECTOR(15 downto 0);
    ball_y: in STD_LOGIC_VECTOR(15 downto 0);
    data: out STD_LOGIC_VECTOR(7 downto 0);
    serial_send: out STD_LOGIC
); end term_draw;

architecture term_draw_impl of term_draw is
    type term_state is (idle, sending);
    signal Sstate: term_state := idle;
    signal Sold_busy, Sshift_cycle: STD_LOGIC := '0';
    signal Sdata: STD_LOGIC_VECTOR(287 downto 0) := (others => '0');  -- 32 bytes

    -- ASCII characters:
    constant ESC: STD_LOGIC_VECTOR(7 downto 0) := "00011011";  -- ESC = 1B = 00011011
    constant ESCSEQ: STD_LOGIC_VECTOR(15 downto 0) := ESC & "01011011";  -- Escape sequence = ESC & "["
    constant SEP: STD_LOGIC_VECTOR(7 downto 0) := "00111011";  -- ; (separator)
    constant BAR: STD_LOGIC_VECTOR(7 downto 0) := "00111101";  -- -
    constant BALL: STD_LOGIC_VECTOR(7 downto 0) := "01000000";  -- @
begin
    data <= Sdata(287 downto 280);

    process(clk)
    begin
        if rising_edge(clk) then
            case Sstate is
            when idle =>
                -- Terminal escape sequences:
                -- Clear screen: ESCSEQ & "2J"
                -- Move to position: ESCSEQ & "LINE;COLUMN" & "H"
                Sdata <= ESCSEQ & "00110010" & "01001010" &  -- clear screen (2J)
                    ESCSEQ & "00110001" & SEP & enemy_x & "01001000" &  -- move to enemy (enemy_x;0H)
                    BAR & BAR & BAR & BAR &
                    ESCSEQ & ball_x & SEP & ball_y & "01001000" &  -- move to ball (ball_x;ball_yH)
                    BALL &
                    ESCSEQ & "00110010" & "00110101" & SEP & player_x & "01001000" &  -- move to player (player_x;25H)
                    BAR & BAR & BAR & BAR;
			    Sold_busy <= '0';
                if redraw = '1' then
                    serial_send <= '1';
                    Sstate <= sending;
                else
                    serial_send <= '0';
                end if;

            when sending =>
                if serial_busy = '0' and Sold_busy = '1' then
                    if Sdata(279 downto 272) = "00000000" then
                        serial_send <= '0';
                        Sstate <= idle;
                    else
						if Sshift_cycle = '1'then
							Sdata <= Sdata(279 downto 0) & "00000000";
						end if;
						Sshift_cycle <= not Sshift_cycle;
                        serial_send <= '1';
                    end if;
                else
                    serial_send <= '0';
                end if;
            end case;
            Sold_busy <= serial_busy;
        end if;
    end process;
end term_draw_impl;
