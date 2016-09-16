library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity deslocador is
    port (
        serial, clk, enable, load: in STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(10 downto 0);
        data_out: out STD_LOGIC_VECTOR(10 downto 0)
    );
end;

architecture deslocador_arch of deslocador is
    signal IQ : std_logic_vector (10 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
                if load = '1' then
                    IQ <= data_in;
                elsif enable = '1' then
                    IQ <= serial & IQ(10 downto 1);
                end if;
        end if;
        data_out <= IQ;
    end process;
end deslocador_arch;
