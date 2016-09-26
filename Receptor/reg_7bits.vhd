library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity reg_7bits is
    port (
        clk, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(6 downto 0);
        data_out: out STD_LOGIC_VECTOR(6 downto 0)
    );
end;

architecture reg_7bits_arch of reg_7bits is
    signal IQ : std_logic_vector (6 downto 0);
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
end reg_7bits_arch;