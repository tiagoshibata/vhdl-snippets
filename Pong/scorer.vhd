library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity scorer is port (
    clk: in STD_LOGIC;
    ball_x, ball_y, player_x: in STD_LOGIC_VECTOR(6 downto 0);
    goal: out STD_LOGIC
); end scorer;

architecture scorer_arch of scorer is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if ball_y = "0000001" and (ball_x < player_x or ball_x > player_x + "0000100") then
                goal <= '1';
            else
                goal <= '0';
            end if;
        end if;
    end process;
end scorer_arch;
