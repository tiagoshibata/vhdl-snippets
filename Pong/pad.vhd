library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pad is port (
    clk, reset, tick: in STD_LOGIC;
    command: in STD_LOGIC_VECTOR(7 downto 0);
    x: out STD_LOGIC_VECTOR(6 downto 0)
); end pad;

architecture pad_arch of pad is
    signal Sx: STD_LOGIC_VECTOR(6 downto 0) := "0100110";
    signal Sball_down, Sball_right, Sright, Sleft: STD_LOGIC;
begin
    x <= Sx;
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                Sx <= "0100110";
                Sright <= '0';
                Sleft <= '0';
            elsif tick = '1' then
                if command = "01100100" then
                    Sright <= '1';
                    Sleft <= '0';
                else
                    if command = "01100001" then
                        Sright <= '0';
                        Sleft <= '1';
                    end if;
                end if;
                if Sright = '1' then -- Right arrow (d)
                    if Sx /= "1001100" then -- Right border
                        Sx <= Sx + "10";
                    end if;
                else
                    if Sleft = '1' then -- Left arrow (a)
                        if Sx /= "0000010" then -- Left border
                            Sx <= Sx - "10";
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
end pad_arch;