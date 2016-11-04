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
    signal Sball_down, Sball_right: STD_LOGIC;
begin
    x <= Sx;
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                Sx <= "0100110";
            elsif tick = '1' then
                if command = "01000000" then -- Right arrow
                    if Sx /= "1010000" then -- Right border
                        Sx <= Sx + '1';
                    end if;
                else
					if command = "00111101" then -- Left arrow
						if Sx /= "0000001" then -- Left border
							Sx <= Sx - '1';
						end if;
					end if;
                end if;
            end if;
        end if;
    end process;
end pad_arch;
