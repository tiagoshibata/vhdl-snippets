library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ball is port (
    clk, reset, starting_direction, tick: in std_logic;
    x, y: out STD_LOGIC_VECTOR(6 downto 0)
); end ball;

architecture ball_impl of ball is
    signal Sx: STD_LOGIC_VECTOR(6 downto 0) := "0101000";
    signal Sy: STD_LOGIC_VECTOR(6 downto 0) := "0001100";
    signal Sball_down, Sball_right: STD_LOGIC := starting_direction;
begin
    x <= Sx;
    y <= Sy;
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                Sx <= "0101000";
                Sy <= "0001100";
                Sball_down <= starting_direction;
                Sball_right <= starting_direction;
            elsif tick = '1' then
                if Sball_right = '1' then
                    if Sx = "1010000" then
                        Sball_right <= '0';
                        Sx <= Sx - '1';
                    else
                        Sx <= Sx + '1';
                    end if;
                else
                    if Sx = "0000001" then
                        Sball_right <= '1';
                        Sx <= Sx + '1';
                    else
                        Sx <= Sx - '1';
                    end if;
                end if;

                if Sball_down = '1' then
                    if Sy = "0011000" then
                        Sball_down <= '0';
                        Sy <= Sy - '1';
                    else
                        Sy <= Sy + '1';
                    end if;
                else
                    if Sy = "0000001" then
                        Sball_down <= '1';
                        Sy <= Sy + '1';
                    else
                        Sy <= Sy - '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
end ball_impl;
