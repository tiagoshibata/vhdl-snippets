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
    constant KEY_RIGHT: STD_LOGIC_VECTOR(7 downto 0) := "01100100";
    constant KEY_LEFT: STD_LOGIC_VECTOR(7 downto 0) := "01100001";
    constant CENTER: STD_LOGIC_VECTOR(6 downto 0) := "0100111";
    
    signal Sx: STD_LOGIC_VECTOR(6 downto 0) := CENTER;
    signal Sright, Sleft: STD_LOGIC;
begin
    x <= Sx;

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                Sx <= CENTER;
                Sright <= '0';
                Sleft <= '0';
            else
                if command = KEY_RIGHT then
                    Sright <= '1';
                    Sleft <= '0';
                elsif command = KEY_LEFT then
                    Sright <= '0';
                    Sleft <= '1';
                end if;
                if tick = '1' then
                    if Sright = '1' and Sx /= "1001100" then
                        Sx <= Sx + "10";
                    elsif Sleft = '1' and Sx /= "0000010" then
                        Sx <= Sx - "10";
                    end if;
                end if;
            end if;
        end if;
    end process;
end pad_arch;
