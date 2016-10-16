library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity register8 is port (
    clk, load: in STD_LOGIC;
    data_in: in STD_LOGIC_VECTOR(7 downto 0);
    data_out: out STD_LOGIC_VECTOR(7 downto 0)
); end;

architecture register8_arch of register8 is
    signal IQ: std_logic_vector (7 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if load = '1' then
                IQ <= data_in;
            end if;
        end if;
        data_out <= IQ;
    end process;
end register8_arch;
