library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity scorer is port (
    clk, tick: in STD_LOGIC;
    ballx, px: in STD_LOGIC_VECTOR(6 downto 0);
    goal: out STD_LOGIC
); end scorer;

architecture scorer_arch of scorer is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if tick = '1' then
                if (ballx < px - "0000010" or ballx > px + "0000110") then
                    goal <= '1';
                else
                    goal <= '0';
                end if;
            end if;
        end if;
    end process;
end scorer_arch;