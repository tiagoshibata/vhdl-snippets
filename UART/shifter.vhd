library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity shifter is
    port (
        clk, enable, serial_in, load: in STD_LOGIC;
        serial_out: out STD_LOGIC;
        data_in: in STD_LOGIC_VECTOR(9 downto 0);
        data_out: out STD_LOGIC_VECTOR(9 downto 0)
    );
end;

architecture shifter_arch of shifter is
    signal IQ: std_logic_vector (9 downto 0) := (others => '1');
begin
    serial_out <= IQ(0);
    process (clk, IQ)
    begin
        if rising_edge(clk) then
                if load = '1' then
                    IQ <= data_in;
                elsif enable = '1' then
                    IQ <= serial_in & IQ(9 downto 1);
                end if;
        end if;
        data_out <= IQ;
    end process;
end shifter_arch;
